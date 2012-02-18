#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

function fish()
{
	echo $1 >> $statusfile
	geturl http://www.neopets.com/water/fishing.phtml referer="http://www.neopets.com/water/fishing.phtml" post-data='go_fish=1' output=temp.html
	$GREP -i reel temp.html 2>/dev/null >> $statusfile
	$RM -f temp.html
	geturl http://www.neopets.com/water/fishing.phtml referer="http://www.neopets.com/water/fishing.phtml" output=/dev/null
}

./checklogin.sh index.html http://www.neopets.com/explore.phtml http://www.neopets.com/games/favorites.phtml || exit -1

geturl http://www.neopets.com/water/index.phtml referer="http://www.neopets.com/explore.phtml" output=/dev/null
geturl http://www.neopets.com/water/index_ruins.phtml referer="http://www.neopets.com/water/index.phtml" output=/dev/null
geturl http://www.neopets.com/water/fishing.phtml referer="http://www.neopets.com/water/index_ruins.phtml" output=/dev/null

i=0
while [ $i -lt ${#fishpets[*]} ]; do
	i=$(($i + 1))
	selectpet ${fishpets[$i]}
	fish
done

$RM -f index.html
