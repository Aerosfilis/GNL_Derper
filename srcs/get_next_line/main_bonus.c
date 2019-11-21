#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "get_next_line_bonus.h"

int		main()
{
	int		fd;
	int		fd1;
	int		res;
	int		res1;
	char	*line;
	char	*line1;
	char	fd_name[30] = "srcs/get_next_line/files/text0";
	char	fd_name1[34] = "srcs/get_next_line/files/textbonus";

	line = NULL;
	line1 = NULL;
	for (int i = 0; i < 6; i++)
	{
		res = -1;
		res1 = -1;
		fd1 = open(fd_name1, O_RDONLY);
		if (i != 5)
		{
			fd_name[29] = i + 48;
			fd = open(fd_name, O_RDONLY);
			printf("%s\n%s\n\n", fd_name, fd_name1);
		}
		else
		{
			fd = 0;
			printf("STDIN\n%s\n\n", fd_name1);
		}
		while (1)
		{
			res = get_next_line(fd, &line);
			res1 = get_next_line(fd1, &line1);
			printf("%d | %s\n%d | %s\n", res, line, res1, line1);
			if (line)
			{
				free(line);
				line = NULL;
			}
			if (line1)
			{
				free(line1);
				line1 = NULL;
			}
			if (res != 1 && res1 != 1)
				break;
		}
		printf("\n");
		if (fd > 0)
			close(fd);
		close(fd1);
	}

	
}

