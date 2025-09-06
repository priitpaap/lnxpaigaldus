#!/bin/bash
# yl5.1-check.sh - kontrollib õppija tegevusi Debian tarkvarahalduse ülesandes
# Käivita root kasutajana (nt sudo ./yl5.1-check.sh)

STUDENT_HOME="/home/student"
TOTAL=0
SCORE=0

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }

echo ">>> Alustan kontrolli..."

# 1. Kas fail debian.txt on olemas ja algab hostnamectl väljundiga
if [ -f "$KODU/debian.txt" ]; then
    if grep -q "Linux" debian.txt; then
        ok "Fail debian.txt olemas ja sisaldab hostnamectl väljundit"
    else
        fail "Fail debian.txt olemas, kuid ei sisalda hostnamectl väljundit"
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

# 3. Kontrolli, kas hostnamectl väljund lisati
if [ -f "$STUDENT_HOME/debian.txt" ]; then
  if grep -q "Linux" "$STUDENT_HOME/debian.txt"; then
    ok "Fail debian.txt sisaldab hostnamectl väljundit"
  else
    fail "Fail debian.txt ei sisalda hostnamectl väljundit"
  fi
else
  fail "Fail debian.txt puudub"
fi

# 4. Kontrolli nginx paketti ja teenust
if dpkg -l | grep -q nginx; then
  ok "Pakk nginx on paigaldatud"
  if systemctl is-active --quiet nginx; then
    ok "Teenuse nginx staatus on aktiivne"
  else
    fail "Teenuse nginx ei tööta"
  fi
else
  fail "Pakk nginx ei ole paigaldatud"
fi

# 5. Kontrolli nginx.txt faili olemasolu
if [ -f "$STUDENT_HOME/nginx.txt" ] && grep -q "Package: nginx" "$STUDENT_HOME/nginx.txt"; then
  ok "Fail nginx.txt olemas ja sisaldab paki infot"
else
  fail "Fail nginx.txt puudub või ei sisalda õiget infot"
fi

# 6. Kontrolli depends.txt faili olemasolu
if [ -f "$STUDENT_HOME/depends.txt" ] && grep -qi "Depends" "$STUDENT_HOME/depends.txt"; then
  ok "Fail depends.txt olemas ja sisaldab sõltuvusi"
else
  fail "Fail depends.txt puudub või ei sisalda sõltuvusi"
fi

# 7. Kontrolli, kas mc on paigaldatud
if dpkg -l | grep -q mc; then
  ok "Pakk mc on paigaldatud"
else
  fail "Pakk mc ei ole paigaldatud"
fi

# 8. Kontrolli, kas bind9 on eemaldatud
if ! dpkg -l | grep -q bind9; then
  ok "Pakk bind9 on eemaldatud"
else
  fail "Pakk bind9 on endiselt paigaldatud"
fi

# 9. Kontrolli, kas fortune-mod on paigaldatud
if dpkg -l | grep -q fortune-mod; then
  ok "Pakk fortune-mod on paigaldatud"
else
  fail "Pakk fortune-mod ei ole paigaldatud"
fi

# 10. Kontrolli, kas webmin on paigaldatud ja deb-fail eemaldatud
if dpkg -l | grep -q webmin; then
  ok "Pakk webmin on paigaldatud"
else
  fail "Pakk webmin ei ole paigaldatud"
fi
if [ ! -f "$STUDENT_HOME/webmin_2.402_all.deb" ]; then
  ok "Webmin installifail on eemaldatud"
else
  fail "Webmin installifail on alles"
fi

# 11. Kontrolli, kas ajalugu on salvestatud
if [ -f "$STUDENT_HOME/debian.txt" ]; then
  if grep -q "apt" "$STUDENT_HOME/debian.txt" && grep -q "history" "$STUDENT_HOME/debian.txt"; then
    ok "Fail debian.txt sisaldab käsuajalugu"
  else
    fail "Fail debian.txt ei sisalda käsuajalugu"
  fi
else
  fail "Fail debian.txt puudub"
fi

echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget kontrollpunkti."
