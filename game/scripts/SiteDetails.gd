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
		if length<9: continue
		for t in range(2,int(length)-2,7):
			lines.append(Geo.transform(a.lerp(b,float(t)/length),Vector3(2.7,0.015,0.10),yaw))
	# Parking stripes / cars use the licensed lot polygons; stall placement is estimated.
	var car_bodies: Array[Transform3D]=[]
	var car_glass: Array[Transform3D]=[]
	var wheels: Array[Transform3D]=[]
	for area in world.site.parking:
		var poly:=PackedVector2Array()
		for p in area.points: poly.append(Vector2(p[0],p[1]))
		var bounds:=Rect2(poly[0],Vector2.ZERO)
		for p in poly: bounds=bounds.expand(p)
		var count:=0
		for x in range(int(bounds.position.x)+4,int(bounds.end.x)-3,6):
			for z in range(int(bounds.position.y)+4,int(bounds.end.y)-3,7):
				var p:=Vector2(x,z)
				if not Geometry2D.is_point_in_polygon(p,poly) or world.inside_building(p,4): continue
				var full_stall:=true
				for offset in [Vector2(-2,-3),Vector2(2,3),Vector2(-2,3),Vector2(2,-3)]:
					if not Geometry2D.is_point_in_polygon(p+offset,poly): full_stall=false
				if not full_stall: continue
				var pos:=Geo.point([x,z])
				for side in [-1,1]: lines.append(Geo.transform(pos+Vector3(side*1.5,0.065,0),Vector3(0.1,0.02,5)))
				if count%3!=0:
					car_bodies.append(Geo.transform(pos+Vector3.UP*0.7,Vector3(1.7,0.65,3.7)))
					car_glass.append(Geo.transform(pos+Vector3.UP*1.23,Vector3(1.5,0.6,1.9)))
					for side in [-1,1]:
						for end in [-1,1]: wheels.append(Geo.transform(pos+Vector3(side*0.85,0.35,end*1.2),Vector3(0.22,0.55,0.55)))
				count+=1
	Geo.instances(root,lines,line_mat,null,400)
	Geo.instances(root,car_bodies,Geo.material(Color("697981")),null,250)
	Geo.instances(root,car_glass,dark,null,250)
	Geo.instances(root,wheels,Geo.material(Color("252928")),null,200)
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
