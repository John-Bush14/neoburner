local M = {}


local inputChecker = require("neoburner.inputChecker")
local new_server = require("neoburner.server")

function M.setup(config)
   inputChecker.config(config)

   M.config = config

   M.server = new_server(config)
   M.server:start_server(function(msg) error(msg) end)
end


function M.show_ram()
   M.server:use_remote_method("getFile", {filename = "", server = "home"})
end


function M.pull_files()
end


return M
