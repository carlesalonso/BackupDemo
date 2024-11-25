#!/bin/bash

# munta unitat
mount /dev/sdb1/   /media/backup

# test
if [ $? -ne 0 ]; then
  echo "$(date +%F-%T) Error muntat unitat" >> /var/log/backup
  exit 1
fi

# set PASSPHRASE
PASSPHRASE='12345678'
export PASSPHRASE

# acció backup
duplicity full /var/www file:///media/backup/

# test
if [ $? -ne 0 ]; then
  echo "$(date +%F-%T) Error durant backup" >> /var/log/backup
  exit 1
fi

# unset PASSPHRASE
unset PASSPHRASE

# desmuntar unitat
umount /media/backup

echo "$(date +%F-%T) Backup realitzat exitosament" >> /var/log/backup
exit 0

# desmuntar unitat
umount /media/backup


exit 0
