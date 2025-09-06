#!/bin/bash

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }
KODU="/home/student"

# 2. Kas fail kaustaoigused.txt on olemas ja algab hostnamectl väljundiga
if [ -f "$KODU/kaustaoigused.txt" ]; then
    if grep -q "Linux" kaustaoigused.txt; then
        ok "Fail kaustaoigused.txt olemas ja sisaldab hostnamectl väljundit"
    else
        fail "Fail kaustaoigused.txt olemas, kuid ei sisalda hostnamectl väljundit"
    fi
else
    fail "Fail kaustaoigused.txt puudub"
fi

# 3. Fail "esimene" õigused 660
if [ -f "$KODU/esimene" ]; then
    if [ "$(stat -c "%a" $KODU/esimene)" = "660" ]; then
        ok "Fail esimene õigused õiged (660)"
    else
        fail "Fail esimene õigused valed"
    fi
else
    fail "Fail esimene puudub"
fi

# 4. Fail "teine" õigused 644
if [ -f "$KODU/teine" ]; then
    if [ "$(stat -c "%a" $KODU/teine)" = "644" ]; then
        ok "Fail teine õigused õiged (644)"
    else
        fail "Fail teine õigused valed"
    fi
else
    fail "Fail teine puudub"
fi

# 5. Fail backup.sh õigused 750
if [ -f "$KODU/backup.sh" ]; then
    if [ "$(stat -c "%a" $KODU/backup.sh)" = "750" ]; then
        ok "Fail backup.sh õigused õiged (750)"
    else
        fail "Fail backup.sh õigused valed"
    fi
else
    fail "Fail backup.sh puudub"
fi

# 6–7. Kasutaja jyri olemas ja fail esimene omanikuks jyri
if id jyri &>/dev/null; then
    if [ "$(stat -c "%U:%G" $KODU/esimene 2>/dev/null)" = "jyri:jyri" ]; then
        ok "Fail esimene omanik ja grupp on jyri"
    else
        fail "Fail esimene ei kuulu kasutajale ja grupile jyri"
    fi
else
    fail "Kasutaja jyri puudub"
fi

# 8–9. Kaust docs õigused 700
if [ -d "$KODU/docs" ]; then
    if [ "$(stat -c "%a" $KODU/docs)" = "700" ]; then
        ok "Kaust docs õigused õiged (700)"
    else
        fail "Kaust docs õigused valed"
    fi
else
    fail "Kaust docs puudub"
fi

# 10. Kaust /var/failid õigused 754 (+võib olla SGID)
if [ -d "/var/failid" ]; then
    perms=$(stat -c "%a" /var/failid)
    if [ "$perms" = "754" ] || [ "$perms" = "2754" ]; then
        ok "Kaust /var/failid õigused õiged (754/2754)"
    else
        fail "Kaust /var/failid õigused valed"
    fi
else
    fail "Kaust /var/failid puudub"
fi

# 11. Kontrollime, et kausta /var/failid grupiks on raamatupidajad
if [ -d "/var/failid" ]; then
    if [ "$(stat -c "%G" /var/failid)" = "raamatupidajad" ]; then
        ok "Kaust /var/failid grupiks on raamatupidajad"
    else
        fail "Kausta /var/failid grupp ei ole raamatupidajad"
    fi
else
    fail "Kausta /var/failid ei eksisteeri"
fi

# 12. Kontrollime, et kaustal /var/failid on SGID bitt
if [ -d "/var/failid" ]; then
    if [ -g /var/failid ] ; then
        ok "Kaustal /var/failid on SGID bitt"
    else
        fail "Kaustal /var/failid puudub SGID bitt"
    fi
else
    fail "Kausta /var/failid ei eksisteeri"
fi


# 13. skript1.sh – teised ei tohi käivitada (750 või 770)
if [ -f "/var/skriptid/skript1.sh" ]; then
    PERM=$(stat -c "%a" /var/skriptid/skript1.sh)
    if [[ "$PERM" =~ ^754$ ]]; then
        ok "skript1.sh õigused õiged ($PERM)"
    else
        fail "skript1.sh õigused valed ($PERM)"
    fi
else
    fail "Fail /var/skriptid/skript1.sh puudub"
fi

# 14. skript2.sh – teised ei tohi lugeda, aga saavad käivitada
if [ -f "/var/skriptid/skript2.sh" ]; then
    if [ "$(stat -c "%a" /var/skriptid/skript2.sh)" = "751" ]; then
        ok "skript2.sh õigused õiged (751)"
    else
        fail "skript2.sh õigused valed"
    fi
else
    fail "Fail /var/skriptid/skript2.sh puudub"
fi

# 15. Kausta /srv/lepingud omanik jyri (grupp muutmata)
if [ -d "/srv/lepingud" ]; then
    if [ "$(stat -c "%U" /srv/lepingud)" = "jyri" ]; then
        ok "Kausta /srv/lepingud omanik jyri"
    else
        fail "Kausta /srv/lepingud omanik pole jyri"
    fi
else
    fail "Kaust /srv/lepingud puudub"
fi

# 16. Kaust /var/avalik sticky bit
if [ -d /var/avalik ]; then
    if [ -k /var/avalik ]; then
        ok "Kaust /var/avalik sticky bit peal"
    else
        fail "Kaust /var/avalik sticky bit puudu"
    fi
else
    fail "Kaust /var/avalik puudub"
fi

# --- Kokkuvõte ---
echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget tulemust."
