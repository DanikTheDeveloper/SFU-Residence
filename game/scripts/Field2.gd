extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const Field=preload("res://scripts/BeedieField.gd")

static func data() -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string("res://data/field2.json"))

static func extend_boundary(original: PackedVector2Array) -> PackedVector2Array:
	var poly:=PackedVector2Array()
	for p in data().points: poly.append(Vector2(p[0],p[1]))
	var expanded:=Geometry2D.offset_polygon(poly,8.0)
	var merged:=Geometry2D.merge_polygons(original,expanded[0])
	assert(merged.size()==1,"Field2 study extension must remain connected")
	return merged[0]

static func build(world: Node3D) -> void:
	var record:=data()
	var root:=Node3D.new()
	root.name="Field2"
	world.get_node("Props").add_child(root)
	root.set_meta("finished_level_estimate",record.height_estimate_m)
	# Official photograph shows dry natural grass and tall H posts; no unverified yard numbers.
	var grass:=Geo.material(Color("929569"),1.0)
	var noise:=FastNoiseLite.new()
	noise.seed=32528091
	noise.frequency=0.045
	var texture:=Image.create(128,128,false,Image.FORMAT_RGB8)
	for y in 128:
		for x in 128:
			var t: float=(noise.get_noise_2d(x,y)+1.0)*0.5
			texture.set_pixel(x,y,Color("778252").lerp(Color("b4ad7c"),t))
	texture.generate_mipmaps()
	grass.albedo_color=Color.WHITE
	grass.albedo_texture=ImageTexture.create_from_image(texture)
	grass.uv1_triplanar=true; grass.uv1_world_triplanar=true
	grass.uv1_scale=Vector3.ONE*0.06
	Geo.polygon(root,record.points,grass,0.045).name="MappedNaturalGrass"
	var a:=Geo.point(record.points[0])
	var u: Vector3=(Geo.point(record.points[1])-a).normalized()
	var v: Vector3=(Geo.point(record.points[-1])-a).normalized()
	u.y=0; v.y=0; u=u.normalized(); v=v.normalized()
	var kit:=Kit.new()
	var width: float=Vector2(record.points[0][0],record.points[0][1]).distance_to(Vector2(record.points[-1][0],record.points[-1][1]))
	var length: float=Vector2(record.points[0][0],record.points[0][1]).distance_to(Vector2(record.points[1][0],record.points[1][1]))
	# Positions and heights provisional; H-shaped form is photo-confirmed.
	for distance in [10.0,length-10.0]:
		var center: Vector3=a+u*distance+v*width*0.5
		center.y=record.height_estimate_m
		for side in [-1,1]:
			var post: Vector3=center+v*side*2.8
			kit.part("posts",post+Vector3.UP*4.5,Vector3(0.14,9,0.14),0)
			preload("res://scripts/ShellCourtyard.gd").collision_box(root,post+Vector3.UP*4.5,Vector3(0.14,9,0.14),0)
		Field.bar(kit,"posts",center-v*2.8+Vector3.UP*3,center+v*2.8+Vector3.UP*3,0.14,0.14)
	var transforms: Array[Transform3D]=[]
	transforms.assign(kit.batches.posts)
	Geo.instances(root,transforms,Geo.material(Color("d3d6cd")),null,350).name="HShapedGoalPosts"

