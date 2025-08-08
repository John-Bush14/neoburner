## Installation

#### Lazy
```lua
{
    "John-Bush14/neoburner",
}
```

## Setup

```lua
require("neoburner").setup({
    -- needed
    filesystem = "~/bitburner_files", -- where bitburner filesystem will be placed

    -- optional
    address = "ws://127.0.0.1", -- = localhost
    port = "12525",

    servers = {"home"}, -- servers wich will be in filesystem, cannot be set to "*" because of api limitations.
    root_server = "home", -- or nil
    servers_folder = "servers", -- or nil
})
```

## Commands

##### :BBRam ?\<file> ?\<server>

Shows screen breaking down ram usage of \<file> on \<server>. 
Default file is current buffer and default server is server of current buffer.


##### :BBPull ?\<server> 

Overwrites all files or only the files of \<server> with the game's savefile's files.
Can also be used to temporarily add a server to the filesystem without adding it to servers in config.
:edit will also pull the games savefile's files to the affected buffer(s).

##### :BBPush ?\<server>

Overwrites all files or only the files of \<server> of the game's savefile's with you're local files.
:write will also push the affected buffer(s) to the game's savefile.
