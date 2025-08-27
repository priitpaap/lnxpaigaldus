#!/bin/bash
# Kontrollskript "kasutajate haldus" ülesande jaoks

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }

# 2. Kas fail kasutajad.txt on olemas ja algab uptime väljundiga
if [ -f "kasutajad.txt" ]; then
    if grep -q "load average" kasutajad.txt; then
        ok "Fail kasutajad.txt olemas ja sisaldab uptime väljundit"
    else
        fail "Fail kasutajad.txt olemas, kuid ei sisalda uptime väljundit"
    fi
else
    fail "Fail kasutajad.txt puudub"
fi

# 3. Kas kasutajad jyri, mari ja kalle on olemas
for user in jyri mari kalle; do
    if id "$user" &>/dev/null; then
        ok "Kasutaja $user olemas"
    else
        fail "Kasutaja $user puudub"
    fi
done

# 4. Grupp praktikandid ja liikmed
if getent group praktikandid >/dev/null; then
    ok "Grupp praktikandid olemas"
    for user in jyri mari kalle; do
        if id -nG "$user" | grep -qw praktikandid; then
            ok "Kasutaja $user on grupis praktikandid"
        else
            fail "Kasutaja $user ei ole grupis praktikandid"
        fi
    done
else
    fail "Grupp praktikandid puudub"
fi

# 5. Grupp abilised
if getent group abilised >/dev/null; then
    ok "Grupp abilised olemas"
else
    fail "Grupp abilised puudub"
fi

# 6. Jyri sudo/wheel grupis
if id -nG jyri | grep -Eq '\bsudo\b|\bwheel\b'; then
    ok "Kasutaja jyri on sudo/wheel grupis"
else
    fail "Kasutaja jyri ei ole sudo/wheel grupis"
fi

# 7. Jyri.txt olemas ja sisaldab tema gruppe
if [ -f /home/jyri/jyri.txt ]; then
    if grep -q "jyri" /home/jyri/jyri.txt; then
        ok "Fail jyri.txt olemas ja sisaldab kasutaja gruppe"
    else
        fail "Fail jyri.txt ei sisalda õiget infot"
    fi
else
    fail "Fail jyri.txt puudub"
fi

# 8. Kas pille EI ole enam grupis raamatupidajad
if id -nG pille 2>/dev/null | grep -qw raamatupidajad; then
    fail "Kasutaja pille on ikka veel grupis raamatupidajad"
else
    ok "Kasutaja pille pole enam grupis raamatupidajad (või kasutaja puudub)"
fi

# 9. Grupp ajutine kustutatud
if getent group ajutine >/dev/null; then
    fail "Grupp ajutine on alles"
else
    ok "Grupp ajutine on kustutatud"
fi

# 10. Jyri parooli muutust ei saa turvaliselt kontrollida → ainult märge
ok "Jyri parooli muutust kontrolli käsitsi (skript ei saa parooli avada)"

# 11. Kas kasutaja teenus olemas ja tal pole parooli
if id teenus &>/dev/null; then
    passwd -S teenus 2>/dev/null | grep -q "NP"
    if [ $? -eq 0 ]; then
        ok "Kasutaja teenus olemas ja tal pole parooli"
    else
        fail "Kasutaja teenus olemas, aga tal on parool"
    fi
else
    fail "Kasutaja teenus puudub"
fi

# 12. Kasutaja kalmer eemaldatud
if id kalmer &>/dev/null; then
    fail "Kasutaja kalmer on endiselt alles"
else
    ok "Kasutaja kalmer on kustutatud"
fi

# 13. Kasutaja mari lukustatud
if passwd -S mari 2>/dev/null | grep -q "L"; then
    ok "Kasutaja mari on lukustatud"
else
    fail "Kasutaja mari ei ole lukustatud"
fi

# 14. Kontrollime, kas on loodud kasutaja sama nimega nagu sisseloginud kasutaja
MYUSER=$(whoami)
if id "$MYUSER" &>/dev/null; then
    ok "Kasutaja $MYUSER loodud"
else
    fail "Sinu nimeline kasutaja ($MYUSER) puudub"
fi

# 15. Fail mina.txt olemas ja sisaldab sinu kasutaja infot
if [ -f /home/$MYUSER/mina.txt ]; then
    if grep -q "$MYUSER" /home/$MYUSER/mina.txt; then
        ok "Fail mina.txt sisaldab sinu kasutaja infot"
    else
        fail "Fail mina.txt ei sisalda sinu kasutaja infot"
    fi
else
    fail "Fail mina.txt puudub"
fi

# 16. Kas kasutaja kersti olemas ja failid üle toodud
if id kersti &>/dev/null; then
    ok "Kasutaja kersti olemas"
    if [ -d /home/kersti ]; then
        COUNT=$(find /home/kersti -type f | wc -l)
        EXT=$(find /home/kersti -type f | sed 's/.*\.//' | sort -u | wc -l)
        if [ "$COUNT" -ge 50 ] && [ "$EXT" -ge 4 ]; then
            ok "Sekretäri failid on üle toodud (≥50 faili, ≥4 laiendit)"
        else
            fail "Sekretäri failid ei vasta tingimustele"
        fi
    else
        fail "Kasutaja kersti kodukaust puudub"
    fi
else
    fail "Kasutaja kersti puudub"
fi

# 17-18. Kas kasutajad.txt lõpus on history ja uptime väljundid
if tail -n 5 kasutajad.txt | grep -q "load average"; then
    ok "Fail kasutajad.txt lõpus on uptime väljund"
else
    fail "Fail kasutajad.txt lõpus pole uptime väljundit"
fi

if tail -n 10 kasutajad.txt | grep -q "history"; then
    ok "Fail kasutajad.txt lõpus on history väljund"
else
    fail "Fail kasutajad.txt lõpus pole history väljundit"
fi
