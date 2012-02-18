#!/usr/local/bin/zsh
cd `dirname $0`
exec > /dev/null
. ./functions.sh
echo "<!-- $0 -->" >> $statusfile
$DATE >&2

./checklogin.sh shore.html http://www.neopets.com/pirates/forgottenshore.phtml http://www.neopets.com/pirates/index.phtml || exit -1

url=`$SED -n -e "/'shore_back'/N;s/.*shore_back.*href='\([^']*\)'.*$/\1/p" shore.html`

if [ -n $url ]; then
    geturl "http://www.neopets.com/pirates/forgottenshore.phtml$url" referer="http://www.neopets.com/pirates/forgottenshore.phtml" output=shore.html
	$SED -n -e "/id='shore_back'/,/<form action/p" shore.html >> $statusfile
fi

$RM -f shore.html
