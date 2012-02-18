#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0  -->" >> $statusfile

./checklogin.sh anchor.html 'http://www.neopets.com/pirates/anchormanagement.phtml' 'http://www.neopets.com/pirates/index.phtml' || exit -1

#each visit gets a different action value
action=` $GREP -A2 'form-fire-cannon' anchor.html | $SED -e 's/>/&\^M/g' | $GREP input | $SED -n -e 's/.*value=.\([a-zA-Z0-9]*\).*/\1/p'`

geturl http://www.neopets.com/pirates/anchormanagement.phtml referer="http://www.neopets.com/pirates/anchormanagement.phtml" output=anchor.html post-data="action=$action"

$GREP "[^\.]prize-item-name" anchor.html >>$statusfile

$RM -f anchor.html
