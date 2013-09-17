#!/bin/sh

# SQL injection prevention
name=`printf "%q" "$USER"`

# Executing
echo "UPDATE mailbox SET accessed = NOW(), accesstype = 'POP3', accessip = '$IP' WHERE username = '$name';" | mysql -u postfix -pmypassword postfix
exec "$@"