from subprocess import run
from signal import pause
from sys import argv
from os import open as os_open, O_RDWR, O_NONBLOCK, fdopen

in_fd = os_open(argv[1], O_RDWR, O_NONBLOCK)

with open(argv[1], "r") as infile, open(argv[2], "w") as outfile:
    run(["websocat", "-s", argv[3], "-E"], stdin=infile, stdout=outfile)

with fdopen(in_fd, "w") as infile, open(argv[2], "r") as outfile:
    pause()
