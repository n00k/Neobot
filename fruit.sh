#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh index.html 'http://www.neopets.com/desert/fruitmachine.phtml' 'http://www.neopets.com/desert/index.phtml' || exit -1

geturl http://www.neopets.com/desert/fruitmachine2.phtml referer="http://www.neopets.com/desert/fruitmachine.phtml" output=fruit.html post-file=blankpost

$GREP -i -A2 '<b>The Neopets Fruit Machine' fruit.html >> $statusfile

$RM -f index.html
$RM -f fruit.html
