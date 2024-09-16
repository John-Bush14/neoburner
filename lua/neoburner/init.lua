local M = {}


local inputChecker = require("neoburner.inputChecker")
local api = require("neoburner.api")


function M.setup(config)
   inputChecker.config(config)

   M.config = config

   local auth_token = config.auth_token
   local port = config.port
   local address = config.address

   M.connection = api.connect(auth_token, port, address)
end


function M.show_ram()
end


function M.pull_files()

end


return M
