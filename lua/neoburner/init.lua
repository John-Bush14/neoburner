local M = {}


local inputChecker = require("neoburner.inputChecker")
local new_client = require("neoburner.client")

function M.setup(config)
   inputChecker.config(config)

   M.config = config

   M.client = new_client(config)
end


function M.show_ram()
   M.check_connection()
end


function M.pull_files()

end


return M
