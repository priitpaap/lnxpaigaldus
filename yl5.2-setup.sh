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
sudo dnf remove -y nginx mc fortune-mod >/dev/null 2>&1 || true
sudo rpm -e webmin >/dev/null 2>&1 || true

# Puhasta süsteem
sudo dnf autoremove -y >/dev/null 2>&1 || true
sudo dnf clean all >/dev/null 2>&1 || true


# Paigalda bind9
dnf install -y samba >/dev/null 2>&1 || true

# Kustuta failid ja käsuajalugu
su - student -c "rm -f ${STUDENT_HOME}/alma.txt ${STUDENT_HOME}/httpd.txt ${STUDENT_HOME}/depends.txt" >/dev/null 2>&1
su - student -c "history -c" >/dev/null 2>&1

# Lae alla Webmini installifail (wget väljastaks muidu infot)
su - student -c "wget -q -O ${STUDENT_HOME}/sl-5.02-1.el9.x86_64.rpm wget https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/s/sl-5.02-1.el9.x86_64.rpm
" >/dev/null 2>&1

echo ">>> Ettevalmistus tehtud! Saad nüüd ülesandega alustada."
