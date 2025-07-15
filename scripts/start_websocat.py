from subprocess import run
from signal import pause
from sys import argv

with open(argv[1], "r") as infile, open(argv[2], "w") as outfile:
    run(["websocat", "-s", argv[3], "-E"], stdin=infile, stdout=outfile)

with open(argv[1], "w") as infile, open(argv[2], "r") as outfile:
    pause()
