-- Custom breakpoint thing, prints all variables and pauses game
function breakpoint(locObs, mode)
	-- Sort table into alphebetical order
	local function pairsByKeys (t, f)
		local a = {}
		for n in pairs(t) do table.insert(a, n) end
			table.sort(a, f)
			local i = 0      -- iterator variable
			local iter = function()   -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
		return iter
	end
	
	local function printNestedTable(tbl, indent)
		indent = indent or 0
		for key, value in pairs(tbl) do
			if type(value) == "table" then
				print(string.rep("   ", indent) .. key .. ": {")
				printNestedTable(value, indent + 1)
				print(string.rep("   ", indent) .. "}")
			else
				print(string.rep("   ", indent) .. key .. ": " .. tostring(value))
			end
		end
	end
	
	local G = _G
	G.localObjects = locObs
	
	
	

	for v, k in pairsByKeys(G) do 
		if type(k) == "table" and v ~= "_G" and v ~= "coroutine" and v ~= "io" and v ~= "arg" and v ~= "love" and v ~= "jit" and v ~= "bit" and v ~= "package" and v ~= "debug" and v ~= "table" and v ~= "string" and v ~= "math" and v ~= "os" and v ~= "graphics" and v ~= "grid" then
			
			print(v..": {")
			printNestedTable(k,1)
			print("}")

		elseif type(k) ~= "function" and v ~= "_G" and v ~= "coroutine" and v ~= "io" and v ~= "arg" and v ~= "love" and v ~= "jit" and v ~= "bit" and v ~= "package" and v ~= "debug" and v ~= "table" and v ~= "string" and v ~= "math" and v ~= "os" then
			print(v..":  "..tostring(k))
		end 
	end
	print("___________________________________________________________________________________________________ \n___________________________________________________________________________________________________")
	if mode then
		io.read()
	else
		onBreak = true
	end
end