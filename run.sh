#!/usr/bin/env sh

cd "$(dirname "$0")" || exit 1

# Hourly backup to git (only if an 'origin' remote is configured)
backup_loop() {
    while true; do
        sleep 3600
        git remote get-url origin >/dev/null 2>&1 || continue
        echo "Backup to github started!!!"
        git add .
        git commit -m "routine backup"
        git push
        echo "Backup complete!"
    done
}

backup_loop &
BACKUP_PID=$!
trap 'kill "$BACKUP_PID" 2>/dev/null' EXIT

mkdir -p worlds

while true; do
    ./TerrariaServer -config serverconfig.txt
    [ $? -eq 0 ] && break
    echo "TerrariaServer exited with code $? — restarting..."
    sleep 1
done
