#!/bin/bash -e

if [[ "$EUID" != 0 ]]; then
  echo must be root
  exit 0
fi


fname='static/flag_is_in_here.jpg'
waiter_password=pl554m

echo 'hostname=?'
read new_hostname
echo 'flag=?'
read flag

set -x

apt update && apt install fish npm openssh-server -y

useradd -U -m potato -s $(which fish)
su potato --shell $(which bash) << EOSU
set -x
cp -r user/* ~
cd ~
chmod -rwx README
exit
EOSU

useradd -U -m waiter -s /bin/bash
su waiter << EOSU
set -x
cp -r potato-server ~
cd ~/potato-server

openssl rand $(( 2**30 / 4 )) >> $fname
echo "The FLAG is on the next line...\n$flag\n" >> $fname 
openssl rand $(( 2**30 / 4 )) >> $fname

echo strict-ssl=false >> .npmrc
npm i
EOSU

chown -R waiter /home/waiter/potato-server

chpasswd << EOF
potato:starch
waiter:$waiter_password
EOF


hostnamectl set-hostname $new_hostname
systemctl restart avahi-daemon

grep 'Match User waiter' /etc/ssh/sshd_config
if [ "$?" -ne "0" ]; then
cat >> /etc/ssh/sshd_config << EOF
Match User waiter
    PasswordAuthentication no
EOF
fi
systemctl restart ssh



{ set +x; } 2> /dev/null
systemctl status avahi-daemon | grep -F '.local' 

echo "Please login as waiter: $(tput bold)su waiter$(tput sgr0)."
echo "cd ~/potato-server && npm start"
echo "password is $waiter_password"

