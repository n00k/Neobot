#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh index.html 'http://www.neopets.com/petpetpark/daily.phtml' 'http://www.neopets.com/petpetpark/celebration.phtml' || exit -1

geturl 'http://www.neopets.com/petpetpark/daily.phtml' referer="http://www.neopets.com/petpetpark/celebration.phtml" output=petpetpark.html post-data='go=1'

$GREP 'ppx_daily_message' petpetpark.html >>$statusfile

$RM -f index.html
$RM -f petpetpark.html
