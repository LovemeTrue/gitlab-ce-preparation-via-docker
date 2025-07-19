## This repository contains a script for preparing a GitLab CE environment via Docker-compose.

## What the script does:
1. Checking for the presence of Docker and Docker-compose and installing them if necessary.2. Settings up network ufw settings and port availability.
3. Checking ssh keys and createsating them if necessary.
4. Installin' GitLab CE.

## Repo structure:
```
gitlab-ce-preparation-via-docker/
├── docker-compose.yml        # Main configuration file
├── .env                      # Environment variables
├── setup-gitlab-docker.sh    # Script for installation
└── README.md
```

## To deploy pre requirements and GitLab CE via Docker-compose clone repo:
```
git clone https://github.com/LovemeTrue/gitlab-ce-preparation-via-docker.git
```
## And launch the sh script:
```
chmod -x ./gitlab-docker-deploy.sh
./gitlab-docker-deploy.sh
```