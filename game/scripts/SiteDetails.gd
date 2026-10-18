extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")

static func build(world: Node3D) -> void:
	var root: Node3D=world.get_node("Props")
	var line_mat:=Geo.material(Color("c7be98"))
	var lines: Array[Transform3D]=[]
	var curb: Array[Transform3D]=[]
	var dark:=Geo.material(Color("37464a"))
	var concrete:=Geo.material(Color("8f9187"))
	var names: Dictionary={}
	for road in world.roads:
		if road.kind!="road": continue
		var a:=Geo.point(road.points[0],0.055)
		var b:=Geo.point(road.points[1],0.055)
		var length:=a.distance_to(b)
		var yaw: float=-atan2((b-a).z,(b-a).x)
		if road.name in ["Residence Lane","Terry Fox Lane","West Campus Road","University Drive West"] and not names.has(road.name):
			names[road.name]=true
			var p: Vector3=a+(b-a).cross(Vector3.UP).normalized()*(road.width*0.5+1)
			Geo.box(root,p+Vector3.UP*1.3,Vector3(0.08,2.6,0.08),dark)
			var sign:=Label3D.new()
			sign.text=road.name
			sign.font_size=40
			sign.pixel_size=0.015
			sign.billboard=BaseMaterial3D.BILLBOARD_ENABLED
			root.add_child(sign)
			sign.position=p+Vector3.UP*2.6
		# No centerline paint without direct marking evidence.
	preload("res://scripts/ParkingLot.gd").build(world,root)
	preload("res://scripts/ShellCourtyard.gd").build(world)
	# Original small plaza furnishings, kept clear of mapped walkways.
	for data in world.registry:
		var center:=Vector2(data.centroid[0],data.centroid[1])
		if world.occupied(center,2.5): continue
		var p:=Geo.point([center.x,center.y])
		Geo.box(root,p+Vector3.UP*0.3,Vector3(3,0.6,2),concrete,true)
		Geo.box(root,p+Vector3.UP*0.66,Vector3(2.8,0.2,1.8),Geo.material(Color("4a6744")))
		for offset in [-2.3,2.3]:
			Geo.box(root,p+Vector3(offset,0.45,0),Vector3(0.5,0.15,2.0),Geo.material(Color("8b6a49")),true)
			Geo.box(root,p+Vector3(offset,0.24,0),Vector3(0.32,0.48,1.5),dark)

