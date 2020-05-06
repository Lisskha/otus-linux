# HW 1. С чего начинается Linux

PR:  

## Table of contents
- [Установка ПО](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_core#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D0%BF%D0%BE)
- [Kernel update]()
    - [Настройка окружения]()
    - [Kernel update]()
    - [Grub update]()
- [Задиние со *](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_core#%D0%B7%D0%B0%D0%B4%D0%B8%D0%BD%D0%B8%D0%B5-%D1%81%D0%BE-)
- [Задание с **](https://github.com/Lisskha/otus-linux/tree/master/01_Linux_core#%D0%B7%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D1%81-)

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
- Конфиг файл для описания ВМ, которые будут созданы - [Vagrantfile](01_Linux_core/Vagrantfile); немношк о [Vagrantfile](https://otus.ru/media-private/0a/ca/Linux_Vagrant__2-5522-0aca54.pdf?hash=wPBxgoBxiatrsCT9J2ZkSw&expires=1588808901)
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
- Форкнула и склонила репу, перенесла Vagrantfile в каталог 01_Linux_core в своей репе, в нем запустила создание виртуалок:
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







## Задиние со *

## Задание с **


[Вернуться к оглавлению ^]()

