local M = {}


local function assert_type(config, key, correct_type)
   local config_type = type(config[key])

   if config_type ~= correct_type then
      error(
         "'" .. key .. "' is in neoburner config, but is of type '" .. config_type .. "', " .. correct_type .. " is the correct type"
      )
   end
end


local function assert_config(config, optionality, keys)
   for key, item in pairs(keys) do
      if optionality == "required" then
         assert(config[key], "'" .. key .. "' missing from neoburner config (required)")
      else
         if config[key] == nil then config[key] = item end
      end

      assert_type(config, key, type(item))
   end
end


local str = "string"
---@diagnostic disable-next-line: unused-local
local int = 0


function M.config(config)
   assert_config(config, "required", {
      filesystem = str
   })

   if (type(config.servers) == str) then config.servers = {config.servers} end

   assert_config(config, "optional", {
      address = "ws://127.0.0.1",
      port = 12525,
      servers = {"home"},
      root_server = "home",
      servers_folder = "servers"
   })
end


return M
