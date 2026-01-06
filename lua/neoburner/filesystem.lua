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

function FS:get_server_root(server)
   local root = vim.fs.joinpath(FS.servers_folder, server)

   if server == FS.root_server then root = FS.root end

   return root
end

local autocmds = {
   ["BufWrite"] = {"pushFile"},
   ["BufReadPost"] = {"getFile", function(result, buffer)
      vim.api.nvim_buf_set_text(buffer, 0, 0, -1, -1, result.content)
   end}
}
function FS:set_up_autocmds(server, SERVER)
   local pattern = vim.fs.joinpath(FS:get_server_root(server), "*")

   vim.api.nvim_clear_autocmds({pattern = pattern})

   for event, action in pairs(autocmds) do
      vim.api.nvim_create_autocmd(event, {
         pattern = pattern, callback = function(ev)
            local remote_method, callback = action[1], action[2]

            if callback ~= nil then callback = function(result) callback(result, ev.buf) end end

            local content = (remote_method == "pushFile") and table.concat(vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false), "\n")
            SERVER:use_remote_method(remote_method, {filename = ev.file, server = server, content = content}, callback)
         end
         })
   end
end

function FS:refresh(server, SERVER)
   local root = FS:get_server_root(server)

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

   FS:set_up_autocmds(server, SERVER)
end

return new
