#!/bin/bash

# Määrame vajalikud kaustad ja failid
KODUKAUST="/home/student"
DOKUMENDID="$KODUKAUST/dokumendid"
BACKUP_FAIL="/var/backups/sissetulek.txt"
PASSWD_FAIL="/etc/passwd"
PRAEGUSED_KASUTAJAD="$KODUKAUST/praegused_kasutajad.txt"
TULEMUSFAIL="$KODUKAUST/tulemus.txt"
ARHIIVKAUST="/var/arhiiv"
USER1="juss"
USER2="pille"
VIIMANE="viimased.txt"

# Kustutame vana tulemusfaili, kui see olemas on
> "$TULEMUSFAIL"

# Funktsioon tulemuse salvestamiseks faili
log_tulemus() {
    echo "$1" >> "$TULEMUSFAIL"
}

# Kontroll 1: Uus kaust nimega dokumendid kodukaustas
if [ -d "$DOKUMENDID" ]; then
    log_tulemus "1. OK - Kaust 'dokumendid' on loodud"
else
    log_tulemus "1. VIGA - Kaust 'dokumendid' ei ole loodud"
fi

# Kontroll 2: Alamkaustad 2011-2025 kaustas dokumendid
TEHTUD=1
for YEAR in {2011..2025}; do
    if [ ! -d "$DOKUMENDID/$YEAR" ]; then
        log_tulemus "2. VIGA - Alamkaust '$YEAR' puudub kaustas 'dokumendid'"
        TEHTUD=0
    fi
done

if [ $TEHTUD -eq 1 ]; then
    log_tulemus "2. OK - Kõik alamkaustad '2011-2025' on olemas"
fi

# Kontroll 3: Faili sissetulek.txt kopeerimine kausta dokumendid/2024
if [ -f "$DOKUMENDID/2024/sissetulek.txt" ] && grep -q -e 1888 "$DOKUMENDID/2024/sissetulek.txt" ; then
    log_tulemus "3. OK - Fail 'sissetulek.txt' on kopeeritud kausta 'dokumendid/2024'"
else
    log_tulemus "3. VIGA - Fail 'sissetulek.txt' ei ole kopeeritud kausta 'dokumendid/2024' või ei ole faili sisu sama"
fi

# Kontroll 4: Faili /etc/passwd kopeerimine kodukausta failina praegused_kasutajad.txt
if [ -f "$PRAEGUSED_KASUTAJAD" ] && grep  -q -e student "$PRAEGUSED_KASUTAJAD" ; then
    log_tulemus "4. OK - Fail '/etc/passwd' on kopeeritud kodukausta failina 'praegused_kasutajad.txt'"
else
    log_tulemus "4. VIGA - Fail '/etc/passwd' ei ole kopeeritud kodukausta failina 'praegused_kasutajad.txt' või pole faili sisu õige"
fi

# Kontroll 5: Uue kausta kasutajad loomine kausta dokumendid/2024 alla
if [ -d "$DOKUMENDID/2024/kasutajad" ]; then
    log_tulemus "5. OK - Kaust 'kasutajad' on loodud kausta 'dokumendid/2024' alla"
else
    log_tulemus "5. VIGA - Kaust 'kasutajad' ei ole loodud kausta 'dokumendid/2024' alla"
fi

# Kontroll 6: Faili praegused_kasutajad.txt kopeerimine kausta dokumendid/2024/kasutajad
if [ -f "$DOKUMENDID/2024/kasutajad/praegused_kasutajad.txt" ]; then
    log_tulemus "6. OK - Fail 'praegused_kasutajad.txt' on kopeeritud kausta 'dokumendid/2024/kasutajad'"
else
    log_tulemus "6. VIGA - Fail 'praegused_kasutajad.txt' ei ole kopeeritud kausta 'dokumendid/2024/kasutajad'"
fi

# Kontroll 7: Kontroll, kas kaust newfile on kopeeritud dokumendid/2025 alla
if [ -f "$DOKUMENDID/2025/newdata/file_30010.txt" ]; then
    log_tulemus "7. OK - Kaust 'newdata' on edukalt kopeeritud 'dokumendid/2025' alla koos failidega."
else
    log_tulemus "7. VIGA - Kaust 'newdata' pole kopeeritud 'dokumendid/2025' alla koos kõigi failidega."
fi

# Kontroll 8: Kontroll, kas kaustad 2000-2009 on /var/arhiiv alt kustutatud
ALL_DELETED=true
ARHIIV_ALLES=true

# Kontrollime, kas kaust /var/arhiiv/2010 on alles
if [ ! -d "$ARHIIVKAUST/2010" ]; then
    log_tulemus "8. VIGA - Kaust '$ARHIIVKAUST/2010' on kustutatud, kuid see kaust pidi alles jääma."
    ARHIIV_ALLES=false
fi

# Kontrollime kaustade 2000-2009 olemasolu
for year in {2000..2009}; do
    DIR="$ARHIIVKAUST/$year"
    
    # Kontrollime, kas kaust eksisteerib
    if [ -d "$DIR" ];then
        log_tulemus "8. VIGA - Kaust '$DIR' on endiselt alles. Kõik kaustad pole kustutatud."
        ALL_DELETED=false
    fi
done

# Kuvame kokkuvõtte kui kõik on korras
if $ALL_DELETED && $ARHIIV_ALLES; then
    log_tulemus "8. OK - Kaustad '2000-2009' on edukalt kustutatud ja kaust $ARHIIVKAUST/2010 on alles."
fi

# Kontroll 9: Kas nimeta.txt failis olevad viimased 5 rida on suunatud faili viimased.txt
if grep -q -e "Rein" "$KODUKAUST/$VIIMANE" && ! grep -q -e "Maarika" "$KODUKAUST/$VIIMANE" ; then
    log_tulemus "9. OK - Fail 'viimased.txt' sisaldab 'nimed.txt' faili 5-te viimast rida"
else
    log_tulemus "9. VIGA - Faili 'viimased.txt' ei leitud või ei sisalda see ainult 'nimed.txt' faili 5-te viimast rida"
fi


# Kontroll 10: Kontroll, kas kasutajad on loodud
USER1_EXISTS=false
USER2_EXISTS=false

if grep -q -e "^$USER1:" /etc/passwd; then
    USER1_EXISTS=true
fi

if grep -q -e "^$USER2:" /etc/passwd; then
    USER2_EXISTS=true
fi

# Kontrollime tulemusi ja logime vastavalt
if $USER1_EXISTS && $USER2_EXISTS; then
    log_tulemus "10. OK - Kasutajad '$USER1' ja '$USER2' on edukalt loodud."
else
    if ! $USER1_EXISTS && ! $USER2_EXISTS; then
        log_tulemus "10. VIGA - Kasutajakontosid '$USER1' ja '$USER2' pole loodud."
    elif ! $USER1_EXISTS; then
        log_tulemus "10. VIGA - Kasutajakontot '$USER1' pole loodud."
    elif ! $USER2_EXISTS; then
        log_tulemus "10. VIGA - Kasutajakontot '$USER2' pole loodud."
    fi
fi

# Kontroll 11: Kontroll, kas kasutajad on loodud
USERNAME="tom"
HOMEDIR=$(getent passwd "$USERNAME" | cut -d: -f6)
UFILE="$HOMEDIR/mypic.jpg"

# Check if the user exists
if id "$USERNAME" &>/dev/null; then    
    # Check if the mypic.jpg file exists in the user's home directory
    if [ -f "$UFILE" ]; then
        log_tulemus "11. OK - Kasutaja 'toomas' kasutajanimi on muudetud 'tom'-iks ja kodukausta failid on ümber kopeeritud"
    else
        log_tulemus "11. VIGA - Kasuta 'tom' on küll olemas', kuid failid pole ümber kopeeritud."
    fi
else
    log_tulemus "11. VIGA - Kasutajat '$USERNAME' ei leitud."
fi

# Kontroll 12: Kontrollib, kas kasutajagrupp "raamatupidajad" eksisteerib
if getent group "raamatupidajad" > /dev/null 2>&1; then
    log_tulemus "12. OK - Kasutajagrupp 'raamatupidajad' on loodud."
else
    log_tulemus "12. VIGA - Kasutajagruppi 'raamatupidajad' pole loodud"
fi

# Kontroll 13: Kontrollib, kas kasutaja "juss" on lisatud gruppi "raamatupidajad"
if id -nG "juss" 2>/dev/null | grep -qw "raamatupidajad"; then
    log_tulemus "13. OK - Kasutaja 'juss' on lisatud gruppi 'raamatupidajad'."
else
    log_tulemus "13. VIGA - Kasutaja 'juss' ei ole lisatud gruppi 'raamatupidajad'."
fi

# Kontroll 14: Kontrollib, kas kasutaja "pille" on lisatud gruppi "sudo"
if id -nG "pille" 2>/dev/null | grep -qw "sudo"; then
    log_tulemus "14. OK - Kasutaja 'pille' on lisatud gruppi 'sudo'."
else
    log_tulemus "14. VIGA - Kasutaja 'pille' ei ole lisatud gruppi 'sudo'."
fi

# Kontroll 15: Kontrollib, kas kasutaja "kalmer" on eemaldatud grupist "juhtkond"
if id -nG "kalmer" 2>/dev/null | grep -qw "juhtkond"; then
    log_tulemus "15. VIGA - Kasutaja 'kalmer' ei ole eemaldatud grupist 'juhtkond'."
else
    log_tulemus "15. OK - Kasutaja 'kalmer' on eemaldatud grupist 'juhtkond'."
fi

# Kontroll 16: Kontrollib, kas grupp "ajutine" on kustutatud
if getent group "ajutine" > /dev/null 2>&1; then
    log_tulemus "16. VIGA - Grupp 'ajutine' ei ole kustutatud."
else
    log_tulemus "16. OK - Grupp 'ajutine' on kustutatud."
fi

# Kontroll 17: Kontrollib, kas kasutaja 'praktikant' on ukustatud
if passwd -S praktikant | grep -q " L "; then
    log_tulemus "17. OK - Kasutaja 'praktikant' konto on lukustatud."
else
    log_tulemus "17. VIGA - Kasutaja 'praktikant' konto pole lukustatud."
fi


# Kontroll 18: Kontrollib, kas kasutaja "laura" on kustutatud koos kodukaustaga /home/laura
USER_CHECK=$(id "laura" 2>/dev/null)
HOME_DIRL="/home/laura"

# Check if the user "laura" exists and if the home directory is still present
if [ -z "$USER_CHECK" ] && [ ! -d "$HOME_DIRL" ]; then
    log_tulemus "18. OK - Kasutaja 'laura' on kustutatud koos kodukaustaga /home/laura."
else
    log_tulemus "18. VIGA - Kasutaja 'laura' või tema kodukaust /home/laura on veel olemas."
fi

# Kontroll 19: Kontrollib, kas faili /var/info.txt omanikuks on "juss" ja grupiks "raamatupidajad"
if [ "$(stat -c %U /var/info.txt)" = "juss" ] && [ "$(stat -c %G /var/info.txt)" = "raamatupidajad" ]; then
    log_tulemus "19. OK - Faili /var/info.txt omanik on 'juss' ja grupp on 'raamatupidajad'."
else
    log_tulemus "19. VIGA - Faili /var/info.txt omanik ei ole 'juss' või grupp ei ole 'raamatupidajad'."
fi

# Kontroll 20: Kontrollib, kas kausta /srv/asjad omanikuks ja grupiks on "student"
if [ "$(stat -c %U /srv/asjad)" = "student" ] && [ "$(stat -c %G /srv/asjad)" = "student" ]; then
    log_tulemus "20. OK - Kausta /srv/asjad omanik ja grupp on 'student'."
else
    log_tulemus "20. VIGA - Kausta /srv/asjad omanik või grupp ei ole 'student'."
fi

# Kontroll 21: Kontrollib, kas kausta /usr/local/avalik õigused on 777
if [ "$(stat -c %a /usr/local/avalik)" = "777" ]; then
    log_tulemus "21. OK - Kausta /usr/local/avalik õigused on korrektsed."
else
    log_tulemus "21. VIGA - Kausta /usr/local/avalik õigused ei ole korrektsed."
fi

# Kontroll 22: Kontrollib, kas kausta /usr/local/eeskirjad õigused on 770
if [ "$(stat -c %a /usr/local/eeskirjad)" = "770" ]; then
    log_tulemus "22. OK - Kausta /usr/local/eeskirjad õigused on korrektsed."
else
    log_tulemus "22. VIGA - Kausta /usr/local/eeskirjad õigused ei ole korrektsed."
fi

# Kontroll 23: Kontrollib, kas faili /srv/skriptid/skript23.sh õigused on 750
if [ "$(stat -c %a /srv/skriptid/skript23.sh)" = "750" ]; then
    log_tulemus "23. OK - Faili /srv/skriptid/skript23.sh õigused on korrektsed."
else
    log_tulemus "23. VIGA - Faili /srv/skriptid/skript23.sh õigused ei ole korrektsed."
fi

# Kontroll 24: Kontrollib, kas faili /srv/notes.txt õigused on 660
if [ "$(stat -c %a /srv/notes.txt)" = "660" ]; then
    log_tulemus "24. OK - Faili /srv/notes.txt õigused on korrektsed."
else
    log_tulemus "24. VIGA - Faili /srv/notes.txt õigused ei ole korrektsed."
fi

# Kontroll 25: Kontrollib, kas kasutaja kodukaustas on link "sisekord", mis viitab failile /usr/local/avalik/sisekord.txt
if [ -L "$KODUKAUST/sisekord" ] && [ "$(readlink -f $KODUKAUST/sisekord)" = "/usr/local/avalik/sisekord.txt" ]; then
    log_tulemus "25. OK - Kodukaustas on link 'sisekord', mis viitab failile /usr/local/avalik/sisekord.txt."
else
    log_tulemus "25. VIGA - Kodukaustas ei ole linki 'sisekord' või see ei viita failile /usr/local/avalik/sisekord.txt."
fi

# Kontroll 26: Kontrollib, kas kausta /var/www/wordpress omanikuks ja grupiks on muudetud www-data ning kas kausta sees olevad failid on samuti muudetud
if [ "$(stat -c %U /var/www/wordpress)" = "www-data" ] && [ "$(stat -c %G /var/www/wordpress)" = "www-data" ]; then
    if find /var/www/wordpress ! -user www-data -o ! -group www-data | grep -q .; then
        log_tulemus "26. VIGA - Kausta /var/www/wordpress sees on faile, mille omanik või grupp ei ole 'www-data'."
    else
        log_tulemus "26. OK - Kausta /var/www/wordpress omanik ja grupp on 'www-data' ning kõik kausta sees olevad failid on samuti muudetud."
    fi
else
    log_tulemus "26. VIGA - Kausta /var/www/wordpress omanik või grupp ei ole 'www-data'."
fi

# Kontroll 27: Kontrollib, kas tarkvarapakk "samba" on paigaldatud
if dpkg -l | grep -q "^ii  samba "; then
    log_tulemus "27. OK - Tarkvarapakk 'samba' on paigaldatud."
else
    log_tulemus "27. VIGA - Tarkvarapakki 'samba' ei ole paigaldatud."
fi

# Kontroll 28: Kontrollib, kas tarkvarapakid "apache2", "mariadb-server", "php", "php-mysql", "libapache2-mod-php" on paigaldatud
PAKID=("apache2" "mariadb-server" "php" "php-mysql" "libapache2-mod-php")
MISSING_PACKAGES=()

# Kontrollime iga pakki
for PAKK in "${PAKID[@]}"; do
    if ! dpkg -l | grep -q "^ii  $PAKK "; then
        MISSING_PACKAGES+=("$PAKK")
    fi
done

# Tulemuste logimine
if [ ${#MISSING_PACKAGES[@]} -eq 0 ]; then
    log_tulemus "28. OK - Kõik vajalikud tarkvarapakid ('apache2', 'mariadb-server', 'php', 'php-mysql', 'libapache2-mod-php') on paigaldatud."
else
    log_tulemus "28. VIGA - Järgmised tarkvarapakid on puudu: ${MISSING_PACKAGES[*]}."
fi

# Kontroll 29: Kontrollib, kas kasutaja kodukaustas on fail "cacti.txt", mis sisaldab sõna "monitoring"
FAILC="$KODUKAUST/cacti.txt"

# Kontrollime, kas fail eksisteerib ja sisaldab sõna "monitoring"
if [ -f "$FAILC" ] && grep -q -e "monitoring" "$FAILC"; then
    log_tulemus "29. OK - Fail 'cacti.txt' on olemas ja sisaldab 'cacti' märksõna otsingutulemusi."
else
    log_tulemus "29. VIGA - Faili 'cacti.txt' ei ole või see ei sisalda 'cacti' märksõna otsingutulemusi."
fi

# Kontroll 30: Kontrollib, kas kasutaja kodukaustas on fail "depends.txt", mis sisaldab sõna "libc6"
FAILD="$KODUKAUST/depends.txt"

# Kontrollime, kas fail eksisteerib ja sisaldab sõna "libc6"
if [ -f "$FAILD" ] && grep -q -e "libc6" "$FAILD"; then
    log_tulemus "30. OK - Fail 'depends.txt' on olemas ja sisaldab htop-i sõltuvusi."
else
    log_tulemus "30. VIGA - Faili 'depends.txt' ei ole või see ei sisalda htop-i sõltuvusi."
fi

# Kontroll 31: Kontrollib, kas tarkvarapakid "fortune" ja "cowsay" on eemaldatud
EEMALDATUD_PAKID=("fortune-mod" "cowsay")
INSTALLEERITUD_PAKID=()

# Kontrollime iga pakki
for PAKK in "${EEMALDATUD_PAKID[@]}"; do
    if dpkg -l | grep -q "^ii  $PAKK "; then
        INSTALLEERITUD_PAKID+=("$PAKK")
    fi
done

# Tulemuste logimine
if [ ${#INSTALLEERITUD_PAKID[@]} -eq 0 ]; then
    log_tulemus "31. OK - Tarkvarapakid 'fortune' ja 'cowsay' on eemaldatud."
else
    log_tulemus "31. VIGA - Järgmised tarkvarapakid ei ole eemaldatud: ${INSTALLEERITUD_PAKID[*]}."
fi

# Kontroll 32: Kontrollib, kas tarkvarapakk "webmin" on paigaldatud
if dpkg -l | grep -q "^ii  webmin "; then
    log_tulemus "32. OK - Tarkvarapakk 'webmin' on paigaldatud."
else
    log_tulemus "32. VIGA - Tarkvarapakki 'webmin' ei ole paigaldatud."
fi

# Kontroll 33: Kontrollib, kas failis ~/otsing1.txt on vajalikud read
if grep -Fxq "/usr/local/share/file4.txt" $KODUKAUST/otsing1.txt && \
   grep -Fxq "/usr/local/etc/file5.txt" $KODUKAUST/otsing1.txt && \
   grep -Fxq "/usr/local/games/file1.txt" $KODUKAUST/otsing1.txt && \
   grep -Fxq "/usr/local/data/file2.txt" $KODUKAUST/otsing1.txt && \
   grep -Fxq "/usr/local/binx/file3.txt" $KODUKAUST/otsing1.txt; then
    log_tulemus "33. OK - Oled kõik failid üles leidnud, milles sisaldub sõna 'peitus'"
else
    log_tulemus "33. VIGA - Failis 'otsing1.txt' ei ole kõigi failide nimekirja kus sisaldub sõna 'peitus'."
fi

# Kontroll 34: Kontrollib, kas failis ~/otsing2.txt on vajalikud read
if grep -Fxq "/var/opt/optfile.log" $KODUKAUST/otsing2.txt && \
   grep -Fxq "/var/log/biglogfile.log" $KODUKAUST/otsing2.txt; then
    log_tulemus "34. OK - Kõik 50+ MB suurusega failid on '/var' kaustast leitud"
else
    log_tulemus "34. VIGA - Failis 'otsing2.txt' ei ole kõigi '/var' kausta failide nimekirja, mis on suuremad kui 50 MB."
fi

# Kontroll 35: Kontrollib, kas failis ~/otsing3.txt on vajalikud read
if grep -Fxq "/etc/local-host" $KODUKAUST/otsing3.txt && \
   grep -Fxq "/etc/graphical" $KODUKAUST/otsing3.txt && \
   grep -Fxq "/etc/system23" $KODUKAUST/otsing3.txt && \
   grep -Fxq "/etc/file2.txt" $KODUKAUST/otsing3.txt; then
    log_tulemus "35. OK - Kõik vanad failid on '/etc' kaustast leitud"
else
    log_tulemus "35. VIGA - Failis 'otsing3.txt' ei ole kõiki vanu '/etc' kausta faile"
fi

# Kontroll 36: Kontrollib, kas kasutaja 'boss' kodukaustas on fail 'plaan.txt' ja kas see sisaldab sõna 'kohvi'
if [ -f /home/boss/plaan.txt ]; then
    if grep -q "kohvi" /home/boss/plaan.txt; then
        log_tulemus "36. OK - Fail 'plaan.txt' eksisteerib ja sisaldab õiget sisu"
    else
        log_tulemus "36. VIGA - Fail 'plaan.txt' eksisteerib, kuid ei sisalda õiget sisu."
    fi
else
    log_tulemus "36. VIGA - Faili 'plaan.txt' ei leitud kasutaja 'boss' kodukaustast."
fi

echo "Tulemused on salvestatud faili $TULEMUSFAIL"
