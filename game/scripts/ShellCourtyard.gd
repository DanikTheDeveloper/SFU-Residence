extends RefCounted
# Shell courtyard furniture: forms from handpicked photos, placement estimated.
const Geo = preload("res://scripts/Geometry.gd")
const Kit = preload("res://scripts/FacadeKit.gd")

static func build(world: Node3D) -> void:
	var root := Node3D.new()
	root.name = "ShellCourtyard"
	world.get_node("Props").add_child(root)
	root.set_meta("placement_confidence", "ESTIMATED west frontage; exact survey unavailable")
	var timber := Geo.material(Color("77796b"), 0.98)
	var concrete := Geo.material(Color("a5a69b"), 0.96)
	var aggregate := Image.create(64,64,false,Image.FORMAT_RGB8)
	for y in 64:
		for x in 64:
			var speck: float = 0.78 + 0.22 * absf(sin(float(x*127+y*311)))
			aggregate.set_pixel(x,y,Color(speck,speck,speck))
	aggregate.generate_mipmaps()
	concrete.albedo_texture = ImageTexture.create_from_image(aggregate)
	concrete.uv1_triplanar = true
	concrete.uv1_world_triplanar = true
	concrete.uv1_scale = Vector3.ONE * 3.0
	var start := Vector3(255.533,0,109.004)
	var tangent := Vector3(11.686,0,-49.726).normalized()
	var outward := Vector3(tangent.z,0,-tangent.x)
	var yaw := -atan2(tangent.z,tangent.x)
	var kit := Kit.new()
	# North screen stays left of the mapped main door; south side has the photo annex.
	for interval in [Vector2(24,43)]:
		var count := int(ceil((interval.y-interval.x)/0.17))
		for i in count+1:
			var p: Vector3 = start+tangent*lerpf(interval.x,interval.y,float(i)/count)+outward*3.2
			p.y = Geo.elevation(p.x,p.z)
			kit.part("wood",p+Vector3.UP*0.79,Vector3(0.105,1.58,0.055),yaw)
		for i in int(ceil((interval.y-interval.x)/2.0))+1:
			var along: float = minf(interval.y,interval.x+i*2.0)
			var p: Vector3 = start+tangent*along+outward*3.2
			p.y = Geo.elevation(p.x,p.z)
			kit.part("wood",p+Vector3.UP*0.81,Vector3(0.13,1.68,0.13),yaw)
		# Short terrain-following rails and coarse collision, not one collider per slat.
		for i in int(ceil(interval.y-interval.x)):
			var lo: float = interval.x+i
			var hi: float = minf(interval.y,lo+1.0)
			var p: Vector3 = start+tangent*((lo+hi)*0.5)+outward*3.2
			p.y = Geo.elevation(p.x,p.z)
			for h in [0.28,1.35]:
				kit.part("wood",p+Vector3.UP*h-outward*0.045,Vector3(hi-lo,0.085,0.08),yaw)
			collision_box(root,p+Vector3.UP*0.8,Vector3(hi-lo,1.6,0.12),yaw)
	var transforms: Array[Transform3D] = []
	transforms.assign(kit.batches.get("wood",[]))
	Geo.instances(root,transforms,timber,null,170).name="WeatheredTimberFence"
	for along in [16.0,29.0,38.0]:
		var p: Vector3 = start+tangent*along+outward*7.0
		p.y = Geo.elevation(p.x,p.z)
		picnic_table(root,p,concrete)
	root.set_meta("table_count",3)
	preload("res://scripts/ShellAnnex.gd").build(world)
	# Narrow concrete walk visible immediately outside the timber screen.
	var walk:=PackedVector3Array()
	for i in range(17,43):
		var corners: Array[Vector3]=[]
		for v in [Vector2(i,3.65),Vector2(i+1,3.65),Vector2(i,4.85),Vector2(i+1,4.85)]:
			var q: Vector3=start+tangent*v.x+outward*v.y
			q.y=Geo.elevation(q.x,q.z)+0.075
			corners.append(q)
		walk.append_array([corners[0],corners[1],corners[2],corners[2],corners[1],corners[3]])
	Geo.mesh_from_vertices(root,walk,concrete).name="ShellScreenWalk"

static func collision_box(root: Node3D,p: Vector3,size: Vector3,yaw: float=0.0) -> void:
	var body := StaticBody3D.new()
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	shape.shape = box
	body.add_child(shape)
	root.add_child(body)
	body.position = p
	body.rotation.y = yaw

static func cylinder(root: Node3D,p: Vector3,radius: float,height: float,mat: Material) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius=radius
	mesh.bottom_radius=radius
	mesh.height=height
	mesh.radial_segments=32
	var node := MeshInstance3D.new()
	node.mesh=mesh
	node.material_override=mat
	root.add_child(node)
	node.position=p
	node.create_trimesh_collision()

static func picnic_table(root: Node3D,p: Vector3,mat: Material) -> void:
	# Round exposed-aggregate tabletop on concrete pedestal, with three curved seats.
	cylinder(root,p+Vector3.UP*0.75,0.78,0.10,mat)
	cylinder(root,p+Vector3.UP*0.34,0.15,0.72,mat)
	for section in 3:
		var vertices := PackedVector3Array()
		var angle: float = section*TAU/3.0
		for i in 16:
			var a: float = angle-0.65+1.30*i/16.0
			var b: float = angle-0.65+1.30*(i+1)/16.0
			var ai:=p+Vector3(cos(a)*1.05,0.48,sin(a)*1.05)
			var ao:=p+Vector3(cos(a)*1.40,0.48,sin(a)*1.40)
			var bi:=p+Vector3(cos(b)*1.05,0.48,sin(b)*1.05)
			var bo:=p+Vector3(cos(b)*1.40,0.48,sin(b)*1.40)
			var down:=Vector3.DOWN*0.10
			vertices.append_array([ai,bi,ao,ao,bi,bo,ai+down,ao+down,bi+down,ao+down,bo+down,bi+down])
			vertices.append_array([ai,ai+down,bi,bi,ai+down,bi+down,ao,bo,ao+down,ao+down,bo,bo+down])
			if i==0: vertices.append_array([ai,ao,ai+down,ai+down,ao,ao+down])
			if i==15: vertices.append_array([bi,bi+down,bo,bo,bi+down,bo+down])
		Geo.mesh_from_vertices(root,vertices,mat,true).name="CurvedConcreteSeat"
		for side in [-0.42,0.42]:
			var foot:=p+Vector3(cos(angle+side)*1.22,0,sin(angle+side)*1.22)
			var bottom: float = minf(p.y,Geo.elevation(foot.x,foot.z))-0.08
			var top: float = p.y+0.39
			Geo.box(root,Vector3(foot.x,(bottom+top)*0.5,foot.z),Vector3(0.16,top-bottom,0.20),mat,true)

