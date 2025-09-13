#!/bin/bash
# yl6.1-setup.sh - ettevalmistus Debiani ülesande 6.1 jaoks
# Käivita root kasutajana (nt sudo ./yl6.1-setup.sh)

set -e

STUDENT_HOME="/home/student"
echo ">>> Alustan harjutuse ettevalmistust..."

# Kontrolli, et kasutaja student eksisteeriks
if ! id -u student >/dev/null 2>&1; then
  echo "Kasutajat 'student' ei eksisteeri! Loo see enne harjutust."
  exit 1
fi

# Loo kasutaja peeter, kui teda ei ole
if ! id -u peeter >/dev/null 2>&1; then
  useradd -m peeter
  echo "peeter:peeter" | chpasswd
fi

# Loo fail /etc kausta sõnaga "abiline"
echo "See on abiline testfail" > /etc/abiline.conf

# Loo /usr/local alla kaust ja failid, mis kuuluvad peeterile
mkdir -p /usr/local/peeter_files
echo "Peetri fail" > /usr/local/peeter_files/test1.txt
echo "Veel üks Peetri fail" > /usr/local/peeter_files/test2.txt
chown -R peeter:peeter /usr/local/peeter_files

# Loo /var/logbackup ja lisa vanad failid (muuda kuupäev 6 a tagasi)
mkdir -p /var/logbackup
echo "Vana logifail" > /var/logbackup/old1.log
echo "Teine vana logifail" > /var/logbackup/old2.log
# Muudame ajatempli 6 aastat tagasi
touch -d "6 years ago" /var/logbackup/*.log

# Loo /var alla error.log failid
mkdir -p /var/test1 /var/test2
echo "Error1" > /var/test1/error.log
echo "Error2" > /var/test2/error.log

# Kustuta võimalikud vanad failid õppija kodukaustast
su - student -c "rm -f ${STUDENT_HOME}/k2sud.txt ${STUDENT_HOME}/abiline.txt ${STUDENT_HOME}/peeter.txt ${STUDENT_HOME}/logid.txt ${STUDENT_HOME}/ssh.txt"

# Tühjenda käsuajalugu
su - student -c "history -c" >/dev/null 2>&1

echo ">>> Ettevalmistus tehtud! Saad nüüd ülesandega alustada."
