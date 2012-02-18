#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh index.html 'http://www.neopets.com/jelly/jelly.phtml' 'http://www.neopets.com/jelly/jelly.phtml' || exit -1

geturl http://www.neopets.com/jelly/jelly.phtml referer="http://www.neopets.com/jelly/jelly.phtml" output=jelly.html post-data='type=get_jelly'

$GREP -i 'you take some' jelly.html >>$statusfile

$RM -f jelly.html
$RM -f index.html
