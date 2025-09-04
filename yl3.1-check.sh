#!/bin/bash
# Kontrollskript "kasutajate haldus" ülesande jaoks

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }
KODU="/home/student"

# 2. Kas fail kasutajad.txt on olemas ja algab hostnamectl väljundiga
if [ -f "$KODU/kasutajad.txt" ]; then
    if grep -q "Linux" kasutajad.txt; then
        ok "Fail kasutajad.txt olemas ja sisaldab hostnamectl väljundit"
    else
        fail "Fail kasutajad.txt olemas, kuid ei sisalda hostnamectl väljundit"
    fi
else
    fail "Fail kasutajad.txt puudub"
fi

# 3. Kas kasutajad jyri, mari on olemas
for user in jyri mari; do
    if id "$user" &>/dev/null; then
        ok "Kasutaja $user olemas"
    else
        fail "Kasutaja $user puudub"
    fi
done

# 4. Grupp praktikandid ja liikmed
if getent group praktikandid >/dev/null; then
    ok "Grupp praktikandid olemas"
    for user in jyri mari; do
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
if id -nG jyri | grep -Eq '\bsudo\b|\bwheel\b' &> /dev/null; then
    ok "Kasutaja jyri on sudo/wheel grupis"
else
    fail "Kasutaja jyri ei ole sudo/wheel grupis"
fi

# 7. Jyri.txt olemas ja sisaldab tema gruppe
if [ -f "$KODU/jyri.txt" ]; then
    if grep -q "jyri" "$KODU/jyri.txt" && (grep -q "sudo" "$KODU/jyri.txt" || grep -q "wheel" "$KODU/jyri.txt"); then
        ok "Fail jyri.txt olemas ja sisaldab kasutaja jyri gruppe (sh sudo/wheel)"
    else
        fail "Fail jyri.txt ei sisalda õiget infot (puudu jyri või sudo/wheel)"
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

# 10. Jyri parooli muutust ei saa skriptiga kontrollida → ainult märge
ok "Jyri parooli muutust ei saa kahjuks skriptiga kontrollida"

# 11. Kas kasutaja teenus olemas ja tal pole parooli
if id teenus &>/dev/null; then
    SHADOW=$(getent shadow teenus | cut -d: -f2 || true)
    # NP loeme kehtivaks, kui parooliväli on tühi või täpselt "!", "!!" või "*"
    if [ -z "$SHADOW" ] || [[ "$SHADOW" == "!" || "$SHADOW" == "!!" || "$SHADOW" == "*" ]]; then
        ok "Kasutaja teenus olemas ja parooli pole"
    else
        fail "Kasutaja teenus olemas, kuid parooliväli pole tühi (shadow='$SHADOW')"
    fi
else
    fail "Kasutaja teenus puudub"
fi

# 12. Kasutaja kalmer eemaldatud
if id kalmer &>/dev/null; then
    fail "Kasutaja kalmer on endiselt alles"
else
    if [ -d "/home/kalmer" ]; then
        fail "Kasutaja kalmer kustutatud, aga kodukataloog /home/kalmer on alles"
    else
        ok "Kasutaja kalmer ja tema kodukataloog on kustutatud"
    fi
fi

# 13. Kasutaja mari lukustatud
if passwd -S mari 2>/dev/null | grep -q "L"; then
    ok "Kasutaja mari on lukustatud"
else
    fail "Kasutaja mari ei ole lukustatud"
fi

# 14. Fail mina.txt olemas ja 4. väli ei ole tühi või ainult komad
if [ -f "$KODU/mina.txt" ]; then
    # Võtame faili esimese rea 4. välja
    FIELD4=$(cut -d: -f5 "$KODU/mina.txt")
    
    # Eemaldame kõik komad ja tühikud ning kontrollime, kas midagi jäi alles
    if [ -n "$(echo "$FIELD4" | tr -d ' ,')" ]; then
        ok "Fail mina.txt sisaldab tõenäoliselt sinu kasutajanime"
    else
        fail "Fail mina.txt ei sisalda õigel väljal sinu täispikka nime"
    fi
else
    fail "Fail mina.txt puudub"
fi

# 15. Kas kasutaja kersti olemas ja failid üle toodud
if id kersti &>/dev/null; then
    ok "Kasutaja kersti olemas"
    if [ -d /home/kersti ]; then
        COUNT=$(find /home/kersti -type f | wc -l)
        EXT=$(find /home/kersti -type f | sed 's/.*\.//' | sort -u | wc -l)
        if [ "$COUNT" -ge 50 ] && [ "$EXT" -ge 4 ]; then
            ok "Sekretäri failid on üle toodud (≥50 faili, ≥4 laiendit)"
        else
            fail "Sekretäri failid ei ole kõik üle toodud"
        fi
    else
        fail "Kasutaja kersti kodukaust puudub"
    fi
else
    fail "Kasutaja kersti puudub"
fi

# 16. Kas kasutajad.txt lõpus on history väljund
if tail -n 10 kasutajad.txt &> /dev/null | grep -q "history" ; then
    ok "Fail kasutajad.txt lõpus on history väljund"
else
    fail "Faili kasutajad.txt lõpus pole history väljundit või faili kasutajad.txt ei leitud"
fi

# --- Kokkuvõte ---
echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget tulemust."
