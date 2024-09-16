local M = {}


local inputChecker = require("neoburner.inputChecker")
local new_api = require("neoburner.api")

function M.setup(config)
   inputChecker.config(config)

   M.config = config

   M.api = new_api(config)
end


function M.show_ram()
   M.check_connection()
end


function M.pull_files()

end


return M
