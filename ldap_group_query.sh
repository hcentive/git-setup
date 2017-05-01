#!/bin/sh
#
# Shamefully ripped from
# https://github.com/sitaramc/gitolite/tree/pu/contrib/ldap
#
# This code is licensed to you under MIT-style license. License text for that
# MIT-style license is as follows:
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# ldap_group_query.sh <arg1>
#
# this script is used to perform ldap querys by giving one argument:
# - <arg1> the user UID for ldap search query
#
# NOTICE: This script requires ldap-utils and sed to be installed to the system.
#

# Script requires user UID as the only parameter
#
if [ $# -ne 1 ]
then
        echo "ldap_group_query.sh requires one argument - user's active directory username"
        exit 1
fi
user="${1}"

# Set needed LDAP search tool options for the query
#ldap_host="172.16.0.113"
ldap_host="10.10.0.111"
#ldap_host="192.168.50.7"
ldap_binddn="administrator@hcentive.com"
ldap_bindpw="/home/git/.gitolite_ad_passwd"
ldap_searchbase="dc=hcentive,dc=com"
#ldap_searchbase="<%=ldap_searchbase%>"
#ldap_scope="sub"

# Construct the command line base with needed options for the LDAP query
#ldap_options="-h ${ldap_host} -x -D ${ldap_binddn} -w ${ldap_bindpw} -b ${ldap_searchbase} -s ${ldap_scope}"
ldap_options="-h ${ldap_host} -x -D ${ldap_binddn} -y ${ldap_bindpw} -b ${ldap_searchbase}"

# Construct the search filter for the LDAP query for the given UID
#ldap_filter="(&(objectClass=top)(objectCategory=group))"
ldap_filter="(&(|(objectClass=top)(objectCategory=group))(|(sAMAccountName=${user}))) memberOf"

# Construct return attribute list for LDAP query result
attr1="memberOf"
ldap_attr="${attr1}"

# Execute the actual LDAP search to get groups for the given UID
echo  "${ldap_options} -LLL ${ldap_filter} ${ldap_attr}"
ldap_result=$(ldapsearch ${ldap_options} -LLL ${ldap_filter} ${ldap_attr})

# Edit search result to get space separated list of group names
#ldap_result=$(echo ${ldap_result} | sed -e "s/memberOf: /\n/g"|grep -v "^cn: "|cut -f1 --delimiter=",")
ldap_result=$(echo ${ldap_result} | sed -e "s/memberOf: /\n/g" | grep -v "^CN= " | cut -f1 --delimiter="," | cut -f2 --delimiter="=")

# Return group names for given user UID
echo ${ldap_result}
