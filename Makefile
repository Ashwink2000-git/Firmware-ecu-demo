CC = gcc
SRC = src/main.c
TARGET = firmware

all:
    $(CC) $(SRC) -o $(TARGET)
    
clean:
    rm -f $(TARGET)
