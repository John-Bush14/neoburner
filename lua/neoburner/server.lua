local SERVER = {}

local in_pipe_path = "/tmp/bitburners_in"
local out_pipe_path = "/tmp/bitburners_out"

local function new(config)
   SERVER.address = config.address
   SERVER.port = config.port
   SERVER.next_id = 1

   return SERVER
end


local function file_is_in_use(file)
   local handle = io.popen("lsof " .. out_pipe_path .. " 2>/dev/null")
   if not handle then error("couldn't get if websocket server was running.") end

   local result = handle:read("a") ~= ""

   handle:close()

   return result
end


function SERVER:start_server(on_data)
   os.execute("mkfifo " .. out_pipe_path .. " " .. in_pipe_path .. " 2>/dev/null")

   if not file_is_in_use(out_pipe_path) then
      vim.fn.jobstart("websocat --exit-on-eof -s " .. SERVER.port .. " > " .. out_pipe_path .. " < " .. in_pipe_path .. " & disown", {shell = true})
      vim.fn.jobstart("exec 3> " .. in_pipe_path .. " & disown", {shell = true})
   end

   SERVER.in_pipe = vim.loop.new_pipe(false)
   vim.loop.fs_open(out_pipe_path, "r", 438, function(_err, fd) SERVER.in_pipe:open(fd) end)
   vim.loop.fs_open(in_pipe_path, "w", 420, function(_err, fd) SERVER.out_fd = fd  end)

   SERVER.in_pipe:read_start(function(err, data)
      if err then error(err) end

      if data then on_data(data) end
   end)
end


function SERVER:use_remote_method(method, params)
   local message = SERVER:generate_message(method, params)

   vim.loop.fs_write(SERVER.out_fd, message, 0, function(err, msg) error(err .. msg) end)
end


function SERVER:generate_message(method, params)
   local message = {
      jsonrpc = "2.0",
      id = SERVER.next_id,
      method = method,
      params = params
   }

   SERVER.next_id = SERVER.next_id + 1

   return message
end


return new
