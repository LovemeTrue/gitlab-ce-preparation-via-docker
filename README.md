## Repo structure:
```
gitlab-ce-preparation-via-docker/
├── docker-compose.yml        # Основной файл запуска GitLab CE
├── .env                      # Переменные окружения (если нужно)
├── setup-gitlab-docker.sh    # ⬅ Скрипт выше
└── README.md
```

To deploy pre requirements and GitLab CE via Docker-compose:

```
chmod -x ./gitlab-docker-deploy.sh
./gitlab-docker-deploy.sh
```