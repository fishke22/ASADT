#!/bin/bash

# Assistive Search And Discovery Tool MARK II
# Script Version 1.0.4

# This Script Is Developed & Maintained By The
# Onetrak Digital Forensics Corportaion

# PROGVAR
cmdvar1="$1"
cmdvar2="$2"
userreg="/root/.asadt"

# INTPROG FUNCTIONS
function userstatus {

    if [ "$UID" = "0" ]; then

        current_su="true"

    else

        echo "$0 Requires Sudo Privledges"
        exit 0

    fi

}

function getuserreg {

    if [ -f "$userreg" ]; then

        source $userreg

        #MAIN PROGRAM DATA LIB
        source $approot/mainprog/func/disphelp.func
        source $approot/mainprog/func/dispversion.func
        source $approot/mainprog/func/update.func

        # SCANTOOL LIB
        source $approot/modules/scantool/func/assetfinder_scan.func
        source $approot/modules/scantool/func/dmitry_scan.func
        source $approot/modules/scantool/func/dnsmap_scan.func
        source $approot/modules/scantool/func/nikto_scan.func
        source $approot/modules/scantool/func/nmap_scan.func
        source $approot/modules/scantool/gui/wiz_assetfinder.gui
        source $approot/modules/scantool/gui/wiz_dmitry.gui
        source $approot/modules/scantool/gui/wiz_dnsmap.gui
        source $approot/modules/scantool/gui/wiz_nikto.gui
        source $approot/modules/scantool/gui/wiz_nmap.gui
        source $approot/config/scantool.config

        # EXEMKR LIB
        source $approot/modules/exemkr/func/msfpc_exemkr.func
        source $approot/modules/exemkr/gui/wiz_msfpc.gui
        source $approot/config/exemkr.config

    else

        echo "FATAL PROGRAM ERROR!"
        echo ""
        echo "MISSING USER REGISTRY FILE @ /root/.asadt"
        echo "ENSURE YOU HAVE PROPERLY INSTALLED THE PROGRAM!"

    fi

}

function mainout {

    if [ -d "$output_main" ]; then

        echo "OK"
        cd "$output_main"

    else

        echo "Looks like '$output_main' Doesn't Exist..."
        echo -n "Press [ENTER] to create the directory or "'"CTRL+C"'" to cancel"
        read nulkey
        mkdir -p "$output_main"
        cd "$output_main"

    fi

}

function passvar_cmd {

    if [ "$cmdvar1" = "-v" ]; then

        dispversion

        exit

    fi

    if [ "$cmdvar1" = "-h" ]; then

        disphelp

        exit

    fi

    if [ "$cmdvar1" = "-hh" ]; then

        disphelp_full

        exit

    fi

    if [ "$cmdvar1" = "--updatecheck" ]; then

        chkupdate

        exit

    fi

    if [[ "$cmdvar1" = "--scantool" && "$cmdvar2" = "assetfinder" ]]; then

        wizgui_assetfinder
        mainout
        scantool_assetfinderscan

        exit

    fi

    if [[ "$cmdvar1" = "--scantool" && "$cmdvar2" = "dmitry" ]]; then

        wizgui_dmitry
        mainout
        scantool_dmitryscan

        exit

    fi

    if [[ "$cmdvar1" = "--scantool" && "$cmdvar2" = "dnsmap" ]]; then

        wizgui_dnsmap
        mainout
        scantool_dnsmapscan

        exit

    fi

    if [[ "$cmdvar1" = "--scantool" && "$cmdvar2" = "nikto" ]]; then

        wizgui_nikto
        mainout
        scantool_niktoscan

        exit

    fi

    if [[ "$cmdvar1" = "--scantool" && "$cmdvar2" = "nmap" ]]; then

        wizgui_nmap
        mainout
        scantool_nmapscan

        exit

    fi

    if [ "$cmdvar1" = "--exemkr" ]; then

        wizgui_msfpc_custom

        mainout

        exemkr_msfpc

        exit

    fi


}

#MAINPROG STACK 1
mainprog () {

userstatus
getuserreg
passvar_cmd

}

mainprog

# SCANTOOL CLAUSE
if [[ "$cmdvar1" = "--scantool" && -z "$cmdvar2" ]]; then

    echo "Prog_Error: Missing argument "'"modulename"'" after '--scantool'"
    echo "Prog_HelpMsg: Need more help? Run $0 -h or -hh"
    exit 0

fi

# UKNOWN CLAUSE
echo "Prog_Error: Unknown Command... $0 $1 $2"
echo "Prog_HelpMsg: Need more help? Run $0 -h or -hh"
exit 0
