if exists("g:loaded_neoSound")
    finish
endif

let g:loaded_neoSound = 1

command! -nargs=0 BBRam lua require("neoburner").show_ram()
command! -nargs=0 BBPull lua require("neoburner").pull_files()
