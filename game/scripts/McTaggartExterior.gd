extends RefCounted
# Distinct 2025 envelope-renewal vocabulary; dimensions/bay placement estimated.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const MASTER_ID="res://scripts/McTaggartExterior.gd"
static var bay_width := 3.25
static var brick: StandardMaterial3D

static func brick_material() -> StandardMaterial3D:
	if brick: return brick
	brick=Geo.material(Color("555863"),0.92)
	var image:=Image.create(128,128,false,Image.FORMAT_RGB8)
	for y in 128:
		for x in 128:
			var row:=int(y/8)
			var joint: bool=y%8==0 or (x+(16 if row%2 else 0))%32==0
			var v: float=0.72 if joint else 0.94+0.05*sin(float(x*13+y*7))
			image.set_pixel(x,y,Color(v,v,v))
	image.generate_mipmaps()
	brick.albedo_texture=ImageTexture.create_from_image(image)
	brick.uv1_triplanar=true
	brick.uv1_world_triplanar=true
	brick.uv1_scale=Vector3(0.5,0.5,0.5)
	return brick

static func build(root: Node3D, data: Dictionary, points: Array, base: float, height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+0.20)
	var kit:=Kit.new()
	var story: float=height/int(data.floors)
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var edge:=Vector3(q[0]-a.x,0,q[1]-a.z)
		var length:=edge.length()
		if length<0.2: continue
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		kit.part("fascia",a+edge*0.5+Vector3.UP*(height+0.10),Vector3(length+0.15,0.20,0.5),yaw)
		if length<3.2: continue
		var bays:=maxi(1,int(length/bay_width))
		var spacing:=length/bays
		for bay in bays:
			var mid:=a+tangent*((bay+0.5)*spacing)
			# Reserve the mapped connector opening; avoid overlapping ordinary
			# room windows with its wider glazing and the ground-level door.
			if Vector2(mid.x,mid.z).distance_to(Vector2(data.entrance[0],data.entrance[1]))<2.8: continue
			for level in int(data.floors):
				var center:=mid+Vector3.UP*((level+0.5)*story)
				var width:=minf(1.38,spacing*0.48)
				var wh:=story*0.72
				kit.part("bronze",center+normal*0.075,Vector3(width+0.25,wh+0.22,0.15),yaw)
				kit.part("glass",center+normal*0.16,Vector3(width,wh,0.035),yaw)
				for side in [-1,1]:
					kit.part("bronze",center+tangent*side*(width*0.5)+normal*0.21,Vector3(0.09,wh+0.08,0.12),yaw)
					kit.part("bronze",center+Vector3.UP*side*(wh*0.5)+normal*0.21,Vector3(width,0.09,0.12),yaw)
				kit.part("bronze",center-Vector3.UP*(wh*0.27)+normal*0.21,Vector3(width,0.065,0.12),yaw)
				kit.part("sill",center-Vector3.UP*(wh*0.5+0.12)+normal*0.20,Vector3(width+0.22,0.12,0.35),yaw)
	# Retain mapped doorway. Upper connector rhythm is a provisional transfer
	# from the verified entrance photo, not a surveyed reconstruction.
	var door:=Vector3(data.entrance[0],base,data.entrance[1])
	var normal:=Vector3(data.outdoor_anchor[0]-door.x,0,data.outdoor_anchor[1]-door.z).normalized()
	var tangent:=Vector3(normal.z,0,-normal.x)
	var yaw:=atan2(normal.x,normal.z)
	var entry:=door+Vector3.UP*1.23+normal*0.45
	kit.part("glass",entry,Vector3(2.6,2.35,0.08),yaw)
	for side in [-1,1]:
		kit.part("fascia",entry+tangent*side*1.3+normal*0.06,Vector3(0.09,2.45,0.12),yaw)
		kit.part("fascia",entry+Vector3.UP*side*1.175+normal*0.06,Vector3(2.65,0.09,0.12),yaw)
		kit.part("fascia",entry+tangent*side*0.12+normal*0.13,Vector3(0.035,0.32,0.08),yaw)
	kit.part("fascia",entry+normal*0.06,Vector3(0.065,2.35,0.12),yaw)
	for level in range(1,int(data.floors)):
		var c:=door+Vector3.UP*((level+0.5)*story)+normal*0.24
		kit.part("glass",c,Vector3(3.4,story*0.62,0.10),yaw)
		kit.part("fascia",c-Vector3.UP*(story*0.41)+normal*0.10,Vector3(3.6,story*0.22,0.25),yaw)
		kit.part("fascia",c+normal*0.08,Vector3(0.08,story*0.62,0.15),yaw)
	for side in [-1,1]:
		kit.part("fascia",door+tangent*side*1.5+normal*0.65+Vector3.UP*1.4,Vector3(0.16,2.8,0.16),yaw)
	var palette: Dictionary={"bronze":Geo.material(Color("71695c"),0.65),"sill":Geo.material(Color("464a4f")),"fascia":Geo.material(Color("aab0b5"),0.64),"glass":Geo.material(Color("46575b"),0.27)}
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,palette[key],null,420).name="McTaggart"+key.capitalize()
