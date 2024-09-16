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
      local type = ""

      if optionality == "required" then
         assert(config[key], "'" .. key .. "' missing from neoburner config (required)")

         type = item
      else
         if config[key] == nil then config[key] = item end

         type = type(item)
      end

      assert_type(config, key, type)
   end
end


local str = "string"
local int = "number"


function M.config(config)
   assert_config(config, "required", {
      auth_token = str,
      port = int,
      filesystem = str
   })

   assert_config(config, "optional", {
      adress = str
   })
end


return M
