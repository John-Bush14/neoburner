local M = {}


local configChecker = require("neoburner.configChecker")
local new_server = require("neoburner.server")

function M.setup(config)
   configChecker.config(config)

   M.config = config

   M.server = new_server(config)
   M.server:start_server()
end


function M.show_ram()
   M.server:use_remote_method("getFile", {filename = "spread.js", server = "home"}, function(data) print(data.result) end)
end


function M.pull_files(server)
end

function M.push_files(server)
end


return M
