#!/bin/bash
# yl5.1-setup.sh - ettevalmistus Debian tarkvarahalduse ülesande jaoks
# Käivita root kasutajana (nt sudo ./yl5.1-setup.sh)

set -e

STUDENT_HOME="/home/student"
echo ">>> Alustan harjutuse ettevalmistust..."

# Kontrolli, et kasutaja student eksisteeriks
if ! id -u student >/dev/null 2>&1; then
  echo "Kasutajat 'student' ei eksisteeri! Loo see enne harjutust."
  exit 1
fi

# Eemalda paketid, mis võivad olla eelnevalt paigaldatud
echo ">>> Eemaldan paketid nginx, mc, fortune-mod, webmin, bind9 (kui olemas)..."
apt purge -y nginx mc fortune-mod bind9 || true
dpkg -r webmin || true

# Puhasta
apt autoremove -y || true
apt clean || true

# Kustuta failid ja käsuajalugu
echo ">>> Kustutan failid debian.txt, nginx.txt, depends.txt ja käsuajalugu..."
su - student -c "rm -f ${STUDENT_HOME}/debian.txt ${STUDENT_HOME}/nginx.txt ${STUDENT_HOME}/depends.txt"
su - student -c "history -c"

# Lae alla Webmini installifail
echo ">>> Laen alla Webmini installifaili..."
su - student -c "wget -O ${STUDENT_HOME}/webmin_2.402_all.deb https://sourceforge.net/projects/webadmin/files/webmin/2.402/webmin_2.402_all.deb/download"

echo ">>> Ettevalmistus tehtud! Saad nüüd ülesandega alustada."
