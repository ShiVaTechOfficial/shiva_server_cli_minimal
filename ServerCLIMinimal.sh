#!/bin/bash

# ---------------- globals & setup

APPNAME=ShiVaServerCLI_minimal

# pretty colors!
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ---------------- hello

show_welcome () {
	clear
	printf "${CYAN}ShiVa 2.0 - CLI Server packaging script for Linux\n"
	printf "ShiVa 2.0 is (c) ShiVa Technologies SAS\n"
	printf "http://www.shiva-engine.com${NC}\n\n"
}
show_welcome

# ---------------- check arg 1

if [ -z "$1" ] ; then
	printf "[ ${RED}ERROR${NC} ]  This script requires a valid path to an existing binary as argument.\n"
	exit 1

else

	if [ -d "$1" ] ; then
		printf "[ ${RED}ERROR${NC} ]  Your target must not be a directory.\n"
		exit 1
	fi

	if [ -f "$1" ] ; then
		ldd "$1" > /dev/null

		if [ $? -ne 0 ] ; then
			printf "[ ${RED}ERROR${NC} ]  Your target must be an executable binary.\n"
			exit 1		
		fi
		printf "[ ${GREEN}INFO${NC} ]  Working on ${CYAN}${1}${NC}.\n"

	else
		printf "[ ${RED}ERROR${NC} ]  Not a valid file: $1\n"
	fi
fi

# ---------------- check arg 2

DIR_TARGET=""

if [ -z "$2" ] ; then
	DIR_TARGET="$(dirname "$(readlink "$(pwd)")")"
else
	if [ -d "$2" ] ; then
		DIR_TARGET="$(readlink -f "${2}")"
	else
		DIR_TARGET="$(dirname "$(readlink -f "${2}")")"
	fi
fi

DIR_TARGET="${DIR_TARGET}/${APPNAME}"
DIR_TARGET_LIBS="${DIR_TARGET}/Libs"
printf "[ ${GREEN}INFO${NC} ]  Using ${CYAN}${DIR_TARGET}${NC} as output target.\n"

# ---------------- paths

DIR_BINARY="$(dirname "$(readlink -f "${1}")")"
DIR_SCRIPT="$(dirname "$(readlink -f "${0}")")"

mkdir -p "$DIR_TARGET" > /dev/null
if [ $? -ne 0 ] ; then
	printf "[ ${RED}ERROR${NC} ]  Could not create output directory.\n"
	exit 1
fi

mkdir -p "$DIR_TARGET_LIBS" > /dev/null
if [ $? -ne 0 ] ; then
	printf "[ ${RED}ERROR${NC} ]  Could not create library subdirectory.\n"
	exit 1
fi

# ---------------- ldd

LIBLIST=$(ldd "$1" | grep "$DIR_BINARY" | awk '{print $3}')
printf "[ ${GREEN}INFO${NC} ]  Local dependencies detected:\n"
printf "$LIBLIST\n"

# ---------------- copy files

printf "[ ${GREEN}INFO${NC} ]  Copying files...\n"

cp "$1" "$DIR_TARGET"
cp "${1}.sh" "$DIR_TARGET"

for line in $LIBLIST ; do
	cp "$line" "$DIR_TARGET_LIBS"
done

printf "[ ${GREEN}INFO${NC} ]  Compressing archive...\n"
tar czf "${DIR_TARGET}.tar.gz" "$DIR_TARGET"

printf "[ ${GREEN}INFO${NC} ]  Removing temporary files...\n"
rm -fr "$DIR_TARGET"
