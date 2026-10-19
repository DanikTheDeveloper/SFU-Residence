extends RefCounted
# Field4-specific sideline context, SFU Lacrosse panorama (2015), user 2026 observation.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const Bar=preload("res://scripts/BeedieField.gd")
const Solid=preload("res://scripts/ShellCourtyard.gd")

static func build(world: Node3D,field: Node3D,a: Vector3,u: Vector3,v: Vector3,length: float,width: float) -> void:
	var root:=Node3D.new()
	root.name="SidelineContext"
	field.add_child(root)
	var kit:=Kit.new()
	var routes: Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/test_routes.json"))
	var mats={"steel":Geo.material(Color("303837")),"roof":Geo.material(Color("252c2d")),"bench":Geo.material(Color("81877f")),"concrete":Geo.material(Color("92978c")),"lamp":Geo.material(Color("c1c6b7"))}
	# Concrete perimeter strip seen in the field-specific southeast photograph.
	for edge in [[a-v*0.8,a+u*length-v*0.8],[a+u*length+u*0.8,a+u*length+v*width+u*0.8],[a+v*width+v*0.8,a+u*length+v*width+v*0.8],[a-u*0.8,a+v*width-u*0.8]]:
		Geo.strip(root,edge[0],edge[1],1.1,mats.concrete,0.065)
	# Low dark chain-link perimeter. Preserve mapped walk crossings and spawn gate.
	for edge in [[a-v*1.5,a+u*length-v*1.5],[a+u*(length+1.5),a+u*(length+1.5)+v*width],[a+v*(width+1.5),a+u*length+v*(width+1.5)],[a-u*1.5,a-u*1.5+v*width]]:
		var count:=int(ceil(edge[0].distance_to(edge[1])/2.5))
		for i in count:
			var start: Vector3=edge[0].lerp(edge[1],float(i)/count)
			var end: Vector3=edge[0].lerp(edge[1],float(i+1)/count)
			var midpoint: Vector3=(start+end)*0.5
			var gate:=absf((midpoint-a).dot(u)-78)<5.0 and (midpoint-a).dot(v)<0
			for gate_center in [47.0,68.0,111.0]:
				if absf((midpoint-a).dot(u)-gate_center)<2.0 and (midpoint-a).dot(v)<0: gate=true
			for road in world.roads:
				var p:=Vector2(midpoint.x,midpoint.z)
				var x: Array=road.points[0]
				var y: Array=road.points[1]
				if p.distance_to(Geometry2D.get_closest_point_to_segment(p,Vector2(x[0],x[1]),Vector2(y[0],y[1])))<float(road.width)*0.5+1.2: gate=true; break
			# Keep already-verified walking crossings open as well as mapped centerlines.
			for route in routes:
				for index in range(route.points.size()-1):
					var x: Array=route.points[index]
					var y: Array=route.points[index+1]
					if Vector2(midpoint.x,midpoint.z).distance_to(Geometry2D.get_closest_point_to_segment(Vector2(midpoint.x,midpoint.z),Vector2(x[0],x[1]),Vector2(y[0],y[1])))<1.8: gate=true; break
			if gate: continue
			start.y=Geo.elevation(start.x,start.z)+0.06; end.y=Geo.elevation(end.x,end.z)+0.06
			Bar.bar(kit,"steel",start,start+Vector3.UP*1.3,0.06,0.06)
			Bar.bar(kit,"steel",start+Vector3.UP*1.3,end+Vector3.UP*1.3,0.06,0.06)
			# Diamond-like diagonals; original opaque geometry, no third-party texture.
			for j in 12:
				var q: Vector3=start.lerp(end,float(j)/12)
				var t: Vector3=start.lerp(end,minf(1,float(j+3)/12))
				Bar.bar(kit,"steel",q,t+Vector3.UP*1.3,0.009,0.009)
				Bar.bar(kit,"steel",q+Vector3.UP*1.3,t,0.009,0.009)
			Solid.collision_box(root,(start+end)*0.5+Vector3.UP*0.65,Vector3(start.distance_to(end),1.3,0.07),-atan2((end-start).z,(end-start).x))
	# Photo-visible residence sideline shelters; sit on their own grounded slabs.
	# Exact dimensions/current side panels are estimates, not an as-built survey.
	for item in [[46.0,5.0],[67.0,5.0],[108.0,17.0]]:
		var center: Vector3=a+u*item[0]-v*5.0
		shelter(root,kit,center,u,v,item[1],mats.concrete)
	# Panorama corroborates tall poles along both long sides. Locations approximate.
	for location in [Vector2(9,-3),Vector2(60,-3),Vector2(115,-3),Vector2(9,width+3),Vector2(60,width+3),Vector2(115,width+3)]:
		var p: Vector3=a+u*location.x+v*location.y
		p.y=Geo.elevation(p.x,p.z)
		kit.part("steel",p+Vector3.UP*8,Vector3(0.18,16,0.18),0)
		Bar.bar(kit,"steel",p-u*1.0+Vector3.UP*16,p+u*1.0+Vector3.UP*16,0.10,0.10)
		for offset in [-0.7,0,0.7]: kit.part("lamp",p+u*offset+Vector3.UP*15.8,Vector3(0.42,0.32,0.25),-atan2(u.z,u.x))
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,mats[key],null,300).name="Field4"+key.capitalize()

static func shelter(root: Node3D,kit: RefCounted,center: Vector3,u: Vector3,v: Vector3,length: float,mat: Material) -> void:
	var yaw: float=-atan2(u.z,u.x)
	var floor_y: float=-INF
	for x in [-length*0.5,length*0.5]:
		for z in [-1.45,1.45]:
			var q: Vector3=center+u*x+v*z
			floor_y=maxf(floor_y,Geo.elevation(q.x,q.z))
	center.y=floor_y+0.04
	var slab:=Geo.box(root,center-Vector3.UP*0.07,Vector3(length+0.2,0.14,3.0),mat,true)
	slab.rotation.y=yaw
	kit.part("roof",center+Vector3.UP*2.65,Vector3(length+0.45,0.18,3.4),yaw)
	Solid.collision_box(root,center+Vector3.UP*2.65,Vector3(length+0.45,0.18,3.4),yaw)
	# Sloping concrete apron meets the existing terrain without a floating front edge.
	var ramp:=PackedVector3Array()
	var count:=int(ceil(length))
	for i in count:
		var left: Vector3=center+u*(float(i)/count-0.5)*length+v*1.5
		var right: Vector3=center+u*(float(i+1)/count-0.5)*length+v*1.5
		var low_left: Vector3=left+v*2.0
		var low_right: Vector3=right+v*2.0
		low_left.y=Geo.elevation(low_left.x,low_left.z)+0.07
		low_right.y=Geo.elevation(low_right.x,low_right.z)+0.07
		ramp.append_array([left,low_right,right,left,low_left,low_right,right,low_right,left,low_right,low_left,left])
	Geo.mesh_from_vertices(root,ramp,mat,true).name="ShelterAccessApron"
	# Open field-facing side, solid black rear and end panels, no enclosed room.
	for side in [-1,1]:
		var q: Vector3=center+u*side*length*0.5+Vector3.UP*1.3
		kit.part("roof",q,Vector3(0.12,2.6,2.9),yaw)
		Solid.collision_box(root,q,Vector3(0.12,2.6,2.9),yaw)
	var back: Vector3=center-v*1.4+Vector3.UP*1.3
	kit.part("roof",back,Vector3(length,2.6,0.12),yaw)
	Solid.collision_box(root,back,Vector3(length,2.6,0.12),yaw)
	var seat: Vector3=center-v*0.9+Vector3.UP*0.46
	kit.part("bench",seat,Vector3(length-0.6,0.10,0.43),yaw)
	Solid.collision_box(root,seat,Vector3(length-0.6,0.10,0.43),yaw)
	for x in [-length*0.45,0,length*0.45]:
		kit.part("steel",center+u*x+v*1.35+Vector3.UP*1.3,Vector3(0.08,2.6,0.08),yaw)
	if length>10:
		# User confirms a fence between this long dark shelter and the pitch.
		# Wide opening retains the existing path and gives sheltered-area access.
		for span in [Vector2(-8.5,1.2),Vector2(5.8,8.5)]:
			var start: Vector3=center+u*span.x+v*3.6
			var end: Vector3=center+u*span.y+v*3.6
			start.y=Geo.elevation(start.x,start.z)+0.05
			end.y=Geo.elevation(end.x,end.z)+0.05
			Bar.fence(root,kit,start,end,1.3,false)
	root.set_meta("shelter_"+str(int(length)),{"center":center,"u":u,"v":v,"length":length})
