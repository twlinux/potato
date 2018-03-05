#!/bin/bash -e

fname='flag_is_in_here.jpg'

echo 'flag=?'
read flag

set -x

openssl rand $(( 2**30)) >> $fname
echo "The flag is on the next line...\n$flag\n" >> $fname 
openssl rand $(( 2**30)) >> $fname

cat << EOF
Next steps

1.) delete this script
2.) move $fname to somewhere safe
EOF

rm LICENSE
chmod -rw README

