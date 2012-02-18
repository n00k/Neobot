#!/usr/local/bin/zsh
cd `dirname $0`
exec > /dev/null
. ./functions.sh
$DATE >&2
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh altador.html 'http://www.neopets.com/altador/council.phtml' 'http://www.neopets.com/explore.phtml' || exit -1

#each page visit gets a pseudo-unique code
code=`$SED -n -e 's/.*altador\/council\.phtml\?prhv=\([a-zA-Z0-9]*\).*/\1/p' altador.html`
if [ -z "$code" ]; then
	echo "Error getting prhv code" >&2
	exit -1
fi
geturl "http://www.neopets.com/altador/council.phtml?prhv=$code" referer="http://www.neopets.com/altador/council.phtml" output=altador.html 

geturl "http://www.neopets.com/altador/council.phtml" referer="http://www.neopets.com/altador/council.phtml?prhv=$code" output=altador.html post-data="prhv=$code&collect=1"

$GREP 'King Altador hands you your gift...' altador.html >> $statusfile

$RM -f altador.html
