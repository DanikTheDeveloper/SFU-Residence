extends RefCounted
# Original meshes, referenced to the OSM outline and official SFU Athletics photos.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")

static func data() -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string("res://data/beedie_field.json"))

static func extend_boundary(original: PackedVector2Array) -> PackedVector2Array:
	var poly:=PackedVector2Array()
	for p in data().points: poly.append(Vector2(p[0],p[1]))
	var expanded:=Geometry2D.offset_polygon(poly,8.0)
	var merged:=Geometry2D.merge_polygons(original,expanded[0])
	assert(merged.size()==1,"Beedie study extension must remain connected")
	return merged[0]

static func build(world: Node3D) -> void:
	var root:=Node3D.new()
	root.name="BeedieField"
	world.get_node("Props").add_child(root)
	var record:=data()
	var level: float=record.height_estimate_m
	root.set_meta("finished_level_estimate",level)
	var materials: Dictionary={"turf":Geo.material(Color("4b7140")),"infield":Geo.material(Color("bd9363")),"track":Geo.material(Color("974f40")),"screen":Geo.material(Color("344b5d")),"steel":Geo.material(Color("7e8986")),"yellow":Geo.material(Color("c4b44e")),"white":Geo.material(Color("dedbd0")),"concrete":Geo.material(Color("92958c")),"roof":Geo.material(Color("9ca8a4")),"score":Geo.material(Color("7f3c37"))}
	var grass: StandardMaterial3D=materials.turf
	var texture:=Image.create(128,128,false,Image.FORMAT_RGB8)
	var grain:=RandomNumberGenerator.new()
	grain.seed=32528092
	for y in 128:
		for x in 128:
			var shade: float=grain.randf_range(0.88,1.0)
			texture.set_pixel(x,y,Color(shade,shade,shade))
	texture.generate_mipmaps()
	grass.albedo_texture=ImageTexture.create_from_image(texture)
	grass.uv1_triplanar=true
	grass.uv1_world_triplanar=true
	grass.uv1_scale=Vector3.ONE*0.4
	Geo.polygon(root,record.points,grass,0.035).name="SportsTurf"
	var home:=Vector3(91,level,139)
	var first:=Vector3(0.970,0,0.243).normalized()
	var third:=Vector3(-first.z,0,first.x)
	var kit:=Kit.new()
	# Infield sector and rubber warning-track band; dimensions are estimates.
	var infield: Array=[[home.x,home.z]]
	for i in 33:
		var p: Vector3=home+(first*cos(i*PI/64)+third*sin(i*PI/64))*29
		infield.append([p.x,p.z])
	Geo.polygon(root,infield,materials.infield,0.055).name="SandSiltInfield"
	for i in range(3,11):
		var a:=Geo.point(record.points[i])
		var b:=Geo.point(record.points[i+1])
		var ai: Vector3=a+(home-a).normalized()*3.0
		var bi: Vector3=b+(home-b).normalized()*3.0
		Geo.polygon(root,[[a.x,a.z],[b.x,b.z],[bi.x,bi.z],[ai.x,ai.z]],materials.track,0.058)
	# White foul lines and original simple bases; no game simulation.
	for axis in [first,third]:
		bar(kit,"white",home+Vector3.UP*0.070,home+axis*55+Vector3.UP*0.070,0.09,0.012)
	for pair in [Vector2(0,0),Vector2(18.288,0),Vector2(18.288,18.288),Vector2(0,18.288)]:
		kit.part("white",home+first*pair.x+third*pair.y+Vector3.UP*0.10,Vector3(0.38,0.05,0.38),-atan2(first.z,first.x))
	var pitch: Vector3=home+(first+third).normalized()*13.11
	kit.part("white",pitch+Vector3.UP*0.085,Vector3(0.61,0.025,0.15),-atan2(first.z,first.x))
	for i in 48:
		var a: Vector3=pitch+Vector3(cos(i*TAU/48)*2.44,0.076,sin(i*TAU/48)*2.44)
		var b: Vector3=pitch+Vector3(cos((i+1)*TAU/48)*2.44,0.076,sin((i+1)*TAU/48)*2.44)
		bar(kit,"white",a,b,0.07,0.01)
	for i in record.points.size():
		var a:=Geo.point(record.points[i])
		var b:=Geo.point(record.points[(i+1)%record.points.size()])
		# Access opening at the home-plate end, rather than trapping the player.
		if i==0:
			fence(root,kit,a,b-(b-a).normalized()*3.2,2.4,false)
			continue
		var height: float=2.0 if i>=3 and i<=10 else 2.4
		fence(root,kit,a,b,height,i>=3 and i<=10)
	# Tall backstop behind home; grid uses batched thin bars instead of transparency.
	fence(root,kit,Vector3(83,level,136),Vector3(86,level,129),9.0,false)
	fence(root,kit,Vector3(86,level,129),Vector3(96,level,131.5),9.0,false)
	for p in [[88,125],[127,136],[157,153],[136,194],[88,206],[65,175]]:
		var base:=Geo.point(p)
		kit.part("steel",base+Vector3.UP*9,Vector3(0.20,18,0.20),0)
		kit.part("steel",base+Vector3.UP*18,Vector3(2.8,0.14,0.14),0)
		for j in 4: kit.part("white",base+Vector3((j-1.5)*0.65,17.85,0.1),Vector3(0.46,0.36,0.26),0)
		preload("res://scripts/ShellCourtyard.gd").collision_box(root,base+Vector3.UP*1.5,Vector3(0.25,3,0.25))
	# Open-sided roofed team shelters; no residential interior or gameplay.
	dugout(root,kit,Vector3(111,level,134.7),first)
	dugout(root,kit,Vector3(76,level,158),third)
	var score:=Geo.point([103,205])
	kit.part("score",score+Vector3.UP*3.8,Vector3(6,2.6,0.15),0)
	for side in [-1,1]: kit.part("steel",score+Vector3(side*2.5,2,0),Vector3(0.15,4,0.15),0)
	var label:=Label3D.new()
	root.add_child(label)
	label.text="BEEDIE FIELD\nHOME    INNING    GUEST"
	label.position=score+Vector3(0,4,-0.09)
	label.rotation.y=PI
	label.font_size=40
	label.pixel_size=0.012
	label.modulate=Color("e0dfd0")
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,materials[key],null,300).name="Field"+key.capitalize()

static func bar(kit: RefCounted,key: String,a: Vector3,b: Vector3,width: float,height: float) -> void:
	kit.part(key,(a+b)*0.5,Vector3(a.distance_to(b),height,width),-atan2((b-a).z,(b-a).x))

static func fence(root: Node3D,kit: RefCounted,a: Vector3,b: Vector3,height: float,screen: bool) -> void:
	var length:=a.distance_to(b)
	var yaw: float=-atan2((b-a).z,(b-a).x)
	var count:=maxi(1,int(ceil(length/2.8)))
	for i in count+1:
		var p: Vector3=a.lerp(b,float(i)/count)
		kit.part("steel",p+Vector3.UP*height*0.5,Vector3(0.065,height,0.065),yaw)
	if screen:
		kit.part("screen",(a+b)*0.5+Vector3.UP*(height*0.48),Vector3(length,height*0.92,0.025),yaw)
	else:
		for i in int(length/0.35):
			var p: Vector3=a.lerp(b,(i+0.5)*0.35/length)
			kit.part("steel",p+Vector3.UP*height*0.5,Vector3(0.012,height,0.012),yaw)
		for i in int(height/0.35): bar(kit,"steel",a+Vector3.UP*i*0.35,b+Vector3.UP*i*0.35,0.012,0.012)
	bar(kit,"yellow" if screen else "steel",a+Vector3.UP*height,b+Vector3.UP*height,0.065,0.065)
	preload("res://scripts/ShellCourtyard.gd").collision_box(root,(a+b)*0.5+Vector3.UP*height*0.5,Vector3(length,height,0.07),yaw)

static func dugout(root: Node3D,kit: RefCounted,p: Vector3,axis: Vector3) -> void:
	var yaw: float=-atan2(axis.z,axis.x)
	var normal:=Vector3(axis.z,0,-axis.x)
	kit.part("concrete",p+Vector3.UP*0.08,Vector3(15.24,0.16,2.6),yaw)
	kit.part("roof",p+Vector3.UP*2.45,Vector3(15.5,0.12,2.9),yaw)
	for along in [-7.4,-2.5,2.5,7.4]:
		for side in [-1,1]: kit.part("steel",p+axis*along+normal*side*1.15+Vector3.UP*1.2,Vector3(0.09,2.4,0.09),yaw)
	kit.part("concrete",p+normal*0.85+Vector3.UP*0.45,Vector3(14.3,0.10,0.4),yaw)
	preload("res://scripts/ShellCourtyard.gd").collision_box(root,p+Vector3.UP*2.45,Vector3(15.5,0.12,2.9),yaw)
	preload("res://scripts/ShellCourtyard.gd").collision_box(root,p+normal*0.85+Vector3.UP*0.45,Vector3(14.3,0.10,0.4),yaw)


