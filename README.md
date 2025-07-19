## This repository contains a script for preparing a GitLab CE environment via Docker-compose.

## Requirements:
1. Checking for the presence of Docker and Docker-compose.
2. Checking for the presence of the necessary files.
3. Checking network settings and port availability.
4. Checking ssh keys
5. Installin' GitLab CE.

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