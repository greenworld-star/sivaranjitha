#!/bin/sh
currentpath=$(pwd)
root_password=`grep -e "root_password" input.properties | awk -F[=] '{print $2}'`
machine_username=`grep -e "machine_username" input.properties | awk -F[=] '{print $2}'`
yum install sed -y >>$currentpath/error.log 2>&1
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config >>$currentpath/error.log 2>&1
sudo service sshd restart >>$currentpath/error.log 2>&1
echo "root:${root_password}" | chpasswd  >>$currentpath/error.log 2>&1
echo "${machine_username} ALL = (ALL) NOPASSWD: ALL" >>/etc/sudoers 2>&1
if grep "No such file" "$currentpath/error.log" 2>&1
then
echo failed > $currentpath/status.log
echo Could not enable the No Password.Kindly refer the error.log for more information >>$currentpath/info.log
exit
else
echo success > $currentpath/status.log
echo Successfully enabled the No Password on this Machine>>$currentpath/info.log
exit
fi
