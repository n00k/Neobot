#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh index.html http://www.neopets.com/games/favorites.phtml http://www.neopets.com || exit -1

geturl http://www.neopets.com/stockmarket.phtml referer="http://www.neopets/games/favorites.phtml" output=/dev/null
[ $? = 0 ] || exit

geturl 'http://www.neopets.com/stockmarket.phtml?type=portfolio' referer="http://www.neopets.com/stockmarket.phtml" output=portfolio.html
#using ruby to parse portfolio.html and sell stock
./parseportfolio.rb >> $statusfile

$RM -f portfolio.html
$RM -f index.html
