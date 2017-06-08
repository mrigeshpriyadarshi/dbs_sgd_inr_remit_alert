#!/bin/bash
#
# Install Pre-requisites for DBS script
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

checkApps()
{
	echo "INFO: checking packages on ${OSTYPE}"
	case $OSTYPE in
		darwin*)
			install_brew
			sudo brew list watch  > /dev/null;; 
		linux*)   
			if [ -f /etc/redhat-release ] ; then
				sudo rpm -qa | grep watch   > /dev/null
			elif [ -f /etc/debian_version ] ; then
				sudo dpkg -l | grep watch   > /dev/null
			fi
			;;
		*)        
			echo "FATAL: unknown OS Type: $OSTYPE"
			echo -e "FATAL: Supports MacOSX and Linux" 
			exit 1
			;;
	esac
	return $?
}

checkRubyApps()
{
    /usr/bin/gem list -i ${1}
    return $?
}

installApps()
{
	if [[ checkApps -ne 0 ]]; then
		echo "INFO: Installing WATCH."
		case "$OSTYPE" in
			darwin*)
				brew install watch coreutils
				;; 
			linux*)   
				if [ -f /etc/redhat-release ] ; then
					sudo rpm -Uvh ${epel_repo}
					sudo yum -y install watch ruby
				elif [ -f /etc/debian_version ] ; then
					sudo apt-get install watch ruby-full
				fi
				;;
		esac
		echo "INFO: Installed packages on system!!!"
	else
		echo "INFO: packages already present on system!!!"
	fi
}

installRubyApps()
{
	gem=$(which gem)
	for appName in ${ruby_apps}; do
		if [[ $(checkRubyApps ${appName}) -ne 0 ]]; then
			${gem} install ${appName}
		else
			echo "INFO: Ruby ${appName} already present on system!!!"
		fi
	done
	echo "INFO: Installed Ruby packages on system!!!"
}


### MAIN SCRIPT #####


installApps
installRubyApps
