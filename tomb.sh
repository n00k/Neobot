#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh tomb.html http://www.neopets.com/worlds/geraptiku/tomb.phtml http://www.neopets.com/worlds/index_geraptiku.phtml || exit -1

[ -n "$tombpet" ] && selectpet $tombpet

geturl http://www.neopets.com/worlds/geraptiku/tomb.phtml referer="http://www.neopets.com/worlds/geraptiku/tomb.phtml" output=tomb.html post-data=opened=1

geturl http://www.neopets.com/worlds/geraptiku/process_tomb.phtml referer="http://www.neopets.com/worlds/geraptiku/tomb.phtml" post-file=blankpost output=tomb.html

$RM -f tomb.html

