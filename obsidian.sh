#!/usr/local/bin/zsh
cd `dirname $0`
. ./functions.sh
exec > /dev/null
echo "<!-- $0 -->" >> $statusfile

./checklogin.sh obsidian.html 'http://www.neopets.com/magma/quarry.phtml' 'http://www.neopets.com/magma/index.phtml' || exit -1
$GREP "Back to Moltara" obsidian.html >> $statusfile

$RM -f obsidian.html
