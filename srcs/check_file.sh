#!/bin/bash

check_makefile()
{
	printf "Makefile"
	#if [ -e ${PATH_PROJ}/Makefile ] || [ -e ${PATH_PROJ}/makefile ]
	if [ -e ${PATH_PROJ}/${MAKEFILE_VAR} ]
	then
		printf "\033[15G-Wall"
		printf "\033[25G-Wextra"
		printf "\033[35G-Werror\n"
		printf "${COLOR_OK}found${DEFAULT}"
		printf "\033[15G"
		if [ -z "$(grep -w '\-Wall' ${PATH_PROJ}/${MAKEFILE_VAR})" ]
		then
			printf "${COLOR_PROJ}missing${DEFAULT}"
		else
			printf "${COLOR_OK}ok${DEFAULT}"
		fi
		printf "\033[25G"
		if [ -z "$(grep -w '\-Wextra' ${PATH_PROJ}/${MAKEFILE_VAR})" ]
		then
			printf "${COLOR_KO}missing${DEFAULT}"
		else
			printf "${COLOR_OK}ok${DEFAULT}"
		fi
		printf "\033[35G"
		if [ -z "$(grep -w '\-Werror' ${PATH_PROJ}/${MAKEFILE_VAR})" ]
		then
			printf "${COLOR_KO}missing\n${DEFAULT}"
		else
			printf "${COLOR_OK}ok\n${DEFAULT}"
		fi
	else
		printf "${COLOR_KO}\nnot found${DEFAULT}\n"
	fi
}

check_auteur()
{
	printf "\nAuthor file"
	if [ -e ${PATH_PROJ}/auteur ] || [ -e ${PATH_PROJ}/author ]
	then
		if [ -e ${PATH_PROJ}/auteur ]
		then
			AUTHOR_VAR="auteur"
		else
			AUTHOR_VAR="author"
		fi
		printf "\033[15GCheck file content\n"
		printf "${COLOR_OK}found${DEFAULT}"
		if [ $(wc -l ${PATH_PROJ}/${AUTHOR_VAR} | tr -d ' ' | head -c 1) -gt 1 ]
		then
			printf "\033[15G${COLOR_KO}Too many lines in your file\n${DEFAULT}"
		elif [ $(wc -c ${PATH_PROJ}/${AUTHOR_VAR} | tr -d ' ' | head -c 1) -eq 0 ]
		then
			printf "\033[15G${COLOR_KO}Empty file\n${DEFAULT}"
		elif [ "$(cat -e ${PATH_PROJ}/${AUTHOR_VAR} | grep '\$')" != "" ]
		then
			if [ "$(norminette ${PATH_PROJ}/${AUTHOR_VAR} 2>&1 | grep command)" != "" ]
			then
				printf "\033[15G${COLOR_OK}$(cat ${PATH_PROJ}/${AUTHOR_VAR})${DEFAULT}\n"
			else
				if [ "$(cat ${PATH_PROJ}/${AUTHOR_VAR})" != "$(echo $(whoami))" ]
				then
					printf "\033[15G${COLOR_KO}Wrong login\n${DEFAULT}"
				else
					printf "\033[15G${COLOR_OK}$(cat ${PATH_PROJ}/${AUTHOR_VAR})${DEFAULT}\n"
				fi
			fi
		else
			printf "\033[15G${COLOR_FAIL}'\\\n' missing${DEFAULT}\n"
		fi
	else
		printf "${COLOR_KO}\nnot found${DEFAULT}\n"
	fi
	printf "\n"
}

check_header()
{
	printf "Header file"
	if [ -e ${PATH_PROJ}/${HEADER_DIR}/${HEADER_FILE} ]
	then
		printf "\033[15GNorme\n"
		printf "${COLOR_OK}found${DEFAULT}"
		if [ ${OPT_NO_NORMINETTE} -eq 1 ]
		then
			printf "${DEFAULT}\033[15Gdisabled\n"
		else
			text="= ${HEADER_FILE}"
			printf "\n${text}" >> ${PATH_DEEPTHOUGHT}/deepthought
			printf "%.s=" $(seq 1 $(( 80 - ${#text} ))) >> ${PATH_DEEPTHOUGHT}/deepthought
			printf "\n" >> ${PATH_DEEPTHOUGHT}/deepthought
			printf "$> norminette ${HEADER_FILE} | grep -E '(Error|Warning)'\n" >> ${PATH_DEEPTHOUGHT}/deepthought
			NORME_VAR=$(norminette ${PATH_PROJ}/${HEADER_DIR}/${HEADER_FILE} 2>&1)
			if echo "$NORME_VAR" | grep -q command
			then
				printf "${COLOR_WARNING}\033[15Gnot found${DEFAULT}\n"
				printf "norminette : command not found\n" >> ${PATH_DEEPTHOUGHT}/deepthought
			elif echo "$NORME_VAR" | grep -qE '(Error|Warning)'
			then
				printf "${COLOR_KO}\033[15Gcheck failed${DEFAULT}\n"
				echo "$NORME_VAR" | grep -E '(Error|Warning)' >> ${PATH_DEEPTHOUGHT}/deepthought
				printf "Norme check failed\n" >> ${PATH_DEEPTHOUGHT}/deepthought
			else
				printf "${COLOR_OK}\033[15Gok${DEFAULT}\n"
			fi
		fi
	else
		printf "${COLOR_KO}\nnot found${DEFAULT}\n"
	fi
	printf "\n"
}

sub_check_files()
{
	for file2 in ${1}/*
	do
		FILE2_NAME=$(echo $file2 | rev | cut -d "/" -f 1 | rev)
		if [ -d file2 ]
		then
			sub_check_file ${file2}
		elif [[ "$FILE2_NAME" == "${2}" || ${FOUND_FILES[index]} -eq 1 ]]
		then
			FOUND_FILES[$index]=1
			break
		fi
	done
}

nb_file_recur()
{
	for file in ${1}/*
	do
		if [ -d "$file" ]
		then
			nb_file_recur ${file}
		else
			NB_FILE2=$((NB_FILE2 + 1))
		fi
	done
}

check_files()
{
	FOUND_FILE1=0
	NB_FILE1=0
	NB_FILE2=0
	index=0
	nb_file_recur ${PATH_PROJ}
	for file1 in ${AUTHORIZED_FILES[@]}
	do
		NB_FILE1=$((NB_FILE1 + 1))
		printf "$file1"
		FOUND_FILES[$index]=0
		sub_check_files ${PATH_PROJ} ${file1}
		if [ ${FOUND_FILES[index]} -eq 1 ]
		then
			FOUND_FILE1=$((FOUND_FILE1    + 1))
			printf "\e[40GNorme\n${COLOR_OK}found${DEFAULT}"
			if [ $OPT_NO_NORMINETTE -eq 1 ]
			then
				printf "\e[40Gdisabled\n"
			else
				text="= ${file1} "
				printf "\n${text}" >> ${PATH_DEEPTHOUGHT}/deepthought
				printf "%.s=" $(seq 1 $(( 80 - ${#text} ))) >> ${PATH_DEEPTHOUGHT}/deepthought
				printf "\n" >> ${PATH_DEEPTHOUGHT}/deepthought
				printf "$> norminette ${file1} | grep -E '(Error|Warning)'\n" >> ${PATH_DEEPTHOUGHT}/deepthought
				NORME_VAR=$(norminette ${file2} 2>&1)
				if echo "$NORME_VAR" | grep -q command
				then
					printf "${COLOR_WARNING}\033[40Gnot found${DEFAULT}\n"
					printf "norminette : command not found\n" >> ${PATH_DEEPTHOUGHT}/deepthought
				elif echo "$NORME_VAR" | grep -qE '(Error|Warning)'
				then
					printf "${COLOR_KO}\033[15Gcheck failed${DEFAULT}\n"
					echo "$NORME_VAR" | grep -E '(Error|Warning)' >> ${PATH_DEEPTHOUGHT}/deepthought
					printf "Norme check failed\n" >> ${PATH_DEEPTHOUGHT}/deepthought
				else
					printf "${COLOR_OK}\033[15Gok${DEFAULT}\n\n"
				fi
			fi
		else
			printf "${COLOR_KO}\nnot found${DEFAULT}\n"
		fi
		printf "\n"
		printf "\n" >> ${PATH_DEEPTHOUGHT}/deepthought
		index=$((index + 1))
	done
	if [[ ${NB_FILE2} -ne ${NB_FILE1} ]]
	then	
		printf "${COLOR_KO}extra file found.${DEFAULT}\n\n"
	fi
}
