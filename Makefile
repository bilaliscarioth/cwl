PROG=		cwm

OBJS=		src/calmwm.o src/menu.o 		\
		src/search.o src/util.o src/conf.o	\
		src/group.o src/kbfunc.o 		\

CPPFLAGS+=	-I${X11BASE}/include -I${X11BASE}/include/freetype2 -I${.CURDIR}

CFLAGS = 	-O2 -Iinclude -std=c11 \
		-Wall -Wextra -Wconversion -Wdeprecated -Werror	\
		-Wpedantic -Wshadow -Wuninitialized -Wunused

CFLAGS += $(pkg-config --cflags wayland-server pixman-1)

LDFLAGS = $(pkg-config --libs wayland-server pixman-1)

.SUFFIXES: .c .o
.c.o:
	${CC} ${CFLAGS} -fPIC $< -c -o $@ ${LDFLAGS}

build: cwl

cwl: ${OBJS}
	@mkdir -p release
	${CC} ${CFLAGS} ${OBJS} -shared -o release/libcwl.so
	${CC} ${CFLAGS} src/main.c -o release/minishell ./release/libcwl.so ${LDFLAGS}	
