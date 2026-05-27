CC ?= cc
CFLAGS ?= -O2 -Wall -Wextra

all: relationship_degree

relationship_degree: relationship_degree.c
	$(CC) $(CFLAGS) -o relationship_degree relationship_degree.c

run: relationship_degree
	./relationship_degree

clean:
	rm -f relationship_degree
