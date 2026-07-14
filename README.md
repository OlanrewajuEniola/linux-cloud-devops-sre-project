
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

EOF
