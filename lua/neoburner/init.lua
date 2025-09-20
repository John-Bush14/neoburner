local M = {}


local configChecker = require("neoburner.configChecker")
local new_server = require("neoburner.server")
local new_filesystem = require("neoburner.filesystem")

function M.setup(config)
   configChecker.config(config)

   M.config = config

   M.server = new_server(config)
   M.server:start_server()

   M.filesystem = new_filesystem(config)


   vim.api.nvim_create_user_command("BBPull",
      function(input)
         local servers = input.fargs

         for _, server in pairs(servers or config.servers) do
            M.filesystem:refresh(server, M.server)
         end
      end, {nargs = "*"}
   )

   vim.api.nvim_create_user_command("BBRam",
      function(input)
         M.server:use_remote_method("getFile", {filename = "spread.js", server = "home"}, function(data) print(data.result) end)
      end, {}
   )

   vim.api.nvim_create_user_command("BBPush",
      function(input) end, {nargs = "*"}
   )
end


return M
