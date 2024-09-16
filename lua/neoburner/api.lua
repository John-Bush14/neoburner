local M = {}


local new_client = require("lua-websockets.src.websocket.client_sync")
local json = require('plenary.json')


function M.connect(auth_token, port, address)
   local client = new_client()

  client.connect(client, address, port)
end


return M
