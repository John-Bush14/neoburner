local FS = {}

function new(config)
   FS.root = config.filesystem
   FS.root_server = config.root_server
   FS.servers_folder = config.servers_folder

   return FS
end

return new
