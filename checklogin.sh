#!/usr/local/bin/zsh
outfile="$1"
url="$2"
referer="$2"

. ./functions.sh

geturl "$url" referer="$referer" output="$outfile"
$GREP -i login "$outfile"
if [ $? = 0 ]; then
	./login.sh
	geturl "$url" referer="$referer" output="$outfile"
	$GREP -i login "$outfile"
	if [ $? = 0 ]; then
		echo "Login Failed" >&2
		exit -1
	fi
fi

