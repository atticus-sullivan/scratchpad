#!/bin/bash

# set -x

# get new titles so that the displayed titles match the real ones
updateTitle(){
	while read ele
	do
		wid="${ele%%+*}"
		echo -n "$wid+"
		xtitle "$wid"
	done
}


file="$HOME/.local/share/scratchpad"

pwd="$(dirname "$(readlink -f "${0}")")"

if [ $# = 0 ]; then
	cat <<EOF
Usage: $(basename "${0}") process_name [executable_name] [--take-first]
    process_name       As recognized by 'xdo' command
    executable_name    As used for launching from terminal
    --take-first       In case 'xdo' returns multiple process IDs
    --current          Add the current window to the scratchpad
    --show             Show one of the scratchpad windows
EOF
exit 0
fi

# Get id of process by class name and then fallback to instance name
id=$(xdo id -N "${1}" || xdo id -n "${1}")

executable=${1}
shift

while [ -n "${1}" ]; do
	case ${1} in
		--take-first)
			id=$(head -1 <<<"${id}" | cut -f1 -d' ')
			;;
		--current)
			id="$(xdo id)"
			[[ -z "$id" ]] && exit
			echo "$id" >> $file
			tmp="$(mktemp)"
			cp -f "$file" "$tmp"
			sort -u "$tmp" > "$file"
			;;
		--show)
			id=$(cat "$file" | updateTitle | dmenu -f -i -l 10)
			[[ -z "$id" ]] && exit
			id="${id%%+*}"
			sed -i '/'"$id"'/d' "$file"
			;;
		*)
			executable=${1}
			;;
	esac
	shift
done

# launch
if [ -z "${id}" ]; then
	echo $1
	case "$executable" in
		ddcalc)
			st -g90x25 -t "ddcalc" -c "ddcalc" -e lua5.4 ${pwd}/ddcalc.lua
			;;
		units)
			st -g90x25 -t "units" -c "units" -e units --verbose
			;;
		yubioath-desktop)
			yubioath-desktop
			;;
		*)
			${executable}
			;;
	esac
else
	while read -r instance; do
		# toggle flag
		bspc node "${instance}" --flag hidden --flag sticky --to-monitor focused --focus
	done <<<"${id}"
fi
