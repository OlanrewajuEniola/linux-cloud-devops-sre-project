
## Linux Troubleshooting Mini Lab

Created a basic Linux troubleshooting lab to practise log investigation, disk checks, permissions, and shell scripting.

### Skills practised

- Created and reviewed application log files
- Used `grep` to find `ERROR`, `WARNING`, and database-related log entries
- Used `grep -n` to show matching lines with line numbers
- Used `grep -v` to filter out unwanted log entries
- Used `df -h` to check filesystem disk usage
- Used `du -sh .` to check folder size
- Created a Bash troubleshooting script
- Made the script executable with `chmod +x`
- Ran the script using `./troubleshoot.sh`

### What the script does

The `troubleshoot.sh` script generates a basic troubleshooting report showing:

- Current user
- Current directory
- Date and time
- Disk usage
- Folder size
- Errors found inside `app-status.log`

### Why this matters

This lab demonstrates a practical Linux troubleshooting workflow. It shows how common Linux commands can be combined to investigate application issues, check system state, and automate repeated checks using a shell script.
## Docker Basic Web App

Built a simple Python Flask web application and packaged it with Docker.

### What I built

- Created a Flask web app with `/` and `/health` routes
- Added `requirements.txt` to define Python dependencies
- Created a `Dockerfile` to build a custom Docker image
- Built the image as `docker-basic-web-app:v1`
- Ran the app as a Docker container
- Mapped host port `5000` to container port `5000`
- Tested the app in the browser using `localhost:5000`
- Checked container logs using `docker logs`

### Key commands practised

```bash
docker build -t docker-basic-web-app:v1 .
docker run -d --name docker-basic-web-app -p 5000:5000 docker-basic-web-app:v1
docker ps
docker logs docker-basic-web-app
docker stop docker-basic-web-app
docker rm docker-basic-web-app
```

## GitHub Actions CI Pipeline

This project includes a GitHub Actions CI workflow for the Docker basic web app.

The workflow file is located at:

```text
.github/workflows/docker-ci.yml
```
### Docker Hub Image Push

The GitHub Actions workflow now logs in to Docker Hub, builds the Docker image, and pushes it to Docker Hub.

The image is published as:

```text
cocomiyati/docker-basic-web-app:latest
```

### Docker Hub workflow steps

1. GitHub Actions starts when code is pushed to the `main` branch.
2. A temporary Ubuntu runner is created.
3. The repository is checked out using `actions/checkout@v4`.
4. Docker logs in to Docker Hub using GitHub Secrets:
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`
5. Docker builds the image:

```bash
docker build -t cocomiyati/docker-basic-web-app:latest ./docker-basic-web-app
```

6. Docker pushes the image to Docker Hub:

```bash
docker push cocomiyati/docker-basic-web-app:latest
```

### Key learning points

- GitHub stores the source code.
- Docker Hub stores Docker images.
- GitHub Secrets securely store credentials such as Docker Hub tokens.
- `docker build` creates a Docker image.
- `docker push` uploads the image to Docker Hub.
- `docker pull` downloads the image from Docker Hub.
- The `latest` tag usually points to the most recent/default image, but it can change.
- Version tags like `v1.0.0` are safer for production because they are clearer and more predictable.## EC2 Docker Deployment
The Docker image was deployed to an Ubuntu EC2 instance.
The image used for deployment is:

```text
cocomiyati/docker-basic-web-app:latest

```

### EC2 setup

The EC2 instance was created using Ubuntu Server.

Docker was installed on the EC2 instance using:

```bash
sudo apt update
sudo apt install docker.io -y
```

Docker was started and enabled using:

```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

### Pulling the image from Docker Hub

The image was pulled from Docker Hub using:

```bash
sudo docker pull cocomiyati/docker-basic-web-app:latest
```

### Running the container on EC2

The container was started using:

```bash
sudo docker run -d --name docker-basic-web-app -p 80:5000 cocomiyati/docker-basic-web-app:latest
```

The port mapping means:

```text
EC2 port 80 → container port 5000
```

The application was tested using:

```text
http://<EC2_PUBLIC_IP>
http://<EC2_PUBLIC_IP>/health
```

### Deployment script

A deployment script was created on the EC2 instance:

```bash
deploy-docker-app.sh
```

The script pulls the latest image, stops the existing container, removes the old container, starts a new container, and shows the running containers.

The script was made executable using:

```bash
chmod +x deploy-docker-app.sh
```

The script was run using:

```bash
./deploy-docker-app.sh
```

## CI/CD Deployment Health Check

The GitHub Actions workflow now verifies that the application is live after deployment.

After the Docker image is built, pushed to Docker Hub, and deployed to the EC2 instance, the workflow checks the `/health` endpoint:

```bash
curl --retry 5 --retry-delay 5 --retry-connrefused -f http://${{ secrets.EC2_HOST }}/health
```
### Docker restart policy

The deployment script runs the container with a restart policy:

```bash
--restart unless-stopped
```

This allows Docker to automatically restart the container if it crashes or if the EC2 instance/Docker service restarts.

The container will not restart automatically if it was deliberately stopped by the user.

The restart policy was confirmed using:

```bash
sudo docker inspect docker-basic-web-app --format='{{.HostConfig.RestartPolicy.Name}}'
```
Expected output:

```text
unless-stopped
```

### Why this is important

The restart policy improves application reliability because the container can recover automatically from crashes or server restarts without needing manual intervention.

### Key learning points

- GitHub stores the application source code.
- GitHub Actions builds and pushes the Docker image.
- Docker Hub stores the Docker image.
- EC2 pulls the image from Docker Hub.
- EC2 runs the image as a Docker container.
- `docker pull` downloads an image from a registry.
- `docker run` creates and starts a container from an image.
- `-p 80:5000` maps EC2 port 80 to container port 5000.
- A deployment script makes the deployment process repeatable.
- A health check confirms the live application is reachable after deployment.
- `--restart unless-stopped` automatically restarts the container after crashes or server restarts unless it was manually stopped.

# 🚀 Terraform AWS EC2 with User Data

## 📌 Project Objective

The objective of this project was to provision AWS infrastructure using Terraform and automatically configure an EC2 instance with a User Data script during its first boot.

---

## 🛠️ What I Built

In this project, I successfully:

- Configured the AWS provider.
- Created reusable Terraform variables.
- Provisioned an Ubuntu EC2 instance.
- Created an AWS Security Group.
- Created and managed an AWS Key Pair.
- Allocated and associated an Elastic IP.
- Added a User Data script to automate the server configuration.
- Verified that Terraform successfully managed the infrastructure.
- Destroyed and recreated infrastructure when configuration changes required a new EC2 instance.

---

## 📁 Project Structure

```text
terraform-aws-ec2/
├── main.tf
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── user_data.sh
├── README.md
└── .gitignore
```

---

## 📄 Terraform Files

### `providers.tf`

This file configures the AWS provider and specifies the AWS region where the infrastructure will be created.

### `variables.tf`

This file declares reusable variables so that values do not need to be hardcoded directly into the Terraform configuration.

### `terraform.tfvars`

This file assigns values to the variables declared in `variables.tf`.

### `main.tf`

This file defines the AWS infrastructure resources, including:

- EC2 instance
- Security Group
- AWS Key Pair
- Elastic IP
- Elastic IP association

### `outputs.tf`

This file displays useful information after deployment, such as the Elastic IP address of the EC2 instance.

### `user_data.sh`

This script automatically configures the EC2 instance during its first boot.

It performs the following tasks:

```bash
#!/bin/bash

apt update
apt install nginx -y
systemctl start nginx
systemctl enable nginx
```

The script:

- Updates the package repository.
- Installs Nginx.
- Starts the Nginx service.
- Enables Nginx to start automatically after a reboot.

---

## ⚙️ Terraform Workflow

The following commands were used during the project.

### Initialise Terraform

```bash
terraform init
```

This command initialises the working directory and downloads the required provider plugins.

### Format the Terraform Files

```bash
terraform fmt
```

This command formats the Terraform configuration files into a consistent style.

### Validate the Configuration

```bash
terraform validate
```

This command checks whether the Terraform configuration is valid.

### Preview Infrastructure Changes

```bash
terraform plan
```

This command shows the infrastructure changes Terraform intends to make before applying them.

### Create or Update Infrastructure

```bash
terraform apply
```

This command creates or updates the AWS infrastructure.

### View Resources in Terraform State

```bash
terraform state list
```

This command displays the resources currently being managed by Terraform.

### Force an EC2 Instance Replacement

```bash
terraform plan -replace=aws_instance.web_server
```

This command was used when the EC2 instance needed to be recreated so that the updated User Data and SSH key configuration could take effect.

### Destroy Infrastructure

```bash
terraform destroy
```

This command removes the infrastructure managed by Terraform.

---

## ☁️ Infrastructure Created

Terraform created and managed the following AWS resources:

- Ubuntu EC2 instance
- Security Group
- AWS Key Pair
- Elastic IP
- Elastic IP association
- AWS provider configuration
- Input variables
- Output values

---

## 🔐 SSH Key Management

The original Terraform configuration used an existing public SSH key:

```hcl
resource "aws_key_pair" "terraform_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
```

The passphrase for the matching private key was unavailable, so a new SSH key was created:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/terraform-web-key-v2 -C "terraform-web-server"
```

The Terraform configuration was then updated to use the new public key:

```hcl
resource "aws_key_pair" "terraform_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("~/.ssh/terraform-web-key-v2.pub")
}
```

Because an existing EC2 instance does not automatically receive a newly created AWS Key Pair, the EC2 instance had to be replaced.

---

## ✅ Deployment Verification

The deployment was verified using several methods.

### Browser Test

The Elastic IP address was opened in a web browser.

The default Nginx welcome page confirmed that:

- The EC2 instance was running.
- The Security Group allowed HTTP traffic.
- Nginx was installed and running.
- The User Data script completed successfully.

### `curl` Test

The web server was tested from the terminal:

```bash
curl http://<ELASTIC-IP>
```

The returned HTML confirmed that the Nginx web server was responding successfully.

### SSH Connection

The EC2 instance was accessed using the new private key:

```bash
ssh -i ~/.ssh/terraform-web-key-v2 ubuntu@<ELASTIC-IP>
```

### Nginx Service Check

After connecting to the EC2 instance, the Nginx service was checked:

```bash
sudo systemctl status nginx
```

The service showed:

```text
Active: active (running)
```

### Cloud-Init Log Check

The Cloud-Init output log was reviewed to confirm that the User Data script executed successfully:

```bash
sudo tail -n 50 /var/log/cloud-init-output.log
```

The log confirmed that:

- The package repository was updated.
- Nginx was installed.
- Nginx was enabled.
- Cloud-Init completed successfully.

---

## 🔍 Challenges Encountered

### User Data Did Not Run Again

User Data normally runs only during the first boot of a newly created EC2 instance.

Updating the User Data configuration on an existing instance did not cause the script to run again.

The solution was to replace the EC2 instance.

### SSH Private Key Passphrase Was Forgotten

The original AWS Key Pair used the public key from:

```text
~/.ssh/id_rsa.pub
```

The matching private key required a passphrase that was no longer available.

The solution was to:

1. Generate a new SSH key.
2. Update the Terraform configuration.
3. Replace the AWS Key Pair.
4. Replace the EC2 instance.
5. Connect using the new private key.

### Remote Host Identification Changed

After replacing the EC2 instance, SSH displayed the following warning:

```text
REMOTE HOST IDENTIFICATION HAS CHANGED
```

This happened because:

- The Elastic IP remained the same.
- The EC2 instance was new.
- The new instance had a different SSH host fingerprint.

The old host keys were removed with:

```bash
ssh-keygen -R <ELASTIC-IP>
```

```bash
ssh-keygen -R <EC2-PUBLIC-DNS>
```

After removing the old entries, the SSH connection succeeded.

---

## Kubernetes Deployment and Scaling

### Deployment and Pods
Kubernetes Deployment manages the desired state of the application Pods. If a Pod fails or crashes, the Deployment, through its ReplicaSet, ensures a replacement Pod is created so that the configured number of replicas is maintained.

### Kubernetes Service
Kubernetes Service provides a stable network endpoint for accessing the application and distributes incoming traffic across Ready Pods. In this project, the Service receives traffic on port `80` and forwards it to the Flask application on `targetPort: 5000`.

### Manual Scaling
Kubernetes Pods can be manually scaled in or out by changing the desired number of replicas. Scaling out increases the number of Pods, while scaling in reduces the number of Pods.

Manual scaling was tested using both:
- Imperative scaling with `kubectl scale`
- Declarative scaling by changing `replicas` in `main.yaml` and applying the configuration

### Resource Requests and Limits
CPU and memory requests and limits were configured to define the resources required and permitted for each container. The CPU request also provides the baseline used by the HPA to calculate CPU utilisation.

### Metrics Server and Horizontal Pod Autoscaler
Metrics Server collects CPU and memory utilisation metrics from Kubernetes Nodes and Pods.

The Horizontal Pod Autoscaler (HPA) uses CPU metrics to automatically scale the Deployment based on the configured target utilisation.

HPA configuration:
- Minimum replicas: `2`
- Maximum replicas: `10`
- Target CPU utilisation: `70%`

HPA was practically tested by generating CPU load and observing Kubernetes automatically scale the application from 2 Pods to 8 Pods and back to 2 Pods after the load was removed.

### Readiness and Liveness Probes
A Readiness Probe checks whether the application inside a Pod is ready to receive traffic. If the probe fails, the Pod is marked `NotReady` and the Service stops routing traffic to it until it recovers.

A Liveness Probe checks whether the application is still functioning. If the probe repeatedly fails, Kubernetes restarts the container to attempt recovery.

---

## 📚 Key Lessons Learned

Through this project, I learned how to:

- Provision AWS infrastructure using Terraform.
- Use Infrastructure as Code to create repeatable infrastructure.
- Organise Terraform configuration across multiple files.
- Use variables to avoid hardcoding values.
- Use outputs to display important infrastructure information.
- Create and manage EC2 instances.
- Configure Security Group rules.
- Create and associate an Elastic IP.
- Manage AWS Key Pairs with Terraform.
- Use User Data to automate server configuration.
- Understand that User Data runs during the first boot of a new instance.
- Use `terraform plan` to preview changes.
- Use `terraform apply` to create infrastructure.
- Use `terraform destroy` to remove infrastructure.
- Use Terraform state to track managed resources.
- Replace infrastructure safely when required.
- Troubleshoot SSH authentication problems.
- Resolve SSH host fingerprint warnings after replacing an EC2 instance.
- Verify a deployment using a browser, `curl`, SSH, `systemctl`, and Cloud-Init logs.

---

## 🎯 Final Result

The final Terraform deployment successfully:

- Created an Ubuntu EC2 instance.
- Created and attached a Security Group.
- Created and used a new SSH Key Pair.
- Allocated and associated an Elastic IP.
- Ran a User Data script during first boot.
- Installed and started Nginx automatically.
- Served the Nginx welcome page over HTTP.
- Allowed successful SSH access.
- Passed browser, `curl`, service, and Cloud-Init verification checks.

