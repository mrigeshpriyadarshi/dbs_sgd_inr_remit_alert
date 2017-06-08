#!/bin/bash
#
# Conversion check script for DBS
#
# Author: Mrigesh Priyadarshi


ruby_apps="ruby-cheerio rest-client terminal-notifier colorize"
epel_repo="http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm"


install_brew()
{
	if [[ ! -f $(which brew) ]]; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null
	fi
}


printUsage()
 {
	echo -e "FATAL: Either, Pass 2 arguments as,i.e., 'check_conversion {interval_period} {ceiling_amount}' "
	exit 1
 }


initialize()
{
	# APP_HOME="$( cd -P "$( dirname $0 )" && pwd )/.."
	RUBY=$(which ruby)

	case "$OSTYPE" in
		darwin*)
			APP_HOME="$(dirname $(dirname $(grealpath $0)))"
			;; 
		linux*)   
			APP_HOME="$(dirname $(dirname $(realpath $0)))"
			;;
	esac
}



execute()
{
	initialize
	watch --color --interval=${interval_period} ${RUBY} ${APP_HOME}/lib/conversion.rb --ceiling=${ceiling_amount}
}

### MAIN SCRIPT #####

if [[ $# == 2 ]]; then
		interval_period=$1
		ceiling_amount=$2

		execute
	else
		echo "ERROR: Arguments Missing"
		printUsage
fi