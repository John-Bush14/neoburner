local FS = {}

function new(config)
   FS.root = config.filesystem
   FS.root_server = config.root_server
   FS.servers_folder = config.servers_folder

   return FS
end

function FS:reinititialize()
   os.execute('rm -rf "' .. FS.root .. '"')

   os.execute('mkdir -p "' .. vim.fs.joinpath(FS.root, FS.servers_folder) .. '"')
end

function FS:refresh(server, SERVER)
   local root = vim.fs.joinpath(FS.root, FS.servers_folder)

   local files =  SERVER:use_remote_method("get_all_files", {server = server})
   if server == FS.root_server then root = FS.root end

   for file, content in pairs(files) do
      local fh = io.open(root .. file, "w+")

      assert(fh ~= nil, error("Problem opening up file '" .. file .. "' for server '" .. server .. "'"))

      fh.write(content)
   end
end

return new
