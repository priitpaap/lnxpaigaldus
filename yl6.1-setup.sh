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

# Loo failid /etc kausta kus sisaldub sõna "abiline"
mkdir -p /etc/local
mkdir -p /etc/X81
echo "Siin see abiline peidus ongi!" > /etc/logcontrol.conf
echo "Vahest on ABILINE kirjutatud ka suurelt!" > /etc/local/system.conf
echo "Samuti võib Abiline alata suure tähega!" > /etc/uboot.conf
echo "Siin see on seeAbilinEkogemata kirjutatud sõna sisse!" > /etc/X81/notaguifile.conf

# Loo /usr/local alla failid, mis kuuluvad peetrile
mkdir -p /usr/local/games
mkdir -p /usr/local/share/log
mkdir -p /usr/local/secure
echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit." > /usr/local/games/xml_file.txt
echo "Fusce lacus purus, auctor ac ante ut, euismod lacinia nisi." > /usr/local/share/log/log1.log
echo "Aenean varius ante feugiat lacus hendrerit aliquam." > /usr/local/secure/secure.conf
chown peeter:peeter /usr/local/games/xml_file.txt
chown peeter:peeter /usr/local/share/log/log1.log
chown peeter:peeter /usr/local/secure/secure.conf

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
