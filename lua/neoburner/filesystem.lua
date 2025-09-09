local FS = {}

function new(config)
   FS.root = config.filesystem
   FS.root_server = config.root_server
   FS.servers_folder = config.servers_folder

   if string.sub(FS.root, string.len(FS.root)) ~= "/" then FS.root = FS.root .. "/" end

   return FS
end

function FS.reinititialize()
   vim.fs.rm(FS.root)

   os.execute('mkdir -p "' .. FS.root .. FS.servers_folder .. '"')
end

return new
