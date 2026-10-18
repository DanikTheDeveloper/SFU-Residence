extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const Field=preload("res://scripts/BeedieField.gd")

static func extend_boundary(original: PackedVector2Array) -> PackedVector2Array:
	var record: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/field4.json"))
	var poly:=PackedVector2Array()
	for p in record.points: poly.append(Vector2(p[0],p[1]))
	var expanded:=Geometry2D.offset_polygon(poly,8.0)
	var merged:=Geometry2D.merge_polygons(original,expanded[0])
	assert(merged.size()==1,"Field4 study extension must remain connected")
	return merged[0]

static func build(world: Node3D) -> void:
	var data: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/field4.json"))
	var root:=Node3D.new()
	root.name="Field4"
	world.get_node("Props").add_child(root)
	root.set_meta("finished_level_estimate",data.height_estimate_m)
	var points: Array=data.points
	var a:=Geo.point(points[3])
	var u: Vector3=(Geo.point(points[2])-a).normalized()
	var v: Vector3=(Geo.point(points[0])-a).normalized()
	u.y=0; v.y=0
	u=u.normalized(); v=v.normalized()
	var length: float=Vector2(points[3][0],points[3][1]).distance_to(Vector2(points[2][0],points[2][1]))
	var width: float=Vector2(points[3][0],points[3][1]).distance_to(Vector2(points[0][0],points[0][1]))
	var mat:=Geo.material(Color("476a45"),0.98)
	var grain:=Image.create(128,128,false,Image.FORMAT_RGB8)
	var rng:=RandomNumberGenerator.new()
	rng.seed=32528090
	for y in 128:
		for x in 128:
			var tone: float=rng.randf_range(0.88,1.0)
			grain.set_pixel(x,y,Color(tone,tone,tone))
	grain.generate_mipmaps()
	mat.albedo_texture=ImageTexture.create_from_image(grain)
	mat.uv1_triplanar=true; mat.uv1_world_triplanar=true
	Geo.polygon(root,points,mat,0.045).name="MappedArtificialTurf"
	var kit:=Kit.new()
	var line:=Geo.material(Color("d5d7cd"))
	var steel:=Geo.material(Color("aeb9b4"))
	# Conservative soccer layout inside mapped playing surface. Dimensions estimated.
	var margin:=3.0
	for x in [margin,length-margin]: mark(kit,a+u*x+v*margin,a+u*x+v*(width-margin))
	for z in [margin,width-margin]: mark(kit,a+u*margin+v*z,a+u*(length-margin)+v*z)
	mark(kit,a+u*length*0.5+v*margin,a+u*length*0.5+v*(width-margin))
	var center: Vector3=a+u*length*0.5+v*width*0.5
	for i in 64:
		mark(kit,center+u*cos(i*TAU/64)*9.15+v*sin(i*TAU/64)*9.15,center+u*cos((i+1)*TAU/64)*9.15+v*sin((i+1)*TAU/64)*9.15)
	for end in [0,1]:
		var origin: Vector3=a+u*(margin if end==0 else length-margin)+v*width*0.5
		var inward: Vector3=u*(1 if end==0 else -1)
		for size in [Vector2(5.5,9.16),Vector2(16.5,20.16)]:
			mark(kit,origin-v*size.y,origin+inward*size.x-v*size.y)
			mark(kit,origin+v*size.y,origin+inward*size.x+v*size.y)
			mark(kit,origin+inward*size.x-v*size.y,origin+inward*size.x+v*size.y)
		goal(root,kit,origin,v,-inward)
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,line if key=="line" else steel,null,260).name="Pitch"+key.capitalize()

static func mark(kit: RefCounted,a: Vector3,b: Vector3) -> void:
	a.y=Geo.elevation(a.x,a.z)+0.071
	b.y=Geo.elevation(b.x,b.z)+0.071
	Field.bar(kit,"line",a,b,0.10,0.012)

static func goal(root: Node3D,kit: RefCounted,p: Vector3,across: Vector3,back: Vector3) -> void:
	var yaw: float=-atan2(across.z,across.x)
	for side in [-1,1]:
		var post: Vector3=p+across*side*3.66
		kit.part("steel",post+Vector3.UP*1.22,Vector3(0.10,2.44,0.10),yaw)
		preload("res://scripts/ShellCourtyard.gd").collision_box(root,post+Vector3.UP*1.22,Vector3(0.10,2.44,0.10),yaw)
		Field.bar(kit,"steel",post+back*1.6+Vector3.UP*0.08,post+Vector3.UP*0.08,0.06,0.06)
	Field.bar(kit,"steel",p-across*3.66+Vector3.UP*2.44,p+across*3.66+Vector3.UP*2.44,0.10,0.10)
	# Lightweight original grid net. No transparent material or gameplay physics.
	for i in 37:
		var q: Vector3=p+across*(-3.6+i*0.2)+back*1.6
		kit.part("steel",q+Vector3.UP*1.22,Vector3(0.012,2.44,0.012),yaw)
	for i in 13:
		Field.bar(kit,"steel",p-across*3.66+back*1.6+Vector3.UP*i*0.2,p+across*3.66+back*1.6+Vector3.UP*i*0.2,0.012,0.012)
