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
    api_key = "*******"
    port = "*****"
    filesystem = "~/bitburner_files" -- where bitburner filesystem will be placed

    -- optional
    address = "ws://127.0.0.1", -- = localhost
    servers = {"home"} -- servers wich will be able to be edited, can also be set to "*"
})
```

## Commands

##### :BBRam

Shows screen breaking down ram usage.


##### :BBPull ?\<server>

Overwrites all files or only the files of \<server> with the game's savefile's files.
Can also be used to temporarily add a server to the filesystem without adding it to servers in config.
