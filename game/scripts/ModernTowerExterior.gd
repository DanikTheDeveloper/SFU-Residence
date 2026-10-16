extends RefCounted
const Kit=preload("res://scripts/FacadeKit.gd")
const MASTER_ID="res://scripts/ModernTowerExterior.gd"
static var bay_width := 3.0
const REVISION=1

static func build(root: Node3D, data: Dictionary, points: Array, base: float, height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("family_revision",REVISION)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+0.22)
	var kit:=Kit.new()
	var story: float=height/int(data.floors)
	for i in points.size():
		var p: Array=points[i]
		var q: Array=points[(i+1)%points.size()]
		var a:=Vector3(p[0],base,p[1])
		var edge:=Vector3(q[0]-p[0],0,q[1]-p[1])
		var length:=edge.length()
		if length<0.1: continue
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		var bays:=maxi(1,int(round(length/bay_width)))
		var spacing:=length/bays
		# Central projecting stair bays are identified from preserved U-shaped footprint.
		# Exact pane dimensions remain estimated; East photos establish material language.
		var curtain: bool=length>10.0 and length<14.0
		for level in int(data.floors):
			var glazed: bool=curtain or level==0 or level==int(data.floors)-1
			var wh: float=story-0.28 if glazed else 2.05
			var width: float=spacing-0.12 if glazed else minf(1.65,spacing*0.58)
			var y: float=level*story+story*0.5
			for bay in bays:
				var center:=a+tangent*((bay+0.5)*spacing)+Vector3.UP*y
				kit.window(center,tangent,normal,width,wh,yaw)
				var pier: float=(spacing-width)*0.5
				for side in [-1,1]:
					kit.part("frame" if glazed else "cladding",center+tangent*side*(width*0.5+pier*0.5)+normal*0.14,Vector3(pier,story,0.28),yaw)
					kit.part("frame" if glazed else "cladding",center+Vector3.UP*side*(wh*0.5+(story-wh)*0.25)+normal*0.14,Vector3(width,(story-wh)*0.5,0.28),yaw)
				if not glazed and (bay+level)%3==1:
					kit.part("orange",center-Vector3.UP*(wh*0.5+0.25)+normal*0.294,Vector3(width*0.44,0.48,0.025),yaw)
				# Vertical metal cladding joints are geometric, not an invented brick texture.
				if not glazed:
					kit.part("cap",center-tangent*(spacing*0.5)+normal*0.285,Vector3(0.018,story,0.018),yaw)
		kit.part("cap",a+edge*0.5+Vector3.UP*(height+0.14),Vector3(length+0.20,0.28,0.65),yaw)
		kit.part("frame",a+edge*0.5+Vector3.UP*(height-story)+normal*0.25,Vector3(length,0.14,0.38),yaw)
	kit.finish(root,"Modern")
