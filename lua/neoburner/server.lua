local SERVER = {}

local in_pipe_path = "/tmp/bitburners_in"
local out_pipe_path = "/tmp/bitburners_out"
local websocat_start_file = "/scripts/start_websocat.py"

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
      local websocat_starter_filepath = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h") .. websocat_start_file

      local websocat_start_command = {"python3", websocat_starter_filepath, in_pipe_path, out_pipe_path, SERVER.port}

      vim.fn.jobstart(websocat_start_command, {
         detach = true,
         stdout = nil,
         stderr = nil
      })
   end

   SERVER.in_pipe = vim.loop.new_pipe(false)
   vim.loop.fs_open(out_pipe_path, "r", 438, function(_err, fd) SERVER.in_pipe:open(fd) end)
   SERVER.out_fd = io.open(in_pipe_path, "w+b")


   SERVER.in_pipe:read_start(function(err, data)
      if err then error(err) end

      if data then on_data(data) end
   end)
end


function SERVER:use_remote_method(method, params, on_answer)
   local message = vim.fn.json_encode(SERVER:generate_message(method, params)) .. "\n"

   local id = SERVER.next_id - 1

   SERVER.out_fd:write(message)
   SERVER.out_fd:flush()

   vim.loop.read_start(SERVER.in_pipe, function(err, data)
      if err then error("Error occured while trying to read answer from " .. out_pipe_path .. ": " .. err) end

      -- json decode can't run in fast event context
      vim.schedule(function()
         data = vim.fn.json_decode(data)

         if data.id ~= id then error("Sending multiple requests at the same time is not suppored!") end

         if data.error then error("jsonrpc request returned error: " .. data.error) end

         on_answer(data)
      end)
   end)
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
