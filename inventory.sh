#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile
$DATE >&2
./checklogin.sh inventory.html 'http://www.neopets.com/objects.phtml?type=inventory' 'http://www.neopets.com/objects.phtml' || exit -1

parseinput() {
	pfile="$1"
	amp=""
	while read lin; do
		itype=`echo $lin | $SED -n -e 's/.*type=['"'"'"]\([^'"'"'"]*\).*$/\1/p'`
		iname=`echo $lin | $SED -n -e 's/.*name=['"'"'"]\([^'"'"'"]*\).*$/\1/p'`
		ivalue=`echo $lin | $SED -n -e 's/.*value=['"'"'"]\([^'"'"'"]*\).*$/\1/p'`
		if [ -n "$itype" -a -n "$iname" -a -n "$ivalue" ]; then
			if [ "${itype:l}" = "hidden" ]; then
				echo -n "${amp}${iname}=${ivalue}" >> "$pfile"
				amp="&"
			else 
				if [ "${itype:l}" = "radio" -a "${ivalue:l}" = "deposit" ]; then
					echo -n "${amp}${iname}=${ivalue}" >> "$pfile"
					amp="&"
				fi
			fi
		fi
	done
	echo $pfile
}

geturl "http://www.neopets.com/quickstock.phtml" referer="http://www.neopets.com/objects.phtml" output=inventory.html
:>"$invpostfile"
$SED -n -e '/<form name=.quickstock/I,/<\/form/I{s/>/&\/g;p;}' inventory.html | $TR "" "\n" | $GREP -i "^<input" | parseinput "$invpostfile"

[ -s "$invpostfile" ] && geturl "http://www.neopets.com/process_quickstock.phtml "post-file="${postfile}"
$WGET -nv --referer="http://www.neopets.com/quickstock.phtml" --load-cookies $cookiefile --save-cookies $cookiefile --keep-session-cookies --post-file="${postfile}" -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13"  "http://www.neopets.com/process_quickstock.phtml" -O inventory.html

$RM -f inventory.html
