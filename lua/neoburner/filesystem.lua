local FS = {}

function new(config)
   FS.root = config.filesystem
   FS.root_server = config.root_server
   FS.servers_folder = config.servers_folder

   return FS
end

function FS:reinititialize()
   os.execute('rm -rf "' .. FS.root .. '"')

function table.map(t, f)
   local result

   for k, e in pairs(t) do result[k] = f(e) end

   return result
end

   os.execute('mkdir -p "' .. vim.fs.joinpath(FS.root, FS.servers_folder) .. '"')
end

function FS:refresh(server, SERVER)
   local root = vim.fs.joinpath(FS.root, FS.servers_folder)

   if server == FS.root_server then root = FS.root end


   SERVER:use_remote_method("getAllFiles", {server = server}, function(answer, _)
      for _, file in pairs(answer.result) do
         local filepath = vim.fs.joinpath(root, file.filename)
         local parent = vim.fn.fnamemodify(filepath, ":h")

         if vim.fn.isdirectory(parent) == 0 then os.execute("mkdir -p '" .. parent .. "'") end

         local fh, err = io.open(filepath, "w+")

         assert(fh and (not err), "Problem opening up file '" .. file.filename .. "' for server '" .. server .. "' with error '" .. tostring(err) .. "'")

         fh:write(file.content)

         fh:close()
      end
   end)
end

return new
