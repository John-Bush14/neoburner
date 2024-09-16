local m = {}


local json = require('plenary.json')


function m.connect(M)
   local client = M.client

   if client.state ~= "CLOSED" then return end

   client.connect(client, M.address .. ":" .. M.port)
end


return m
