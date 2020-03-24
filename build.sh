#!/usr/bin/env bash

ip=$1

type=$2

folder=''

if [[ ! "$ip" ]];then
   echo "Please enter IP Address to scp"
   exit;
fi
echo "Moving app terraform script.."

echo $ip

case "$type" in
    "build") folder="app-terraform";;

    "ansible") folder="app-ansible";;

    *)
    echo "Include type"
    exit;;
esac

cmd="rm -rf ~/"${folder}
echo ${cmd}

ssh -i ~/.ssh/secret_key ubuntu@$ip ${cmd}

scp -i ~/.ssh/secret_key -r ./${folder} ubuntu@$ip:~/
