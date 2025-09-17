local FS = {}

require("neoburner.shared").extend(table)

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

function FS:set_up_autocmds(server) end

function FS:refresh(server, SERVER)
   local root = vim.fs.joinpath(FS.servers_folder, server)

   if server == FS.root_server then root = FS.root end


   SERVER:use_remote_method("getAllFiles", {server = server}, function(answer, _)
      local filepaths = table.map(answer.result, function(file) return vim.fs.joinpath(root, file.filename) end)

      clean_up_forsaken_files(root, filepaths)

      for k, filepath in pairs(filepaths) do
         local parent = vim.fs.dirname(filepath)

         if vim.fn.isdirectory(parent) == 0 then os.execute("mkdir -p '" .. parent .. "'") end

         local fh, err = io.open(filepath, "w+")

         assert(fh and (not err), "Problem opening up file '" .. filepath .. "' for server '" .. server .. "' with error '" .. tostring(err) .. "'")

         fh:write(answer.result[k].content)

         fh:close()
      end
   end)

   FS:set_up_autocmds(server)
end

return new
