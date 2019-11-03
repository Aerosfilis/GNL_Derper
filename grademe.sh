#!/bin/bash

PATH_TEST="$(cd "$(dirname "$0")" && pwd -P)"

exc 2> /dev/null

source ${PATH_TEST}/srcs/variables.sh

i=1
while [ $i -le $# ]
do
	case "${!i}" in
		"--help")		echo "No manual entry for $0"
						exit ;;
		"-h")			echo "No manual entry for $0"
						exit ;;
		"-s")			OPT_NO_SEARCH=1 ;;
		"--update")		OPT_UPDATE=1 ;;
		"-u")			OPT_UPDATE=1 ;;
		"-c")			OPT_NO_COLOR=1 ;;
		"-d")			i=$((i + 1))
						if [ $i -gt $# ]
						then
							echo "$0: option '-d' requires an argument"
							exit
						elif [ -d ${!i} ]
						then
							PATH_PROJ=${!i}
						elif [ -d ${PATH_TEST}/${!i} ]
						then
							PATH_PROJ=${PATH_TEST}/${!i}
						elif [ -e ${PATH_TEST}/${!i} ]
						then
							echo "$0: not a directory: ${!i}"
							exit
						else
							echo "$0: no such file or directory: ${!i}"
							exit
						fi ;;
	esac
	i=$((i+1))
done

source ${PATH_TEST}/srcs/colors.sh
source ${PATH_TEST}/srcs/check_cheat.sh
source ${PATH_TEST}/srcs/check_compilation.sh
source ${PATH_TEST}/srcs/check_file.sh
source ${PATH_TEST}/srcs/check_norme.sh
source ${PATH_TEST}/srcs/check_update.sh
source ${PATH_TEST}/srcs/compil.sh

cd ${PATH_TEST}

if [ ${OPT_UPDATE} -eq 1 ]
then
	func_check_update
	exit
fi

source ${PATH_TEST}/config.sh

if [ -d ${PATH_TEST}/projdir ]
then
	rm -rf ${PATH_TEST}/projdir
fi
mkdir ${PATH_TEST}/projdir
cp -R ${PATH_PROJ}/* ${PATH_TEST}/projdir
PATH_PROJ=${PATH_TEST}/projdir

init_deepthought()
{
	if [ -e ${PATH_DEEPTHOUGHT}/deepthought ]
	then
		rm -f ${PATH_DEEPTHOUGHT}/deepthought
	fi
	text="= Host-specific information "
	printf "${text}" >> ${PATH_DEEPTHOUGHT}/deepthought
	printf "%.s=" $(seq 1 $(( 80 - ${#text} ))) >> ${PATH_DEEPTHOUGHT}/deepthought
	printf "$> hostname; uname -msr\n" >> ${PATH_DEEPTHOUGHT}/deepthought
	hostname >> ${PATH_DEEPTHOUGHT}/deepthought
	uname -msr >> ${PATH_DEEPTHOUGHT}/deepthought
	printf "$> date\n" >> ${PATH_DEEPTHOUGHT}/deepthought
	date >> ${PATH_DEEPTHOUGHT}/deepthought
	printf "$> gcc --version\n" >> ${PATH_DEEPTHOUGHT}/deepthought
	gcc --version >> ${PATH_DEEPTHOUGHT}/deepthought
	printf "$> clang --version\n" >> ${PATH_DEEPTHOUGHT}/deepthought
	clang --version >> ${PATH_DEEPTHOUGHT}/deepthought
}

clear
init_deepthought

if [ -e ${PATH_PROJ}/Makefile ]
then
	MAKEFILE_VAR="Makefile"
elif [ -e ${PATH_PROJ}/makefile ]
then
	MAKEFILE_VAR="makefile"
else
	MAKEFILE_VAR="missing_makefile"
fi

if [ ${OPT_NO_SEARCH} -eq 0 ]
then
	func_check_file
fi
#if [ ${OPT_NO_LIBRARY} -eq 0 ]
#then
#	func_compil
#fi

if [ -e ${PATH_TEST}/a.out ]
then
	rm ${PATH_TEST}/a.out
fi
if [ ${DIRECTORY} -eq 1 ]
then
	if [ -d ${PATH_TEST}/projdir ]
	then
		rm -rf ${PATH_TEST}/projdir
	fi
fi

printf "A deepthought file has been generated in ${COLOR_PATH}${PATH_DEEPTHOUGHT}${DEFAULT}\n\n"

if [ ${MAKEFILE_VAR} != "missing_makefile" ]
then
	make --no-print-directory -C ${PATH_PROJ} fclean > /dev/null
fi
