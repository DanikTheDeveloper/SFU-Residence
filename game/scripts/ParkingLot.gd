extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")

static func build(world: Node3D, parent: Node3D) -> void:
	var root:=Node3D.new()
	root.name="ParkingLots"
	parent.add_child(root)
	var paint:=Node3D.new()
	root.add_child(paint)
	var white:=Geo.material(Color("cac9bb"))
	var bodies: Array[Transform3D]=[]
	var glass: Array[Transform3D]=[]
	var wheels: Array[Transform3D]=[]
	var stalls:=0
	for area in world.site.parking:
		var poly:=PackedVector2Array()
		for p in area.points: poly.append(Vector2(p[0],p[1]))
		var axis:=Vector2.RIGHT
		var longest:=0.0
		for i in poly.size()-1:
			var edge:=poly[i+1]-poly[i]
			if edge.length()>longest:
				longest=edge.length()
				axis=edge.normalized()
		var cross:=Vector2(-axis.y,axis.x)
		var umin:=INF
		var umax:=-INF
		var vmin:=INF
		var vmax:=-INF
		for p in poly:
			umin=minf(umin,p.dot(axis)); umax=maxf(umax,p.dot(axis))
			vmin=minf(vmin,p.dot(cross)); vmax=maxf(vmax,p.dot(cross))
		var rows: Array=[vmin+3.3]
		if vmax-vmin>17: rows.append(vmax-3.3)
		for v in rows:
			for index in range(int((umax-umin-3)/2.7)):
				var u: float=umin+2.2+index*2.7
				var p: Vector2=axis*u+cross*v
				var fits:=true
				for du in [-1.35,1.35]:
					for dv in [-2.6,2.6]:
						if not Geometry2D.is_point_in_polygon(p+axis*du+cross*dv,poly): fits=false
				if not fits or world.inside_building(p,3): continue
				for side in [-1,1]:
					var a: Vector2=p+axis*side*1.30-cross*2.6
					var b: Vector2=a+cross*5.2
					Geo.strip(paint,Geo.point([a.x,a.y]),Geo.point([b.x,b.y]),0.09,white,0.065)
				stalls+=1
				# Keep original pedestrian and service paths clear of parked vehicles.
				var route_clear:=true
				for road in world.roads:
					var a:=Vector2(road.points[0][0],road.points[0][1])
					var b:=Vector2(road.points[1][0],road.points[1][1])
					if p.distance_to(Geometry2D.get_closest_point_to_segment(p,a,b))<road.width*0.5+2.5: route_clear=false
				if stalls%3==0 or not route_clear: continue
				var pos:=Geo.point([p.x,p.y])
				var front:=Geo.point([p.x+cross.x*2,p.y+cross.y*2])
				var back:=Geo.point([p.x-cross.x*2,p.y-cross.y*2])
				var forward: Vector3=(front-back).normalized()
				var right:=Vector3.UP.cross(forward).normalized()
				var up:=forward.cross(right).normalized()
				var basis:=Basis(right,up,forward)
				bodies.append(Transform3D(basis.scaled_local(Vector3(1.75,0.6,3.9)),pos+up*0.72))
				glass.append(Transform3D(basis.scaled_local(Vector3(1.55,0.55,2.0)),pos+up*1.23))
				for side in [-1,1]:
					for end in [-1,1]: wheels.append(Transform3D(basis.scaled_local(Vector3(0.24,0.55,0.55)),pos+up*0.35+right*side*0.85+forward*end*1.2))
				var body:=StaticBody3D.new()
				root.add_child(body)
				body.transform=Transform3D(basis,pos+up*0.8)
				var shape:=CollisionShape3D.new()
				var box:=BoxShape3D.new()
				box.size=Vector3(1.8,1.3,4)
				shape.shape=box
				body.add_child(shape)
		var sign_pos:=Geo.point(area.points[0])
		Geo.box(root,sign_pos+Vector3.UP*1.4,Vector3(0.08,2.8,0.08),Geo.material(Color("555e61")))
		var sign:=Label3D.new()
		sign.text="P\nRESIDENCE"
		sign.font_size=32
		sign.pixel_size=0.018
		sign.billboard=BaseMaterial3D.BILLBOARD_ENABLED
		root.add_child(sign)
		sign.position=sign_pos+Vector3.UP*2.8
	Geo.merge_surfaces(paint)
	Geo.instances(root,bodies,Geo.material(Color("647984")),null,220)
	Geo.instances(root,glass,Geo.material(Color("34484e")),null,220)
	Geo.instances(root,wheels,Geo.material(Color("252a2c")),null,160)
	root.set_meta("estimated_stalls",stalls)
	root.set_meta("cars",bodies.size())
