--Extra Table Functions

table.print = function(tbl, indent)
  indent = indent or 0
  for key, value in pairs(tbl) do
    if type(value) == "table" then
      print(string.rep("   ", indent)..key..": {")
      table.print(value, indent + 1)
      print(string.rep("   ", indent).."}")
    else
      print(string.rep("   ", indent)..key..": "..tostring(value))
    end
  end
end

table.toString = function(tbl, indent)
  indent = indent or 0
  local output = ""
  for key, value in pairs(tbl) do
    if type(value) == "table" then
      output = output..string.rep("   ", indent)..key..": {\n"
      output = output..table.toString(value, indent + 1)
      output = output..string.rep("   ", indent).."}\n"
    else
      output = output..string.rep("   ", indent)..key..": "..tostring(value).."\n"
    end
  end
  return output
end

table.copy = function(tbl)
  local copy = {}
  for key, value in pairs(tbl) do
    if type(value) == "table" then
      copy[key] = table.copy(value)
    else
      copy[key] = value
    end
  end
  return copy
end

table.compare = function(tbl1, tbl2)
  for key, value in pairs(tbl1) do
    if type(value) == "table" then
      if not table.compare(value, tbl2[key]) then
        return false
      end
    else
      if value ~= tbl2[key] then
        return false
      end
    end
  end
  return true
end

table.merge = function(tbl1, tbl2)
  for key, value in pairs(tbl2) do
    if type(value) == "table" then
      if not tbl1[key] then
        tbl1[key] = table.copy(value)
      else
        table.merge(tbl1[key], value)
      end
    else
      tbl1[key] = value
    end
  end
end

table.find = function(tbl, value)
  for key, val in pairs(tbl) do
    if val == value then
      return key
    end
  end
  return nil
end

table.findNested = function(tbl, value)
  for key, val in pairs(tbl) do
    if type(val) == "table" then
      local result = table.findNested(val, value)
      if result then
        return key, result
      end
    elseif val == value then
      return key
    end
  end
  return nil
end

table.findKey = function(tbl, key)
  for k, v in pairs(tbl) do
    if k == key then
      return v
    end
  end
  return nil
end

table.findNestedKey = function(tbl, key)
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      local result = table.findNestedKey(v, key)
      if result then
        return k, result
      end
    elseif k == key then
      return v
    end
  end
  return nil
end

table.findValue = function(tbl, value)
  for k, v in pairs(tbl) do
    if v == value then
      return k
    end
  end
  return nil
end

table.findNestedValue = function(tbl, value)
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      local result = table.findNestedValue(v, value)
      if result then
        return k, result
      end
    elseif v == value then
      return k
    end
  end
  return nil
end

table.findKeyByValue = function(tbl, value)
  for k, v in pairs(tbl) do
    if v == value then
      return k
    end
  end
  return nil
end

table.findNestedKeyByValue = function(tbl, value)
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      local result = table.findNestedKeyByValue(v, value)
      if result then
        return k, result
      end
    elseif v == value then
      return k
    end
  end
  return nil
end

