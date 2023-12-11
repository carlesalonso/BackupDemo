# Exemple script per gestionar backup amb Duplicity

Duplicity us permet fer backups d'un servidor Linux tant cap unitats locals, com cap unitats remotes. 

La informació sobre com usar Duplicity la teniu al següent link: [Duplicity man page](https://manpages.ubuntu.com/manpages/jammy/man1/duplicity.1.html)

Per poder automatitzar les còpies usarem scripts que executarem amb `cron` per planificar la periodicitat.

L'script que teniu és un **exemple** on es fa una còpia **completa** de la carpeta **/var/www** a una unitat extraïble que es munta a la ruta **/media/tape**.

L'script l'haurà d'executar **root**, per tant, s'ubicarà a la carpeta `/root/`

Les accions que realitza són:

1. Munta la unitat extraïble.
2. Comprova si s'ha pogut muntar i si no, surt de l'execució amb error (exit 1)
3. Defineix el valor de la variable d'entorn `PASSPHRASE` que Duplicity utilitza com clau de xifrat.
4. Executa duplicity
5. Comprova que la còpia s'ha realitzat amb èxit i si no, surt de l'execució amb error (exit 1)
6. Elimina la variable d'entorn PASSPHRASE
7. Desmunta la unitat extraïble
8. Surt de l'execució amb èxit (exit 0)

Aquí teniu l'exemple:

```bash

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
```

Recordar que l'script ha de tenir permisos d'execució:

```bash

chmod +x fullBackup.sh

```

Per planificar-lo, cal editar cron (com root) i fixar la planificació, en aquest exemple, diumenges a les 23:00.

```bash
crontab -e
```

I escriure la següent entrada:

```bash
0   23   *   *   7   /root/fullBackup.sh
```



