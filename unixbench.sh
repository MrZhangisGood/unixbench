#! /bin/bash
#==============================================================#
#   Description:  Unixbench script                             #
#   Author: root                          #
#   Intro:  https://unixbench.org                      #
#==============================================================#
cur_dir=/opt/unixbench

# Check System
[[ $EUID -ne 0 ]] && echo 'Error: This script must be run as root!' && exit 1
[[ -f /etc/redhat-release ]] && os='centos'
[[ ! -z "`egrep -i debian /etc/issue`" ]] && os='debian'
[[ ! -z "`egrep -i ubuntu /etc/issue`" ]] && os='ubuntu'
[[ "$os" == '' ]] && echo 'Error: Your system is not supported to run it!' && exit 1

# Install necessary libaries
if [ "$os" == 'centos' ]; then
    yum -y install make automake gcc autoconf gcc-c++ time perl-Time-HiRes zip unzip
else
    apt-get -y update
    apt-get -y install make automake gcc autoconf time perl zip unzip
fi

# Create new soft download dir
mkdir -p ${cur_dir}
cd ${cur_dir}

# Download UnixBench5.1.3
if [ -s UnixBench.zip ]; then
    echo "UnixBench.zip [found]"
else
    echo "UnixBench.zip not found!!!download now..."
    if ! wget -c --no-check-certificate https://raw.githubusercontent.com/zq/unixbench/master/UnixBench/UnixBench.zip; then
        echo "Failed to download UnixBench.zip, please download it to ${cur_dir} directory manually and try again."
        exit 1
    fi
fi
unzip UnixBench.zip && rm -f UnixBench.zip
cd UnixBench/

#Run unixbench
chmod +x Run
make
./Run

echo
echo
echo "# ========================================================= #"
echo "# Script description and score comparison completed!  "
echo "# For more information, please go to https://unixbench.org "
echo "# ========================================================= #"
echo
echo