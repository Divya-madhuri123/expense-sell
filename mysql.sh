#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[33m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo "$2...FAILURE"
        exit 1
    else
        echo "$2...SUCCESS"
   fi
}


if [ $USERID -ne 0 ]
then
    echo "please run this script with root access."
    exit 1
else
    echo "you are super user."
fi


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MYSQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MYSQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MYSQL Server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting up root password"