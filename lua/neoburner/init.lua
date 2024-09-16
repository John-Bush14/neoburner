local M = {}


local inputChecker = require("neoburner.inputChecker")
local api = require("neoburner.api")
local new_client = require("lua-websockets.src.websocket.client_sync")

function M.setup(config)
   inputChecker.config(config)

   M.config = config

   M.client = new_client()

   M.check_connection = api.connect
end


function M.show_ram()
end


function M.pull_files()

end


return M
