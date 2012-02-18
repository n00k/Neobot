#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile
./checklogin.sh bank.html http://www.neopets.com/bank.phtml http://www.neopets.com/objects.phtml || exit -1

$GREP "Collect Interest ([0-9,]* NP)" bank.html > /dev/null 2>/dev/null

if [ $? = 0 ]; then    
	geturl post-data='type=interest' referer="http://www.neopets.com/bank.phtml" output=pbank.html http://www.neopets.com/process_bank.phtml
fi

np=`$SED -n -e "s/.*<a id='npanchor'[^>]*>\([^<]*\).*/\1/p" bank.html | $TR -C -d "0-9"`

#if carrying more that 50k neopoint, deposit all but 15k
if [ $np -gt 50000 ]; then
	geturl http://www.neopets.com/process_bank.phtml post-data="type=deposit&amount=$(($np - 15000))" referer="http://www.neopets.com/bank.phtml" output=bank.html
fi

#if carrying less than 15k withdraw up to 15k
np=`$SED -n -e "s/.*<a id='npanchor'[^>]*>\([^<]*\).*/\1/p" bank.html | $TR -C -d "0-9"`

if [ $np -lt 15000 ]; then
	geturl http://www.neopets.com/process_bank.phtml "post-data=type=withdraw&amount=15000"referer="http://www.neopets.com/bank.phtml" output=bank.html
fi

$RM -f bank.html
$RM -f pbank.html
