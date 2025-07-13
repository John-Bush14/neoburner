local SERVER = {}

local WebsocketServer = require('websocket').server.ev
local ev = require("ev")

local function new(config)
   SERVER.address = config.address
   SERVER.port = config.port
   SERVER.next_id = 1

   return SERVER
end


function SERVER:start_listening(on_message)
   SERVER.server = WebsocketServer.listen({
      port = SERVER.port,
      default = function(ws)
         SERVER.connection = ws
         ws:on_message(on_message)
      end
   })

   coroutine.resume(coroutine.create(ev.Loop.default.loop))
end


function SERVER:send_message(method, params)
   local message = SERVER:generate_message(method, params)
   local ws = SERVER.connection

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
