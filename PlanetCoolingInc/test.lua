function test()
	list={"3","plus","+","4"}

	--Iterate though the table and print each value
	table.foreach(list,print)
	--[[
		Can also be written as:
		for key, value in pairs(list) do
			print(value)
		end
	]]

	--Write a function that takes the table as an argument and then concatenates them into a string
	function concatTable(table)
   	fullString=""
		for x = 1, #table do
   	   fullString=fullString..list[x]
		end
		print(fullString)
   end
	concatTable(list)

	--YOURE WRONG LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL

	--Write a table that a string as the key and a number as the value
	funkyTable={baba=3,booie=4}

	--now print the second value of the table
	print(funkyTable[booie])
end