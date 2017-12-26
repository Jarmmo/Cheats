function CameraTarget(aaB,Range)
	hook.Remove("CalcView","ctp_CalcView")
	--RunConsoleCommand("ctp")
	if not Range then Range = 120 end
	Range = Range *-1
	function PointOnCircle( ang, radius)
		ang = math.rad( ang )
		local x = math.cos( ang ) * radius
		local y = math.sin( ang ) * radius
		return x, y
	end
	function PointOnCircle2( ang, radius)
		ang = math.rad( ang )
		local z = math.atan( ang ) * radius
		return z
	end
	function aaaBB(targg,distans,dist2)
		x,y = PointOnCircle( LocalPlayer():EyeAngles().y, distans)
		z = PointOnCircle2(-LocalPlayer():EyeAngles().x , distans)
		return (Vector(x,y,z)+targg:GetPos())
	end	
	function camstop()
		hook.Remove("Think", "noggered")
		hook.Remove("CalcView", "StalkTarget")
		myview = nil
		aaB = nil
		PointOnCircle = nil
		PointOnCircle2 = nil
		aaaBB = nil
		hook.Remove("Think", "noggered")
		hook.Remove("CalcView", "StalkTarget")
		hook.Remove( "HUDPaint", "noggered")
		meme = nil
	end
	function myview()
		angles = LocalPlayer():EyeAngles()
		
		angles.x = angles.x * 0.7
		thing = aaaBB(aaB,Range,Range)
		view = {}
		view.origin = thing+Vector(0,0,70)
		view.angles = angles
		view.fov = 90
		view.drawviewer = true
		return view
	end
	hook.Add( "CalcView", "StalkTarget", myview)
end
