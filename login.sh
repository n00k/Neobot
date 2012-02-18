#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
geturl  http://www.neopets.com output=index.html
[ $? = 0 ] || exit
$GREP -i "login" index.html
[ $? = 0 ] || exit
$SLEEP 5
geturl http://www.neopets.com/login/index.phtml output=login.html referer="http://www.neopets.com/" 
[ $? = 0 ] || exit
$SLEEP 15
geturl http://www.neopets.com/login.phtml referer="http://www.neopets.com/login/index.phtml" output=username.html "post-data=username=${username}&password=${password}"

$RM -f username.html
$RM -f login.html
$RM -f index.html
