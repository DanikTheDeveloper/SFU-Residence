extends RefCounted
# User-confirmed exterior connection; survey geometry and step count estimated.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const Bar=preload("res://scripts/BeedieField.gd")

static func build(world: Node3D) -> void:
	var plan: Dictionary=world.get_node("Buildings/SBH").get_meta("exterior_passage")
	var root:=Node3D.new()
	root.name="NorthDiningStair"
	world.add_child(root)
	var u: Vector3=plan.side
	var v:=Vector3(-u.z,0,u.x)
	var a: Vector3=plan.gallery_end
	a.y=Geo.elevation(a.x,a.z)+0.045
	var top: float=preload("res://scripts/TerrainController.gd").foundation("DC")
	var total:=11.8
	var middle:=a.y+3.61
	var stations: Array[Vector2]=[Vector2(0,a.y),Vector2(5.94,middle),Vector2(6.94,middle),Vector2(total,top)]
	var concrete:=Geo.material(Color("aaa99c"),0.96)
	var steel:=Geo.material(Color("a0aaa6"),0.62)
	var kit:=Kit.new()
	var yaw: float=-atan2(u.z,u.x)
	var width:=2.4
	var ramp:=PackedVector3Array()
	# Bury the leading collision edge below the existing grade to avoid a capsule lip.
	var lead: Vector3=a-u*0.8
	lead.y=Geo.elevation(lead.x,lead.z)-0.12
	var la: Vector3=lead-v*width*0.5
	var lb: Vector3=lead+v*width*0.5
	var ra: Vector3=a-v*width*0.5
	var rb: Vector3=a+v*width*0.5
	ramp.append_array([la,rb,lb,la,ra,rb,lb,rb,la,rb,ra,la])
	# Collision follows two flights and a level landing; visible risers stay detailed.
	# This is standard exterior stair traversal, avoiding capsule snag on every riser.
	for i in 3:
		var begin: Vector2=stations[i]
		var end: Vector2=stations[i+1]
		var start: Vector3=a+u*begin.x; start.y=begin.y
		var finish: Vector3=a+u*end.x; finish.y=end.y
		var l: Vector3=start-v*width*0.5
		var rr: Vector3=start+v*width*0.5
		var fl: Vector3=finish-v*width*0.5
		var fr: Vector3=finish+v*width*0.5
		ramp.append_array([l,fr,rr,l,fl,fr,rr,fr,l,fr,fl,l])
		var steps: int=19 if i==0 else (15 if i==2 else 1)
		for j in steps:
			var d0: float=lerpf(begin.x,end.x,float(j)/steps)
			var d1: float=lerpf(begin.x,end.x,float(j+1)/steps)
			var y: float=lerpf(begin.y,end.y,float(j+1)/steps)
			var center: Vector3=a+u*(d0+d1)*0.5
			var bottom: float=minf(Geo.elevation(center.x,center.z)-0.12,y-0.24)
			center.y=(bottom+y)*0.5
			kit.part("concrete",center,Vector3(d1-d0+0.01,y-bottom,width),yaw)
			kit.part("edge",Vector3(center.x,y+0.006,center.z)-u*(d1-d0)*0.5,Vector3(0.045,0.012,width),yaw)
		for side in [-1,1]:
			var sa: Vector3=start+v*side*(width*0.5+0.10)
			var sb: Vector3=finish+v*side*(width*0.5+0.10)
			rail(kit,"steel",sa+Vector3.UP*0.95,sb+Vector3.UP*0.95,0.055,0.055)
			for j in int(ceil(sa.distance_to(sb)/1.4))+1:
				var q: Vector3=sa.lerp(sb,minf(1,float(j)/maxf(1,ceil(sa.distance_to(sb)/1.4))))
				rail(kit,"steel",q,q+Vector3.UP*0.95,0.045,0.045)
	var collision_ramp:=Geo.mesh_from_vertices(root,ramp,concrete,true)
	collision_ramp.name="ContinuousStairCollision"
	# Keep the smooth physics ramp, but render only actual treads and landings.
	collision_ramp.visible=false
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,steel if key=="steel" else (Geo.material(Color("c7c7bd")) if key=="edge" else concrete),null,180)
	root.set_meta("start",a)
	root.set_meta("direction",u)
	root.set_meta("length",total)
	root.set_meta("confidence","USER_CONFIRMED_CONNECTION_ESTIMATED_DIMENSIONS")

static func rail(kit: RefCounted,key: String,a: Vector3,b: Vector3,width: float,height: float) -> void:
	var along: Vector3=(b-a).normalized()
	var across: Vector3=along.cross(Vector3.UP)
	if across.length()<0.01: across=Vector3.FORWARD
	across=across.normalized()
	var up: Vector3=across.cross(along).normalized()
	var basis:=Basis(along*a.distance_to(b),up*height,across*width)
	if not kit.batches.has(key): kit.batches[key]=[]
	kit.batches[key].append(Transform3D(basis,(a+b)*0.5))
