#!/bin/bash
# yl5.2-check.sh - kontrollib õppija tegevusi Alma Linux tarkvarahalduse ülesandes
# Käivita root kasutajana (nt sudo ./yl5.2-check.sh)

STUDENT_HOME="/home/student"
TOTAL=0
SCORE=0

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }

echo ">>> Alustan kontrolli..."

# 1. Fail alma.txt olemas ja sisaldab hostnamectl väljundit
if [ -f "$STUDENT_HOME/alma.txt" ]; then
  if grep -q "Linux" "$STUDENT_HOME/alma.txt"; then
    ok "Fail alma.txt olemas ja sisaldab hostnamectl väljundit"
  else
    fail "Fail alma.txt olemas, kuid ei sisalda hostnamectl väljundit"
  fi
else
  fail "Fail alma.txt puudub"
fi

# 2. Kontrolli, kas süsteemis pole uuendatavaid pakette
dnf check-update -q >/dev/null 2>&1
RC=$?
if [ "$RC" -eq 0 ]; then
  ok "Kõik süsteemi paketid on uuendatud"
elif [ "$RC" -eq 100 ]; then
  fail "Süsteemis on uuendatavaid pakette"
else
  fail "Pakettide uuenduste kontroll ebaõnnestus (võrguprobleem või repo viga)"
fi


# 3. Kontrolli httpd paketti ja teenust
if rpm -q httpd >/dev/null 2>&1; then
  ok "Pakk httpd on paigaldatud"
  if systemctl is-active --quiet httpd; then
    ok "Teenuse httpd staatus on aktiivne"
  else
    fail "Teenuse httpd ei tööta"
  fi
else
  fail "Pakk httpd ei ole paigaldatud"
fi

# 4. Kontrolli httpd.txt faili ja versiooni
if [ -f "$STUDENT_HOME/httpd.txt" ]; then
  VERSION=$(rpm -q httpd)
  if grep -q "$VERSION" "$STUDENT_HOME/httpd.txt"; then
    ok "Fail httpd.txt sisaldab paigaldatud httpd versiooni"
  else
    fail "Fail httpd.txt ei sisalda paigaldatud httpd versiooni"
  fi
else
  fail "Fail httpd.txt puudub"
fi

# 5. Kontrolli depends.txt faili ja libc (või systemd-libs) sõltuvust
if [ -f "$STUDENT_HOME/depends.txt" ]; then
  if grep -q "systemd" "$STUDENT_HOME/depends.txt"; then
    ok "Fail depends.txt sisaldab sõltuvusi"
  else
    fail "Fail depends.txt olemas, kuid ei sisalda ootuspärast sõltuvust"
  fi
else
  fail "Fail depends.txt puudub"
fi

# 6. Kontrolli, kas epel-release on paigaldatud
if rpm -q epel-release >/dev/null 2>&1; then
  ok "EPEL repositoorium on lisatud (epel-release on paigaldatud)"
else
  fail "EPEL repositoorium pole lisatud"
fi

# 7. Kontrolli, kas toilet on paigaldatud
if rpm -q toilet >/dev/null 2>&1; then
  ok "Pakk toilet on paigaldatud"
else
  fail "Pakk toilet ei ole paigaldatud"
fi

# 8. Kontrolli, kas samba on eemaldatud
if rpm -q samba >/dev/null 2>&1; then
  fail "Pakk samba on veel eemaldamata"
else
  ok "Pakk samba on eemaldatud"
fi

# 9. Kontrolli, kas nmap on paigaldatud
if rpm -q nmap >/dev/null 2>&1; then
  ok "Pakk nmap on paigaldatud"
else
  fail "Pakk nmap ei ole paigaldatud"
fi

# 10. Kontrolli, kas webmin on paigaldatud ja rpm-fail eemaldatud
if rpm -q webmin >/dev/null 2>&1; then
  ok "Pakk webmin on paigaldatud"
else
  fail "Pakk webmin ei ole paigaldatud"
fi
if [ ! -f "$STUDENT_HOME"/webmin*.rpm ]; then
  ok "Webmin installifail on eemaldatud"
else
  fail "Webmin installifail on alles"
fi

# 11. Kontrolli, kas ajalugu ja uptime on salvestatud
if [ -f "$STUDENT_HOME/alma.txt" ]; then
  if grep -q "history" "$STUDENT_HOME/alma.txt" && grep -q "load average" "$STUDENT_HOME/alma.txt"; then
    ok "Fail alma.txt sisaldab käsuajalugu ja uptime väljundit"
  else
    fail "Fail alma.txt ei sisalda käsuajalugu või uptime väljundit"
  fi
else
  fail "Fail alma.txt puudub"
fi

echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget tulemust."
