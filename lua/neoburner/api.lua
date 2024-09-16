local API = {}


local json = require('plenary.json')
local new_client = require("lua-websockets.src.websocket.client_sync")


local function new(config)
   API.address = config.address
   API.port = config.port
   API.client = new_client()

   return API
end


function API:connect()
   local client = API.client

   if client.state ~= "CLOSED" then return end

   client.connect(client, API.address .. ":" .. API.port)
end


return new
