#!/bin/bash
# yl5.1-setup.sh - ettevalmistus AlmaLinux 10 (EL10) tarkvarahalduse ülesande jaoks
# Käivita root kasutajana (nt: sudo -s; ./yl5.1-setup.sh)

set -euo pipefail

trap 'echo "✖ Viga: katkestati real $LINENO"; exit 1' ERR

echo ">>> Alustan harjutuse ettevalmistust..."

# 1) Kontrolli, et skript jookseb root'ina
if [[ $EUID -ne 0 ]]; then
  echo "Palun käivita skript root kasutajana."
  exit 1
fi

# 2) Leia sobiv DNF käsk (EL10-s on levinud dnf5; kuid 'dnf' võib olla alles)
DNF_BIN="$(command -v dnf5 || command -v dnf || true)"
if [[ -z "${DNF_BIN}" ]]; then
  echo "DNF ei ole saadaval (ei leitud ei dnf5 ega dnf)."
  exit 1
fi
# 3) Kontrolli, et kasutaja 'student' eksisteerib ja leia tema kodukataloog
if ! id -u student >/dev/null 2>&1; then
  echo "Kasutajat 'student' ei eksisteeri! Loo see enne harjutust."
  exit 1
fi
STUDENT_HOME="$(getent passwd student | cut -d: -f6)"
STUDENT_HOME="${STUDENT_HOME:-/home/student}"

echo ">>> Kasutan paketihaldurit: ${DNF_BIN}"
echo ">>> Student HOME: ${STUDENT_HOME}"

# 4) Eemalda võimalikke eelnevaid pakette (vaikides; vead ei peata)
"${DNF_BIN}" -y remove nginx mc fortune-mod webmin >/dev/null 2>&1 || true
rpm -q webmin >/dev/null 2>&1 && rpm -e webmin >/dev/null 2>&1 || true

# 5) Puhasta süsteem (vaikides)
"${DNF_BIN}" -y autoremove >/dev/null 2>&1 || true
"${DNF_BIN}" clean all >/dev/null 2>&1 || true

# 6) Paigalda Samba
"${DNF_BIN}" -y install samba >/dev/null 2>&1 || true

# 7) Kustuta failid ja bash'i ajalugu 'student' kasutajal
runuser -u student -- bash -lc "rm -f '${STUDENT_HOME}/alma.txt' '${STUDENT_HOME}/httpd.txt' '${STUDENT_HOME}/depends.txt' || true"
runuser -u student -- bash -lc "rm -f ~/.bash_history; : > ~/.bash_history 2>/dev/null || true"



echo ">>> Ettevalmistus tehtud! Saad nüüd ülesandega alustada."
