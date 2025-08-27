#!/bin/bash
# setup.sh - ettevalmistusskript Linuxi käsurea harjutuse jaoks
# Käivita root kasutajana (nt sudo ./setup.sh)

set -e

STUDENT_HOME="/home/student"
MARKER="[SETUP]"

echo ">>> Alustan harjutuse ettevalmistust..."

# --- Kontroll, et kasutaja student eksisteeriks ---
if ! id -u student >/dev/null 2>&1; then
    echo "Kasutajat 'student' ei eksisteeri! Loo see enne harjutust."
    exit 1
fi

# --- 1. Loo vajalik grupp 'salajane' suure GID-ga (nt 5500) ---
if ! grep -q '^salajane:' /etc/group; then
    groupadd -g 5500 salajane
    echo "Loodi grupp 'salajane' GID=5500"
else
    echo "Grupp 'salajane' juba olemas, jätan vahele."
fi

# --- 2. /var/skriptid: loo 25 skripti ---
mkdir -p /var/skriptid
for i in {1..25}; do
  echo '#!/bin/bash' > /var/skriptid/script$i.sh
  echo "echo \"$MARKER Tere, see on skript $i!\"" >> /var/skriptid/script$i.sh
  chmod +x /var/skriptid/script$i.sh
done

# --- 3. /var/vanalogi.txt ---
echo "$MARKER See on vana logifail" > /var/vanalogi.txt

# --- 4. /srv/ohoo: vähemalt 20 faili ---
mkdir -p /srv/ohoo
for i in {1..20}; do
  echo "$MARKER Ohoo fail $i" > /srv/ohoo/file$i.txt
done

# --- 5. /srv/somefiles/somefolder: vähemalt 20 faili ---
mkdir -p /srv/somefiles/somefolder
for i in {1..20}; do
  echo "$MARKER Somefolderi fail $i" > /srv/somefiles/somefolder/doc$i.txt
done

# --- 6. /srv/filemess: 10 faili (50 .txt + 50 muud laiendid) ---
mkdir -p /srv/filemess

# 25 .txt faili
for i in {1..50}; do
  echo "$MARKER See on kustutatav .txt fail $i" > /srv/filemess/delete$i.txt
done

# 10 .log faili
for i in {1..20}; do
  echo "$MARKER See on logifail $i" > /srv/filemess/log$i.log
done

# 8 .conf faili
for i in {1..20}; do
  echo "$MARKER See on conf fail $i" > /srv/filemess/conf$i.conf
done

# 7 .dat faili
for i in {1..10}; do
  echo "$MARKER See on dat fail $i" > /srv/filemess/data$i.dat
done

# --- 7. Kodukaust: vajalikud failid ---
su - student -c "echo '$MARKER See on data1' > ${STUDENT_HOME}/data1.txt"
su - student -c "echo '$MARKER See on rämps' > ${STUDENT_HOME}/junk"
su - student -c "rm -f ${STUDENT_HOME}/ajalugu.txt"

echo ">>> Ettevalmistus tehtud! Saad nüüd harjutusega alustada."
