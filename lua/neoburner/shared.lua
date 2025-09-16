return {extend = function(table)
   function table.contains(t, v)
      for _, e in pairs(t) do
         if e == v then return true end
      end

      return false
   end

   function table.map(t, f)
      local result = {}

      for k, e in pairs(t) do result[k] = f(e) end

      return result
   end
end}
