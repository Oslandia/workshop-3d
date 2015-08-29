#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive
sudo locale-gen "en_US.UTF-8" "fr_FR.UTF-8"
sudo dpkg-reconfigure locales
sudo apt-get update -qq
sudo apt-get dist-upgrade -y 

sudo apt-get install -y -q git \
        wget \
        gdal-bin \
        unzip

sudo apt-get install -y --fix-missing update-notifier \
    update-manager \
    dictionaries-common \
    hunspell-en-us \
    libenchant1c2a \
    enchant \
    libgtkspell0 \
    libsexy2 \
    aspell \
    aspell-en \
    libyelp0 \
    yelp

sudo apt-get install -y --fix-missing update-notifier \
        libabiword-3.0 \
        libwebkitgtk-1.0-0 \
        libwebkitgtk-3.0-0 \
        abiword \
        abiword-plugin-grammar \
        abiword-plugin-mathview \
        gir1.2-webkit-3.0 \
        gnome-user-guide \
        gnumeric-doc \
        pidgin \
        pidgin-libnotify \
        software-center \
        xchat \
        xchat-indicator \
        zenity \
        ubuntu-release-upgrader-gtk \
        unity-control-center \
        unity-control-center-signon \
        indicator-bluetooth \
        pgadmin3

sudo apt-get install -y --fix-missing xubuntu-desktop
