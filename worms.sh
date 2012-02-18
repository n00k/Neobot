#!/usr/local/bin/zsh
cd `dirname $0`
exec > /dev/null

. ./functions.sh
echo "<!-- $0 -->" >> $statusfile
if [ -e "$statusdir" ]; then
	echo "statusdir is not defined!">&2
	exit
fi
if [ ! -d "$statusdir" ]; then
	mkdir -p "$statusdir"
	if [ ! -d "$statusdir" ]; then
		echo "statusdir does not exist">&2
		exit
	fi
fi

cleanup() {
	$RM -f lampwick.html
	$RM -f moltara.html 
	$RM -f moltaracaves.html 
	exit $1
}

if [ "$1" = "clearstats" ]; then
	$DATE >&2
	echo "Clearing Stats" >&2
	$RM -f "$statusdir/material.html"
	$RM -f "$statusdir/scrap.date"
	if [ -e "$statusdir/alldone" -o -e "$statusdir/wormsdone" ]; then
		$RM -f "$statusdir/lantern.date" "$statusdir/wormsdone" "$statusdir/alldone" "$statusdir/worm"*".html"
	fi
	cleanup
fi
 
[ -e "$statusdir/alldone" ] && cleanup 

getmaterial() {
	fname=$1
	eurl=`$GREP -i material_url "$fname" | head -n1 | sed "s/.*'material_url[^']*'[^']*'\([^']*\)'.*/\1/"`
	url="http://www.neopets.com`perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' "$eurl"`"
	geturl "$url" referer="http://www.neopets.com/magma/index.phtml" output="$statusdir/material.html"
	echo "Got Miscellaneous Gears" >> $statusfile
}

getworms() {
	fname=$1
	$GREP -i "'worm[0-9]\{1,2\}'" $fname | while read wrm; do
		worm=`echo $wrm | sed 's/.*\(worm[0-9]\{1,2\}\).*/\1/'`
		eurl=`echo $wrm | sed "s/.*'worm[0-9]\{1,2\}'[^']*'\([^']*\)'.*/\1/"`
		url="http://www.neopets.com`perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' "$eurl"`"
		echo "${worm}: $url" >> $statusfile
		if [ "$1" = "moltara.html" ]; then
          	refer="index.phtml"
		else
			refer="moltaracaves.phtml"
		fi
		geturl "$url" referer="http://www.neopets.com/magma/$refer" output="$statusdir/${worm}.html"
		$GREP "What a neat looking worm.  Too bad you have nowhere to put it" "$statusdir/${worm}.html" &>/dev/null && $RM -f "$statusdir/${worm}.html"
	done
}

checklinks() {
	fname=$1
	$GREP -i 'scrap metal' $1 &>/dev/null  && $DATE >> $statusdir/scrap.date && echo "Got Scrap Metal" >> $statusfile
	$GREP -i 'material_url' $1 &>/dev/null && getmaterial $fname 
	[ ! "$skipworms" = "yes" ] && $GREP -i "worm[1-9]" $1 &>/dev/null && getworms $fname
}

./checklogin.sh lampwick.html 'http://www.neopets.com/objects.phtml?type=shop&obj_type=110' http://www.neopets.com/objects.phtml || cleanup -1

$GREP -i 'worms broke out' lampwick.html &>/dev/null && date > $statusdir/lantern.date
if [ -e "$statusdir/wormsdone" ]; then
	skipworms="yes"
fi

wdone=`$GREP -l "You found a worm!  You pick it up and take it with you." $statusdir/worm* | wc -l`
if [ $wdone -eq 10 ]; then
	[ "$skipworms" == "yes" ] || echo "Got all 10 worms" >> $statusfile
	geturl "http://www.neopets.com/objects.phtml?type=inventory" output=lampwick.html referer="http://www.neopets.com/objects.phtml"
	lanid=`$SED -n -e "s/.*openwin(\([^)]*\))[^(]*This lantern does not even have a light source inside. How utterly useless.*/\1/p" lampwick.html`
	geturl "http://www.neopets.com/iteminfo.phtml?obj_id=$lanid" output=lampwick.html referer="http://www.neopets.com/objects.phtml"
	geturl "http://www.neopets.com/useobject.phtml?obj_id=$lanid&action=worms" output=lampwick.html referer="http://www.neopets.com/iteminfo.phtml"
	geturl "http://www.neopets.com/useobject.phtml?obj_id=$lanid&action=worms" output=lampwick.html referer="http://www.neopets.com/iteminfo.phtml"
	geturl "http://www.neopets.com/magma/darkcave.phtml" output=lampwick.html referer="http://www.neopets.com/magma/caves.phtml"
	turns=("At least it's not" 2 1 2 1 "Does it smell like" 2 1 1 1 "Hello?  Is there anyone" 1 1 2 2 "I hope I can" 2 1 1 2 "I hope there's no" 1 2 2 2 "I should have studied" 2 2 2 1 "I sure wish Roxton" 2 2 1 1 "I wonder where this" 1 1 1 2 "It's very hot in" 1 1 2 1 "Jordie would know what" 1 2 1 2 "Let's go spelunking" 2 2 2 2 "Look at the shiny" 1 2 2 1 "This lantern is bright" 2 1 2 2 "What a mysterious passage" 1 1 1 1 "Where does this cave" 1 2 1 1 "Which way should we" 2 2 1 2 )
	i=1;
	found=0;
	while [ $i -lt ${#turns[*]} -a $found -eq 0 ]; do
		if $GREP "${turns[$i]}" lampwick.html &>/dev/null; then
			echo "${turns[$i]}" >>$statusfile
			geturl "http://www.neopets.com/magma/darkcave.phtml" output=lampwick.html post-data="dir=${turns[$(($i+1))]}" referer="http://www.neopets.com/magma/darkcave.phtml"
			geturl "http://www.neopets.com/magma/darkcave.phtml" output=lampwick.html post-data="dir=${turns[$(($i+2))]}" referer="http://www.neopets.com/magma/darkcave.phtml"
			geturl "http://www.neopets.com/magma/darkcave.phtml" output=lampwick.html post-data="dir=${turns[$(($i+3))]}" referer="http://www.neopets.com/magma/darkcave.phtml"
			geturl "http://www.neopets.com/magma/darkcave.phtml" output=lampwick.html post-data="dir=${turns[$(($i+4))]}" referer="http://www.neopets.com/magma/darkcave.phtml"
			geturl "http://www.neopets.com/magma/darkcave.phtml" output=lampwick.html post-data="collect=1" referer="http://www.neopets.com/magma/darkcave.phtml"
			if $GREP -i 'moltite' lampwick.html &>/dev/null; then 
				found=1;
				$DATE >> "$statusdir/wormsdone"
			fi
		else 
			i=$(($i + 5))
		fi
	done
	$RM -f "$statusdir/worm[1-9]*.html"
	$WGET -nv --referer="http://www.neopets.com/objects.phtml" --load-cookies $cookiefile --save-cookies $cookiefile --keep-session-cookies -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13" "http://www.neopets.com/objects.phtml?type=shop&obj_type=110" -O lampwick.html
fi
if [ -e  "$statusdir/wormsdone" -a -e "$statusdir/material.html" -a -e "$statusdir/scrap.date" ]; then
	$DATE > "$statusdir/alldone"
	echo "Worms All Done for Today." >> $statusfile
	cleanup
fi

geturl http://www.neopets.com/magma/index.phtml output=moltara.html referer="http://www.neopets.com/explore.phtml" 

checklinks moltara.html

[ -e "$statusdir/wormsdone" ] && cleanup

geturl http://www.neopets.com/magma/caves.phtml output=moltaracaves.html referer="http://www.neopets.com/magma/index.phtml"

checklinks moltaracaves.html

cleanup

