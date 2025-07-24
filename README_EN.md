## This repository will guide you to virtualize `Debian 12.iso` on MacOS M1 by UTM and set up a `GitLab CE` environment and services via Docker-compose. Please proceed to READMME_FULL_GUIDE_RU.md for full step-bystep guide on Russian Lnaguage.

## What the script does:
1. Checking for the presence of Docker, Docker-compose and other apts and installing them if necessary.
2. Settings up network ufw settings and port availability.
3. Checking ssh keys and createsating them if necessary.
4. Installin' GitLab CE, Gitlab-Runner, Prometheus, caDvisor via Docker composer.

## Repo structure:
```
gitlab-ce-preparation-via-docker/
├── .env                      # Environment variables
|── docker-compose.yml
├── gitlab-ce-services-deploy.sh
├── prometheus.yml
├── README_EN.md
└── README.md
```
## To deploy pre requirements and GitLab CE via Docker-compose clone repo:
```
git clone https://github.com/LovemeTrue/gitlab-ce-via-docker-compose.git
```
## And launch the sh script:
```
cd gitlab-ce-via-docker-compose
chmod -R 777 ./gitlab-ce-services-deploy.sh
./gitlab-ce-services-deploy.sh
```
## To deploy services:
```
docker compose up -d
```
## To stop services: 
```
docker compose down
```
## To restart services:
```
docker compose restart
```
