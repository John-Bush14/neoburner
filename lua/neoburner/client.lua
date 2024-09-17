local CLIENT = {}


local new_client = require("lua-websockets.src.websocket.client_sync")


local function new(config)
   CLIENT.address = config.address
   CLIENT.port = config.port
   CLIENT.client = new_client()
   CLIENT.next_id = 1

   return CLIENT
end


function CLIENT:connect()
   local client = CLIENT.client

   if client.state ~= "CLOSED" then return end

   client.connect(client, CLIENT.address .. ":" .. CLIENT.port)
end


function CLIENT:send_and_receive(message)
   CLIENT:connect()

   local client = CLIENT.client

   client.send(client, vim.fn.json_encode(message), nil)

   return client.receive(client)
end


function CLIENT:generate_message(method, params)
   local message = {
      jsonrpc = "2.0",
      id = CLIENT.next_id,
      method = method,
      params = params
   }

   CLIENT.next_id = CLIENT.next_id + 1

   return message
end


return new
