#!/bin/sh
PERCENT=$1
USER=$2
cat << EOF | /usr/libexec/dovecot/dovecot-lda -d $USER -o "plugin/quota=maildir:User quota:noenforcing"
MIME-Version: 1.0
From: postmaster@domain.tld
Subject: Quota warning
Content-Type: text/plain; charset=UTF-8;format=flowed
Content-Transfer-Encoding: 8bit

Your mailbox is now $PERCENT% full. You should delete some messages from the server.
EOF
DELIMITER
