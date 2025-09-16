#!/bin/bash

sudo apt update 

######################
#Sissetulek          #
######################

# Define the file path
FILE="/var/backups/sissetulek.txt"

# Create the file if it does not exist and set permissions
if [ ! -f "$FILE" ]; then
    sudo touch "$FILE"
    sudo chmod 644 "$FILE"
fi

# Generate a list of random numbers between 10 and 1600
# Adjust the count variable to change the number of random numbers generated
count=100
random_numbers=$(for i in $(seq 1 $count); do echo $((RANDOM % 1591 + 10)); done)

# Add the random numbers and the number 1888 to the file
{
    echo "$random_numbers"
    echo 1888
} | sudo tee -a "$FILE" > /dev/null

echo "Numbers have been added to $FILE"

######################
#Nimed               #
######################

# Määrame faili asukoha
OUTPUT_FILE="/var/nimed.txt"

# Loome nimekirja Eesti nimedest
NIMED=("Mari" "Kristjan" "Laura" "Markus" "Kaarel" "Liis" "Andres" "Heli" "Kati" "Toomas" \
       "Anna" "Martin" "Tiina" "Peeter" "Karin" "Jaan" "Eva" "Siim" "Heiki" "Lea" \
       "Piret" "Mati" "Sirje" "Ain" "Eve" "Erki" "Maarika" "Arvo" "Kristi" "Rauno" \
       "Merle" "Tarmo" "Rein" "Kai" "Ülle")

# Kontrollime, kas fail /var/nimed.txt juba eksisteerib, ja kui jah, siis kustutame selle
if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
fi

# Loome tühja faili
touch "$OUTPUT_FILE"

# Lisame kõik nimed nimekirjast faili
for NAME in "${NIMED[@]}"; do
    echo "$NAME" >> "$OUTPUT_FILE"
done

# Kontrollime, kas fail loodi ja nimed lisati
if [ -f "$OUTPUT_FILE" ]; then
    echo "Fail $OUTPUT_FILE on loodud ja sisaldab nimekirjas olevaid Eesti nimesid."
else
    echo "Faili loomine ebaõnnestus."
fi

######################
#Arhiiv             #
######################

#!/bin/bash

# Create base directory if it doesn't exist
BASE_DIR="/var/arhiiv"
mkdir -p "$BASE_DIR"

# Loop to create directories from 2000 to 2010
for year in {2000..2010}; do
  # Create the directory
  DIR="$BASE_DIR/$year"
  mkdir -p "$DIR"

  # Generate a random number of files (between 1 and 10) for each year
  NUM_FILES=$((RANDOM % 10 + 1))

  for ((i=1; i<=NUM_FILES; i++)); do
    # Generate a random file name
    FILE_NAME="file_$RANDOM.txt"
    
    # Generate random content for the file
    echo "Random content $RANDOM" > "$DIR/$FILE_NAME"
  done
done

echo "Folders and random files created successfully!"

######################
#Otsing1           #
######################

# Määrame kaustade ja failide asukohad
BASE_DIR="/usr/local"
SUBDIRS=("games" "data" "binx" "share" "etc")
FILES=("file1.txt" "file2.txt" "file3.txt" "file4.txt" "file5.txt")

# Luuakse põhikaust ja alamkaustad
for DIR in "${SUBDIRS[@]}"; do
    mkdir -p "$BASE_DIR/$DIR"
done

# Suvalised tekstid, millest üks sisaldab sõna "peitus" suvalises kirjapildis
TEXTS=(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Peitus"
    "Vestibulum vulputate odio vel velit vestibulum vehicula. PEITUS"
    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem. peItUs"
    "But in one hidden text, the word pEItus is hidden."
    "At vero eos et accusamus et iusto odio dignissimos ducimus. PEitus"
)

# Loome failid ja kirjutame suvalise teksti
for i in "${!FILES[@]}"; do
    echo "${TEXTS[i]}" > "$BASE_DIR/${SUBDIRS[i]}/${FILES[i]}"
done

# Kontrollime, kas failid loodi õigesti
echo "Failid loodud järgnevatesse kaustadesse:"
for i in "${!FILES[@]}"; do
    echo "$BASE_DIR/${SUBDIRS[i]}/${FILES[i]}"
done

######################
#Otsing2           #
######################
# Määrame kaustade ja failide asukohad
LOG_DIR="/var/log"
OPT_DIR="/var/opt"
LOG_FILE="$LOG_DIR/biglogfile.log"
OPT_FILE="$OPT_DIR/optfile.log"

# Luuakse kaustad, kui need ei ole juba olemas
mkdir -p "$LOG_DIR"
mkdir -p "$OPT_DIR"

# Loome failide jaoks juhusliku suuruse vahemikus 55 MB kuni 100 MB (56 kuni 99 MB)
LOG_SIZE=$((55 + RANDOM % 45))  # 55 + 0 kuni 44 MB
OPT_SIZE=$((55 + RANDOM % 45))  # 55 + 0 kuni 44 MB

# Loome failid määratud suurusega (kasutades /dev/urandom juhuslike andmete genereerimiseks)
dd if=/dev/urandom of="$LOG_FILE" bs=1M count="$LOG_SIZE" status=progress
dd if=/dev/urandom of="$OPT_FILE" bs=1M count="$OPT_SIZE" status=progress

# Kontrollime, kas failid on õigesti loodud
echo "Failid on loodud:"
ls -lh "$LOG_FILE"
ls -lh "$OPT_FILE"

######################
#Otsing3           #
######################

# Failinimed
failid=("local-host" "file2.txt" "system23" "graphical")

# Loo failid ja lisa suvaline sisu
for fail in "${failid[@]}"
do
    echo "Suvaline sisu $fail jaoks" > /etc/$fail
    echo "Fail /etc/$fail loodud."
done

# Määra failide muutmis- ja juurdepääsu ajad rohkem kui 3 aastat tagasi
for fail in "${failid[@]}"
do
    touch -d "5 years ago" /etc/$fail
    echo "Faili /etc/$fail loomisaeg määratud rohkem kui 3 aastat tagasi."
done

echo "Kõik failid on loodud ja nende loomisaeg on määratud."

######################
#Kasutajad         #
######################


# Variables for user creation
USERNAME="kalmer"
PASSWORD="Passw0rd"
HOMEDIR="/home/$USERNAME"
GROUP="juhtkond"

# Create the user with home directory and /bin/bash as the shell
sudo useradd -m -s /bin/bash "$USERNAME"

# Set the password for the user
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Check if user was created and the home directory exists
if [ ! -d "$HOMEDIR" ]; then
    echo "Failed to create home directory for user $USERNAME."
    exit 1
fi

# Change ownership of the home directory to the new user
sudo chown "$USERNAME:$USERNAME" "$HOMEDIR"

sudo addgroup $GROUP
sudo adduser $USERNAME $GROUP

sudo addgroup ajutine

sudo useradd -m -s /bin/bash "praktikant"
echo "praktikant:Passw0rd123" | sudo chpasswd
sudo chown praktikant:praktikant /home/praktikant

sudo useradd -m -s /bin/bash "boss"
echo "boss:Passw0rd123" | sudo chpasswd
sudo chown boss:boss /home/boss


######################
#Kaustad   #
######################


# Define the paths and ownership settings
FILE_PATH="/var/info.txt"
DIR_SRV_ASJAD="/srv/asjad"
DIR_USR_LOCAL_AVALIK="/usr/local/avalik"
DIR_USR_LOCAL_EESKIRJAD="/usr/local/eeskirjad"
DIR_SRV_SKRIPTID="/srv/skriptid"
FILE_SKRIPT23="$DIR_SRV_SKRIPTID/skript23.sh"
FILE_NOTES="/srv/notes.txt"
FILE_SISEKORD="/usr/local/avalik/sisekord.txt"
OWNER="student:student"

# Create the file /var/info.txt
sudo touch "$FILE_PATH"
if [ -f "$FILE_PATH" ]; then
    echo "Fail '$FILE_PATH' on loodud edukalt."
else
    echo "VIGA - Faili '$FILE_PATH' loomine ebaõnnestus."
fi

# Create the directory /srv/asjad and set ownership to root:root
sudo mkdir -p "$DIR_SRV_ASJAD"
sudo chown root:root "$DIR_SRV_ASJAD"
if [ -d "$DIR_SRV_ASJAD" ] && [ "$(stat -c '%U:%G' "$DIR_SRV_ASJAD")" == "root:root" ]; then
    echo "Kaust '$DIR_SRV_ASJAD' on loodud ja omanikuks määratud root:root."
else
    echo "VIGA - Kausta '$DIR_SRV_ASJAD' loomine või omandi määramine ebaõnnestus."
fi

# Create the directory /usr/local/avalik and set ownership to student:student
sudo mkdir -p "$DIR_USR_LOCAL_AVALIK"
sudo chown student:student "$DIR_USR_LOCAL_AVALIK"
if [ -d "$DIR_USR_LOCAL_AVALIK" ] && [ "$(stat -c '%U:%G' "$DIR_USR_LOCAL_AVALIK")" == "student:student" ]; then
    echo "Kaust '$DIR_USR_LOCAL_AVALIK' on loodud ja omanikuks määratud student:student."
else
    echo "VIGA - Kausta '$DIR_USR_LOCAL_AVALIK' loomine või omandi määramine ebaõnnestus."
fi

# Create the directory /usr/local/eeskirjad and set ownership to juhtkond:juhtkond
sudo mkdir -p "$DIR_USR_LOCAL_EESKIRJAD"
sudo chown boss:juhtkond "$DIR_USR_LOCAL_EESKIRJAD"
if [ -d "$DIR_USR_LOCAL_EESKIRJAD" ] && [ "$(stat -c '%U:%G' "$DIR_USR_LOCAL_EESKIRJAD")" == "boss:juhtkond" ]; then
    echo "Kaust '$DIR_USR_LOCAL_EESKIRJAD' on loodud ja omanikuks määratud juhtkond:juhtkond."
else
    echo "VIGA - Kausta '$DIR_USR_LOCAL_EESKIRJAD' loomine või omandi määramine ebaõnnestus."
fi

# Create the directory /srv/skriptid
sudo mkdir -p "$DIR_SRV_SKRIPTID"
if [ -d "$DIR_SRV_SKRIPTID" ]; then
    echo "Kaust '$DIR_SRV_SKRIPTID' on loodud edukalt."
else
    echo "VIGA - Kausta '$DIR_SRV_SKRIPTID' loomine ebaõnnestus."
fi

# Ensure the /srv/skriptid directory exists
sudo mkdir -p "$DIR_SRV_SKRIPTID"

# Create skript23.sh under /srv/skriptid and set ownership to student:student
sudo touch "$FILE_SKRIPT23"
sudo chown $OWNER "$FILE_SKRIPT23"
if [ -f "$FILE_SKRIPT23" ] && [ "$(stat -c '%U:%G' "$FILE_SKRIPT23")" == "$OWNER" ]; then
    echo "Fail '$FILE_SKRIPT23' on loodud ja omanikuks määratud $OWNER."
else
    echo "VIGA - Faili '$FILE_SKRIPT23' loomine või omandi määramine ebaõnnestus."
fi

# Create notes.txt under /srv and set ownership to student:student
sudo touch "$FILE_NOTES"
sudo chown $OWNER "$FILE_NOTES"
if [ -f "$FILE_NOTES" ] && [ "$(stat -c '%U:%G' "$FILE_NOTES")" == "$OWNER" ]; then
    echo "Fail '$FILE_NOTES' on loodud ja omanikuks määratud $OWNER."
else
    echo "VIGA - Faili '$FILE_NOTES' loomine või omandi määramine ebaõnnestus."
fi

# Create /usr/local/avalik directory if it doesn't exist
sudo mkdir -p "/usr/local/avalik"

# Create sisekord.txt with random rules and write sample content
sudo bash -c "echo -e '1. Järgi ohutusreegleid.\n2. Hoia töökoht puhas.\n3. Täida tööülesanded õigeaegselt.\n4. Austa töökaaslasi.\n5. Kasuta ettevõtte ressursse säästlikult.' > $FILE_SISEKORD"

if [ -f "$FILE_SISEKORD" ]; then
    echo "Fail '$FILE_SISEKORD' on loodud ja sinna on lisatud suvalised sisekorrareeglid."
else
    echo "VIGA - Faili '$FILE_SISEKORD' loomine ebaõnnestus."
fi



######################
#Boss         #
######################

# Kontrolli, kas /mnt/tmp kaust eksisteerib, kui ei, siis loo see
if [ ! -d "/mnt/tmp" ]; then
    mkdir -p /mnt/tmp
    echo "Kaust /mnt/tmp on loodud."
else
    echo "Kaust /mnt/tmp juba eksisteerib."
fi

# Loo fail plaan.txt ja lisa sinna sisu
cat <<EOL > /mnt/tmp/plaan.txt
1. Juua kohvi.
2. Lugeda kirju.
3. Korraldada mõni sisutu koosolek.
4. Vallandada Juss.
EOL

sudo chown boss:boss /mnt/tmp/plaan.txt

echo "Fail /mnt/tmp/plaan.txt on loodud ja sisu lisatud."

######################
#Folders       #
######################

# Define the directory path
DIR="/var/backups/newdata"

# Create the directory if it doesn't exist
if [ ! -d "$DIR" ]; then
    sudo mkdir -p "$DIR"
    sudo chmod 755 "$DIR"
fi

# Define the list of possible file extensions
extensions=("txt" "log" "dat" "csv" "xml" "json" "html" "bin" "md" "conf")

# Generate random data and create 9 files with random extensions
for i in $(seq 1 9); do
    # Choose a random extension
    ext=${extensions[$RANDOM % ${#extensions[@]}]}
    # Create a random filename
    filename="file_$RANDOM.$ext"
    # Create the file with random data
    head -c 512 </dev/urandom | sudo tee "$DIR/$filename" > /dev/null
done

# Create the specific file file_30010.txt with random data
head -c 512 </dev/urandom | sudo tee "$DIR/file_30010.txt" > /dev/null

echo "10 files have been created in $DIR, including file_30010"

######################
#Laura     #
######################

# Variables for user creation
USERNAME="laura"
PASSWORD="Passw0rd"
HOMEDIR="/home/$USERNAME"

# Create the user with home directory and /bin/bash as the shell
sudo useradd -m -s /bin/bash "$USERNAME"

# Set the password for the user
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Check if user was created and the home directory exists
if [ ! -d "$HOMEDIR" ]; then
    echo "Failed to create home directory for user $USERNAME."
    exit 1
fi

# Change ownership of the home directory to the new user
sudo chown "$USERNAME:$USERNAME" "$HOMEDIR"

# Create 10 random files in the user's home directory, including mypic.jpg
for i in $(seq 1 9); do
    # Generate a random file name with random extension
    filename="file_$RANDOM.txt"
    # Create the file with some random data
    head -c 256 </dev/urandom | sudo tee "$HOMEDIR/$filename" > /dev/null
    # Set the correct ownership for the file
    sudo chown "$USERNAME:$USERNAME" "$HOMEDIR/$filename"
done

# Create the specific file mypic.jpg with random data
head -c 256 </dev/urandom | sudo tee "$HOMEDIR/wallpaper.jpg" > /dev/null
sudo chown "$USERNAME:$USERNAME" "$HOMEDIR/wallpaper.jpg"

# Create 5 random directories in the user's home directory
for i in $(seq 1 5); do
    # Generate a random directory name
    dirname="dir_$RANDOM"
    # Create the directory
    sudo mkdir "$HOMEDIR/$dirname"
    # Set the correct ownership for the directory
    sudo chown "$USERNAME:$USERNAME" "$HOMEDIR/$dirname"
done

echo "User $USERNAME created with a home directory and populated with files and directories."

######################
#Toomas    #
######################

# Variables for user creation
USERNAME="toomas"
PASSWORD="Passw0rd"
HOMEDIR="/home/$USERNAME"

# Create the user with home directory and /bin/bash as the shell
sudo useradd -m -s /bin/bash "$USERNAME"

# Set the password for the user
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Check if user was created and the home directory exists
if [ ! -d "$HOMEDIR" ]; then
    echo "Failed to create home directory for user $USERNAME."
    exit 1
fi

# Change ownership of the home directory to the new user
sudo chown "$USERNAME:$USERNAME" "$HOMEDIR"

# Create 10 random files in the user's home directory, including mypic.jpg
for i in $(seq 1 9); do
    # Generate a random file name with random extension
    filename="file_$RANDOM.txt"
    # Create the file with some random data
    head -c 256 </dev/urandom | sudo tee "$HOMEDIR/$filename" > /dev/null
    # Set the correct ownership for the file
    sudo chown "$USERNAME:$USERNAME" "$HOMEDIR/$filename"
done

# Create the specific file mypic.jpg with random data
head -c 256 </dev/urandom | sudo tee "$HOMEDIR/mypic.jpg" > /dev/null
sudo chown "$USERNAME:$USERNAME" "$HOMEDIR/mypic.jpg"

# Create 5 random directories in the user's home directory
for i in $(seq 1 5); do
    # Generate a random directory name
    dirname="dir_$RANDOM"
    # Create the directory
    sudo mkdir "$HOMEDIR/$dirname"
    # Set the correct ownership for the directory
    sudo chown "$USERNAME:$USERNAME" "$HOMEDIR/$dirname"
done

echo "User $USERNAME created with a home directory and populated with files and directories."

######################
#Wordpress    #
######################


sudo mkdir -p /var/www
cd /var/www

wget https://wordpress.org/latest.zip

unzip latest.zip &> /dev/null

rm latest.zip

sudo apt install -y htop
sudo apt install -y fortune-mod
sudo apt install -y cowsay
