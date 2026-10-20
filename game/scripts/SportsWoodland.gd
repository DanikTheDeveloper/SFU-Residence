extends RefCounted
# Forest context outside sports surfaces, restricted to existing OSM woodland polygons.
const Geo=preload("res://scripts/Geometry.gd")
const Trees=preload("res://scripts/PhotoVegetation.gd")
static func build(world: Node3D) -> void:
	var regions: Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/planting_regions.json"))
	var woods: Array[PackedVector2Array]=[]
	for region in regions:
		if region.kind!="wood": continue
		var poly:=PackedVector2Array()
		for p in region.points: poly.append(Vector2(p[0],p[1]))
		woods.append(poly)
	var fields: Array[PackedVector2Array]=[]
	for name in ["field4","field2","beedie_field"]:
		var record: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/"+name+".json"))
		var poly:=PackedVector2Array()
		for p in record.points: poly.append(Vector2(p[0],p[1]))
		for expanded in Geometry2D.offset_polygon(poly,7): fields.append(expanded)
	var rng:=RandomNumberGenerator.new()
	rng.seed=41182
	var groups: Dictionary={}
	var count:=0
	for x in range(-100,300,9):
		for z in range(100,274,9):
			var p:=Vector2(x+rng.randf_range(-1.8,1.8),z+rng.randf_range(-1.8,1.8))
			if world.occupied(p,3.5): continue
			var blocked:=false
			for field in fields:
				if Geo.contains_point(p,field): blocked=true; break
			if blocked: continue
			var wooded:=false
			for wood in woods:
				if Geo.contains_point(p,wood): wooded=true; break
			if not wooded: continue
			var key:=Vector3i(floori(p.x/32),floori(p.y/32),0 if count%5 else 1)
			if not groups.has(key): groups[key]=[]
			var size:=rng.randf_range(1.6,2.6)
			groups[key].append(Geo.transform(Geo.point([p.x,p.y]),Vector3(size*0.85,size,size*0.85),rng.randf()*TAU))
			count+=1
	var mat:=Geo.material(Color.WHITE,0.98)
	mat.vertex_color_use_as_albedo=true
	mat.cull_mode=BaseMaterial3D.CULL_DISABLED
	var conifer:=Trees.tree(true,0.35)
	var broad:=Trees.tree(false,0.35)
	var root:=Node3D.new()
	root.name="SportsWoodlandContext"
	world.get_node("Props").add_child(root)
	for key in groups:
		var transforms: Array[Transform3D]=[]
		transforms.assign(groups[key])
		Geo.instances(root,transforms,mat,conifer if key.z==0 else broad,300)
	root.set_meta("tree_count",count)
	print("SPORTS_WOODLAND trees=",count," mapped woodland only; species/spacing estimated")
