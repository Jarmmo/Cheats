NewWeapon = nil
OldWeapon = nil

hook.Add("PlayerSwitchWeapon","toon",function(ply, oldWeapon, newWeapon)
	if not IsFirstTimePredicted() then return end
	NewWeapon = newWeapon
	OldWeapon = oldWeapon
end)

hook.Add( "PlayerBindPress", "QuickSwitch", function( ply, bind, pressed )
	if bind == "+menu" then
		if OldWeapon:IsValid() then
			input.SelectWeapon(OldWeapon)
		end
	end
end )