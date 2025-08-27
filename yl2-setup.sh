#!/bin/bash
# setup.sh - ettevalmistus Linuxi käsurea kasutajate halduse harjutuseks
# Käivita root kasutajana (nt sudo ./setup.sh)

set -e

MARKER="[SETUP]"
echo ">>> Alustan kasutajate halduse harjutuse ettevalmistust..."

# --- 1. Loo olemasolevad grupid ---
for grp in raamatupidajad ajutine; do
    if ! getent group "$grp" >/dev/null; then
        groupadd "$grp"
        echo "Loodi grupp: $grp"
    else
        echo "Grupp $grp juba olemas"
    fi
done

# --- 2. Loo olemasolevad kasutajad ---
declare -A EXIST_USERS
EXIST_USERS=( ["pille"]="raamatupidajad" ["kalmer"]="" ["sektetar"]="" )

for user in "${!EXIST_USERS[@]}"; do
    if ! id "$user" >/dev/null 2>&1; then
        useradd -m -s /bin/bash "$user"
        echo "$user:Passw0rd" | chpasswd
        # Lisa kasutaja esmase grupi, kui määratud
        if [ -n "${EXIST_USERS[$user]}" ]; then
            usermod -aG "${EXIST_USERS[$user]}" "$user"
        fi
        echo "Loodi kasutaja: $user"
    else
        echo "Kasutaja $user juba olemas"
    fi
done

# --- 3. Loo sekretäri kodukausta failid ---
SEC_HOME="/home/sektetar"
mkdir -p "$SEC_HOME"

# 50 faili, vähemalt 4 erinevat laiendit (.txt, .log, .conf, .dat)
for i in {1..13}; do echo "$MARKER sekretäri .txt fail $i" > "$SEC_HOME/file$i.txt"; done
for i in {1..13}; do echo "$MARKER sekretäri .log fail $i" > "$SEC_HOME/file$i.log"; done
for i in {1..12}; do echo "$MARKER sekretäri .conf fail $i" > "$SEC_HOME/file$i.conf"; done
for i in {1..12}; do echo "$MARKER sekretäri .dat fail $i" > "$SEC_HOME/file$i.dat"; done

# --- 4. Loo markerfailid kasutajate kodukaustades ---
for user in "${!EXIST_USERS[@]}"; do
    USER_HOME=$(eval echo "~$user")
    echo "$MARKER Testfail kasutajale $user" > "$USER_HOME/kasutajad.txt"
done

echo ">>> Ettevalmistus tehtud! Saad nüüd õppija ülesannet täita."
