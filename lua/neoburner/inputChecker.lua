local M = {}


local function assert_type(config, key, correct_type)
   local config_type = type(config[key])

   if config_type ~= correct_type then
      error(
         "'" .. key .. "' is in neoburner config, but is of type '" .. config_type .. "', " .. correct_type .. " is the correct type"
      )
   end
end


local function assert_required(config, keys)
   for key, type in pairs(keys) do
      assert(config[key], "'" .. key .. "' missing from neoburner config (required)")

      assert_type(config, key, type)
   end
end


local function assert_optional(config, keys)
   for key, default in pairs(keys) do
      if config[key] == nil then config[key] = default end

      assert_type(config, key, type(default))
   end
end


function M.config(config)
   assert_required(config, {
      auth_token = "string",
      port = "number",
      filesystem = "string"
   })

   assert_optional(config, {
      adress = "string"
   })
end


return M
