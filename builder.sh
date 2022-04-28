#!/bin/bash
# Assistive Search And Discovery Tool Mark II v100 Builder Application
# Licensed Under GNU GENERAL PUBLIC LICENSE
# Script Developed And Maintained by Onetrak Digital Forensics Corporation


builder_version="1.0.1"
buildv="v1.0.1"
buildv_long="MARK II BETA | v 1.0.1"

function checkroot {

    if [ "$USER" = "root" ]; then

        echo "proginit> user=$SUDO_USER"

    else

        echo "proginit> please run "'"sudo ./builder.sh"'" "

        exit

    fi

}

function getuser {

    if [ "$SUDO_USER" = "root" ]; then

        echo "proginit> WARNING!"
        echo ""
        echo "proginit> The active terminal user is currently reflecting "'"root"'"! "
        echo "          Please note that installing ASADT as root on systems with user"
        echo "          accounts setup is extremely discouraged. This form of install is"
        echo "          recommended only for those using ASADT on Kali-Docker, or any Linux"
        echo "          system that does not have a user directory setup."
        echo ""
        echo "proginit> The most common reason for general users to recieve this message is if"
        echo "          you executed "'"sudo ./builder.sh"'" after running "'"sudo su"'"! "
        echo "          If that is the case, please execute "'"./builder.sh"'" without "'"sudo"'"! "
        echo ""
        echo "nouseracct> PRESS [ENTER] TO CONTINUE, OR CTRL+C TO QUIT!"

        read nulkey

    fi

}

function getuserreg {

    regkey=/home/"$SUDO_USER"/.asadt

    if [ -f $regkey ]; then

        source $regkey

        echo "userreg> PREVIOUS USERREG FILE FOUND, ASADT WILL NOW UPDATE IT SELF"
        echo "userreg> TO FRESH INSTALL PLEASE RUN: sudo rm /home/$SUDO_USER/.asadt"
        echo ""

        asadtupdate=1

    else

        regkey=/root/.asadt

        if [ -f $regkey ]; then

            source $regkey

            echo "userreg> PREVIOUS USERREG FILE FOUND, ASADT WILL NOW UPDATE IT SELF"
            echo "userreg> TO FRESH INSTALL PLEASE RUN: sudo rm /root/.asadt"
            echo ""

            asadtupdate=1

        fi

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

function build {

    echo "ASADT Release-$buildv Build Script"
    echo "Version to be Built: [$buildv_long]"
    echo "Builder Script Version: [$builder_version]"
    echo ""
    echo ""

    if [ "$asadtupdate" = "1" ]; then

        sudo rm -r $approot

        sleep 2 # For slow kernels

        sudo mkdir $approot $progroot $docroot $cnfroot

        sleep 2 # For slow kernels

        cd build

        cp asadt.sh $approot
        cp -r prog cnf doc $approot

        cd $approot

        chmod +x asadt.sh

        echo "UPDATE COMPLETE!"
        exit

    else

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
            echo -n "Would you like to make it? [y/n]"
            read mkdiryn

            if [ "$mkdiryn" = "y" ]; then

                    sudo mkdir $custominstloc

            else

                exit

            fi

        fi
    fi

    if [ -d "$PWD/build" ]; then

        cd $PWD/build

        sudo cp asadt.sh $custominstloc

        sudo mkdir $custominstloc/doc
        sudo mkdir $custominstloc/cnf
        sudo mkdir $custominstloc/prog

        sudo cp -r prog $custominstloc
        sudo cp -r cnf $custominstloc
        sudo cp -r doc $custominstloc

        cd $custominstloc

        sudo chmod +x asadt.sh


        if [ "$SUDO_USER" = "root" ]; then

            echo "userreg> user=root"
            echo "userreg> only generating root key!"

        else

            echo "userreg> GENERATING ACTIVE USER REGISTRY FILE!"
            echo "appversion='$buildv'" > /home/$SUDO_USER/.asadt
            echo "appversion_long='$buildv_long'" >> /home/$SUDO_USER/.asadt
            echo "approot='$custominstloc'" >> /home/$SUDO_USER/.asadt
            echo "progroot='$custominstloc/prog'" >> /home/$SUDO_USER/.asadt
            echo "cnfroot='$custominstloc/cnf'" >> /home/$SUDO_USER/.asadt
            echo "docroot='$custominstloc/doc'" >> /home/$SUDO_USER/.asadt

        fi

        echo "userreg> GENERATING ROOT BACKUP KEY!"
        echo "appversion='$buildv'" > /root/.asadt
        echo "appversion_long='$buildv_long'" >> /root/.asadt
        echo "approot='$custominstloc'" >> /root/.asadt
        echo "progroot='$custominstloc/prog'" >> /root/.asadt
        echo "cnfroot='$custominstloc/cnf'" >> /root/.asadt
        echo "docroot='$custominstloc/doc'" >> /root/.asadt

    else

        echo "Could Not Access '$PWD/build!'"
        echo "Please ensure The working directory houses ASADT's build data!"

        exit

    fi

}

function checkapt {

    echo ""
    echo "checkapt> using 'which' to detect apt sources."
    echo "          if any sources respond "'"Not Found"'","
    echo "          then run: apt-get install "'"pkg"'" -y"
    echo ""

    which zenity
    which git
    which cat
    which sudo
    which nmap
    which nikto
    which dnsmap
    which dmitry
    which assetfinder

    echo ""

}


checkroot
getuser
getuserreg
getrolling
build
checkapt

echo ""
echo "INSTALL COMPLETE! PLEASE ENSURE APT-SOURCES ARE PROPERLY CONFIGURED ABOVE!"
echo "RUN: $custominstloc/asadt.sh -h | THIS WILL DISPLAY THE HELP DOC"

exit 1
