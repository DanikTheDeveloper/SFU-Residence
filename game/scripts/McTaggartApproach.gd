extends RefCounted
# Western/Dining-facing connector confirmed by user; as-built dimensions estimated.
const Geo=preload("res://scripts/Geometry.gd")
const Walk=preload("res://scripts/EastWestRecreation.gd")
const Kit=preload("res://scripts/FacadeKit.gd")

static func build(world: Node3D) -> void:
	var d: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/mctaggart_entry.json"))
	var root:=Node3D.new();root.name="McTaggartApproach";world.get_node("Props").add_child(root)
	var door:=Vector3(d.entrance[0],d.landing_height,d.entrance[1])
	var n:=Vector3(d.outward[0],0,d.outward[1])
	var u:=Vector3(-n.z,0,n.x)
	var low: Vector3=door+n*3.0
	var top: Vector3=door+n*5.8;top.y=d.top_height
	var outer: Vector3=door+n*12;outer.y=d.top_height
	var approach: Vector3=door+n*19;approach.y=Geo.elevation(approach.x,approach.z)-0.08
	var kit:=Kit.new()
	var concrete:=preload("res://scripts/PavementMaterials.gd").material("concrete").duplicate() as StandardMaterial3D
	# World projection avoids repeating a slab joint down each BoxMesh riser.
	concrete.uv1_triplanar=true;concrete.uv1_world_triplanar=true
	concrete.uv1_scale=Vector3.ONE*0.25
	var steel:=Geo.material(Color("838b85"),0.72)
	Walk.path(root,approach,outer,2.4,concrete,"EntryApproach")
	Walk.path(root,outer,top,3.2,concrete,"UpperLanding")
	Walk.guarded_path(root,kit,top,low,3.4,concrete,"DescendingEntryStair",true,false)
	Walk.path(root,low,door+n*0.65,3.4,concrete,"DoorLanding")
	# Feather the preserved east-west pedestrian line into the door landing.
	# Existing terrain sits below its slab edge; do not leave a capsule-blocking lip.
	Walk.path(root,Vector3(152,Geo.elevation(152,114)-0.08,114),Vector3(148,door.y,114),2.2,concrete,"ExistingRouteTieIn")
	# Photo shows boulders and dense low planting beside the descending stair.
	var stone:=SphereMesh.new();stone.radius=0.48;stone.height=0.8
	stone.radial_segments=12;stone.rings=5
	var stones: Array[Transform3D]=[]
	var grasses: Array[Transform3D]=[]
	var rng:=RandomNumberGenerator.new();rng.seed=178250355
	for side in [-1,1]:
		var bed: Array=[]
		for st in [Vector2(3.1,2.1),Vector2(10.3,2.1),Vector2(10.3,3.3),Vector2(3.1,3.3)]:
			var q: Vector3=door+n*st.x+u*side*st.y
			bed.append([q.x,q.z])
		Geo.polygon(root,bed,Geo.material(Color("615345"),1.0),0.06).name="PhotoPlantingBed"
		for t in [5.1,8.9,10.0]:
			var q: Vector3=door+n*t+u*side*2.4
			q.y=Geo.elevation(q.x,q.z)+0.15
			stones.append(Geo.transform(q,Vector3(1.4,0.75,0.9),rng.randf()*TAU))
		for i in 22:
			var q: Vector3=door+n*rng.randf_range(3.4,10.1)+u*side*rng.randf_range(2.2,3.2)
			q.y=Geo.elevation(q.x,q.z)+0.065
			grasses.append(Geo.transform(q,Vector3(1.2,2.6,1.2)*rng.randf_range(0.8,1.2),rng.randf()*TAU))
	Geo.instances(root,stones,Geo.material(Color("a5a38b"),1.0),stone,140).name="EntryBoulders"
	var leaves:=Geo.material(Color("849077"),1.0);leaves.cull_mode=BaseMaterial3D.CULL_DISABLED
	Geo.instances(root,grasses,leaves,preload("res://scripts/PhotoVegetation.gd").grass_mesh(),100).name="EntryPlanting"
	for key in kit.batches:
		var transforms: Array[Transform3D]=[];transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,steel if key=="steel" else concrete,null,160)
	Walk.batch_visible(root)
	root.set_meta("door",door);root.set_meta("normal",n)
	root.set_meta("top",top);root.set_meta("low",low)
	root.set_meta("approach",approach);root.set_meta("outer",outer)
