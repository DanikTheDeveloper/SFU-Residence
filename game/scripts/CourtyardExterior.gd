extends RefCounted
# Courtyard-specific precast facade, distinct from both tower families.
# Photo-supported vocabulary; bay counts and wing-specific exceptions provisional.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const MASTER_ID="res://scripts/CourtyardExterior.gd"
static var bay_width:=2.85
static var palette: Dictionary={}

static func material(key: String) -> Material:
	if palette.is_empty():
		palette={"panel":Geo.material(Color("cecdc5"),0.9),"ribbed":Geo.material(Color("bbbdb7"),0.92),"glass":Geo.material(Color("416775"),0.29),"frame":Geo.material(Color("293638"),0.72),"reveal":Geo.material(Color("454b48")),"red":Geo.material(Color("a74c3c")),"cap":Geo.material(Color("a6aaa5"))}
		var image:=Image.create(128,128,false,Image.FORMAT_RGB8)
		for y in 128:
			for x in 128:
				var v: float=0.80 if x%8<2 else 1.0
				image.set_pixel(x,y,Color(v,v,v))
		image.generate_mipmaps()
		palette.ribbed.albedo_texture=ImageTexture.create_from_image(image)
		palette.ribbed.uv1_scale=Vector3(2,1,1)
	return palette[key]

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
		var bays:=maxi(1,int(round(length/bay_width)))
		var spacing:=length/bays
		for bay in bays:
			var mid:=a+tangent*((bay+0.5)*spacing)
			for level in int(data.floors):
				# Leave the mapped entrance clear of the repeated facade piers.
				if level==0 and Vector2(mid.x,mid.z).distance_to(Vector2(data.entrance[0],data.entrance[1]))<2.1: continue
				var center:=mid+Vector3.UP*((level+0.5)*story)
				var podium: bool=level<2
				var width: float=spacing*0.79 if podium else minf(1.1,spacing*0.40)
				var wh: float=story-0.16
				kit.window(center,tangent,normal,width,wh,yaw,false)
				kit.part("frame",center+Vector3.UP*(wh*0.18)+normal*0.17,Vector3(width,0.055,0.10),yaw)
				var pier: float=(spacing-width)*0.5
				for side in [-1,1]:
					kit.part("ribbed" if (bay+side)%2==0 else "panel",center+tangent*side*(width*0.5+pier*0.5)+normal*0.19,Vector3(pier,story,0.38),yaw)
				if level>=2 and length>20:
					kit.part("red",center-tangent*(width*0.5+0.045)+normal*0.18,Vector3(0.10,wh,0.28),yaw)
				if level%2==0 or level==2:
					kit.part("frame",mid+Vector3.UP*(level*story)+normal*0.23,Vector3(spacing,0.10,0.48),yaw)
		kit.part("panel",a+edge*0.5+Vector3.UP*(height-0.38)+normal*0.18,Vector3(length,0.76,0.40),yaw)
		kit.part("cap",a+edge*0.5+Vector3.UP*(height+0.10)+normal*0.20,Vector3(length+0.12,0.20,0.48),yaw)
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,material(key),null,450).name="Courtyard"+key.capitalize()
