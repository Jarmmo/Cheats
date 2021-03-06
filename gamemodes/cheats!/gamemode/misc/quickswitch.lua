NewWeapon = nil
OldWeapon = nil

hook.Add("PlayerSwitchWeapon","toon",function(ply, oldWeapon, newWeapon)
	if not IsFirstTimePredicted() then return end
	NewWeapon = newWeapon
	OldWeapon = oldWeapon
end)

hook.Add("PlayerBindPress", "QuickSwitch", function(ply, bind, pressed)
	if bind == "+menu" then
		if IsValid(OldWeapon) then
			input.SelectWeapon(OldWeapon)
		end
	end

	local weps = LocalPlayer():GetWeapons()
	local wep = LocalPlayer():GetActiveWeapon()
	if(!IsValid(wep))then return end

	table.sort(weps, function(a, b) return a:GetSlot() < b:GetSlot() end)

	if(bind == "slot1")then
		input.SelectWeapon(weps[1])
	elseif(bind == "slot2")then
		input.SelectWeapon(weps[2])
	elseif(bind == "slot3")then
		input.SelectWeapon(weps[3])
	end

	if(bind == "invnext")then
		if(wep:GetSlot() == table.Count(weps)-1)then
			input.SelectWeapon(weps[1])
		else
			input.SelectWeapon(weps[wep:GetSlot()+2])
		end
	elseif(bind == "invprev")then
		if(wep:GetSlot() == 0)then
			input.SelectWeapon(weps[table.Count(weps)])
		else
			input.SelectWeapon(weps[wep:GetSlot()])
		end
	end
end)