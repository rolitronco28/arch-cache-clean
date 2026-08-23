#!/bin/bash
# CACHE & TEMPORARY FILES CLEAN SCRIPT - ADAPTED TO ARCH LINUX


# root privileges
if [ "$EUID" -ne 0 ]; then
	echo "* Run this script as root! (sudo)"
	exit 1
fi

echo "* Cleaning pacman cache & unnecesary packages..."
if command -v pacman &> /dev/null; then
	pacman -Sc --noconfirm

	sleep 1
	
	pacman -Rns $(pacman -Qtdq 2>/dev/null) --noconfirm
fi

sleep 3

echo "* Cleaning temporary files..."
find /tmp -type f -mtime +7 -delete 2>/dev/null
find /var/tmp -type f -mtime +7 -delete 2>/dev/null

sleep 3

echo "* Cleaning Journal Logs..."
journalctl --rotate
journalctl --vacuum-time=1s

sleep 3

# Clean user_home cache
echo "* Cleaning $HOME/.cache/ directory..."
for user_home in /home/*; do
	if [ -d "$user_home/.cache" ]; then
		user_name=$(basename "$user_home")
		echo "	* Cleaning cache for $user_name"

		rm -rf "$user_home/.cache/"* 2>/dev/null
	fi
done


