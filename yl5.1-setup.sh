#!/bin/bash
# yl5.1-setup.sh - ettevalmistus Debian tarkvarahalduse ülesande jaoks
# Käivita root kasutajana (nt sudo ./yl5.1-setup.sh)

set -e

STUDENT_HOME="/home/student"
echo ">>> Alustan harjutuse ettevalmistust..."
echo ">>> Oota, see võtab natuke aega..."

# Kontrolli, et kasutaja student eksisteeriks
if ! id -u student >/dev/null 2>&1; then
  echo "Kasutajat 'student' ei eksisteeri! Loo see enne harjutust."
  exit 1
fi

# Eemalda paketid, mis võivad olla eelnevalt paigaldatud
apt purge -y nginx mc fortune-mod >/dev/null 2>&1 || true
dpkg -r webmin >/dev/null 2>&1 || true

# Puhasta
apt autoremove -y >/dev/null 2>&1 || true
apt clean >/dev/null 2>&1 || true

# Paigalda bind9
apt install -y bind9 >/dev/null 2>&1 || true

# Kustuta failid ja käsuajalugu
su - student -c "rm -f ${STUDENT_HOME}/debian.txt ${STUDENT_HOME}/nginx.txt ${STUDENT_HOME}/depends.txt" >/dev/null 2>&1
su - student -c "history -c" >/dev/null 2>&1

# Lae alla Webmini installifail (wget väljastaks muidu infot)
su - student -c "wget -q -O ${STUDENT_HOME}/webmin_2.501_all.deb https://sourceforge.net/projects/webadmin/files/webmin/2.501/webmin_2.501_all.deb/download" >/dev/null 2>&1

echo ">>> Ettevalmistus tehtud! Saad nüüd ülesandega alustada."
