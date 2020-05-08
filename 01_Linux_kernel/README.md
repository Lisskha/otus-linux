# HW 1. С чего начинается Linux

PR:  

## Table of contents
- [Установка ПО](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D0%BF%D0%BE)
- [Kernel update](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#kernel-update)
    - [Настройка окружения](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0-%D0%BE%D0%BA%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F)
    - [Kernel update](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#kernel-update-1)
    - [Grub update](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#grub-update)
- [Packer](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#packer)
    - [Packer provision config](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#packer-provision-config)
    - [Packer build](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#packer-build)
    - [Тестирование](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#%D1%82%D0%B5%D1%81%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)
- [Vagrant cloud](https://github.com/Lisskha/otus-linux/blob/master/01_Linux_kernel/README.md#vagrant-cloud)
- [Задиние со *](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#%D0%B7%D0%B0%D0%B4%D0%B8%D0%BD%D0%B8%D0%B5-%D1%81%D0%BE-)
- [Задание с **](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#%D0%B7%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D1%81-)

### Для выполнения работы потребуются следующие инструменты:
- **VirtualBox** - среда виртуализации, позволяет создавать и выполнять виртуальные машины;
- **Vagrant** - ПО для создания и конфигурирования виртуальной среды. В данном случае в качестве среды виртуализации используется VirtualBox;
- **Packer** - ПО для создания образов виртуальных машин;
- **Git** - система контроля версий

### А так же аккаунты:
- GitHub - https://github.com/
- Vagrant Cloud - https://app.vagrantup.com

---
## Установка ПО

**Vagrant**
- [Vagrant Cloud](https://app.vagrantup.com/boxes/search) - хранилище Vagrant боксов, используется для скачивания образов по дефолту
- Конфиг файл для описания ВМ, которые будут созданы - [Vagrantfile](Vagrantfile); немношк о [Vagrantfile](https://otus.ru/media-private/0a/ca/Linux_Vagrant__2-5522-0aca54.pdf?hash=wPBxgoBxiatrsCT9J2ZkSw&expires=1588808901)
- Скачала и установила [VirtualBox for OS X](https://www.virtualbox.org/wiki/Downloads)
    ```sh
    VirtualBox
    Версия 6.1.6
    ```
- Скачала и установила [Vagrant](https://www.vagrantup.com/downloads.html)
    ```sh
    $ vagrant -v
    Vagrant 2.2.8
    ```

**Packer**
- Обновила ранее установленный пакер
    ```sh
    $ brew upgrade packer

    $ packer --version
    1.5.6
    ```
---

## Kernel update

### Настройка окружения
- Форкнула и склонила репу, перенесла Vagrantfile в каталог 01_Linux_kernel в своей репе, в нем запустила создание виртуалок:
    ```sh
    $ git clone git@github.com:Lisskha/manual_kernel_update.git

    $ vagrant up
    ```
- Посмотреть список скачанных образов:
    ```sh
    $ vagrant box list
    centos/7        (virtualbox, 1905.1)
    ubuntu/xenial64 (virtualbox, 20191113.0.0)
    ```
- Смотреть статус виртуалок:
    ```sh
    $ vagrant status
    Current machine states:

    kernel-update             running (virtualbox)
    ```
- Зайти на ВМ kernel-update:
    ```sh
    $ vagrant ssh kernel-update
    [vagrant@kernel-update ~]$ uname -r
    3.10.0-957.12.2.el7.x86_64
    ```

### Kernel update
- Ставим необходимую репу
    ```sh
    [vagrant@kernel-update ~]$ sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    [vagrant@kernel-update ~]$ sudo yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
    ``` 
- В репозитории есть две версии ядер `kernel-ml` и `kernel-lt`. Первая является наиболее свежей стабильной версией, вторая это стабильная версия с длительной поддержкой, но менее свежая, чем первая. В данном случае ядро 5й версии будет в kernel-ml.
    ```
    [root@kernel-update vagrant]# yum search --enablerepo elrepo-kernel kernel
    ```
- Ставим последнее ядро
    ```
    [root@kernel-update vagrant]# yum install --enablerepo elrepo-kernel kernel-ml -y
    ```

### Grub update
> После успешной установки нам необходимо сказать системе, что при загрузке нужно использовать новое ядро. В случае обновления ядра на рабочих серверах необходимо перезагрузиться с новым ядром, выбрав его при загрузке. И только при успешно прошедших загрузке нового ядра и тестах сервера переходить к загрузке с новым ядром по-умолчанию. В тестовой среде можно обойти данный этап и сразу назначить новое ядро по-умолчанию.  

- Обновляем конфигурацию загрузчика:
    ```
    [root@kernel-update vagrant]# grub2-mkconfig -o /boot/grub2/grub.cfg
    ```
- Выбираем загрузку с новым ядром по-умолчанию:
    ```
    [root@kernel-update vagrant]# grub2-set-default 0
    ```
- Перезагружаем вирттуалку и проверяем версию ядра:
    ```
    [root@kernel-update vagrant]# reboot

    $ vagrant ssh kernel-update

    [vagrant@kernel-update ~]$ uname -r
    5.6.10-1.el7.elrepo.x86_64
    ```
---

## Packer
> Необходимо создать свой образ системы, с уже установленым ядром 5й версии.  
- Перекинула из репы manual_kernel_update в свою репу каталог packer. В директории packer есть все необходимые настройки и скрипты для создания необходимого образа системы.

### Packer provision config
- Файл `centos.json` - packer шаблон, с помощью которого собираем baked-образ. Обратим внимание на основные секции или ключи.
- Создаем переменные (**variables**) с версией и названием нашего проекта (**artifact**):
    ```sh
    "variables": {
        "artifact_description": "CentOS 7.7 with kernel 5.x",
        "artifact_version": "7.7.1908",
    ```
- В секции **`builders`** задаем исходный образ, для создания своего в виде ссылки и контрольной суммы. Параметры подключения к создаваемой виртуальной машине
    ```sh
      "iso_url": "http://mirror.yandex.ru/centos/7.7.1908/isos/x86_64/CentOS-7-x86_64-Minimal-1908.iso",
      "iso_checksum": "9a2c47d97b9975452f7d582264e9fc16d108ed8252ac6816239a3b58cef5c53d",
      "iso_checksum_type": "sha256",
    ```
- В секции **`post-processors`** указываем имя файла, куда будет сохранен образ, в случае успешной сборки
    ```sh
      "output": "centos-{{user `artifact_version`}}-kernel-5-x86_64-Minimal.box",
    ```
- В секции **`provisioners`** указываем каким образом и какие действия необходимо произвести для настройки виртуальой машины. Именно в этой секции мы и обновим ядро системы, чтобы можно было получить образ с 5й версией ядра. Настройка системы выполняется несколькими скриптами, заданными в секции **scripts**.
    ```sh
          "scripts" :
            [
              "scripts/stage-1-kernel-update.sh",
              "scripts/stage-2-clean.sh"
            ]
    ```
- `Скрипты будут выполнены в порядке указания`. Первый скрипт включает себя набор команд, которые мы ранее выполняли вручную, чтобы обновить ядро. Второй скрипт занимается подготовкой системы к упаковке в образ. Она заключается в очистке директорий с логами, временными файлами, кешами. Это позволяет уменьшить результирующий образ.

### Packer build
- Проверка шаблона на ошибки и запуск билда:
    ```sh
    $ packer validate ./centos.json
    Template validated successfully.

    $ packer build centos.json
    ```
1908 деприкейтед и выдает ошибку 404 при попытке скачать исошник с зеркала. В файле centos.json внесла изменения:
```sh
  "variables": {
    "artifact_description": "CentOS 7.8 with kernel 5.x",
    "artifact_version": "7.8.2003",
    "image_name": "centos-7.8"
  },

  "builders": [
    {
        ...
        "iso_url": "https://mirror.yandex.ru/centos/7.8.2003/isos/x86_64/CentOS-7-x86_64-Minimal-2003.iso",
        "iso_checksum": "659691c28a0e672558b003d223f83938f254b39875ee7559d1a4a14c79173193",
```
- Успешная сбоорка образа:
    ```sh
    ==> Builds finished. The artifacts of successful builds are:
    --> centos-7.8: 'virtualbox' provider box: centos-7.8.2003-kernel-5-x86_64-Minimal.box
    ```
    Был скачан исходный iso-образ CentOS, установлен на виртуальную машину в автоматическом режиме, обновлено ядро и осуществлен экспорт в указанный нами файл. В текущей дире появился файл `centos-7.8.2003-kernel-5-x86_64-Minimal.box`

### Тестирование
- Проведем тестирование созданного образа. Выполним его `импорт в vagrant`:
    ```sh
    $ vagrant box add --name centos-7-5 centos-7.8.2003-kernel-5-x86_64-Minimal.box

    ==> box: Successfully added box 'centos-7-5' (v0) for 'virtualbox'!
    ```
- Проверим его в списке имеющихся образов:
    ```sh
    $ vagrant box list
    centos-7-5      (virtualbox, 0)
    ```
- Теперь необходимо провести тестирование полученного образа. Для этого создадим диру test, скопируем туда Vagrantfile, произведем замену значения `box_name` на имя импортированного образа:
    ```sh
    :box_name => "centos-7-5",
    ```
> Для нового Vagrantfile в дире test можно запустить `vagrant init centos-7-5`
- Теперь запустим виртуальную машину, подключимся к ней и проверим, что у нас в ней новое ядро:
    ```sh
    $ vagrant up
    ...
    $ vagrant ssh kernel-update
    [vagrant@kernel-update ~]$ uname -rs
    Linux 3.10.0-1127.el7.x86_64
    ```
    Машина загрузилась не с новым ядром.. Пошла править пакер.  

**`Fix`**
- Удалила тестовый образ из локального хранилища:
    ```sh
    $ vagrant box remove centos-7-5
    Removing box 'centos-7-5' (v0) with provider 'virtualbox'...

    # Проверила, что образа больше нет
    $ vagrant box list
    # Виртуалка осталась запущенной
    $ vagrant status
    kernel-update             running (virtualbox)
    # Удалила ВМ
    $ vagrant destroy kernel-update
    ==> kernel-update: Destroying VM and associated drives...
    ```
- В пакере поправила провижинеров, скрипт `stage-2-clean.sh`, запусттила сборку образа, и на его основаании создание бокса в вагранте. 
    ```sh
    [vagrant@kernel-update ~]$ uname -rs
    Linux 5.6.11-1.el7.elrepo.x86_64
    ```
---

## Vagrant cloud
- Делимся созданным образом. Для этого зальем его в `Vagrant Cloud`. Vagrant позволяет заливать через CLI. Логинимся в vagrant cloud, указывая e-mail, пароль и описание выданого токена (можно оставить по-умолчанию):
    ```sh
    $ vagrant cloud auth login
    Vagrant Cloud username or email: <my_email>
    Password (will be hidden):
    Token description (Defaults to "Vagrant login from MacBook-Pro.local"):
    You are now logged in.
    ```
- Теперь публикуем полученный бокс:
    ```sh
    $ vagrant cloud publish --release <vagrant_username>/centos-7-5 1.0 virtualbox ../packer/centos-7.8.2003-kernel-5-x86_64-Minimal.box
    ```
    - `cloud publish` - загрузить образ в облако;
    - `release` - указывает на необходимость публикации образа после загрузки;
    - `<username>/centos-7-5` - username, указаный при публикации и имя образа;
    - `1.0` - версия образа;
    - `virtualbox` - провайдер;
    - `centos-7.7.1908-kernel-5-x86_64-Minimal.box` - имя файла загружаемого образа;
- В результате создан и загружен в vagrant cloud образ виртуальной машины. Данный подход позволяет создать базовый образ виртульной машины с необходимыми обновлениями или набором предустановленного ПО. К примеру при создании MySQL-кластера можно создать образ с предустановленным MySQL, а при развертывании нужно будет добавить или изменить только настройки (то есть отличающуюся часть). Таким образом существенно экономя затрачиваемое время.
---

## Задиние со *
Собрать ядро из исходников.  
- Проверить нынешнее ядро
    ```sh
    [vagrant@kernel-update ~]$ uname -rs
    Linux 3.10.0-957.12.2.el7.x86_64
    ```
- Обновить пакеты и установить необходимые
    ```sh
    sudo yum update -y
    sudo yum makecache
    sudo yum install -y ncurses-devel make gcc bc openssl-devel elfutils-libelf-devel rpm-build wget
    ```
- Качнуть последнюю стабильную версию ядра  
  https://www.kernel.org/
    ```sh
    sudo cd /opt/ && sudo wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.11.tar.xz
    ```
- Разархивировать и зайти в каталог
    ```sh
    sudo tar xvf linux-5.6.11.tar.xz
    cd linux-5.6.11/
    ```
- Скопировала действующее ядро и запустила make
    ```sh
    sudo cp -v /boot/config-3.10.0-957.12.2.el7.x86_64 .config

    ‘/boot/config-3.10.0-957.12.2.el7.x86_64’ -> ‘.config’

    sudo make menuconfig
    ```
    - make ругнулся на недостающие пакеты, установила
        ```sh
        sudo yum install -y flex-devel flex bison-devel bison
        ```
    - перезапустила и попала в конфиг меню
        ```sh
        sudo make menuconfig
        ```
    - файл `.config` обновился
- Запустила компилирование
    ```sh
    sudo make rpm-pkg
    ```
- Посмотрела что нагенерилось и запустила установку рпмов
    ```sh
    sudo ls /root/rpmbuild/RPMS/x86_64/

    kernel-5.6.11-1.x86_64.rpm
    kernel-devel-5.6.11-1.x86_64.rpm
    kernel-headers-5.6.11-1.x86_64.rpm

    sudo rpm -iUv /root/rpmbuild/RPMS/x86_64/*.rpm
    ```
- Перезагрузка и проверка
    ```sh
    sudo shutdown -r now

    uname -rs
    Linux 5.6.11
    ```
- Вышеуказанные шаги внесла в файл [custom-1-kernel-update.sh](packer/scripts/custom-1-kernel-update.sh)
- Переделала старый скрипт и создала файл [custom-2-clean.sh](packer/scripts/custom-2-clean.sh)
- Файл для пакера с новыми провижинерами - [centos_custom.json](packer/centos_custom.json)
- Проверила конфиг и запустила билд образа
    ```sh
    packer validate ./centos_custom.json
    ...
    Template validated successfully.

    packer build centos_custom.json
    ```
    - Создался образ `centos-custom-7.8.2003-kernel-5-x86_64-Minimal.box`
- Протестировала новый образ, закинула его в облако вагранта
    ```sh
    vagrant box add --name centos-7-5-c centos-custom-7.8.2003-kernel-5-x86_64-Minimal.box

    подправила test/Vagrantfile

    vagrant up
    ...
    vagrant ssh kernel-custom

    uname -rs
    Linux 5.6.11

    vagrant cloud auth login
    ...
    vagrant cloud publish --release <vagrant_username>/centos-7-5-c 1.0 virtualbox ../packer/centos-custom-7.8.2003-kernel-5-x86_64-Minimal.box
    ```
---

## Задание с **


[Наверх ^](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_kernel#hw-1-%D1%81-%D1%87%D0%B5%D0%B3%D0%BE-%D0%BD%D0%B0%D1%87%D0%B8%D0%BD%D0%B0%D0%B5%D1%82%D1%81%D1%8F-linux)

