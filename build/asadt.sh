#!/bin/bash
# ASADT Mark II
# Script Developed & Maintained by ODFSEC
# Script Version: 1.0.0


# Internal Variable Table

    userregfile="/home/$SUDO_USER/.asadt"
    userregbackup="/root/.asadt"

    initprog="initprog>"
    userreg="userreg>"

    cmd1=$1
    cmd2=$2
    cmd3=$3

# Internal Function Library

    function userstat {

        if [ "$USER" = "root" ]; then

            checkpass=1

        else

            echo "$initprog Please run 'sudo $0'"

            exit 401

        fi

    }

    function getuserreg {

        if [ -f "$userregfile" ]; then

            source $userregfile

            elif [ -f "$userregbackup" ]; then

                source $userregbackup

            else

                echo "$initprog Can't access the 'userreg' file from its default location."
                echo "$initprog Try Executing: 'sudo cp /root/.asadt /home/$SUDO_USER/.asadt'"
                echo "$initprog This will copy the root backup to the missing or corrupt user one."

                exit

        fi

    }

    function sourceprog {

        source $progroot/func/main/dispversion.func
        source $progroot/func/main/disphelp.func
        source $progroot/func/main/update.func
        source $progroot/func/main/parsevar_scantool.func

        source $progroot/func/scantool/assetfinder_scan.func
        source $progroot/func/scantool/dmitry_scan.func
        source $progroot/func/scantool/dnsmap_scan.func
        source $progroot/func/scantool/nikto_scan.func
        source $progroot/func/scantool/nmap_scan.func

        source $cnfroot/scantool/scantool.cnf

        source $progroot/gui/scantool/wiz_nmap.gui
        source $progroot/gui/scantool/wiz_dmitry.gui
        source $progroot/gui/scantool/wiz_assetfinder.gui
        source $progroot/gui/scantool/wiz_nikto.gui
        source $progroot/gui/scantool/wiz_dnsmap.gui

    }

    function passvar_mainprog {

        if [ -z "$cmd1" ]; then

            echo "Missing argument after '$0'"

            exit 404

        fi

        if [ "$cmd1" = "-v" ]; then

            dispversion

            exit 99

            elif [ "$cmd1" = "-h" ]; then

                disphelp

                elif [ "$cmd1" = "--update" ]; then

                    update

                    exit

                    elif [[ "$cmd1" = "--scantool" && "$cmd2" = "nmap" ]]; then

                        wizgui_nmap

                        parsevar_scantool

                        scantool_nmapscan

                        exit

                        elif [[ "$cmd1" = "--scantool" && "$cmd2" = "dmitry" ]]; then

                            wizgui_dmitry

                            parsevar_scantool

                            scantool_dmitryscan

                            exit

                            elif [[ "$cmd1" = "--scantool" && "$cmd2" = "nikto" ]]; then

                                wizgui_nikto

                                parsevar_scantool

                                scantool_niktoscan

                                exit

                                elif [[ "$cmd1" = "--scantool" && "$cmd2" = "assetfinder" ]]; then

                                    wizgui_assetfinder

                                    parsevar_scantool

                                    scantool_assetfinderscan

                                    exit

                                    elif [[ "$cmd1" = "--scantool" && "$cmd2" = "dnsmap" ]]; then

                                        wizgui_dnsmap

                                        parsevar_scantool

                                        scantool_dnsmapscan

                                        exit

        else

            echo "passvar_mainprog.intfunc> Error, uknown command '$0 $cmd1 $cmd2 $cmd3'"

            exit 404

        fi

    }

#PROGMAIN STACK 1

progmain () {

userstat
getuserreg
sourceprog
passvar_mainprog

}

progmain

exit 999
