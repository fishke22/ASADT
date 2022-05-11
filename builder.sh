#!/bin/bash
# Assistive Search And Discovery Tool Mark II v102 Builder Application
# Licensed Under GNU GENERAL PUBLIC LICENSE
# Script Developed & Maintained By The
# Onetrak Digital Forensics Corporation


builder_version="1.0.1"
buildv="v1.0.3"
buildv_long="MARK II BETA | v 1.0.3"

function checkroot {

    if [ "$USER" = "root" ]; then

        echo "proginit> user=$SUDO_USER"

    else

        echo "proginit> please run "'"sudo ./builder.sh"'" "

        exit

    fi

}

function getrolling {

    if [ -f "/etc/os-release" ]; then

        source "/etc/os-release"

        if [ "$VERSION_CODENAME" = "kali-rolling" ]; then

            echo "os_v_codename> "'"kali-rolling"'" detected!"

        else

            echo "os_v_codename> "'"kali-rolling"'" was not detected in "'"/etc/os-release"'"!"
            echo ""
            echo "os_v_codename> It looks like kali-rolling wasnt detected!"
            echo "               If you currently are not running Kali-OS, please"
            echo "               ensure all of the necesary apt-sources are installed"
            echo "               either via kali's deb repo or via the open internet."
            echo ""
            echo "dispmsg> This message will dissmiss in 15 seconds!"
            echo ""

            sleep 15

        fi

    fi

}

function buildscript {

    echo ""
    echo "ASADT Release-$buildv Build Script"
    echo "Version to be Built: [$buildv_long]"
    echo "Builder Script Version: [$builder_version]"
    echo ""
    echo ""

    echo "[NO SPACES OR SPECIAL CHARS.]"
    echo -n "Enter Install Location: "
    read custominstloc

    if [ -z "$custominstloc" ]; then

        echo "No Input Provided!"

        exit

    fi

    if [ -d "$custominstloc" ]; then

        echo "OK"

    else

        echo "Looks like this directory doesnt exist!"
        echo -n "Would you like to create it? [y/n]"
        read mkdiryn

        if [ "$mkdiryn" = "y" ]; then

            sudo mkdir -p "$custominstloc"

        else

            echo "Function Canceled!"
            exit

        fi

    fi

    if [ -d "$PWD/build" ]; then

        cd build

        sudo cp -r config mainprog modules asadt.sh "$custominstloc"

        cd $custominstloc

        sudo chmod +x asadt.sh

        echo "usrreg> GENERATING ROOT KEY!"

        if [ -f "/root/.asadt" ]; then

            rm /root/.asadt

            sleep 2

        fi

        echo "appversion='$buildv'" > /root/.asadt
        echo "appversion_long='$buildv_long'" >> /root/.asadt
        echo "approot='$custominstloc'" >> /root/.asadt
        echo "progroot='$custominstloc/mainprog'" >> /root/.asadt
        echo "cnfroot='$custominstloc/config'" >> /root/.asadt
        echo "modroot='$custominstloc/modules'" >> /root/.asadt

    else

        echo "BUILD ERROR: CANNOT FIND '/build/" in "'"$PWD"'"
        echo "Please ensure The working directory houses ASADT's build data!"

        exit 2

    fi

}

function checkapt {

    echo ""
    echo "checkapt> using 'which' to detect apt sources."
    echo "          if any sources respond "'"Not Found"'","
    echo "          then run: apt-get install "'"missing-pkg"'" -y"
    echo ""

    which which
    which zenity
    which git
    which cat
    which sudo
    which nmap
    which nikto
    which dnsmap
    which dmitry
    which assetfinder
    which msfpc

    echo ""

}

builder () {

    checkroot
    getrolling
    buildscript
    checkapt

    echo "Install Complete! To execute ASADT's shell, execute:"
    echo "'$custominstloc/asadt.sh -h' for more help info"

    exit 1

}

builder
