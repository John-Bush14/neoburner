local SERVER = {}

local WebsocketServer = require('websocket').server.ev
local ev = require("ev")

local function new(config)
   SERVER.address = config.address
   SERVER.port = config.port
   SERVER.next_id = 1

   return SERVER
end


   SERVER.server = WebsocketServer.listen({
      port = SERVER.port,
      default = function(ws)
         SERVER.connection = ws
         ws:on_message(on_message)
      end
   })
local function file_is_in_use(file)
   local handle = io.popen("lsof " .. out_pipe_path .. " 2>/dev/null")
   if not handle then error("couldn't get if websocket server was running.") end

   coroutine.resume(coroutine.create(ev.Loop.default.loop))
   local result = handle:read("a") ~= ""

   handle:close()

   return result
end


   local message = SERVER:generate_message(method, params)
   local ws = SERVER.connection
function SERVER:start_server(on_data)

   if ws == nil then error("Bitburner not connected.") end
function SERVER:use_remote_method(method, params)

   ws:send(vim.fn.json_encode(message))
end


function SERVER:generate_message(method, params)
   local message = {
      jsonrpc = "2.0",
      id = SERVER.next_id,
      method = method,
      params = params
   }

   SERVER.next_id = SERVER.next_id + 1

   return message
end


return new
