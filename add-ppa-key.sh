#!/usr/bin/env sh

# Christian Kakesa
#
# christian.kakesa@gmail.com
# 20 september 2011
#
# Retireve GPG keys from Ubuntu, Debian or others repository.

usage()
{
cat << _USAGE
###############################################################################
## Usage                                                                     ##
## Christian Kakesa <christian.kakesa@gmail.com> (c) 2011                    ##
###############################################################################
${0} - Retireve PPA repository GPG keys for Ubuntu, Debian or others distrib
       Support 8 characters length of GPG_ID_KEY,
       (is GPG_ID_KEY more than 8 chars ?).
Synopsis:
  ${0} GPG_ID_KEY

_USAGE
}

exit_success()
{
	exit 0
}

exit_failure()
{
	if [ $# -ne 1 ]; then
		exit 1
	else
		exit $1
	fi
}

if [ $# -ne 1 -o `expr length "${1}"` -ne 8 -o `expr "${1}" : '^[0-9a-fA-F]*$'` -eq 0 ]
then
	usage
	exit 1
fi

wget -q -O- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${1}" | grep -ve '^<.*' | sudo apt-key add -

for ret in $PIPESTATUS
do
	if [ $ret -ne 0 ]
	then
		exit_failure $ret
	fi
done

exit_success
