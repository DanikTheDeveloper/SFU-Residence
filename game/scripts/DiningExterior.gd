extends RefCounted
# Two exterior vocabularies within the existing merged footprint: old south wing
# from handpicked photos; north 2022 extension from DIALOG render/construction views.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const MASTER_ID="res://scripts/DiningExterior.gd"
static var cache: Dictionary={}

static func material(key: String) -> Material:
	if cache.has(key): return cache[key]
	var colors: Dictionary={"concrete":"b8b09b","dark":"454b49","glass":"4e6a6e","frame":"a4b1aa","screen":"797d72","wood":"ac8356","cap":"c2c4ba","reveal":"777d71"}
	var mat:=Geo.material(Color(colors[key]),0.26 if key=="glass" else 0.88)
	if key in ["concrete","screen","wood"]:
		var pixels:=Image.create(128,128,false,Image.FORMAT_RGB8)
		for y in 128:
			for x in 128:
				var shade: float=0.985+0.006*sin(float(x*13+y*37))
				if key=="concrete":
					if y%32==0 or x%64==0: shade-=0.025
					if x%32==8 and y%32==8: shade-=0.14
				elif key=="screen": shade=0.58 if x%4<2 and y%4<2 else 0.94
				else: shade-=0.22 if x%8==0 else 0.0
				pixels.set_pixel(x,y,Color(shade,shade,shade))
		pixels.generate_mipmaps()
		mat.albedo_texture=ImageTexture.create_from_image(pixels)
		mat.uv1_triplanar=true
		mat.uv1_world_triplanar=true
		mat.uv1_scale=Vector3.ONE*0.35
	cache[key]=mat
	return mat

static func source_edge(mid: Vector3,data: Dictionary) -> int:
	var closest:=0
	var distance:=INF
	var point:=Vector2(mid.x,mid.z)
	for i in data.footprint.size():
		var p: Array=data.footprint[i]
		var q: Array=data.footprint[(i+1)%data.footprint.size()]
		var d: float=point.distance_to(Geometry2D.get_closest_point_to_segment(point,Vector2(p[0],p[1]),Vector2(q[0],q[1])))
		if d<distance:
			closest=i
			distance=d
	return closest

static func glazing(kit: RefCounted,center: Vector3,tangent: Vector3,normal: Vector3,width: float,height: float,yaw: float) -> void:
	kit.part("glass",center+normal*0.12,Vector3(width,height,0.06),yaw)
	var bays:=maxi(1,int(round(width/1.45)))
	for i in range(bays+1):
		kit.part("frame",center+tangent*(float(i)/bays-0.5)*width+normal*0.20,Vector3(0.065,height+0.12,0.14),yaw)
	var rows:=maxi(1,int(round(height/2.1)))
	for i in range(rows+1):
		kit.part("frame",center+Vector3.UP*(float(i)/rows-0.5)*height+normal*0.20,Vector3(width,0.065,0.14),yaw)

static func build(root: Node3D,data: Dictionary,points: Array,base: float,height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+0.45)
	root.set_meta("exterior_zones",["original_concrete_south","north_2022_extension"])
	var kit:=Kit.new()
	var grade:=PackedVector3Array()
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var edge:=Vector3(q[0]-a.x,0,q[1]-a.z)
		var length:=edge.length()
		if length<0.1: continue
		var mid:=a+edge*0.5
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		var original_edge:=source_edge(mid,data)
		# Extend the visible plinth to the unchanged sampled grade, not a new pad.
		var segments:=maxi(1,int(ceil(length)))
		for segment in segments:
			var left: Vector3=a+edge*(float(segment)/segments)+normal*0.24
			var right: Vector3=a+edge*(float(segment+1)/segments)+normal*0.24
			var bottom_left:=Vector3(left.x,minf(base-0.06,Geo.elevation(left.x,left.z)-0.06),left.z)
			var bottom_right:=Vector3(right.x,minf(base-0.06,Geo.elevation(right.x,right.z)-0.06),right.z)
			left.y=base+0.3
			right.y=base+0.3
			grade.append_array([bottom_left,right,bottom_right,bottom_left,left,right])
		var modern: bool=original_edge>=2 and original_edge<=9
		if modern:
			# Northern long wall and service projections are dark with clerestory.
			var glass_end: bool=original_edge in [2,8]
			kit.part("dark",mid+Vector3.UP*height*0.5+normal*0.09,Vector3(length,height,0.20),yaw)
			if length>4:
				if glass_end:
					glazing(kit,mid+Vector3.UP*(height*0.49),tangent,normal,length-0.7,height*0.91,yaw)
				else:
					glazing(kit,mid+Vector3.UP*(height-1.1),tangent,normal,length-0.7,1.35,yaw)
					for seam in [2.8,5.7,8.5]:
						kit.part("frame",mid+Vector3.UP*seam+normal*0.22,Vector3(length,0.035,0.045),yaw)
			# Render confirms pale cap and warm slatted soffit; final finish is provisional.
			var overhang: float=3.0 if glass_end else 1.4
			kit.part("cap",mid+Vector3.UP*(height+0.22)+normal*(overhang*0.3),Vector3(length+0.20,0.45,overhang),yaw)
			kit.part("wood",mid+Vector3.UP*(height-0.035)+normal*(overhang*0.3),Vector3(length+0.16,0.06,overhang-0.04),yaw)
		else:
			kit.part("concrete",mid+Vector3.UP*(height-0.10)+normal*0.5,Vector3(length+0.18,0.8,2.0),yaw)
			if length<4: continue
			var solid_upper: bool=original_edge in [12,14]
			if solid_upper:
				# Large opaque service/end boxes are visible in the user's second photo.
				glazing(kit,mid+Vector3.UP*1.7,tangent,normal,length*0.72,2.8,yaw)
			else:
				glazing(kit,mid+Vector3.UP*(height*0.48),tangent,normal,length-1.0,height*0.85,yaw)
				for sign_value in [-1,1]:
					kit.part("concrete",mid+tangent*sign_value*(length*0.5-0.45)+Vector3.UP*height*0.5+normal*0.30,Vector3(0.9,height,0.8),yaw)
				if length>10 and original_edge not in [11]:
					kit.part("screen",mid+Vector3.UP*(height*0.67)+normal*0.60,Vector3(length-1.3,1.8,0.12),yaw)
					for rail in [-1,0,1]:
						kit.part("frame",mid+Vector3.UP*(height*0.67+rail*0.87)+normal*0.68,Vector3(length-1.3,0.06,0.09),yaw)
			kit.part("concrete",mid+Vector3.UP*0.38+normal*0.18,Vector3(length,0.76,0.5),yaw)
	Geo.mesh_from_vertices(root,grade,material("concrete"),true).name="DiningGradeStem"
	# Closed entrance follows existing route anchor. No interior geometry or transparency.
	var door:=Geo.point(data.entrance)
	var normal:=Vector3(data.outdoor_anchor[0]-door.x,0,data.outdoor_anchor[1]-door.z).normalized()
	var tangent:=Vector3(normal.z,0,-normal.x)
	var yaw:=atan2(normal.x,normal.z)
	kit.window(door+Vector3.UP*1.3+normal*0.32,tangent,normal,2.8,2.5,yaw,false,"frame")
	kit.part("frame",door+Vector3.UP*1.3+normal*0.52,Vector3(0.065,2.5,0.10),yaw)
	for side in [-1,1]:
		kit.part("frame",door+tangent*side*0.18+Vector3.UP*1.25+normal*0.61,Vector3(0.035,0.42,0.045),yaw)
	# Original OSM west-wall entrance directly above the North-gallery approach.
	var mapped: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/dining_gallery_entrance.json"))
	var west_door:=Vector3(mapped.point[0],base+0.10,mapped.point[1])
	var west_tangent:=Vector3(0.228793,0,-0.973475)
	var west_normal:=Vector3(-0.973475,0,-0.228793)
	var west_yaw: float=-atan2(west_tangent.z,west_tangent.x)
	kit.window(west_door+west_normal*0.30+Vector3.UP*1.25,west_tangent,west_normal,1.6,2.5,west_yaw,true,"frame")
	kit.part("frame",west_door+west_normal*0.50+Vector3.UP*1.25,Vector3(0.06,2.5,0.08),west_yaw)
	root.set_meta("gallery_entrance",west_door)
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,material(key),null,420).name="Dining"+key.capitalize()
