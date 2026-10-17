extends RefCounted
# Hamilton-only envelope from the user's sign-identified photographs.
# Footprint, four floors and grade retained; exact bay count/orientation estimated.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const MASTER_ID="res://scripts/HamiltonExterior.gd"
static var cache: Dictionary={}
static var bay_width:=5.8

static func material(key: String) -> Material:
	if cache.has(key): return cache[key]
	var colors: Dictionary={"stucco":"878b85","siding":"b6b9b0","white_frame":"c8cec5","glass":"53686a","reveal":"747c76","fascia":"717773","stone":"737974","curtain":"aeb7ad"}
	var mat:=Geo.material(Color(colors[key]),0.30 if key=="glass" else 0.9)
	if key in ["siding","stucco","stone"]:
		var pixels:=Image.create(128,128,false,Image.FORMAT_RGB8)
		for y in 128:
			for x in 128:
				var shade: float=0.97+0.025*sin(float(x*17+y*31))
				if key=="siding": shade=0.78 if y%8==0 else (1.0 if y%8==1 else 0.97)
				if key=="stone":
					var row:=int(y/16)
					shade=0.66 if y%16==0 or (x+row*13)%32==0 else 0.86+0.12*sin(float(int((x+row*13)/32)*19+row*31))
				pixels.set_pixel(x,y,Color(shade,shade,shade))
		pixels.generate_mipmaps()
		mat.albedo_texture=ImageTexture.create_from_image(pixels)
		mat.uv1_triplanar=true
		mat.uv1_world_triplanar=true
		mat.uv1_scale=Vector3.ONE*(0.5 if key=="siding" else 0.65)
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
		# Low overhanging fascia and gutters, not a tower parapet vocabulary.
		kit.part("fascia",a+edge*0.5+Vector3.UP*(height+0.1)+normal*0.28,Vector3(length+0.30,0.2,0.9),yaw)
		kit.part("white_frame",a+edge*0.5+Vector3.UP*height+normal*0.73,Vector3(length+0.25,0.08,0.10),yaw)
		kit.part("stone",a+edge*0.5+Vector3.UP*0.18+normal*0.08,Vector3(length,0.36,0.18),yaw)
		if length<3: continue
		var bays:=maxi(1,int(round(length/bay_width)))
		var spacing:=length/bays
		# Recessed central block on the original stepped north frontage has stucco.
		var central_block: bool=length>14 and length<16
		for bay in bays:
			var mid:=a+tangent*((bay+0.5)*spacing)
			var projected: bool=not central_block and length>20
			var depth: float=0.40 if projected else 0.10
			var panel_width: float=spacing-0.65 if projected else spacing-0.2
			if projected:
				kit.part("siding",mid+Vector3.UP*height*0.5+normal*0.16,Vector3(panel_width,height-0.3,0.36),yaw)
				for side in [-1,1]:
					kit.part("white_frame",mid+tangent*side*panel_width*0.5+Vector3.UP*height*0.5+normal*0.39,Vector3(0.07,height-0.3,0.08),yaw)
			for level in int(data.floors):
				if central_block and level==0 and absf((mid-(a+edge*0.5)).dot(tangent))<4.0: continue
				if level==0 and absf((mid-door).dot(tangent))<spacing*0.5+1.6 and absf((mid-door).dot(normal))<0.5: continue
				var center:=mid+Vector3.UP*(level*story+1.6)+normal*depth
				var wh:=2.25
				var width: float=(panel_width-0.26)*0.5 if projected else minf(1.65,spacing*0.48)
				for half in ([-1,1] if projected else [0]):
					var window: Vector3=center+tangent*half*(width*0.5+0.045)
					kit.window(window,tangent,normal,width,wh,yaw,false,"white_frame")
					kit.part("white_frame",window+tangent*width*0.25+normal*0.16,Vector3(0.06,wh,0.085),yaw)
					kit.part("white_frame",window-Vector3.UP*wh*0.22+normal*0.16,Vector3(width,0.06,0.085),yaw)
					if (bay+level+half)%3==0:
						kit.part("curtain",window-tangent*width*0.25+normal*0.05,Vector3(width*0.3,wh-0.12,0.018),yaw)
				kit.part("white_frame",mid+Vector3.UP*(level*story+0.38)+normal*(depth+0.10),Vector3(panel_width,0.07,0.15),yaw)
			if bay==0 or bay==bays-1:
				kit.part("fascia",mid-tangent*spacing*0.46+Vector3.UP*height*0.5+normal*0.5,Vector3(0.08,height,0.08),yaw)
	# Keep the old east route anchor as a closed secondary door, not a broad portico.
	var secondary_normal:=Vector3(data.outdoor_anchor[0]-door.x,0,data.outdoor_anchor[1]-door.z).normalized()
	kit.window(door+Vector3.UP*1.25+secondary_normal*0.18,Vector3(secondary_normal.z,0,-secondary_normal.x),secondary_normal,2.1,2.4,atan2(secondary_normal.x,secondary_normal.z),false,"white_frame")
	# Official level2 plan labels north toward the Towers and shows the central
	# projecting entrance block. Ground doorway position within it is photo-inferred.
	var p: Array=data.footprint
	var entry_a:=Vector3(p[4][0],base,p[4][1])
	var entry_b:=Vector3(p[5][0],base,p[5][1])
	door=(entry_a+entry_b)*0.5
	door.y=Geo.elevation(door.x,door.z)
	var along: Vector3=(entry_b-entry_a).normalized()
	var normal:=Vector3(along.z,0,-along.x)
	root.set_meta("photo_entrance",door)
	root.set_meta("photo_entrance_normal",normal)
	preload("res://scripts/HamiltonPaving.gd").build(root,door,normal)
	var tangent:=Vector3(normal.z,0,-normal.x)
	var yaw:=atan2(normal.x,normal.z)
	# Broad flat portico shown in sign-identified photo, on the central north block.
	var canopy:=Geo.box(root,door+normal*0.85+Vector3.UP*3.0,Vector3(11.0,0.40,2.1),material("stucco"),true)
	canopy.name="HamiltonEntrancePortico"
	canopy.rotation.y=yaw
	for side in [-1,1]:
		var column:=Geo.box(root,door+tangent*side*5.15+normal*1.35+Vector3.UP*1.4,Vector3(0.32,2.8,0.32),material("stucco"),true)
		column.rotation.y=yaw
		column.name="HamiltonPorticoColumn"
	var entry:=door+normal*0.3+Vector3.UP*1.3
	kit.window(entry,tangent,normal,2.6,2.5,yaw,false,"white_frame")
	kit.part("white_frame",entry+normal*0.18,Vector3(0.06,2.5,0.09),yaw)
	for side in [-1,1]:
		kit.part("white_frame",entry+tangent*side*0.16+normal*0.25,Vector3(0.035,0.4,0.04),yaw)
		kit.window(entry+tangent*side*2.6,tangent,normal,2.1,2.5,yaw,false,"white_frame")
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,material(key),null,420).name="Hamilton"+key.capitalize()

