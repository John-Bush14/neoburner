local M = {}


local inputChecker = require("neoburner.inputChecker")
local new_server = require("neoburner.client")

function M.setup(config)
   inputChecker.config(config)

   M.config = config

   M.server = new_server(config)
   M.server:start_listening()
end


function M.show_ram()
   M.server:connect()
end


function M.pull_files()
end


return M
