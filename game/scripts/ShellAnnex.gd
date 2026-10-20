extends RefCounted
# Supplied Shell.jpg: glazed low annex and weathered timber pergola south of main entry.
# Original geometry; approximate dimensions. Closed exterior only.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
static func build(world: Node3D) -> void:
	var root:=Node3D.new();root.name="ShellAnnexExterior";world.get_node("Props").add_child(root)
	var start:=Vector3(255.533,0,109.004)
	var u:=Vector3(11.686,0,-49.726).normalized()
	var n:=Vector3(u.z,0,-u.x)
	var yaw: float=-atan2(u.z,u.x)
	var base: float=preload("res://scripts/TerrainController.gd").foundation("SHR")
	var concrete:=Geo.material(Color("a4a89c"),0.94)
	var glass:=Geo.material(Color("536b71"),0.34)
	var frame:=Geo.material(Color("35433e"),0.75)
	var timber:=Geo.material(Color("696a5d"),0.97)
	var kit:=Kit.new()
	var center: Vector3=start+u*9.5+n*1.6;center.y=base
	# Solid plinth embeds annex into current terrain; original main-building pad retained.
	var ground: float=minf(base-0.20,Geo.elevation(center.x+n.x*1.5,center.z+n.z*1.5)-0.15)
	var plinth:=Geo.box(root,Vector3(center.x,(ground+base)*0.5,center.z),Vector3(9,base-ground,3.2),concrete,true)
	plinth.rotation.y=yaw
	var front: Vector3=center+n*1.6
	var glazing:=Geo.box(root,front+Vector3.UP*1.35,Vector3(9,2.7,0.12),glass,true);glazing.rotation.y=yaw
	for along in [-4.5,-3,-1.5,0,1.5,3,4.5]:
		kit.part("frame",front+u*along+Vector3.UP*1.35,Vector3(0.07,2.7,0.16),yaw)
	for h in [0.1,0.72,2.7]: kit.part("frame",front+Vector3.UP*h,Vector3(9,0.075,0.16),yaw)
	# Roof rises to the old facade; solid sloped side cheeks close all back faces.
	var roof:=PackedVector3Array()
	var rear_left: Vector3=center-u*4.5-n*1.6+Vector3.UP*3.5
	var rear_right: Vector3=rear_left+u*9
	var front_left: Vector3=front-u*4.5+Vector3.UP*2.7
	var front_right: Vector3=front_left+u*9
	roof.append_array([rear_left,front_left,front_right,rear_left,front_right,rear_right])
	var underside:=roof.duplicate()
	for i in range(0,underside.size(),3):
		roof.append_array([underside[i],underside[i+2],underside[i+1]])
	Geo.mesh_from_vertices(root,roof,glass,true).name="SlopedGlazedAnnexRoof"
	for end in [-1,1]:
		var near: Vector3=center+u*end*4.5-n*1.6
		var far: Vector3=near+n*3.2
		var face:=PackedVector3Array([near,far,far+Vector3.UP*2.7,near,far+Vector3.UP*2.7,near+Vector3.UP*3.5])
		var both:=face.duplicate()
		for i in range(0,face.size(),3): both.append_array([face[i],face[i+2],face[i+1]])
		Geo.mesh_from_vertices(root,both,concrete,true).name="ClosedAnnexSide"
	for along in [-4.5,-3,-1.5,0,1.5,3,4.5]:
		beam(kit,"frame",rear_left+u*(along+4.5)+Vector3.UP*0.035,front_left+u*(along+4.5)+Vector3.UP*0.035,0.07,0.08)
	# Open timber pergola in front of the glazed annex, as in Shell.jpg.
	for along in [5.0,9.5,14.0]:
		var p: Vector3=start+u*along+n*4.7;p.y=base
		var bottom: float=Geo.elevation(p.x,p.z)-0.12
		var post:=Geo.box(root,Vector3(p.x,(bottom+base+3.4)*0.5,p.z),Vector3(0.23,base+3.4-bottom,0.23),timber,true);post.rotation.y=yaw
		kit.part("wood",p-n*1.8+Vector3.UP*3.35,Vector3(0.19,0.27,4.2),yaw)
		for direction in [-1,1]:
			beam(kit,"wood",p+Vector3.UP*2.6,p+u*direction*0.65+Vector3.UP*3.3,0.14,0.14)
	kit.part("wood",start+u*9.5+n*4.7+Vector3.UP*(base+3.4),Vector3(10.2,0.28,0.23),yaw)
	for key in kit.batches:
		var transforms: Array[Transform3D]=[];transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,timber if key=="wood" else frame,null,180)
	var walk: Array=[]
	for v in [Vector2(4.5,3.25),Vector2(14.5,3.25),Vector2(14.5,5.4),Vector2(4.5,5.4)]:
		var p: Vector3=start+u*v.x+n*v.y;walk.append([p.x,p.z])
	Geo.polygon(root,walk,preload("res://scripts/PavementMaterials.gd").material("concrete"),0.085).name="AnnexPergolaWalk"
	root.set_meta("origin",start);root.set_meta("along",u);root.set_meta("outward",n)

static func beam(kit: RefCounted,key: String,a: Vector3,b: Vector3,width: float,height: float) -> void:
	var along: Vector3=(b-a).normalized()
	var across: Vector3=along.cross(Vector3.UP)
	if across.length()<0.01: across=Vector3.FORWARD
	across=across.normalized()
	var up: Vector3=across.cross(along).normalized()
	if not kit.batches.has(key): kit.batches[key]=[]
	kit.batches[key].append(Transform3D(Basis(along*a.distance_to(b),up*height,across*width),(a+b)*0.5))
