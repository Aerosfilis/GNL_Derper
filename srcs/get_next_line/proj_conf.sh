#!/bin/bash

AUTHORIZED_FILES=(\
get_next_line.c get_next_line_utils.c get_next_line.h \
get_next_line_bonus.c get_next_line_utils_bonus.c get_next_line_bonus.h)

OPT_NO_LIBRARY=1

declare -a FOUND_FILES=()

func_check_file()
{
	text="CHECKING FILES"
	printf "${COLOR_TITLE}"
	printf "%.s${CHAR_LENGTH}" $(seq 1 ${TITLE_LENGTH})
	printf "\n${CHAR_WIDTH}\e[$(( (${TITLE_LENGTH} - ${#text}) / 2 ))G${text}\033[${TITLE_LENGTH}G${CHAR_WIDTH}\n"
	printf "%.s${CHAR_LENGTH}" $(seq 1 ${TITLE_LENGTH})
	printf "\n\n${DEFAULT}"
	check_files
}

test_func()
{
	text="TESTING ${PROJ_NAME^^}"
	printf "${COLOR_TITLE}%.s${CHAR_LENGTH}" $(seq 1 ${TITLE_LENGTH})
	printf "\n${CHAR_WIDTH}\e[$(( (${TITLE_LENGTH} - ${#text}) / 2 ))G${text}\e[${TITLE_LENGTH}G${CHAR_WIDTH}\n"
	printf "%.s${CHAR_LENGTH}" $(seq 1 ${TITLE_LENGTH})
	printf "\n\n${DEFAULT}"

	printf "basic      "
	if [[ ${FOUND_FILES[0]} -eq "1" && ${FOUND_FILES[1]} -eq "1" && ${FOUND_FILES[2]} -eq "1" ]]
	then
		basic_func "32" "basic0" ""
		basic_func "1" "basic0" ""
		basic_func "0" "basic1" ""
		basic_func "$(wc -c srcs/get_next_line/files/text0 | cut -d' ' -f1)" "basic0"
		basic_func "$(($(wc -c srcs/get_next_line/files/text0 | cut -d' ' -f1) + 1))" "basic0" ""
		basic_func "$(($(wc -c srcs/get_next_line/files/text0 | cut -d' ' -f1) - 1))" "basic0"
	else
		printf "${COLOR_KO}missing files${DEFAULT}"
	fi
	printf "\n"

	printf "bonus      "
	if [[ ${FOUND_FILES[3]} -eq "1" && ${FOUND_FILES[4]} -eq "1" && ${FOUND_FILES[5]} -eq "1" ]]
	then
		basic_func "32" "bonus0" "_bonus"
		basic_func "1" "bonus0" "_bonus"
		basic_func "0" "bonus1" "_bonus"
		basic_func "$(wc -c srcs/get_next_line/files/text0 | cut -d' ' -f1)" "basic0"
		basic_func "$(($(wc -c srcs/get_next_line/files/text0 | cut -d' ' -f1) + 1))" "bonus0" "_bonus"
		basic_func "$(($(wc -c srcs/get_next_line/files/text0 | cut -d' ' -f1) - 1))" "bonus0" "_bonus"
	else
		printf "${COLOR_KO}missing files${DEFAULT}"
	fi
	printf "\n\n"
}

basic_func()
{
	cp ${PATH_TEST}/srcs/get_next_line/main$3.c ${PATH_PROJ}
	if [ -e usertest ]
	then
		rm usertest
	fi
	text="= $2 "
	printf "\n$text" >> ${PATH_DEEPTHOUGHT}/deepthought
	printf "%.s=" $(seq 1 $((80 - ${#text}))) >> ${PATH_DEEPTHOUGHT}/deepthought
	printf "$> clang -Wall -Wextra -Werror -g3 -fsanitize=address -D BUFFER_SIZE=$1 get_next_line$3.c get_next_line_utils$3.c main$3.c -o usertest\n" >> ${PATH_DEEPTHOUGHT}/deepthought
	clang -Wall -Wextra -Werror -D BUFFER_SIZE=$1 ${PATH_PROJ}/get_next_line$3.c ${PATH_PROJ}/get_next_line_utils$3.c ${PATH_PROJ}/main$3.c 2>>${PATH_DEEPTHOUGHT}/deepthought -o usertest
	if [ -e ${PATH_TEST}/usertest ]
	then
		printf "$> usertest < text0 > output\n" >> ${PATH_DEEPTHOUGHT}/deepthought
		${PATH_TEST}/usertest < ${PATH_TEST}/srcs/get_next_line/files/text0 > ${PATH_TEST}/output
		printf "$> diff $2 output\n" >> ${PATH_DEEPTHOUGHT}/deepthought
		diff_out=$(diff ${PATH_TEST}/output ${PATH_TEST}/srcs/get_next_line/files/$2)
		diff ${PATH_TEST}/output ${PATH_TEST}/srcs/get_next_line/files/$2 >> ${PATH_DEEPTHOUGHT}/deepthought
		printf "\n\n" >> ${PATH_DEEPTHOUGHT}/deepthought
		if [[ ${diff_out} = "" ]]
		then
			printf " ${COLOR_OK}OK${DEFAULT}"
		else
			printf " ${COLOR_KO}KO${DEFAULT}"
		fi
		rm ${PATH_TEST}/output ${PATH_TEST}/usertest
	else
		printf " ${COLOR_KO}KO${DEFAULT}"
	fi
	rm ${PATH_PROJ}/main$3.c
}
