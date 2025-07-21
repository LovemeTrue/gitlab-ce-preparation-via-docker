# Гайд по виртуализиации `Debian 12` на локальной MacOS M1.

### 1. Установка UTM для MacOS(других ОС можно использовать VMWare или VirtualBox):  https://mac.getutm.app
### 2. В открытых источниках находим Debian iso с предустановленными зависимостями для удобства администрирования(в идеале иметь кастомные образа для делплоя): 
### https://archive.org/details/debian-12-rosetta-arm64-utm
```
- QEMU Guest Agent
- SPICE Guest Agent
- 9pfs for VirtIO sharing
- Auto-mount shared directory at boot
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
### 4. Запускаем UTM и виртуализируем скачанный образ включая опции:
```
- Use Apple Virtualization
- Enable Rosetta(x86_64 Emulation)
```
### 5. В UTM настраиваем виртуальную машину:
```
CPU: 6 cores
RAM: половина от максимальной, или хотя бы 8Gb.
STORAGE: 20Gb
```
### 6. Ставим галочку открыть настройки после устаеновки и в настройках виртуальной машины в разделе "Network" ставим `Bridged(Advanced)` с автоматическим определнием сетевого интерфейса.

### 7. Заходим в интерфейс под кредами:
```
debian/debian
```
### 8. Устанавливаем git:
```
apt install git
```
### 9. Клонируем репозиторий: 