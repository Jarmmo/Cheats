function ScrambleDM()
	local t1 = {}
	local t2 = {}

	for k,v in pairs(player.GetAll())do
		if(v:Team() == 3)then
			table.insert(t1,v)
		end
	end

	local pamnt = math.ceil(table.Count(t1)/2)
	for i = 1,pamnt do
		local rnum = math.random(1,pamnt)
		table.insert(t2,t1[rnum])
		table.remove(t1,rnum)
	end
	for k,v in pairs(t1)do
		v:SetTeam(1)
		v:Spawn()
	end
	for k,v in pairs(t2)do
		v:SetTeam(2)
		v:Spawn()
	end
end

function ScrambleALL()--debug function
	local t1 = {}
	local t2 = {}

	for k,v in pairs(player.GetAll())do
		if(v:Team() == 3 or v:Team() == 0)then
			table.insert(t1,v)
		end
	end

	local pamnt = math.ceil(table.Count(t1)/2)
	for i = 1,pamnt do
		local rnum = math.random(1,pamnt)
		table.insert(t2,t1[rnum])
		table.remove(t1,rnum)
	end
	for k,v in pairs(t1)do
		v:SetTeam(1)
		v:Spawn()
	end
	for k,v in pairs(t2)do
		v:SetTeam(2)
		v:Spawn()
	end
end