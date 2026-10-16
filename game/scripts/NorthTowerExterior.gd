extends RefCounted
const Kit=preload("res://scripts/FacadeKit.gd")
const MASTER_ID="res://scripts/NorthTowerExterior.gd"
static var bay_width := 3.6

static func build(root: Node3D, data: Dictionary, points: Array, base: float, height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+0.25)
	var kit:=Kit.new()
	var story: float=height/int(data.floors)
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var edge:=Vector3(q[0]-a.x,0,q[1]-a.z)
		var length:=edge.length()
		if length<0.1: continue
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		var bays:=maxi(1,int(round(length/bay_width)))
		var spacing:=length/bays
		var narrow: bool=length<19 and length>5
		for bay in bays:
			var mid:=a+tangent*((bay+0.5)*spacing)
			var width: float=minf(0.9,spacing*0.36) if narrow else spacing*0.72
			for level in int(data.floors):
				var wh: float=story-0.38 if narrow else 2.05
				var center:=mid+Vector3.UP*((level+0.5)*story)
				kit.window(center,tangent,normal,width,wh,yaw,true,"white_frame")
				var pier: float=(spacing-width)*0.5
				for side in [-1,1]:
					kit.part("concrete",center+tangent*side*(width*0.5+pier*0.5)+normal*0.16,Vector3(pier,story,0.32),yaw)
					kit.part("concrete",center+Vector3.UP*side*(wh*0.5+(story-wh)*0.25)+normal*0.12,Vector3(width,(story-wh)*0.5,0.24),yaw)
				if not narrow:
					kit.part("concrete",mid+Vector3.UP*(level*story)+normal*0.32,Vector3(spacing,0.18,0.78),yaw)
			kit.part("concrete",mid-tangent*spacing*0.5+Vector3.UP*height*0.5+normal*0.40,Vector3(0.20,height,0.8),yaw)
		kit.part("concrete",a+edge*0.5+Vector3.UP*(height+0.12)+normal*0.35,Vector3(length+0.5,0.25,1.35),yaw)
	kit.finish(root,"North")
