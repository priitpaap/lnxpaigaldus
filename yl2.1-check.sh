#!/bin/bash
# check.sh - kontrollib õppija tegevusi Linuxi käsurea harjutuses
# Käivita root kasutajana (nt sudo ./check.sh)

STUDENT_HOME="/home/student"
MARKER="[SETUP]"
TOTAL=0
SCORE=0

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }

echo ">>> Alustan kontrolli..."

# 1. Kontrolli, kas ajalugu pole puhastatud (ajalugu.txt peab sisaldama käskusid hiljem)
if [ -f "$STUDENT_HOME/ajalugu.txt" ]; then
    if grep -q "load average" "$STUDENT_HOME/ajalugu.txt"; then
        ok "Fail ajalugu.txt sisaldab uptime käske"
    else
        fail "Fail ajalugu.txt puudub või ei sisalda uptime käske"
    fi
else
    fail "Fail ajalugu.txt puudub"
fi

# 2. Kontrolli kausta ajutine olemasolu ja alamkaustad
if [ -d "$STUDENT_HOME/ajutine/failid1" ] && \
   [ -d "$STUDENT_HOME/ajutine/failid2" ] && \
   [ -d "$STUDENT_HOME/ajutine/failid3" ]; then
    ok "Kaust ajutine koos alamkaustadega on olemas"
else
    fail "Kaust ajutine või alamkaustad puuduvad"
fi

# 3. Kontrolli kausta september koos 30 alamkaustaga
if [ -d "$STUDENT_HOME/september" ]; then
    count=$(ls -1 "$STUDENT_HOME/september" | grep -c '^sept[0-9]\{1,2\}$')
    if [ "$count" -eq 30 ]; then
        ok "Kaust september sisaldab 30 alamkausta"
    else
        fail "Kaust september ei sisalda täpselt 30 alamkausta (leiti $count)"
    fi
else
    fail "Kaust september puudub"
fi

# 4. Kontrolli kausta "olulised failid" olemasolu
if [ -d "$STUDENT_HOME/olulised failid" ]; then
    ok "Kaust 'olulised failid' on olemas"
else
    fail "Kaust 'olulised failid' puudub"
fi

# 5. Kontrolli faile andmed1 ja andmed2
if [ -f "$STUDENT_HOME/andmed1" ] && [ -f "$STUDENT_HOME/andmed2" ]; then
    ok "Failid andmed1 ja andmed2 olemas"
else
    fail "Failid andmed1 ja/või andmed2 puuduvad"
fi

# 6. Kontrolli, kas /var/vanalogi.txt kopeeriti ajutine/failid1 alla
if [ -f "$STUDENT_HOME/ajutine/failid1/vanalogi.txt" ]; then
    if grep -q "$MARKER" "$STUDENT_HOME/ajutine/failid1/vanalogi.txt"; then
        ok "Fail vanalogi.txt kopeeriti õigesti"
    else
        fail "Fail vanalogi.txt kopeeriti, aga marker puudub"
    fi
else
    fail "Fail vanalogi.txt puudub ajutine/failid1 kaustas"
fi

# 7. Kontrolli, kas data1.txt on ümber nimetatud ajutised_andmed
if [ -f "$STUDENT_HOME/ajutised_andmed" ]; then
    WORDS=$(wc -w < "$STUDENT_HOME/ajutised_andmed")
    if [ "$WORDS" -gt 4 ]; then
        ok "Fail ajutised_andmed olemas ja sinna on lisatud uut sisu"
    else
        fail "Fail ajutised_andmed on alles, aga sisu ei ole muudetud"
    fi
else
    fail "Fail ajutised_andmed puudub"
fi

# 8. Kontrolli, kas /etc/group kopeeriti ajutine/failid2 alla
if [ -f "$STUDENT_HOME/ajutine/failid2/group" ]; then
    ok "Fail group kopeeriti õigesti"
else
    fail "Fail group puudub ajutine/failid2 kaustas"
fi

# 9. Kontrolli faili salajane.txt olemasolu ja sisu
if [ -f "$STUDENT_HOME/salajane.txt" ]; then
    # Leia süsteemist grupi "salajane" GID
    SYS_GID=$(getent group salajane | cut -d: -f3)

    if grep -q "$SYS_GID" "$STUDENT_HOME/salajane.txt"; then
        ok "Fail salajane.txt olemas ja sisaldab õiget GID väärtust ($SYS_GID)"
    else
        fail "Fail salajane.txt olemas, aga ei sisalda õiget GID väärtust"
    fi
else
    fail "Fail salajane.txt puudub"
fi

# 10. Kontrolli, kas /var/skriptid kaust kopeeriti ajutine/failid3 alla
if [ -d "$STUDENT_HOME/ajutine/failid3/skriptid" ]; then
    count=$(ls -1 "$STUDENT_HOME/ajutine/failid3/skriptid" | wc -l)
    if [ "$count" -ge 25 ]; then
        ok "Kaust skriptid kopeeriti õigesti ($count faili)"
    else
        fail "Kaust skriptid kopeeriti, aga failide arv vale ($count)"
    fi
else
    fail "Kaust skriptid puudub ajutine/failid3 all"
fi

# 11. Kontrolli, kas kaust ohoo liigutas failid4 nime alla
if [ -d "$STUDENT_HOME/ajutine/failid4" ]; then
    ok "Kaust ohoo liigutas õigesti failid4 nime alla"
else
    fail "Kaust ohoo puudub või ei ole nimega failid4"
fi

# 12. Kontrolli, kas kaust /srv/somefiles/somefolder kustutati
if [ ! -d "/srv/somefiles/somefolder" ]; then
    ok "Kaust somefolder on kustutatud"
else
    fail "Kaust somefolder ikka olemas"
fi

# 13. Kontrolli, kas /srv/filemess kaustas on ainult mitte-.txt failid alles
txtcount=$(ls /srv/filemess/*.txt 2>/dev/null | wc -l)
allcount=$(ls /srv/filemess 2>/dev/null | wc -l)

if [ "$allcount" -eq 0 ]; then
    fail "Kaust /srv/filemess on tühi, ei tohiks kõiki faile kustutada"
elif [ "$txtcount" -eq 0 ]; then
    ok "Kõik .txt failid kustutati ja teised failid on alles /srv/filemess kaustas"
else
    fail "Kaustas /srv/filemess on veel $txtcount .txt faili alles"
fi

# 14. Kontrolli, kas junk fail kustutati
if [ ! -f "$STUDENT_HOME/junk" ]; then
    ok "Fail junk kustutati"
else
    fail "Fail junk ikka alles"
fi

# 15. Kontrolli viimased.txt
if [ -f "$STUDENT_HOME/viimased.txt" ]; then
    LINECOUNT=$(wc -l < "$STUDENT_HOME/viimased.txt")
    if [ "$LINECOUNT" -eq 5 ]; then
        if tail -n 5 "$STUDENT_HOME/viimased.txt" | grep -qi "student"; then
            ok "Fail viimased.txt olemas, sisaldab 5 rida ja sisaldab faili viimaseid ridu"
        else
            fail "Fail viimased.txt olemas ja sisaldab 5 rida, aga need ei ole faili viimased read"
        fi
    else
        fail "Fail viimased.txt olemas, aga ridade arv vale ($LINECOUNT)"
    fi
else
    fail "Fail viimased.txt puudub"
fi

# 16. Kontrolli esimesed.txt
if [ -f "$STUDENT_HOME/esimesed.txt" ]; then
    LINECOUNT=$(wc -l < "$STUDENT_HOME/esimesed.txt")
    if [ "$LINECOUNT" -eq 5 ]; then
        if grep -q "^root:" "$STUDENT_HOME/esimesed.txt"; then
            ok "Fail esimesed.txt olemas, sisaldab 5 rida ja sisaldab faili esimesi ridu"
        else
            fail "Fail esimesed.txt olemas ja 5 rida, aga need pole faili esimesed read"
        fi
    else
        fail "Fail esimesed.txt olemas, aga ridade arv vale ($LINECOUNT)"
    fi
else
    fail "Fail esimesed.txt puudub"
fi

# --- Kokkuvõte ---
echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget kontrollpunkti."
