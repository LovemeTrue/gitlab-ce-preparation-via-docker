# Гайд по виртуализиации `Debian 12` на локальной MacOS M1.

## Структура репозитория:
```
gitlab-ce-preparation-via-docker/
├── .env                     
|── docker-compose.yml
├── gitlab-ce-services-deploy.sh
├── prometheus.yml
├── README_EN.md
└── README.md
```

### 1. Установка UTM для MacOS(других ОС можно использовать VMWare или VirtualBox): https://mac.getutm.app
### 2. В открытых источниках находим Debian.utm templates с предустановленными зависимостями для удобства администрирования(в идеале иметь кастомные образа для делплоя: 
### https://archive.org/details/debian-12-rosetta-arm64-utm
```
- QEMU Guest Agent
- SPICE Guest Agent
- 9pfs for VirtIO sharing
- Auto-mount shared directory at boot
- Gnome GUI
```
### 3. Проверяем установлена ли Rosetta - устанавливаем если нет
### 
```
lsbom -f /Library/Apple/System/Library/Receipts/com.apple.pkg.RosettaUpdateAuto.bom
./Library/Apple/usr/lib/libRosettaAot.dylib     100755  0/0     423488  319171956
./Library/Apple/usr/libexec/oah/RosettaLinux/rosetta    100755  0/0     1726464 3658766315
./Library/Apple/usr/libexec/oah/RosettaLinux/rosettad   100755  0/0     382344  368746606
./Library/Apple/usr/libexec/oah/libRosettaRuntime       100755  0/0     464320  1896935315
./Library/Apple/usr/share/rosetta/rosetta       100644  0/0     64      1875722922
```
### 4. В UTM настраиваем виртуальную машину:
```
CPU: 6 cores(можно оставить 4)
RAM: половина от максимальной от RAM мастер хоста, или хотя бы 8Gb.
STORAGE: 20Gb(будет дефолтный 64Gb - можно пересоздать)
```
### 5. В настройках виртуальной машины в разделе "Network" ставим `Bridged(Advanced)` с автоматическим определнием сетевого интерфейса - запускаем виртуальную машину.

### 6. Заходим в интерфейс под кредами:
```
debian/debian
```
`Вариативно настроить хоткейс для Terminal и других удобств под себя(или иметь свой конфиг для Linux).`
### 7. Устанавливаем git по root:
```
apt install git
```
### 8. Клонируем репозиторий: 
```
git clone https://github.com/LovemeTrue/gitlab-ce-via-docker-compose.git
```
### 9. Запускаем скрипт(так же есть отдельный ридми для репозиория)
```
cd gitlab-ce-via-docker-compose
chmod -R 777 ./gitlab-ce-services-deploy.sh
./gitlab-ce-services-deploy.sh
```
### 10. Дожидаемся скачивание образов и запуск контейнеров и идем в UI браузера указанному в compose,
### в данном случае это `http://gitlab.panov.local:8080`

### 11. Заходим в UI на `Settings -> Access Tokens` и создаем токен для автоматизации через Ansible и сохраняем его на мастер ВМ c правами:
```	
read_service_ping, read_repository, read_api, write_repository, create_runner, admin_mode, sudo
```

### 12. Далее переходим на мастер ВМ устаналиваем Ansible в моем случае через `brew install ansible`:
```
which ansible
/opt/homebrew/bin/ansible 
```
### 13. Клонируем репозиторй с Ansible:
```
git clone https://github.com/LovemeTrue/gitlabe-ce-ansible.git
```
### 14. Переходим в папку с репозиторием:
```
cd gitlabe-ce-ansible
```
### 15. Создаем файл `secrets.yml`
```
ansible-vault create secrets.yml
```
### 16. Добавляем в файл: `vault_gitlab_token: <TOKEN>` из п.12

### 17. Добавляем пароль для пользователя ansible в файл `secrets.yml`:
```
ansible-vault edit secrets.yml -> 'gitlab_password: <PASSWORD>'
```
### 18. Перед запуском убеждаемся, что есть сетевая связность между мастер хостом и виртуальной машиной - sudo nano /etc/hosts, например: `192.168.64.53 gitlab.panov.local`

### 19. Команда для запуска плейбука:
```
ansible-playbook -i localhost, -c local site.yml --ask-vault-pass 
```

### P.S. Ожидаемым результатом является создание проектов в GitLab CE и пуш кода в репозиторий, который триггерит пайплан CI/CD и так же:
- Все проекты созданы, запушены в репозиторий GitLab и работают в контейнерах
- Существуют healthcheck для проверки состояния контейнеров java-app и flask-app
- Проекты возвращают Hello World по curl запросу
- Порты для сервисов добавляются в ufw sh скриптом:
- `8088` для web-app
- `8080` для java-app
- `5000` для flask-app
- `9090` для prometheus
- `8081` для cadvisor