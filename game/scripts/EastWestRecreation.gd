extends RefCounted
# User-confirmed arrangement; exact dimensions, finishes and levels are estimates.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const Rail=preload("res://scripts/NorthDiningStair.gd")
const Prism=preload("res://scripts/NorthTowerPassage.gd")

static func point(p: Array,y: float) -> Vector3:
	return Vector3(p[0],y,p[1])

static func slab(root: Node3D,points: Array[Vector3],mat: Material,title: String) -> void:
	var bottom: Array[Vector3]=[]
	for p in points: bottom.append(p-Vector3.UP*0.16)
	Prism.closed_prism(root,bottom,0.16,mat,title)

static func path(root: Node3D,a: Vector3,b: Vector3,width: float,mat: Material,title: String) -> void:
	var side:=Vector3(-(b-a).z,0,(b-a).x).normalized()*width*0.5
	slab(root,[a-side,b-side,b+side,a+side],mat,title)

static func guarded_path(root: Node3D,kit: RefCounted,a: Vector3,b: Vector3,width: float,mat: Material,title: String,steps: bool=false) -> void:
	var u:=Vector3(b.x-a.x,0,b.z-a.z).normalized()
	var v:=Vector3(-u.z,0,u.x)
	path(root,a,b,width,mat,title)
	if steps:
		# Smooth invisible capsule ramp, visible shallow treads. Rise is derived
		# from the estimated terrace endpoints, never a global terrain multiplier.
		root.get_child(root.get_child_count()-1).visible=false
		var n:=maxi(1,int(ceil(absf(a.y-b.y)/0.16)))
		for i in n:
			var start: Vector3=a.lerp(b,float(i)/n)
			var end: Vector3=a.lerp(b,float(i+1)/n)
			var top: float=maxf(start.y,end.y)
			var tread:=Geo.box(root,Vector3((start.x+end.x)*0.5,top-0.12,(start.z+end.z)*0.5),Vector3(Vector2(start.x,start.z).distance_to(Vector2(end.x,end.z))+0.006,0.24,width),mat)
			tread.rotation.y=-atan2(u.z,u.x)
	for sign_value in [-1,1]:
		# On short switchback landings retain only the outside guard; an inside
		# bar would cross the walking line as the user turns onto the next flight.
		var horizontal_length: float=Vector2(a.x,a.z).distance_to(Vector2(b.x,b.z))
		if not steps and horizontal_length<4.0 and title=="SwitchbackRamp":
			var outside_sign: float=1.0 if ((a+b)*0.5).x<100 else -1.0
			if sign_value!=outside_sign:continue
		var inset: float=minf(width*0.5+0.12,horizontal_length*0.45)
		if horizontal_length<4.0 and title=="SwitchbackRamp":inset=0.0
		var s: Vector3=a.lerp(b,inset/horizontal_length)+v*sign_value*(width*0.5-0.05)
		var e: Vector3=b.lerp(a,inset/horizontal_length)+v*sign_value*(width*0.5-0.05)
		for h in [0.55,1.0]: Rail.rail(kit,"steel",s+Vector3.UP*h,e+Vector3.UP*h,0.045,0.045)
		var guard:=StaticBody3D.new();guard.name="GuardCollision"
		var shape:=CollisionShape3D.new();var box:=BoxShape3D.new()
		box.size=Vector3(s.distance_to(e),0.98,0.06);shape.shape=box
		guard.add_child(shape);root.add_child(guard)
		var along: Vector3=(e-s).normalized()
		guard.basis=Basis(along,v.cross(along).normalized(),v)
		guard.position=(s+e)*0.5+Vector3.UP*0.5
		var n:=maxi(1,int(ceil(s.distance_to(e)/1.25)))
		for i in n+1:
			var q: Vector3=s.lerp(e,float(i)/n)
			Rail.rail(kit,"steel",q,q+Vector3.UP,0.045,0.045)
		# Grounded cheeks close the visible underside; collision stays on deck.
		var cheek_count:=maxi(1,int(ceil(s.distance_to(e)/0.5)))
		for i in cheek_count:
			var q: Vector3=s.lerp(e,(i+0.5)/cheek_count)
			var base: float=minf(Geo.elevation(q.x,q.z)-0.12,q.y-0.18)
			kit.part("concrete",Vector3(q.x,(base+q.y)*0.5,q.z),Vector3(s.distance_to(e)/cheek_count+0.015,q.y-base,0.10),-atan2(u.z,u.x))

static func build(world: Node3D) -> void:
	var d: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/east_west_recreation.json"))
	var root:=Node3D.new(); root.name="EastWestRecreation"; world.get_node("Props").add_child(root)
	root.set_meta("confidence",d.confidence)
	var kit:=Kit.new()
	var concrete:=preload("res://scripts/PavementMaterials.gd").material("concrete")
	var court_mat:=Geo.material(Color("818681"),0.94)
	var steel:=Geo.material(Color("515956"),0.72)
	var white:=Geo.material(Color("dddcd1"),0.8)
	var u:=Vector3(d.across[0],0,d.across[1])
	var v:=Vector3(-u.z,0,u.x)
	var origin:=point(d.center,d.upper_y)
	var corners: Array[Vector3]=[]
	for st in [Vector2(-6.5,-5),Vector2(6.5,-5),Vector2(6.5,5),Vector2(-6.5,5)]:corners.append(origin+u*st.x+v*st.y)
	slab(root,corners,court_mat,"SharedPracticeCourt")
	# Two side-by-side hoops, NOT opposed full-court goals. Pose is provisional.
	for bay in [-3.25,3.25]:
		var post: Vector3=origin+u*bay-v*4.65
		var pole:=Geo.box(root,post+Vector3.UP*1.95,Vector3(0.14,3.9,0.14),steel,true)
		pole.name="HoopPost"
		var board: Vector3=post+v*0.75+Vector3.UP*3.45
		Rail.rail(kit,"steel",post+Vector3.UP*3.4,board,0.1,0.1)
		var backboard:=Geo.box(root,board,Vector3(1.8,1.05,0.065),white,true)
		backboard.rotation.y=-atan2(u.z,u.x)
		var target: Vector3=post+v*0.79+Vector3.UP*3.28
		for sign_value in [-1,1]:
			kit.part("steel",target+u*sign_value*0.295,Vector3(0.025,0.45,0.015),backboard.rotation.y)
			kit.part("steel",target+Vector3.UP*sign_value*0.225,Vector3(0.59,0.025,0.015),backboard.rotation.y)
		var hoop_center: Vector3=post+v*1.08+Vector3.UP*3.05
		for i in 24:
			var a: float=TAU*i/24;var b: float=TAU*(i+1)/24
			Rail.rail(kit,"rim",hoop_center+(u*cos(a)+v*sin(a))*0.23,hoop_center+(u*cos(b)+v*sin(b))*0.23,0.022,0.022)
			if i%2==0:
				Rail.rail(kit,"net",hoop_center+(u*cos(a)+v*sin(a))*0.22,hoop_center+(u*cos(b)+v*sin(b))*0.15-Vector3.UP*0.4,0.009,0.009)
		# Unpainted neutral slab until actual line layout/colour is visible in photos.
	var mid: Array[Vector3]=[]
	for p in d.middle_polygon:mid.append(point(p,d.middle_y))
	slab(root,mid,concrete,"PicnicTerrace")
	var ramp: Array=d.ramp
	var lengths: Array[float]=[];var total:=0.0
	for i in ramp.size()-1:
		var length:=Vector2(ramp[i][0],ramp[i][1]).distance_to(Vector2(ramp[i+1][0],ramp[i+1][1]))
		lengths.append(length);total+=length
	var run:=0.0
	for i in ramp.size()-1:
		var ya: float=d.ramp_levels[i]
		run+=lengths[i]
		var yb: float=d.ramp_levels[i+1]
		guarded_path(root,kit,point(ramp[i],ya),point(ramp[i+1],yb),2.6,concrete,"SwitchbackRamp")
	var upper: Array=d.stairs_upper
	for i in 2:guarded_path(root,kit,point(upper[i],5.3-i*0.75),point(upper[i+1],4.55-i*0.75),1.5,concrete,"UpperStair",true)
	var lower: Array=d.stairs_lower
	var levels: Array[float]=[3.8,3.25,3.25,2.7]
	for i in 3:guarded_path(root,kit,point(lower[i],levels[i]),point(lower[i+1],levels[i+1]),2.6,concrete,"LowerStair",i!=1)
	path(root,Geo.point([90,44],-0.08),point(d.west_access[0],2.72),2.6,concrete,"EmbeddedWestApproach")
	guarded_path(root,kit,point(d.west_access[0],2.72),point(d.west_access[1],5.3),2.6,concrete,"WestApproachStair",true)
	path(root,point(d.west_access[1],5.3),point([99.5,44],5.3),2.6,concrete,"WestUpperLanding")
	path(root,point([105,52.5],5.3),point(ramp[0],5.3),2.6,concrete,"CourtRampAccess")
	path(root,point([98,51],5.3),point(upper[0],5.3),2.0,concrete,"CourtStairAccess")
	path(root,point(ramp[-1],3.8),mid[0],2.6,concrete,"RampTerraceAccess")
	path(root,point(upper[-1],3.8),mid[0],2.6,concrete,"StairTerraceAccess")
	path(root,point(lower[-1],2.7),point([94.424,86.098],2.62),2.6,concrete,"LaneAccess")
	# User confirms picnic seating on middle level. Rectangular bench/table form
	# is deliberately plain until exact furniture is photo-identified.
	for xz in [[100.7,66.6],[99.5,70.0]]:
		var p:=point(xz,3.8)
		var table:=Geo.box(root,p+Vector3.UP*0.75,Vector3(1.8,0.09,0.7),white,true);table.rotation.y=-atan2(u.z,u.x)
		for sign_value in [-1,1]:
			var bench:=Geo.box(root,p+v*sign_value*0.68+Vector3.UP*0.43,Vector3(1.8,0.08,0.3),white,true);bench.rotation.y=table.rotation.y
			for side in [-1,1]:
				kit.part("steel",p+u*side*0.6+v*sign_value*0.68+Vector3.UP*0.22,Vector3(0.06,0.44,0.06),0.0)
			kit.part("steel",p+u*sign_value*0.6+Vector3.UP*0.36,Vector3(0.08,0.72,0.5),table.rotation.y)
	for key in kit.batches:
		var transforms: Array[Transform3D]=[];transforms.assign(kit.batches[key])
		var mat: Material=steel
		if key=="concrete":mat=concrete
		elif key=="rim":mat=Geo.material(Color("af542e"))
		elif key=="net":mat=white
		Geo.instances(root,transforms,mat,null,180)
	batch_visible(root)
	root.set_meta("hoop_count",2)
	root.set_meta("hoop_direction",v)

static func batch_visible(root: Node3D) -> void:
	# Preserve physics independently before batching visible meshes by material.
	# Invisible stair ramps must not be merged back into the visible stair mesh.
	var visuals:=Node3D.new();visuals.name="BatchedSurfaces";root.add_child(visuals)
	var face_vertices_before:=0
	for child in root.get_children():
		if not child is MeshInstance3D or not child.visible:continue
		for body in child.get_children():
			if body is StaticBody3D:body.reparent(root,true)
		# BoxMesh is indexed, procedural prism meshes are not. Normalize before
		# append_from: mixing them drops unindexed faces when the merged mesh
		# acquires an index buffer from later boxes.
		face_vertices_before+=child.mesh.get_faces().size()
		var normalized:=SurfaceTool.new()
		normalized.create_from(child.mesh,0)
		normalized.deindex()
		child.mesh=normalized.commit()
		child.reparent(visuals,true)
	Geo.merge_surfaces(visuals)
	var face_vertices_after:=0
	for mesh in visuals.get_children():
		mesh.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		face_vertices_after+=mesh.mesh.get_faces().size()
	assert(face_vertices_before==face_vertices_after,"Recreation batching lost visible triangles")
