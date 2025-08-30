#!/bin/bash
# setup.sh - seab üles keskkonna õiguste harjutamiseks

# Käivitada root'ina

STUDENT_HOME="/home/student"

echo "[INFO] Loon kasutaja student kodukaustaga, kui seda pole..."
if ! id student &>/dev/null; then
    useradd -m -s /bin/bash student
    echo "student:student" | chpasswd
fi

echo "[INFO] Loon vajalikud failid kodukausta..."
touch "$STUDENT_HOME/esimene"
touch "$STUDENT_HOME/teine"
touch "$STUDENT_HOME/backup.sh"

# Lisa natuke sisu backup.sh sisse
echo -e "#!/bin/bash\necho 'Backup tehtud'" > "$STUDENT_HOME/backup.sh"

echo "[INFO] Loon kataloogid /var/failid, /var/skriptid, /srv/lepingud, /var/avalik..."
mkdir -p /var/failid
mkdir -p /var/skriptid
mkdir -p /srv/lepingud
mkdir -p /var/avalik

echo "[INFO] Loon failid skript1.sh ja skript2.sh..."
echo -e "#!/bin/bash\necho 'Skript1 töötab'" > /var/skriptid/skript1.sh
echo -e "#!/bin/bash\necho 'Skript2 töötab'" > /var/skriptid/skript2.sh
chmod +x /var/skriptid/skript*.sh

echo "[INFO] Loon vähemalt 20 faili kolme erineva laiendiga /var/failid alla..."
for i in {1..7}; do
    echo "See on txt fail $i" > /var/failid/fail$i.txt
    echo "See on log fail $i" > /var/failid/fail$i.log
    echo "See on conf fail $i" > /var/failid/fail$i.conf
done

echo "[INFO] Loon vähemalt 20 faili kolme erineva laiendiga /srv/lepingud alla..."
for i in {1..7}; do
    echo "Leping tekst $i" > /srv/lepingud/leping$i.txt
    echo "Leping log $i" > /srv/lepingud/leping$i.log
    echo "Leping conf $i" > /srv/lepingud/leping$i.conf
done

echo "[INFO] Loon vähemalt 20 faili kolme erineva laiendiga /var/avalik alla..."
for i in {1..7}; do
    echo "Avalik tekst $i" > /var/avalik/avalik$i.txt
    echo "Avalik log $i" > /var/avalik/avalik$i.log
    echo "Avalik conf $i" > /var/avalik/avalik$i.conf
done

echo "[INFO] Lisan grupi raamatupidajad, kui seda pole..."
getent group raamatupidajad >/dev/null || groupadd raamatupidajad

echo "[INFO] Seadistan õigused student kodukausta failidele..."
chown student:student "$STUDENT_HOME/esimene" "$STUDENT_HOME/teine" "$STUDENT_HOME/backup.sh"

echo "Ettevalmistus tehtud! Saad nüüd ülesandega alustada."
