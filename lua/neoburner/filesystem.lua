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

function FS.refresh(server, SERVER)
   local root = FS.root .. (FS.servers_folder and server ~= FS.root_server or "")

   local files =  SERVER:use_remote_method("get_all_files", {server = server})

   for file, content in pairs(files) do
      local fh = io.open(root .. file, "w+")

      assert(fh ~= nil, error("Problem opening up file '" .. file .. "' for server '" .. server .. "'"))

      fh.write(content)
   end
end

return new
