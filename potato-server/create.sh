#!/bin/bash -e

fname='static/flag_is_in_here.jpg'

echo 'flag=?'
read flag

set -x

openssl rand $(( 2**30)) >> $fname
echo "The FLAG is on the next line...\n$flag\n" >> $fname 
openssl rand $(( 2**30)) >> $fname
