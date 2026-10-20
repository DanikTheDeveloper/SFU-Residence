extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")

static func triangle(st: SurfaceTool,a: Vector3,b: Vector3,c: Vector3,color: Color) -> void:
	var normal: Vector3=(b-a).cross(c-a).normalized()
	st.set_color(color)
	st.set_normal(normal)
	for p in [a,b,c]: st.add_vertex(p)

static func branch(st: SurfaceTool,a: Vector3,b: Vector3,radius: float) -> void:
	var axis: Vector3=(b-a).normalized()
	var right: Vector3=axis.cross(Vector3.FORWARD).normalized()
	if right.length()<0.1: right=Vector3.RIGHT
	var side: Vector3=axis.cross(right)
	for i in 6:
		var u: Vector3=right*cos(i*TAU/6)+side*sin(i*TAU/6)
		var v: Vector3=right*cos((i+1)*TAU/6)+side*sin((i+1)*TAU/6)
		triangle(st,a+u*radius,b+u*radius*0.42,b+v*radius*0.42,Color("635b49"))
		triangle(st,a+u*radius,b+v*radius*0.42,a+v*radius,Color("635b49"))

static func leaf(st: SurfaceTool,p: Vector3,rng: RandomNumberGenerator,color: Color,size: float) -> void:
	var direction:=Vector3(rng.randf_range(-1,1),rng.randf_range(-0.4,0.5),rng.randf_range(-1,1)).normalized()*size
	var side:=direction.cross(Vector3.UP).normalized()*size*0.42
	triangle(st,p-direction,p+side,p+direction,color)
	triangle(st,p-direction,p+direction,p-side,color)

static func tree(pine: bool,detail: float=1.0) -> ArrayMesh:
	var st:=SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rng:=RandomNumberGenerator.new()
	rng.seed=12311 if pine else 92403
	branch(st,Vector3.ZERO,Vector3(0.12,6.7,0),0.19)
	var branch_count:=maxi(12,int((65 if pine else 42)*detail))
	for i in branch_count:
		var y: float=2.0+float(i)/float(branch_count)*4.9 if pine else rng.randf_range(2.5,6.7)
		var angle:=rng.randf()*TAU
		var radius: float=(7.7-y)*0.38 if pine else sqrt(maxf(0.0,1.0-pow((y-4.7)/2.6,2)))*2.15
		var end:=Vector3(cos(angle)*radius,y+0.25,sin(angle)*radius)
		branch(st,Vector3(0,y-0.7,0),end,0.045)
		if detail<0.5:
			# Coarse solid needle/leaf clusters keep distant woods from becoming
			# transparent skeletons after leaf-count reduction. Original mesh only.
			var foliage:=Color("35583d") if pine else Color("49673b")
			var radius_cluster: float=0.7 if pine else 0.9
			var center: Vector3=end*Vector3(0.78,1,0.78)
			for wedge in 6:
				var r0:=Vector3(cos(wedge*TAU/6)*radius_cluster,0,sin(wedge*TAU/6)*radius_cluster)
				var r1:=Vector3(cos((wedge+1)*TAU/6)*radius_cluster,0,sin((wedge+1)*TAU/6)*radius_cluster)
				triangle(st,center+r0,center+Vector3.UP*0.75,center+r1,foliage*(0.85+0.04*wedge))
				triangle(st,center+r1,center-Vector3.UP*0.45,center+r0,foliage*0.8)
		for j in maxi(8,int(26*detail)):
			var spread: float=0.48 if pine else 0.75
			var p: Vector3=end+Vector3(rng.randf_range(-spread,spread),rng.randf_range(-0.4,0.6),rng.randf_range(-spread,spread))
			var tone: float=rng.randf_range(0.75,1.15)
			leaf(st,p,rng,(Color("3b6349") if pine else Color("527241"))*tone,(0.24 if pine else 0.21)/sqrt(detail))
	return st.commit()

static func grass_mesh() -> ArrayMesh:
	var st:=SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rng:=RandomNumberGenerator.new()
	rng.seed=513
	for i in 18:
		var p:=Vector3(rng.randf_range(-0.26,0.26),0,rng.randf_range(-0.26,0.26))
		var angle:=rng.randf()*TAU
		var side:=Vector3(cos(angle),0,sin(angle))*0.024
		var tip:=p+Vector3(rng.randf_range(-0.08,0.08),rng.randf_range(0.12,0.27),rng.randf_range(-0.08,0.08))
		triangle(st,p-side,p+side,tip,Color("64764c")*rng.randf_range(0.8,1.1))
	return st.commit()

static func build(world: Node3D,parent: Node3D) -> void:
	var regions: Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/planting_regions.json"))
	var woods: Array=[]
	var lawns: Array=[]
	for region in regions:
		var polygon:=PackedVector2Array()
		for p in region.points: polygon.append(Vector2(p[0],p[1]))
		if region.kind=="wood": woods.append(polygon)
		else: lawns.append(polygon)
	var material:=Geo.material(Color.WHITE,0.97)
	material.vertex_color_use_as_albedo=true
	material.cull_mode=BaseMaterial3D.CULL_DISABLED
	var broad: Array[Transform3D]=[]
	var pine: Array[Transform3D]=[]
	var rng:=RandomNumberGenerator.new()
	rng.seed=34052
	# Infill only within mapped woodland, never scatter over the entire campus.
	for i in 4500:
		var p:=Vector2(rng.randf_range(-295,360),rng.randf_range(-125,185))
		if not Geo.contains_point(p,world.boundary) or world.occupied(p,3): continue
		var wooded:=false
		for polygon in woods:
			if Geo.contains_point(p,polygon): wooded=true; break
		if not wooded: continue
		var size:=rng.randf_range(0.9,1.55)
		var transform:=Geo.transform(Geo.point([p.x,p.y]),Vector3.ONE*size,rng.randf()*TAU)
		if i%4==0: broad.append(transform)
		else: pine.append(transform)
		if broad.size()+pine.size()>=90: break
	# Official North rear photograph confirms this planting type/edge; spacing estimated.
	for x in [-4,26,55,87,118,150,175]:
		var p:=Vector2(x,0.2314*x-17.85+1.4)
		if world.inside_building(p,0.6): continue
		broad.append(Geo.transform(Geo.point([p.x,p.y]),Vector3(0.7,1.15,0.7),float(x)*0.13))
	Geo.instances(parent,broad,material,tree(false),220).name="PhotoAndMappedBroadleaf"
	Geo.instances(parent,pine,material,tree(true),260).name="MappedWoodlandConifers"
	var groups: Dictionary={}
	for i in 5000:
		var p:=Vector2(rng.randf_range(-280,350),rng.randf_range(-110,175))
		if not Geo.contains_point(p,world.boundary) or world.occupied(p,0.8): continue
		var lawn:=false
		for polygon in lawns:
			if Geo.contains_point(p,polygon): lawn=true; break
		if not lawn: continue
		var key:=Vector2i(floori(p.x/32),floori(p.y/32))
		if not groups.has(key): groups[key]=[]
		groups[key].append(Geo.transform(Geo.point([p.x,p.y],0.02),Vector3.ONE,rng.randf()*TAU))
	var mesh:=grass_mesh()
	var count:=0
	for key in groups:
		var transforms: Array[Transform3D]=[]
		transforms.assign(groups[key])
		count+=transforms.size()
		Geo.instances(parent,transforms,material,mesh,65).name="MappedGrass_"+str(key)
	print("PHOTO_PLANTING broadleaf=",broad.size()," conifers=",pine.size()," grass_clumps=",count)
