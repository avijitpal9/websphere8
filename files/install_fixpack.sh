#!/bin/bash
#Install Fixpack Validation Script
num_args=$#
#echo $num_args

mtn_pkgid=$1
install_loc=$2

if [ $num_args -lt 2 ]
then
echo "You need to pass atleast 2 arguments"
exit 1
elif [ $num_args -gt 2 ]
then
echo "You need to pass only 2 arguments"
exit 1
fi

#if [[ $install_type == "wassdk" || $install_type == "ihssdk" ]]
#then
#echo "SDK Intallation"
#cmd="$install_loc/bin/versionInfo.sh -maintenancePackages |& grep $mtn_pkgid"
#else
#echo "Non SDK Installation"
#cmd="$install_loc/bin/versionInfo.sh -maintenancePackages |& grep $mtn_pkgid"
#fi

cmd="$install_loc/bin/versionInfo.sh -maintenancePackages |& grep $mtn_pkgid"

echo "$cmd"

eval "$cmd"

if [ $? -eq 0 ]
then
#echo "command successfull"
exit 0
else
#echo "command fail"
exit 1
fi

