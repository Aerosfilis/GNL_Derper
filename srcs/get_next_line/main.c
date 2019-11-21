#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include "get_next_line.h"

int		main()
{
	int		fd;
	int		res;
	char	*line;
	char	fd_name[31] = "srcs/get_next_line/files/text0";

	line = NULL;
	res = -1;
	for (int i = 0; i < 6; i++)
	{
		if (i != 5)
		{
			fd_name[29] = i + 48;
			fd = open(fd_name, O_RDONLY);
			printf("%s\n\n", fd_name);
		}
		else
		{
			fd = 0;
			printf("STDIN\n\n");
		}
		while (1)
		{
			res = get_next_line(fd, &line);
			printf("%d | %s\n", res, line);
			if (line)
			{
				free(line);
				line = NULL;
			}
			if (res != 1)
				break;
		}
		printf("\n");
		if (fd > 0)
			close(fd);
	}
}

