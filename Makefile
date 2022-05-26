CC=gcc
#INC=-I/usr/include/dbus-1.0/ -I/usr/lib/$(shell uname -m)-linux-gnu/dbus-1.0/include/
INC=$(shell pkg-config --cflags dbus-1)
CFLAGS=-Wall $(INC)
LDFLAGS=-ltinyalsa -ldbus-1 -ldl
SOURCES=src/q6voiced.c
OBJECTS=$(SOURCES:.c=.o)
NAME=q6voiced
EXECUTABLE=$(NAME)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)

install:
	install -Dm755 $(EXECUTABLE) /usr/bin/$(EXECUTABLE)
	install -Dm644 $(NAME).service /etc/systemd/system
	test -f /etc/$(NAME).conf || install -Dm644 $(NAME).conf /etc/$(NAME).conf
	systemctl enable /etc/systemd/system/$(NAME).service
	systemctl start $(NAME)

uninstall:
	systemctl stop $(NAME)
	systemctl disable $(NAME)
	rm /etc/systemd/system/$(NAME).service
	rm /usr/bin/$(EXECUTABLE)

clean:
	rm -r $(EXECUTABLE) $(OBJECTS)
