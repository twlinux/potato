#!/bin/bash -ex
if [[ "$EUID" != 0 ]]; then
  echo must be root
  exit 0
fi

fname='static/flag_is_in_here.jpg'
waiter_password=jetEnerbEf

echo 'flag=?'
read flag


apt update && apt install fish npm -y

useradd -U -m potato -s $(which fish)
su potato << EOF
cd ..
cp -r user/* ~
cd ~
chmod -rwx README
exit
EOF

useradd -U -m waiter -s /bin/bash
su waiter << EOF
cd ..
cp -r potato-server ~
cd ~/potato-server

openssl rand $(( 2**30)) >> $fname
echo "The FLAG is on the next line...\n$flag\n" >> $fname 
openssl rand $(( 2**30)) >> $fname

npm config set strict-ssl false
npm i
EOF

chpasswd <<< "potato:starch\nwaiter:$waiter_password"

{ set +x; } 2> /dev/null
echo "Please login as $(tput bold)waiter$(tput sgr0)."
echo "cd ~/potato-server && npm start"
echo "password is $waiter_password"

