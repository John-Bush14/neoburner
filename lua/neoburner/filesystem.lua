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

   if server == FS.root_server then root = FS.root end


         local fh = io.open(root .. file, "w+")
   SERVER:use_remote_method("getAllFiles", {server = server}, function(answer, _)
      for _, file in pairs(answer.result) do

         assert(fh ~= nil, error("Problem opening up file '" .. file .. "' for server '" .. server .. "'"))

         fh.write(content)
      end
   end)
end

return new
