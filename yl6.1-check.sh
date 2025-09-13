#!/bin/bash
# yl6.1-check.sh - kontrollib õppija tegevusi Debian ülesandes 6.1
# Käivita root kasutajana (nt sudo ./yl6.1-check.sh)

STUDENT_HOME="/home/student"
TOTAL=0
SCORE=0

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }

echo ">>> Alustan kontrolli..."

# 4. hostnamectl väljund k2sud.txt alguses
if [ -f "$STUDENT_HOME/k2sud.txt" ]; then
  if head -n1 "$STUDENT_HOME/k2sud.txt" | grep -q "Linux"; then
    ok "Fail k2sud.txt algab hostnamectl väljundiga"
  else
    fail "Fail k2sud.txt ei sisalda hostnamectl väljundit alguses"
  fi
else
  fail "Fail k2sud.txt puudub"
fi

# 5. abiline.txt – peab sisaldama ainult /etc failide nimesid kus sõna abiline
if [ -f "$STUDENT_HOME/abiline.txt" ]; then
  if grep -qi "abiline" "$STUDENT_HOME/abiline.txt"; then
    ok "Fail abiline.txt sisaldab sõnaga 'abiline' leitud ridu"
  else
    fail "Fail abiline.txt ei sisalda sõnaga 'abiline' ridu"
  fi
else
  fail "Fail abiline.txt puudub"
fi

# 6. peeter.txt – peab sisaldama /usr/local alt peetrile kuuluvaid faile
if [ -f "$STUDENT_HOME/peeter.txt" ]; then
  if grep -q "/usr/local/peeter_files" "$STUDENT_HOME/peeter.txt"; then
    ok "Fail peeter.txt sisaldab peetri failide nimesid"
  else
    fail "Fail peeter.txt ei sisalda peetri faile"
  fi
else
  fail "Fail peeter.txt puudub"
fi

# 7. logid.txt – peab sisaldama 5 vana faili
if [ -f "$STUDENT_HOME/logid.txt" ]; then
  COUNT=$(wc -l < "$STUDENT_HOME/logid.txt")
  if [ "$COUNT" -ge 5 ]; then
    ok "Fail logid.txt sisaldab vähemalt 5 vana faili"
  else
    fail "Fail logid.txt sisaldab liiga vähe ridu ($COUNT)"
  fi
else
  fail "Fail logid.txt puudub"
fi

# 9. ssh.txt – peab sisaldama ssh_config faili asukohta
if [ -f "$STUDENT_HOME/ssh.txt" ]; then
  if grep -q "ssh_config" "$STUDENT_HOME/ssh.txt"; then
    ok "Fail ssh.txt sisaldab ssh_config faili asukohta"
  else
    fail "Fail ssh.txt ei sisalda ssh_config asukohta"
  fi
else
  fail "Fail ssh.txt puudub"
fi

# 10. alias list püsiv
if su - student -c "alias list" >/dev/null 2>&1; then
  if su - student -c "alias list" | grep -q "ls -la"; then
    ok "Alias 'list' on määratud ja püsiv"
  else
    fail "Alias 'list' ei ole õigesti määratud"
  fi
else
  fail "Alias 'list' puudub"
fi

# 11. alias vlo püsiv
if su - student -c "alias vlo" >/dev/null 2>&1; then
  if su - student -c "alias vlo" | grep -q "cd /var/log"; then
    ok "Alias 'vlo' on määratud ja püsiv"
  else
    fail "Alias 'vlo' ei ole õigesti määratud"
  fi
else
  fail "Alias 'vlo' puudub"
fi

# 12. cowsay paigaldatud
if dpkg -s cowsay >/dev/null 2>&1; then
  ok "Pakk cowsay on paigaldatud"
else
  fail "Pakk cowsay ei ole paigaldatud"
fi

# 13. .bashrc sisaldab cowsay tervitust
if grep -q "cowsay" "$STUDENT_HOME/.bashrc"; then
  ok ".bashrc sisaldab cowsay tervitust"
else
  fail ".bashrc ei sisalda cowsay tervitust"
fi

# 14. PATH sisaldab /var/programmid
if su - student -c "echo \$PATH" | grep -q "/var/programmid"; then
  ok "PATH sisaldab kataloogi /var/programmid"
else
  fail "PATH ei sisalda kataloogi /var/programmid"
fi

# 15. uptime lisatud k2sud.txt lõppu
if [ -f "$STUDENT_HOME/k2sud.txt" ]; then
  if tail -n1 "$STUDENT_HOME/k2sud.txt" | grep -q "load average"; then
    ok "Fail k2sud.txt lõpeb uptime väljundiga"
  else
    fail "Fail k2sud.txt ei sisalda uptime väljundit lõpus"
  fi
fi

# 17. failed.txt – syslogi read sõnaga Failed
if [ -f "$STUDENT_HOME/failed.txt" ]; then
  if grep -qi "Failed" "$STUDENT_HOME/failed.txt"; then
    ok "Fail failed.txt sisaldab logiridu sõnaga 'Failed'"
  else
    fail "Fail failed.txt ei sisalda sõna 'Failed'"
  fi
else
  fail "Fail failed.txt puudub"
fi

# lisa kontrollid: ss.txt, pille.txt, big.txt, suured.txt
for f in ss.txt pille.txt big.txt suured.txt; do
  if [ -f "$STUDENT_HOME/$f" ]; then
    ok "Fail $f on olemas"
  else
    fail "Fail $f puudub"
  fi
done

echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget tulemust."
