if exists("g:loaded_neoSound")
    finish
endif

let g:loaded_neoSound = 1

command! -nargs=0 BBRam lua require("neoburner").show_ram()
command! -nargs=1 BBPull lua require("neoburner").pull_files(<f-args>)
