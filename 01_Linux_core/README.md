# HW 1. С чего начинается Linux

PR:  

## Table of contents
- [Установка ПО]()
- [Задиние со *]()
- [Задание с **]()

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
- Конфиг файл для описания ВМ, которые будут созданы - [Vagrantfile]()
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






- Создание виртуалок, описанных в Vagrantfile (запускается в каталоге, где лежит Vagrantfile):
```sh
$ vagrant up
```
 - Смотреть список, скаченных на машину образов:
```sh
$ vagrant box list
```
 - Смотреть статус виртуалок:
```sh
$ vagrant status
Current machine states:
```
 - Зайти на ВМ appserver и пингануть с нее dbserver:
```sh
$ vagrant ssh appserver

vagrant@appserver:~$ ping 10.10.10.10
```

---




## Задиние со *

## Задание с **


[Вернуться к оглавлению ^]()

