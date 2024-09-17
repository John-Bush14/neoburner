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
    address = "ws://127.0.0.1" -- = localhost
})
```

## Commands

##### :BBRam

shows screen breaking down ram usage


##### :BBPull

overwrites buffers and filesystem with bitburners filesystem
