#!/bin/bash
# Setup chfagent - The Kentik Proxy Agent
# Auther: Craig Yamato II
# date: 02/22/2017
# url: https://github.com/cyamato/chfagent-systemd
# License: GPLv3

# Colors
Red=''
Green=''
Cyan=''
Yellow=''
White=''
NC=''
bold=''
normal=''

# Define the dialog exit status codes
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

# setup common vars
proxy_Local="/usr/bin/chfagent"
url_chfagentServic="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.service"
url_chfagentSystemv="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent-systemv.sh"
url_chfagentServicStatus="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.remote.status"
url_chfagentCapture="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.remote.capture"
url_update="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent-update.sh"


# Make sure user is running with root
if [ ! "$(whoami)" == 'root' ]; then
    echo "${Red}This script must be executed as root or with sudo${NC}"
    exit 0
fi

# Check for dependancies
echo "${Green}Checking for dependancies${NC}"

# wget
wgetCheck=1
if [[ $(hash wget) ]]; then 
    echo "${Yellow}Your system does not have wget.  We will call your package manager to install it for you ${NC}"
    wgetCheck=0
fi

# chfagent
chfagentCheck=1
if [[ ! -e $proxy_Local ]]; then
    echo "${Yellow}Kentik Proxy Agent not found on system.  We will call your package manager to install it for you ${NC}"
    chfagentCheck=0
fi

# check which OS they are running

# Redhat / CentOS
if [[ -e "/etc/redhat-release" ]]; then
    
    case $(grep -Eom1 '[0-9]' /etc/redhat-release | grep -Eom1 '[0-9]') in
    
        "5")
            echo "${Green}RHEL 5"
            OS="rhel"
            init="systemv"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/5/chfagent_rhel_5-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_5-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        "6")
            echo "${Green}RHEL 6"
            OS="rhel"
            init="systemv"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/6/chfagent_rhel_6-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_6-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        "7")
            echo "${Green}RHEL 7"
            OS="rhel"
            init="systemd"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/7/chfagent_rhel_7-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_7-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        *)
            echo "${Red}Sorry only versons 5, 6, and 7 of RHEL/CentOS is supported by this script"
            exit 0
            ;;
    esac

# Debian
else

    if [[ -e "/etc/os-release" ]]; then
        case $(grep -Em1 'NAME="' /etc/os-release) in
            'NAME="Debian"')
                case $(grep -Eom1 'VERSION="[0-9]?[0-9]?.?[0-9]?[0-9]' /etc/os-release | grep -Eom1 '[0-9][0-9]?.?[0-9]?[0-9]?') in
                    "8")
                        echo "${Green}Debian 8"
                        OS="debian"
                        init="systemd"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/debian/8/chfagent-jessie_latest_amd64.deb"
                        packageName="chfagent-jessie_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "7")
                        echo "${Green}Debian 7"
                        OS="debian"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/debian/7/chfagent-wheezy_latest_amd64.deb"
                        packageName="chfagent-wheezy_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    *)
                        echo "${Red}Sorry only versions 7 and 8 of Debian is supported by this script"
                        exit 0
                        ;;
                esac
                ;;
            'NAME="Ubuntu"')
                case $(grep -Eom1 'VERSION="[0-9]?[0-9]?.?[0-9]?[0-9]' /etc/os-release | grep -Eom1 '[0-9][0-9]?.?[0-9]?[0-9]?') in
                    "16.04")
                        echo "${Green}Ubuntu 16.04"
                        OS="ubuntu"
                        init="systemd"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/16.04/chfagent-xenial_latest_amd64.deb"
                        packageName="chfagent-xenial_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "14.04")
                        echo "${Green}Ubuntu 14.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/14.04/chfagent-trusty_latest_amd64.deb"
                        packageName="chfagent-trusty_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "12.04")
                        echo "${Green}Ubuntu 12.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/12.04/chfagent-precise_latest_amd64.deb"
                        packageName="chfagent-precise_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "10.04")
                        echo "${Green}Ubuntu 10.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/10.04/chfagent-lucid_latest_amd64.deb"
                        packageName="chfagent-lucid_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    *)
                        echo "${Red}Sorry only versions 10.04, 12.04, and 14.04 of Ubuntu is supported by this script"
                        exit 0
                        ;;
                esac
                ;;
            *)
                echo "${Red}Sorry this linux distrobution and or version is not curently supported by this script"
                exit 0
                ;;
        esac
    else
        echo "${Red}Sorry this linux distrobution and or version is not curently supported by this script"
        exit 0
    fi
fi

# Check for dependancies
echo "${Green}Checking for dependancies${NC}"

# wget
wgetCheck=1
if [[ $(hash wget) ]]; then 
    echo "${Yellow}Your system does not have wget.  We will call your package manager to install it for you ${NC}"
    wgetCheck=0
fi

# chfagent
chfagentCheck=1
if [[ ! -e $proxy_Local ]]; then
    echo "${Yellow}Kentik Proxy Agent not found on system.  We will call your package manager to install it for you ${NC}"
    chfagentCheck=0
fi

# check which OS they are running

# Redhat / CentOS
if [[ -e "/etc/redhat-release" ]]; then
    
    case $(grep -Eom1 '[0-9]' /etc/redhat-release | grep -Eom1 '[0-9]') in
    
        "5")
            echo "${Green}RHEL 5"
            OS="rhel"
            init="systemv"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/5/chfagent_rhel_5-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_5-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        "6")
            echo "${Green}RHEL 6"
            OS="rhel"
            init="systemv"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/6/chfagent_rhel_6-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_6-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        "7")
            echo "${Green}RHEL 7"
            OS="rhel"
            init="systemd"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/7/chfagent_rhel_7-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_7-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        *)
            echo "${Red}Sorry only versons 5, 6, and 7 of RHEL/CentOS is supported by this script"
            exit 0
            ;;
    esac

# Debian
else

    if [[ -e "/etc/os-release" ]]; then
        case $(grep -Em1 'NAME="' /etc/os-release) in
            'NAME="Debian"')
                case $(grep -Eom1 'VERSION="[0-9]?[0-9]?.?[0-9]?[0-9]' /etc/os-release | grep -Eom1 '[0-9][0-9]?.?[0-9]?[0-9]?') in
                    "8")
                        echo "${Green}Debian 8"
                        OS="debian"
                        init="systemd"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/debian/8/chfagent-jessie_latest_amd64.deb"
                        packageName="chfagent-jessie_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "7")
                        echo "${Green}Debian 7"
                        OS="debian"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/debian/7/chfagent-wheezy_latest_amd64.deb"
                        packageName="chfagent-wheezy_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    *)
                        echo "${Red}Sorry only versions 7 and 8 of Debian is supported by this script"
                        exit 0
                        ;;
                esac
                ;;
            'NAME="Ubuntu"')
                case $(grep -Eom1 'VERSION="[0-9]?[0-9]?.?[0-9]?[0-9]' /etc/os-release | grep -Eom1 '[0-9][0-9]?.?[0-9]?[0-9]?') in
                    "16.04")
                        echo "${Green}Ubuntu 16.04"
                        OS="ubuntu"
                        init="systemd"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/16.04/chfagent-xenial_latest_amd64.deb"
                        packageName="chfagent-xenial_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "14.04")
                        echo "${Green}Ubuntu 14.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/14.04/chfagent-trusty_latest_amd64.deb"
                        packageName="chfagent-trusty_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "12.04")
                        echo "${Green}Ubuntu 12.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/12.04/chfagent-precise_latest_amd64.deb"
                        packageName="chfagent-precise_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "10.04")
                        echo "${Green}Ubuntu 10.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/10.04/chfagent-lucid_latest_amd64.deb"
                        packageName="chfagent-lucid_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    *)
                        echo "${Red}Sorry only versions 10.04, 12.04, and 14.04 of Ubuntu is supported by this script"
                        exit 0
                        ;;
                esac
                ;;
            *)
                echo "${Red}Sorry this linux distrobution and or version is not curently supported by this script"
                exit 0
                ;;
        esac
    else
        echo "${Red}Sorry this linux distrobution and or version is not curently supported by this script"
        exit 0
    fi
fi

# Get chfagent proxy config info

echo ""
echo "${Green}Now setting up the Kentik Proxy Agent, chfagent, SystemD Scripts"

ips=($(ifconfig | grep -Eo 'inet addr:[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?' | grep -Eo '[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?'))
defulatIP=("0.0.0.0")
ips=("${defulatIP[@]}" "${ips[@]}")
COUNTER=1

for i in "${ips[@]}"; do
   if [[ $COUNTER == 1 ]]; then
      RADIOLIST="$RADIOLIST $COUNTER $i on "
   else
      RADIOLIST="$RADIOLIST $COUNTER $i off "
   fi
   let COUNTER=COUNTER+1
done
let COUNTER=COUNTER-1           

emailAddress=""
apiKey=""
exitstatus=0

while [[ -z $emailAddress || -z $apiKey ]]; do
    VALUES=$(dialog --backtitle "Kentik Proxy Agent Setup" --title "Authrization" --ok-label "Submit" --form "Please use the Up and Down Arrows to move between fileds. \nProxy Authrization:" 15 80 0 "eMail Address:" 1 1 "$emailAddress" 1 16 40 0 "API Key:" 3 1 "$apiKey" 3 16 40 0 3>&1 1>&2 2>&3 3>&-)
    exitstatus=$?
    auth=($VALUES)
    emailAddress=${auth[0]}
    apiKey=${auth[1]}
    if [[ $exitstatus -ne 0 ]]; then
            echo
            clear
            echo
            echo "Kentik Proxy Agent Setup Cancled"
            exit $exitstatus
    fi
    if [[ ${#auth[@]} -ne 2 ]]; then
        emailAddress=""
        apiKey=""
    fi
done
   
ip=$(dialog --backtitle "Kentik Proxy Agent Setup" --title "IP Address" --radiolist "Which IP Should The Agent listen On:" 15 80 $COUNTER $RADIOLIST 3>&1 1>&2 2>&3 3>&-)

exitstatus=$?
if [[ $exitstatus -eq 1 ]]; then
    echo
    clear
    echo
    echo "Kentik Proxy Agent Setup Cancled"
    exit $exitstatus
fi
ip=$ip-1
ip=${ips[ip]}

port=9995
ncport=9996
port=$(dialog --backtitle "Kentik Proxy Agent Setup" --title "IP Port" --inputbox "Listen For Flow On Port" 15 80 $port 3>&1 1>&2 2>&3 3>&-)
exitstatus=$?
if [[ $exitstatus -eq 1 ]]; then
    echo
    clear
    echo
    echo "Kentik Proxy Agent Setup Cancled"
    exit $exitstatus
fi
ncport=port+1

dialog --backtitle "Kentik Proxy Agent Setup" --title "Auto Update" --yesno "Auto Update Kentik Proxy Agent?" 10 80 3>&1 1>&2 2>&3 3>&-
autoUpdate=$?

if [ $autoUpdate -eq 0 ]; then
    frq=$(dialog --backtitle "Kentik Proxy Agent Setup" --title "Autoupdate" --radiolist "Pleae note that there may be a brife outage during a Proxy Agnet Upgrade. \n Frequancy:" 20 80 3 1 "Daily" on 2 "Weekly" off 3 "Monthly" off 3>&1 1>&2 2>&3 3>&-)
    exitstatus=$?
    if [[ $exitstatus -eq 1 ]]; then
        echo
        clear
        echo
        echo "Kentik Proxy Agent Setup Cancled"
        exit $exitstatus
    fi
    
    aumin=0
    auhour=0
    auday=0
    audw=0
    
    if [ $frq -eq 1 ]; then
        VALUES=$(dialog --backtitle "Kentik Proxy Agent Setup" --title "Auto Update" --ok-label "Submit" --form "Time:" 20 80 0 "Hour (0-23):" 1 1 "0" 1 18 2 0 "Minute (0-59):" 3 1 "0" 3 18 2 0 3>&1 1>&2 2>&3 3>&-)
        exitstatus=$?
        autime=($VALUES)
        if [[ $exitstatus -ne 0 ]]; then
                echo
                clear
                echo
                echo "Kentik Proxy Agent Setup Cancled"
                exit $exitstatus
        fi
        auhour=${autime[0]}
        aumin=${autime[1]}    
        auday="*"
        audw="*"
    fi
    if [ $frq -eq 2 ]; then
        VALUES=$(dialog --backtitle "Kentik Proxy Agent Setup" --title "Auto Update" --ok-label "Submit" --form "Time:" 15 80 0 "Day (Sun=0-Sat=6):" 1 1 "0" 1 18 2 0 "Hour (0-23):" 3 1 "0" 3 18 2 0 "Minute (0-59):" 5 1 "0" 5 18 2 0 3>&1 1>&2 2>&3 3>&-)
        exitstatus=$?
        autime=($VALUES)
        if [[ $exitstatus -ne 0 ]]; then
                echo
                clear
                echo
                echo "Kentik Proxy Agent Setup Cancled"
                exit $exitstatus
        fi
        audw=${autime[0]}
        auhour=${autime[1]}
        aumin=${autime[2]}    
        auday="*"
    fi
    if [ $frq -eq 3 ]; then
        VALUES=$(dialog --backtitle "Kentik Proxy Agent Setup" --title "Auto Update" --ok-label "Submit" --form "Time:" 15 80 0 "Day of Month:" 1 1 "0" 1 18 2 0 "Hour (0-23):" 3 1 "0" 3 18 2 0 "Minute (0-59):" 5 1 "0" 5 18 2 0 3>&1 1>&2 2>&3 3>&-)
        exitstatus=$?
        autime=($VALUES)
        if [[ $exitstatus -ne 0 ]]; then
                echo
                clear
                echo
                echo "Kentik Proxy Agent Setup Cancled"
                exit $exitstatus
        fi
        auday=${autime[0]}
        auhour=${autime[1]}
        aumin=${autime[2]}    
        audw="*"
    fi
fi

echo "${NC}${normal}"

if [[ $init == "systemd" ]]; then
    # Install Proxy Systemd Scripts and configuration file
    
    if [ ! -w "${systemd_dir}" ]; then
        echo "You do not have write permission to ${systemd_dir}"
        exit 1
    fi
    
    localFile="${systemd_dir}chfagent.service"
    
    if [[ -e $localFile ]]; then
        rm $localFile
    fi
    
    wget -O $localFile $url_chfagentServic
    
    if [ ! -d "${systemd_dir}chfagent.service.d/" ]; then
        mkdir ${systemd_dir}chfagent.service.d/
    fi
    
    if [ -e "${systemd_dir}chfagent.service.d/local.conf" ]; then
        rm ${systemd_dir}chfagent.service.d/local.conf
    fi
    
    echo "[Service]" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_email=$emailAddress'" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_token=$apiKey'" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_ip=$ip'" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_port=$port" >> ${systemd_dir}chfagent.service.d/local.conf
    
    echo "export ncport='$ncport'" >> /etc/sysconfig/chfagent
    echo "export OS='$os'" >> /etc/sysconfig/chfagent
    echo "export proxy_dl_url='$proxy_dl_url'" >> /etc/sysconfig/chfagent
    echo "export pakageName='$pakageName'" >> /etc/sysconfig/chfagent
    echo "export init='$init'" >> /etc/sysconfig/chfagent
    
    if [[ -e "$packageName" ]]; then
        rm $packageName
    fi
    
    eval systemctl enable chfagent
    
    eval systemctl start chfagent
fi

if [[ $init == "systemv" ]]; then
    if [ ! -w "/var/lock/" ]; then
        echo "You do not have write permission to /var/lock/"
        exit 1
    fi
    if [ ! -w "/etc/" ]; then
        echo "You do not have write permission to /etc/"
        exit 1
    fi
    if [ ! -w "/etc/init.d/" ]; then
        echo "You do not have write permission to /etc/init.d/"
        exit 1
    fi
    if [ ! -w "/etc/rc0.d/" ]; then
        echo "You do not have write permission to /etc/rc0.d/"
        exit 1
    fi
    
    if [ -e "/etc/init.d/chfagent" ]; then
        rm /etc/init.d/chfagent
    fi
    
    wget -O /etc/init.d/chfagent $url_chfagentSystemv
    chmod +x /etc/init.d/chfagent
    
    if [ ! -d "/etc/sysconfig/" ]; then
        mkdir /etc/sysconfig/
    fi 
    
    if [ ! -w "/etc/sysconfig/" ]; then
        echo "You do not have write permission to /etc/sysconfig/"
        exit 1
    fi
    
    if [ ! -d "/var/lock/subsys/" ]; then
        mkdir /var/lock/subsys/
    fi
    
    if [ -e "/etc/sysconfig/chfagent" ]; then
        rm /etc/sysconfig/chfagent
    fi
    
    echo email='$emailAddress' >> /etc/sysconfig/chfagent
    echo token='$apiKey' >> /etc/sysconfig/chfagent
    echo host='$ip' >> /etc/sysconfig/chfagent
    echo port='$port' >> /etc/sysconfig/chfagent
    echo "export ncport='$ncport'" >> /etc/sysconfig/chfagent
    echo "export OS='$os'" >> /etc/sysconfig/chfagent
    echo "export proxy_dl_url='$proxy_dl_url'" >> /etc/sysconfig/chfagent
    echo "export pakageName='$pakageName'" >> /etc/sysconfig/chfagent
    echo "export init='$init'" >> /etc/sysconfig/chfagent
            
    
    ln -s /etc/init.d/chfagent /etc/rc0.d/S55chfagent
    
    service chfagent start
fi

wget -O /usr/bin/ $url_chfagentCapture
chmod u+x /usr/bin/chfagent.remote.capture
wget -O /usr/bin/ $url_chfagentServicStatus
chmod u+x /usr/bin/chfagent.remote.status
wget -O /usr/bin/ $url_update
chmod u+x /usr/bin/chfagent-update.sh

if [ $autoUpdate=0 ]; then
    crontab -e $aumin $auhour $auday * $audw /usr/bin/chfagent-update.sh
fi

echo "${White}${bold}The Kentik Proxy Agent, chfagent, startup script completed.  Starting Proxy Agent...${NC}${normal}"
echo ""

statuscheck=$(nc localhost ${ncport})
dialog --backtitle "Kentik Proxy Agent Setup" --title "Kentik Proxy Agent Status" --msgbox "${statuscheck}" 10 80

echo ""
echo clear
echo ""
echo ""