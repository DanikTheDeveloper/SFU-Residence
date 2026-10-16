extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const NorthMaterials=preload("res://scripts/NorthTowerMaterials.gd")
const Passage=preload("res://scripts/NorthTowerPassage.gd")
const MASTER_ID="res://scripts/NorthTowerExterior.gd"
static var bay_width := 2.8

static func build(root: Node3D, data: Dictionary, points: Array, base: float, height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+0.25)
	var kit:=Kit.new()
	var story: float=height/int(data.floors)
	var passage:=Passage.layout(data,base)
	var door:=Geo.point(data.entrance)
	var door_normal:=Geo.point(data.outdoor_anchor)-door
	door_normal.y=0
	door_normal=door_normal.normalized()
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var edge:=Vector3(q[0]-a.x,0,q[1]-a.z)
		var length:=edge.length()
		if length<0.1: continue
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		var end_face: bool=length>9.8 and length<11.2 and absf(tangent.dot(passage.side))>0.95 and ((a+edge*0.5)-passage.start).dot(passage.axis)<-8.0
		if end_face:
			# Dark screened stair core beside a continuous narrow glazed strip.
			var stair_mid:=a+edge*0.5+Vector3.UP*height*0.5
			var projecting_end: bool=(stair_mid-passage.start).dot(passage.side)<0
			if data.id=="PJH": projecting_end=not projecting_end
			var inner_sign: float=1.0 if (passage.start-stair_mid).dot(tangent)>0 else -1.0
			var glass_along: float=length*0.5+inner_sign*(length*0.5-1.1)
			var screen_along: float=length*0.5+inner_sign*(length*0.5-3.9)
			if projecting_end:
				kit.part("stair_screen",a+tangent*screen_along+Vector3.UP*(height+story)*0.5+normal*0.18,Vector3(3.6,height-story,0.30),yaw)
			for level in int(data.floors):
				var center:=a+tangent*glass_along+Vector3.UP*((level+0.5)*story)
				kit.window(center,tangent,normal,1.9,story-0.12,yaw,true,"white_frame")
				if projecting_end:
					kit.part("concrete",a+tangent*(glass_along+screen_along)*0.5+Vector3.UP*(level*story)+normal*0.24,Vector3(5.7,0.10,0.48),yaw)
			for position in [a,a+edge]:
				kit.part("concrete",position+Vector3.UP*height*0.5+normal*0.4,Vector3(0.35,height,0.9),yaw)
			kit.part("concrete",a+edge*0.5+Vector3.UP*(height+0.12),Vector3(length+0.5,0.25,1.4),yaw)
			continue
		if length<2.3:
			kit.part("concrete",a+edge*0.5+Vector3.UP*height*0.5+normal*0.12,Vector3(length,height,0.24),yaw)
			continue
		var room_bays:=maxi(1,int(round((length-5.0)*0.5/bay_width)))
		var bays:=room_bays*2+1 if length>25 else maxi(1,int(round(length/bay_width)))
		var spacing:=length/bays
		var central_lounge_width: float=5.0 if length>25 else spacing
		var room_spacing: float=(length-central_lounge_width)/(bays-1) if length>25 else spacing
		var narrow: bool=length<19 and length>5
		var inner_wing: bool=length>10.8 and length<12.3 and absf(tangent.dot(passage.axis))>0.95
		for bay in bays:
			var lounge: bool=length>25 and bay==room_bays
			spacing=central_lounge_width if lounge else room_spacing
			var along: float=(bay+0.5)*spacing
			if length>25:
				if lounge: along=length*0.5
				elif bay<room_bays: along=(bay+0.5)*room_spacing
				else: along=room_bays*room_spacing+central_lounge_width+(bay-room_bays-0.5)*room_spacing
			var mid:=a+tangent*along
			var width: float=minf(1.25,spacing*0.46) if narrow else spacing*0.43
			if lounge: width=spacing-0.18
			for level in int(data.floors):
				# Omit ground-level modules at the real opening, including projecting fins.
				if level==0 and absf((mid-door).dot(tangent))<spacing*0.5+1.3 and absf((mid-door).dot(normal))<0.4: continue
				if level==0 and not lounge and Passage.interval(mid-tangent*spacing*0.5,mid+tangent*spacing*0.5,passage,0.35).x>=0: continue
				var window_width: float=spacing*0.88 if inner_wing and level==0 else width
				var wh: float=story-0.75 if narrow else 2.05
				if inner_wing and level==0: wh=1.4
				if lounge: wh=story-0.27
				var center:=mid+Vector3.UP*((level+0.5)*story)
				if inner_wing and level==0: center.y=base+2.05
				if lounge: center+=normal*0.65
				kit.window(center,tangent,normal,window_width,wh,yaw,true,"white_frame")
				# Exterior-only blind surface; repeatable variation, not verified room occupancy.
				if not lounge and level>0 and (bay+level)%4==0:
					kit.part("blind",center-tangent*window_width*0.16+Vector3.UP*wh*0.2+normal*0.06,Vector3(window_width*0.62,wh*0.58,0.015),yaw)
				if not lounge and not (inner_wing and level==0):
					kit.part("white_frame",center-Vector3.UP*(wh*0.5+0.2)+normal*0.31,Vector3(width,0.35,0.10),yaw)
				elif lounge:
					# Glazed returns and deep slab edges make the lounge a real projection.
					kit.part("white_frame",center-tangent*width*0.18+normal*0.16,Vector3(0.055,wh,0.085),yaw)
					for sign_value in [-1,1]:
						kit.part("glass",center+tangent*sign_value*width*0.5-normal*0.28,Vector3(0.04,wh,0.65),yaw)
						kit.part("white_frame",center+tangent*sign_value*width*0.5-normal*0.28,Vector3(0.08,0.065,0.65),yaw)
					kit.part("concrete",mid+Vector3.UP*(level*story)+normal*0.55,Vector3(spacing+0.18,0.20,1.35),yaw)
				var pier: float=(spacing-window_width)*0.5
				for side in [-1,1]:
					kit.part("concrete",center+tangent*side*(window_width*0.5+pier*0.5)+normal*0.16,Vector3(pier,story,0.32),yaw)
				var lower_height: float=maxf(0.0,center.y-base-wh*0.5-level*story)
				var upper_height: float=maxf(0.0,(level+1)*story-(center.y-base+wh*0.5))
				kit.part("concrete",center-Vector3.UP*(wh*0.5+lower_height*0.5)+normal*0.12,Vector3(window_width,lower_height,0.24),yaw)
				kit.part("concrete",center+Vector3.UP*(wh*0.5+upper_height*0.5)+normal*0.12,Vector3(window_width,upper_height,0.24),yaw)
				if not narrow:
					kit.part("concrete",mid+Vector3.UP*(level*story)+normal*0.16,Vector3(spacing,0.16,0.40),yaw)
			var fin:=mid-tangent*spacing*0.5
			var fin_bottom: float=height-story*2.0
			kit.part("concrete",fin+Vector3.UP*(height+fin_bottom)*0.5+normal*0.40,Vector3(0.20,height-fin_bottom,0.8),yaw)
		kit.part("concrete",a+edge*0.5+Vector3.UP*(height+0.12)+normal*0.35,Vector3(length+0.5,0.25,1.35),yaw)
	# Closed exterior entry only; preserve the established geographic threshold.
	var door_yaw:=atan2(door_normal.x,door_normal.z)
	var door_tangent:=Vector3(door_normal.z,0,-door_normal.x)
	kit.window(door+Vector3.UP*1.275+door_normal*0.10,door_tangent,door_normal,2.1,2.55,door_yaw,false,"white_frame")
	kit.part("white_frame",door+Vector3.UP*1.275+door_normal*0.27,Vector3(0.065,2.55,0.09),door_yaw)
	kit.part("white_frame",door+Vector3.UP*2.28+door_normal*0.27,Vector3(2.1,0.07,0.09),door_yaw)
	for side in [-1,1]:
		kit.part("white_frame",door+door_tangent*side*0.16+Vector3.UP*1.05+door_normal*0.36,Vector3(0.035,0.48,0.06),door_yaw)
	var canopy:=Geo.box(root,door+Vector3.UP*2.85+door_normal*0.9,Vector3(3.6,0.22,2.1),NorthMaterials.material("concrete"),true)
	canopy.name="NorthEntranceCanopy"
	canopy.rotation.y=door_yaw
	NorthMaterials.finish(kit,root)
	Passage.build(root,data,base,NorthMaterials.material("concrete"))
