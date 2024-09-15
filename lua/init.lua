local M = {}


InputChecker = require("neoburner.lua.inputChecker")
Api = require("neoburner.lua.api")


function M.setup(config)
   InputChecker.config(config)


   local auth_token = config.auth_token
   local port = config.port


   local connection = Api.connect(auth_token, port)
end


function M.show_ram()

end


function M.pull_files()

end


return M
