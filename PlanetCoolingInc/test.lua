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

	--[[Write a function that takes the table as an 
    argument and then concatenates them into a string]]
    fullString=""
	for x=#list,1,-1 do
        fullString=fullString..list[x]
    end
    print(fullString)
end