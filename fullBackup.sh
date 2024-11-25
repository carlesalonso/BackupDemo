
#!/bin/bash

# munta unitat per exemple /dev/sdb1 a /media/backup


# set PASSPHRASE
# Això defineix una variable d'entorn anomenada PASSPHRASE que és el que espera duplicity
PASSPHRASE='12345678'
export PASSPHRASE

# acció backup
duplicity tipus carpeta_origen file:///media/backup


# unset PASSPHRASE
# Això elimina el valor de la variables
unset PASSPHRASE

# desmuntar unitat
umount /media/backup


exit 0
