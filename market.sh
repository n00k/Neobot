#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh index.html http://www.neopets.com/stockmarket.phtml http://www.neopets/games/favorites.phtml || exit -1

geturl 'http://www.neopets.com/stockmarket.phtml?type=buy' referer="http://www.neopets.com/stockmarket.phtml" output=/dev/null
[ $? = 0 ] || exit
geturl 'http://www.neopets.com/stockmarket.phtml?type=list&full=true' referer="http://www.neopets.com/stockmarket.phtml?type=buy" output=market.html
#./parsemarket.rb
./portfolio.sh >> $statusfile

$RM -f index.html
$RM -f market.html
