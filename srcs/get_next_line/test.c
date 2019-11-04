#include "get_next_line.h"
#include <stdio.hi>
#include <stdlib.h>
#include <fcntl.h>

int		main(int ac, char **av)
{
	int	fd1;
	char *line1 = NULL;
	int	err1;

	if (ac > 1)
		if (ac[1] == "STDIN")
			fd1 = 0;
		else if (ac[1] == "FAKE_FD")
			fd1 = 10;
		else
			fd1 = open(ac[1], O_RDONLY);
	else
		fd1 = -1;
	while ((err1 = get_next_line(fd1, &line1)) > 0)
	{
		if (line)
		{
			printf("[%zd] %s\n", err1, line1);
			free(line1);
			line = NULL;
		}
		else
			printf("[%zd] (null)\n", err1);
	}
	if (line)
	{
		printf("[%zd] %s\n", err1, line1);
		free(line1);
		line = NULL;
	}
	else
		printf("[%zd] (null)\n", err1);
}
