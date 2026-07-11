
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


## GitHub Actions CI Pipeline

This project includes a GitHub Actions CI workflow for the Docker basic web app.

The workflow file is located at:

```text
.github/workflows/docker-ci.yml

The workflow runs automatically when code is pushed to the main branch or when a pull request targets main.

What the workflow does
Creates a temporary Ubuntu GitHub Actions runner.
Checks out the repository using actions/checkout@v4.
Checks that the required Docker project files exist:
docker-basic-web-app/Dockerfile
docker-basic-web-app/app.py
docker-basic-web-app/requirements.txt

Builds the Docker image using:
docker build -t docker-basic-web-app:ci ./docker-basic-web-app

Key learning points
docker-ci.yml is the GitHub Actions workflow file.
The Dockerfile contains the instructions for building the Docker image.
actions/checkout@v4 downloads the repository code into the GitHub Actions runner.
test -f checks that a required file exists.
docker build reads the Dockerfile and builds the Docker image.
The image is built inside the temporary GitHub Actions runner.
The image is not pushed to Docker Hub yet.
When the runner is destroyed after the job, the locally built image disappears.

Current CI status
The Docker CI workflow has passed successfully.