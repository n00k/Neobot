#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile
./checklogin.sh index.html http://www.neopets.com/explore.phtml http://www.neopets.com/games/favorites.phtml || exit -1

[ -n "$snowagerpet" ] && selectpet $snowagerpet
geturl http://www.neopets.com/winter/index.phtml referer="http://www.neopets/explore.phtml" output=/dev/null
[ $? = 0 ] || exit
geturl 'http://www.neopets.com/winter/icecaves.phtml' referer="http://www.neopets.com/winter/index.phtml" output=/dev/null
geturl 'http://www.neopets.com/winter/snowager.phtml' referer="http://www.neopets.com/winter/icecaves.phtml" output=snowager.html
$GREP "The Snowager is currently sleeping..." snowager.html > /dev/null 2>/dev/null
#[ $? = 0 ] || exit
geturl 'http://www.neopets.com/winter/snowager2.phtml' referer="http://www.neopets.com/winter/snowager.phtml" output=snowager2.html
$GREP -A2 "<b>The Snowager</b>" snowager2.html | tail -n1 >> $statusfile

$RM -f snowager2.html
$RM -f snowager.html
$RM -f index.html
