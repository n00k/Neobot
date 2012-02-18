#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh index.html 'http://www.neopets.com/prehistoric/omelette.phtml' 'http://www.neopets.com/prehistoric/plateau.phtml' || exit -1

geturl http://www.neopets.com/prehistoric/omelette.phtml referer="http://www.neopets.com/prehistoric/omelette.phtml" output=omelette.html post-data='type=get_omelette'

$GREP -i 'a slice' omelette.html >> $statusfile

$RM -f omelette.html
$RM -f index.html
