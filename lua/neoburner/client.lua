local CLIENT = {}


local json = require('plenary.json')
local new_client = require("lua-websockets.src.websocket.client_sync")


local function new(config)
   CLIENT.address = config.address
   CLIENT.port = config.port
   CLIENT.client = new_client()

   return CLIENT
end


function CLIENT:connect()
   local client = CLIENT.client

   if client.state ~= "CLOSED" then return end

   client.connect(client, CLIENT.address .. ":" .. CLIENT.port)
end


function CLIENT:send_and_receive(data)
   local client = CLIENT.client

   client.send(client, data, nil)
end


return new
