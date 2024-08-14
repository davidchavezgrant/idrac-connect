#!/bin/bash

#echo -n 'Host: '
#read drachost

#echo -n 'Username: '
#read dracuser

#echo -n 'Password: '
#read -s dracpwd

# Statically set for homelab.local
drachost="192.168.100.3"
dracuser="root"
dracpwd="root"

# cd for global usage
cd ~/config/utilities/idrac-connect/

if [[ ! -f ./avctKVM.jar ]]
then
   wget https://${drachost}/software/avctKVM.jar --no-check-certificate
fi

file1=""
file2=""
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   if [[ ! -f ./lib/avctVMLinux64.jar ]]; then
      file1="https://${drachost}/software/avctKVMIOLinux64.jar"
      file2="https://${drachost}/software/avctVMLinux64.jar"
   fi
elif [[ "$unamestr" == 'Darwin' ]]; then
   if [[ ! -f ./lib/avctVMMac64.jar ]]; then
      file1="https://${drachost}/software/avctKVMIOMac64.jar"
      file2="https://${drachost}/software/avctVMMac64.jar"
   fi
fi

mkdir -p `pwd`/lib/;
wget -O `pwd`/lib/`basename ${file1}` ${file1} --no-check-certificate
wget -O `pwd`/lib/`basename ${file2}` ${file2} --no-check-certificate


./jre/bin/java -cp avctKVM.jar -Djava.library.path=./lib com.avocent.idrac.kvm.Main ip=$drachost kmport=5900 vport=5900 user=$dracuser passwd=$dracpwd apcp=1 version=2 vmprivilege=true "helpurl=https://$drachost:443/help/contents.html"
