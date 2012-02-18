. ./config.sh
exec 2>>errors.log
geturl() {
	#geturl url=<url> referer=<referer> post-data=<data> post-file=<filename> output=<filename>
	valid=""
	url=""
	postdata=""
	referer=""
	output=""
	while [ $# -gt 0 ]; do
		argtype=`echo "$1" | $CUT -d= -f1 2>/dev/null`
		argdata=`echo "$1" | $CUT -d= -f2 2>/dev/null`
		#echo "Valid:$valid - Argtype:$argtype($1)"
		case $argtype in
			"url")
				if [ -n "${url}" ]; then
					echo "Error retrieving URL $url/$1"
					valid="nope"
				fi
				url=$argdata ;;
			"referer")
				referer=$argdata ;;
			"post-data")
				if [ -n "${postdata}" ]; then
					echo "Error retrieving URL: post-data and post-file are mutually exclusive" >&2
					valid="nope"
				fi
				postdata="--$1";;
			"post-file")
				if [ -n "${postdata}" ]; then
					echo "Error retrieving URL: post-data and post-file are mutually exclusive" >&2
					valid="nope"
				fi 
				postdata="--$1" ;;
			"output")
				output=$argdata ;;
			*)
				if [ -n "$url" ]; then
					echo "Error retrieving URL: unknown option $1" >&2
					valid="nope"
				fi
				url=$1 ;;
		esac
		shift 1
	done
	if [ "$valid" != "nope" ]; then
		[ -z "$referer" ] && referer="$url"
		[ -z "$output" ] && output="-"
		$WGET --referer="$referer" --load-cookies $cookiefile --save-cookies $cookiefile --keep-session-cookies -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13" $postdata "$url" -O $output > /dev/null 2>/dev/null
	fi
}

selectpet() {
	geturl 'http://www.neopets.com/process_changepet.phtml?new_active_pet='"$1" output=/dev/null referer="http://www.neopets.com/quickref.phtml"
}

echo "Content-Type: application/x-www-form-urlencoded" > blankpost
echo "Content-Length: 0" >> blankpost
