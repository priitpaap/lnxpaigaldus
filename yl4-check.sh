#!/bin/bash
# yl4-check.sh - kontrollib õppija tegevusi Debian tarkvarahalduse ülesandes
# Käivita root kasutajana (nt sudo ./yl4-check.sh)

STUDENT_HOME="/home/student"
TOTAL=0
SCORE=0

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }

echo ">>> Alustan kontrolli..."

# 1. Fail debian.txt olemas ja sisaldab uptime
if [ -f "$STUDENT_HOME/debian.txt" ]; then
  if grep -q "load average" "$STUDENT_HOME/debian.txt"; then
    ok "Fail debian.txt sisaldab uptime väljundit"
  else
    fail "Fail debian.txt olemas, kuid ei sisalda uptime väljundit"
  fi
else
  fail "Fail debian.txt puudub"
fi

# 2. Kontrolli, kas süsteemis pole uuendatavaid pakette
UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)
if [ "$UPGRADABLE" -eq 0 ]; then
  ok "Kõik süsteemi paketid on uuendatud"
else
  fail "Süsteemis on $UPGRADABLE uuendatavat paketti"
fi

# 3. Kontrolli, kas uname -a on lisatud
if grep -q "Linux" "$STUDENT_HOME/debian.txt"; then
  ok "Fail debian.txt sisaldab uname -a väljundit"
else
  fail "Fail debian.txt ei sisalda uname -a väljundit"
fi

# 4. Kontrolli, kas ajalugu on salvestatud
if grep -q "apt" "$STUDENT_HOME/debian.txt" && grep -q "history" "$STUDENT_HOME/debian.txt"; then
  ok "Fail debian.txt sisaldab käsuajalugu"
else
  fail "Fail debian.txt ei sisalda käsuajalugu"
fi

# 5. Kontrolli, kas nginx on paigaldatud
if dpkg -l | grep -q nginx; then
  ok "Pakk nginx on paigaldatud"
else
  fail "Pakk nginx ei ole paigaldatud"
fi

# 6. Kontrolli nginx teenuse tööd
if systemctl is-active --quiet nginx; then
  ok "Teenuse nginx staatus on aktiivne"
else
  fail "Teenuse nginx ei tööta"
fi

# 7. Kontrolli nginx versiooni olemasolu failis
if grep -i "nginx" "$STUDENT_HOME/debian.txt" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+'; then
  ok "Fail debian.txt sisaldab nginx versiooni"
else
  fail "Fail debian.txt ei sisalda nginx versiooni"
fi

# 8. Kontrolli, kas mc on eemaldatud
if ! dpkg -l | grep -q mc; then
  ok "Pakk mc on eemaldatud"
else
  fail "Pakk mc on endiselt paigaldatud"
fi

# 9. Kontrolli, kas fortune-mod on paigaldatud
if dpkg -l | grep -q fortune-mod; then
  ok "Pakk fortune-mod on paigaldatud"
else
  fail "Pakk fortune-mod ei ole paigaldatud"
fi

# 10. Kontrolli, kas webmin on paigaldatud
if dpkg -l | grep -q webmin; then
  ok "Pakk webmin on paigaldatud"
else
  fail "Pakk webmin ei ole paigaldatud"
fi

# 11. Kontrolli, kas webmin installifail on eemaldatud
if [ ! -f "$STUDENT_HOME/webmin_2.402_all.deb" ]; then
  ok "Webmin installifail on eemaldatud"
else
  fail "Webmin installifail on alles"
fi

echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget kontrollpunkti."
