local FS = {}

local function new(config)
   FS.root = vim.fs.normalize(config.filesystem)
   FS.root_server = config.root_server
   FS.servers_folder = vim.fs.joinpath(FS.root, config.servers_folder)

   return FS
end

local function clean_up_forsaken_files(directory, rightful_files)
   if not vim.fn.isdirectory(directory) then return end

   local dir, filename, type = vim.fs.dir(directory, {depth = math.maxinteger}), "", ""

   repeat
      local filepath = vim.fs.joinpath(directory, filename)

      if type == "file" and not table.contains(rightful_files, filepath) then
         vim.fs.rm(filepath)
      end

      ---@diagnostic disable-next-line: cast-local-type
      filename, type = dir()
   until filename == nil
end

function table.map(t, f)
   local result

   for k, e in pairs(t) do result[k] = f(e) end

   return result
end

function table.contains(t1, t2)
   for _, e2 in pairs(t2) do
      local contains_element = false
      for _, e1 in pairs(t1) do
         if e1 == e2 then contains_element = true end
      end
      if not contains_element then return false end
   end
   return true
end

function FS:refresh(server, SERVER)
   local root = vim.fs.joinpath(FS.servers_folder, server)

   if server == FS.root_server then root = FS.root end


   SERVER:use_remote_method("getAllFiles", {server = server}, function(answer, _)
      local files = answer.result

      clean_up_forsaken_files(root, table.map(files, function(file) return file.filename end))

      for _, file in pairs(files) do
         local filepath = vim.fs.joinpath(root, file.filename)
         local parent = vim.fs.dirname(filepath)

         if vim.fn.isdirectory(parent) == 0 then os.execute("mkdir -p '" .. parent .. "'") end

         local fh, err = io.open(filepath, "w+")

         assert(fh and (not err), "Problem opening up file '" .. file.filename .. "' for server '" .. server .. "' with error '" .. tostring(err) .. "'")

         fh:write(file.content)

         fh:close()
      end
   end)
end

return new
