#!/bin/bash
#
# This Source Code Form is subject to the terms of the Mozilla Public 
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (C) 2011-2012 Star2Billing S.L.
# 
# The Initial Developer of the Original Code is
# Arezqui Belaid <info@star2billing.com>
#

DATETIME=$(date +"%Y%m%d%H%M%S")
KERNELARCH=$(uname -p)


# Identify Linux Distribution type
func_identify_os() {
    
    if [ -f /etc/debian_version ] ; then
        DIST='DEBIAN'
        if [ "$(lsb_release -cs)" != "lucid" ] && [ "$(lsb_release -cs)" != "precise" ]; then
		    echo "This script is only intended to run on Ubuntu LTS 10.04 / 12.04 or CentOS 6.2"
		    exit 255
	    fi
    elif [ -f /etc/redhat-release ] ; then
        DIST='CENTOS'
        if [ "$(awk '{print $3}' /etc/redhat-release)" != "6.2" ] ; then
        	echo "This script is only intended to run on Ubuntu LTS 10.04 / 12.04 or CentOS 6.2"
        	exit 255
        fi
    else
        echo ""
        echo "This script is only intended to run on Ubuntu LTS 10.04 / 12.04 or CentOS 6.2"
        echo ""
        exit 1
    fi
    
    #Prepare settings for installation
    case $DIST in
        'DEBIAN')
            SCRIPT_VIRTUALENVWRAPPER="/usr/local/bin/virtualenvwrapper.sh"
            APACHE_CONF_DIR="/etc/apache2/sites-enabled/"
            APACHE_USER="www-data"
            APACHE_SERVICE='apache2'
            WSGI_ADDITIONAL=""
            WSGIApplicationGroup=""
        ;;
        'CENTOS')
            SCRIPT_VIRTUALENVWRAPPER="/usr/bin/virtualenvwrapper.sh"
            APACHE_CONF_DIR="/etc/httpd/conf.d/"
            APACHE_USER="apache"
            APACHE_SERVICE='httpd'
            #WSGI_ADDITIONAL="WSGISocketPrefix run/wsgi"
            WSGI_ADDITIONAL="WSGISocketPrefix        /var/run/wsgi"
            WSGIApplicationGroup="WSGIApplicationGroup %{GLOBAL}"
        ;;
    esac
}


#Function accept license mplv2
func_accept_license_mplv2() {
    echo ""
    wget --no-check-certificate -q -O  MPL-V2.0.txt https://raw.github.com/areski/sms-khomp-api/master/COPYING
    more MPL-V2.0.txt
    echo ""
    echo ""
    echo "License MPL V2.0"
    echo ""
    echo "This Source Code Form is subject to the terms of the Mozilla Public"
    echo "License, v. 2.0. If a copy of the MPL was not distributed with this file,"
    echo "You can obtain one at http://mozilla.org/MPL/2.0/."
    echo ""
    echo "Copyright (C) 2012 Star2Billing S.L."
    echo ""
    echo ""
    echo "I agree to be bound by the terms of the license - [YES/NO]"
    echo ""
    read ACCEPT
    
    while [ "$ACCEPT" != "yes" ]  && [ "$ACCEPT" != "Yes" ] && [ "$ACCEPT" != "YES" ]  && [ "$ACCEPT" != "no" ]  && [ "$ACCEPT" != "No" ]  && [ "$ACCEPT" != "NO" ]; do
        echo "I agree to be bound by the terms of the license - [YES/NO]"
        read ACCEPT
    done
    
    if [ "$ACCEPT" != "yes" ]  && [ "$ACCEPT" != "Yes" ] && [ "$ACCEPT" != "YES" ]; then
        echo "License rejected !"
        exit 0
    else
        echo "Licence accepted !"
    fi
}

