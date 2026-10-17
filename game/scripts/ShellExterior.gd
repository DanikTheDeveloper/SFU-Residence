extends RefCounted
# Shell House facade family. Registry four-floor mass retained pending grade/level audit.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const MASTER_ID="res://scripts/ShellExterior.gd"
static var cache: Dictionary={}

static func material(key: String) -> Material:
	if cache.has(key): return cache[key]
	var colors: Dictionary={"concrete":"b0b2a7","fin":"c4c6bc","panel":"77685f","frame":"303c38","glass":"4a5c59","reveal":"7a7e74","fascia":"63413b","blind":"999b87"}
	var mat:=Geo.material(Color(colors[key]),0.32 if key=="glass" else 0.93)
	if key in ["panel","concrete"]:
		var pixels:=Image.create(128,128,false,Image.FORMAT_RGB8)
		for y in 128:
			for x in 128:
				var shade: float=0.96+0.025*sin(float(x*13+y*29))
				if key=="panel":
					if x%16==0 or y%16==0: shade=0.70
					elif x%16==1 or y%16==1: shade=1.04
				elif y%32==0: shade-=0.04
				pixels.set_pixel(x,y,Color(shade,shade,shade))
		pixels.generate_mipmaps()
		mat.albedo_texture=ImageTexture.create_from_image(pixels)
		mat.uv1_triplanar=true
		mat.uv1_world_triplanar=true
		mat.uv1_scale=Vector3.ONE*0.5
	cache[key]=mat
	return mat

static func build(root: Node3D,data: Dictionary,points: Array,base: float,height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+0.20)
	var kit:=Kit.new()
	var story: float=height/int(data.floors)
	var door:=Geo.point(data.entrance)
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var edge:=Vector3(q[0]-a.x,0,q[1]-a.z)
		var length:=edge.length()
		if length<0.1: continue
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		# Close small grade gaps below projecting facade bands without moving the pad.
		var skirt:=PackedVector3Array()
		var segments:=maxi(1,int(ceil(length)))
		for segment in segments:
			var left: Vector3=a+edge*(float(segment)/segments)+normal*0.28
			var right: Vector3=a+edge*(float(segment+1)/segments)+normal*0.28
			var bottom_left:=Vector3(left.x,minf(base-0.05,Geo.elevation(left.x,left.z)-0.05),left.z)
			var bottom_right:=Vector3(right.x,minf(base-0.05,Geo.elevation(right.x,right.z)-0.05),right.z)
			left.y=base+0.20
			right.y=base+0.20
			skirt.append_array([bottom_left,right,bottom_right,bottom_left,left,right])
		Geo.mesh_from_vertices(root,skirt,material("concrete"),true).name="ShellGradeStem"
		kit.part("concrete",a+edge*0.5+Vector3.UP*(height+0.1)+normal*0.25,Vector3(length+0.1,0.30,0.85),yaw)
		kit.part("frame",a+edge*0.5+Vector3.UP*(height+0.27)+normal*0.25,Vector3(length+0.1,0.045,0.9),yaw)
		if length<3: continue
		var bays:=maxi(1,int(round(length/3.1)))
		var spacing:=length/bays
		for level in int(data.floors):
			kit.part("concrete",a+edge*0.5+Vector3.UP*(level*story+0.28)+normal*0.20,Vector3(length,0.56,0.48),yaw)
			if level>0:
				kit.part("concrete",a+edge*0.5+Vector3.UP*(level*story-0.05)+normal*0.32,Vector3(length+0.06,0.10,0.72),yaw)
			for bay in bays:
				var mid:=a+tangent*((bay+0.5)*spacing)
				if level==0 and absf((mid-door).dot(tangent))<spacing*0.5+1.8 and absf((mid-door).dot(normal))<0.6: continue
				var center:=mid+Vector3.UP*(level*story+story*0.58)
				var panel_width: float=spacing*0.52
				var window_height: float=story*0.69
				kit.part("panel",center-Vector3.UP*0.1+normal*0.12,Vector3(panel_width,window_height+0.25,0.22),yaw)
				for side in [-1,1]:
					var window: Vector3=center+tangent*side*spacing*0.375+normal*0.06
					kit.window(window,tangent,normal,spacing*0.22,window_height,yaw,false,"frame")
					kit.part("frame",window-Vector3.UP*window_height*0.25+normal*0.16,Vector3(spacing*0.22,0.055,0.08),yaw)
					if (bay+level+side)%4==0:
						kit.part("blind",window+Vector3.UP*window_height*0.14+normal*0.045,Vector3(spacing*0.19,window_height*0.62,0.02),yaw)
				# Deep pale concrete dividers are confined to the top storey in photos.
				if level==int(data.floors)-1:
					kit.part("fin",mid-tangent*spacing*0.5+Vector3.UP*(level*story+story*0.57)+normal*0.49,Vector3(0.18,story*0.86,0.98),yaw)
	var normal:=Vector3(data.outdoor_anchor[0]-door.x,0,data.outdoor_anchor[1]-door.z).normalized()
	var tangent:=Vector3(normal.z,0,-normal.x)
	var yaw:=atan2(normal.x,normal.z)
	var entry:=door+normal*0.18+Vector3.UP*1.25
	kit.window(entry,tangent,normal,2.8,2.4,yaw,false,"frame")
	kit.part("frame",entry+normal*0.18,Vector3(0.055,2.4,0.08),yaw)
	for side in [-1,1]:
		kit.part("fin",entry+tangent*side*0.15+normal*0.25,Vector3(0.035,0.35,0.04),yaw)
	var canopy:=Geo.box(root,door+normal*0.9+Vector3.UP*2.85,Vector3(3.6,0.22,2.1),material("concrete"),true)
	canopy.rotation.y=yaw
	canopy.name="ShellEntryCanopy"
	kit.part("fascia",door+normal*1.97+Vector3.UP*2.86,Vector3(3.6,0.11,0.07),yaw)
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,material(key),null,420).name="Shell"+key.capitalize()
