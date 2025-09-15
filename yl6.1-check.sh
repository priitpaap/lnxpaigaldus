#!/bin/bash
# yl6.1-check.sh - kontrollib õppija tegevusi Debian ülesandes 6.1
# Käivita root kasutajana (nt sudo ./yl6.1-check.sh)

STUDENT_HOME="/home/student"
TOTAL=0
SCORE=0

ok()  { echo "✅ $1"; SCORE=$((SCORE+1)); TOTAL=$((TOTAL+1)); }
fail(){ echo "❌ $1"; TOTAL=$((TOTAL+1)); }

echo ">>> Alustan kontrolli..."

# 1. hostnamectl väljund k2sud.txt alguses
if [ -f "$STUDENT_HOME/k2sud.txt" ]; then
  if grep -q "Linux" "$STUDENT_HOME/k2sud.txt"; then
    ok "Fail k2sud.txt sisaldab hostnamectl väljundit"
  else
    fail "Fail k2sud.txt ei sisalda hostnamectl väljundit"
  fi
else
  fail "Fail k2sud.txt puudub"
fi

# 2. abiline.txt – peab sisaldama kõigi peidetud failide nimesid
if [ -f "$STUDENT_HOME/abiline.txt" ]; then
  FILES=(
    "/etc/logcontrol.conf"
    "/etc/local/system.conf"
    "/etc/uboot.conf"
    "/etc/X81/notaguifile.conf"
  )
  ALL_FOUND=true
  for f in "${FILES[@]}"; do
    if ! grep -q "$f" "$STUDENT_HOME/abiline.txt"; then
      ALL_FOUND=false
    fi
  done
  if $ALL_FOUND; then
    ok "Fail abiline.txt sisaldab kõiki /etc kauta faile, kus leidub sõna 'abiline'"
  else
    fail "Fail abiline.txt ei sisalda kõiki vajalikke ridu"
  fi
else
  fail "Fail abiline.txt puudub"
fi

# 3. failed.txt – syslogi read peavad sisaldama 'Failed' ja 'isc-dhcp-server'
if [ -f "$STUDENT_HOME/failed.txt" ]; then
  if grep -qi "Failed" "$STUDENT_HOME/failed.txt" && grep -qi "isc-dhcp-server" "$STUDENT_HOME/failed.txt"; then
    ok "Fail failed.txt sisaldab 'Failed' ridu isc-dhcp-server teenuse kohta"
  else
    fail "Fail failed.txt ei sisalda piisavalt õigeid ridu)"
  fi
else
  fail "Fail failed.txt puudub"
fi

# 4. ss.txt – peab sisaldama ainult ssh ridu, mitte kogu ss väljundit
if [ -f "$STUDENT_HOME/ss.txt" ]; then
  if grep -q "ssh" "$STUDENT_HOME/ss.txt"; then
    if grep -q "Port" "$STUDENT_HOME/ss.txt"; then
      fail "Fail ss.txt sisaldab vaid filtreerimata ss käsu tulemust"
    else
      ok "Fail ss.txt sisaldab ainult filtreeritud ssh ridu"
    fi
  else
    fail "Fail ss.txt ei sisalda ssh ridu"
  fi
else
  fail "Fail ss.txt puudub"
fi

# 5. peeter.txt – peab sisaldama kõiki peetrile kuuluvaid faile
if [ -f "$STUDENT_HOME/peeter.txt" ]; then
  FILES=(
    "/usr/local/games/xml_file.txt"
    "/usr/local/share/log/log1.log"
    "/usr/local/secure/secure.conf"
  )
  ALL_FOUND=true
  for f in "${FILES[@]}"; do
    if ! grep -q "$f" "$STUDENT_HOME/peeter.txt"; then
      ALL_FOUND=false
    fi
  done
  if $ALL_FOUND; then
    ok "Fail peeter.txt sisaldab kõiki peetrile kuuluvaid faile"
  else
    fail "Fail peeter.txt ei sisalda kõiki vajalikke ridu"
  fi
else
  fail "Fail peeter.txt puudub"
fi

# 6. pille.txt – peab sisaldama kõiki pille kasutajale kuuluvaid kaustu
if [ -f "$STUDENT_HOME/pille.txt" ]; then
  DIRS=(
    "/usr/kst"
    "/usr/local/share/itune"
    "/usr/local/books"
  )
  ALL_FOUND=true
  for d in "${DIRS[@]}"; do
    if ! grep -q "$d" "$STUDENT_HOME/pille.txt"; then
      ALL_FOUND=false
    fi
  done
  if $ALL_FOUND; then
    ok "Fail pille.txt sisaldab kõiki pille kasutajale kuuluvaid kaustu"
  else
    fail "Fail pille.txt ei sisalda kõiki vajalikke katalooge"
  fi
else
  fail "Fail pille.txt puudub"
fi

# 7. logid.txt – peab sisaldama setupis vanaks tehtud 5 faili
if [ -f "$STUDENT_HOME/logid.txt" ]; then
  FILES=(
    "/var/logbackup/file1.log"
    "/var/logbackup/file20.log"
    "/var/logbackup/file40.log"
    "/var/logbackup/file60.log"
    "/var/logbackup/file80.log"
  )
  ALL_FOUND=true
  for f in "${FILES[@]}"; do
    if ! grep -q "$f" "$STUDENT_HOME/logid.txt"; then
      ALL_FOUND=false
    fi
  done
  if $ALL_FOUND; then
    ok "Fail logid.txt sisaldab kõiki vanemaid logifaile"
  else
    fail "Fail logid.txt ei sisalda kõiki vajalikke ridu"
  fi
else
  fail "Fail logid.txt puudub"
fi

# 8. ssh.txt – peab sisaldama ssh_config faili asukohti
if [ -f "$STUDENT_HOME/ssh.txt" ]; then
  FILES=(
    "/etc/ssh/ssh_config"
    "/etc/ssh/ssh_config.d"
  )
  ALL_FOUND=true
  for f in "${FILES[@]}"; do
    if ! grep -q "$f" "$STUDENT_HOME/ssh.txt"; then
      ALL_FOUND=false
    fi
  done
  if $ALL_FOUND; then
    ok "Fail ssh.txt sisaldab kõiki ssh_config faili asukohti"
  else
    fail "Fail ssh.txt ei sisalda kõiki ssh_config faili asukohti"
  fi
else
  fail "Fail ssh.txt puudub"
fi

# 9. alias list olemas ja püsiv
if grep -q "alias[[:space:]]\+list" "$STUDENT_HOME/.bashrc" && grep -q "ls -lah" "$STUDENT_HOME/.bashrc"; then
  ok "Alias 'list' on kirjas .bashrc failis ja viitab õigele käsule"
else
  fail "Alias 'list' puudub või ei vasta õigele ls käsule"
fi

# 10. alias vlo olemas ja püsiv
if grep -q "alias[[:space:]]\+vlo" "$STUDENT_HOME/.bashrc" && grep -q "cd /var/log" "$STUDENT_HOME/.bashrc"; then
  ok "Alias 'vlo' on kirjas .bashrc failis ja viitab õigele käsule"
else
  fail "Alias 'vlo' puudub või ei vasta õigele käsule"
fi

# 11. cowsay paigaldatud
if dpkg -s cowsay >/dev/null 2>&1; then
  ok "Pakk cowsay on paigaldatud"
else
  fail "Pakk cowsay ei ole paigaldatud"
fi

# 12. .bashrc sisaldab cowsay tervitust
if grep -q "cowsay" "$STUDENT_HOME/.bashrc"; then
  ok ".bashrc sisaldab cowsay tervitust"
else
  fail ".bashrc ei sisalda cowsay tervitust"
fi

# 13. PATH sisaldab /srv/programmid
if grep -q "/srv/programmid" "$STUDENT_HOME/.bashrc" 2>/dev/null || \
   grep -q "/srv/programmid" "$STUDENT_HOME/.bash_profile" 2>/dev/null; then
  ok "PATH on laiendatud /srv/programmid kataloogiga (.bashrc või .bash_profile)"
else
  fail "PATH ei ole laiendatud /srv/programmid kataloogiga"
fi

# 14. uptime lisatud k2sud.txt
if [ -f "$STUDENT_HOME/k2sud.txt" ]; then
  if grep -q "load average" "$STUDENT_HOME/k2sud.txt" ; then
    ok "Fail k2sud.txt sisaldab uptime väljundit"
  else
    fail "Fail k2sud.txt ei sisalda uptime väljundit"
  fi
fi

echo ">>> Kontroll valmis."
echo "Tulemused: $SCORE / $TOTAL õiget tulemust."
