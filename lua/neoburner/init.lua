local M = {}


local inputChecker = require("neoburner.inputChecker")
local new_client = require("neoburner.client")

function M.setup(config)
   inputChecker.config(config)

   M.config = config

   M.client = new_client(config)
end


function M.show_ram()
   M.client.check_connection()
end


function M.pull_files()
   M.client.check_connection()
end


return M
