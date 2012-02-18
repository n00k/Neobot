#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh shrine.html 'http://www.neopets.com/desert/shrine.phtml' 'http://www.neopets.com/desert/index.phtml' || exit -1

[ -n "$coltzanpet" ] && selectpet $coltzanpet

geturl http://www.neopets.com/desert/shrine.phtml referer="http://www.neopets.com/desert/index.phtml" output=shrine.html
geturl http://www.neopets.com/desert/shrine.phtml referer="http://www.neopets.com/desert/shrine.phtml" output=shrine.html post-data="type=approach"

$GREP "Back to the" shrine.html >> $statusfile

$RM -f shrine.html
