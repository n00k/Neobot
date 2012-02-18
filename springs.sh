#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh index.html 'http://www.neopets.com/faerieland/springs.phtml' 'http://www.neopets.com/faerieland/index.phtml' || exit -1

geturl http://www.neopets.com/faerieland/springs.phtml referer="http://www.neopets.com/faerieland/springs.phtml" output=springs.html post-data='type=heal'

$GREP 'Leave the Healing Springs' springs.html >>$statusfile

$RM -f index.html
$RM -f springs.html
