local M = {}


function M.config(config)
   assert(config.auth_token, "'auth_token' missing from neoburner .setup() config")


   if config.port == nil then
      config.port = 12525
   end

   assert(type(config.port) == "number" and config.port > 0, "'port' needs to be a positive number")
end


return M
