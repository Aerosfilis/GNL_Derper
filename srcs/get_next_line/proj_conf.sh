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
	echo ${FOUND_FILES[@]}
}

test_func()
{
	text="TESTING ${PROJ_NAME^^}"
	printf "${COLOR_TITLE}%.s${CHAR_LENGTH}" $(seq 1 ${TITLE_LENGTH})
	printf "\n${CHAR_WIDTH}\e[$(( (${TITLE_LENGTH} - ${#text}) / 2 ))G${text}\e[${TITLE_LENGTH}G${CHAR_WIDTH}\n"
	printf "%.s${CHAR_LENGTH}" $(seq 1 ${TITLE_LENGTH})
	printf "\n\n${DEFAULT}"
	
	printf "${PURPLE}Part\e[20GCompil\e[20GTesti${DEFAULT}\n"
	printf "Basic"
}
