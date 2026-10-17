extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
const Finish=preload("res://scripts/PavementMaterials.gd")
const Pavers=preload("res://scripts/ResidencePavers.gd")

static func near_townhouse(point: Vector2,registry: Array) -> bool:
	for building in registry:
		if building.type!="townhouse": continue
		var footprint: Array=building.footprint
		for i in footprint.size():
			var a: Array=footprint[i]
			var b: Array=footprint[(i+1)%footprint.size()]
			if point.distance_to(Geometry2D.get_closest_point_to_segment(point,Vector2(a[0],a[1]),Vector2(b[0],b[1])))<8.0: return true
	return false

static func closest_entry_is_east(point: Vector2,registry: Array) -> bool:
	var closest: String=""
	var distance: float=INF
	for building in registry:
		var entry:=Vector2(building.entrance[0],building.entrance[1])
		var candidate:=point.distance_squared_to(entry)
		if candidate<distance:
			distance=candidate
			closest=building.id
	return closest=="EAT"

static func strip(parent: Node3D,a: Vector3,b: Vector3,width: float,mat: Material,offset: float,tile: float=4.0) -> void:
	var side:=Vector3(-(b-a).z,0,(b-a).x).normalized()*width*0.5
	var polygon: Array=[]
	for corner in [a+side,b+side,b-side,a-side]: polygon.append([corner.x,corner.z])
	var node:=Geo.polygon(parent,polygon,mat,offset)
	# Shared world texture origin prevents conflicting patterns at strip overlaps.
	Pavers.align(node,Vector3.ZERO,Vector3.RIGHT,tile)

static func build(world: Node3D,parent: Node3D) -> void:
	var asphalt:=Finish.material("road")
	var concrete:=Finish.material("concrete")
	var walkway:=Finish.material("walkway")
	var border:=Finish.material("border")
	var edge:=Geo.material(Color("9a9b91"))
	var east_door:=Vector2(130.164,86.2765)
	var counts: Dictionary={"concrete":0,"townhouse_grey":0,"east_pavers":0,"vehicle":0}
	# Original polygons and every centreline/width retained. No new ground collisions.
	for area in world.site.parking: Geo.polygon(parent,area.points,asphalt,0.025)
	for road in world.roads:
		var a:=Geo.point(road.points[0])
		var b:=Geo.point(road.points[1])
		var mid:=Vector2((a.x+b.x)*0.5,(a.z+b.z)*0.5)
		var pedestrian: bool=road.kind=="path" or road.name=="Residence Lane"
		if not pedestrian:
			var in_parking:=false
			for area in world.site.parking:
				if Geo.contains_point(mid,area.points): in_parking=true
			if not in_parking: Geo.strip(parent,a,b,road.width+0.5,edge,0.025)
			strip(parent,a,b,road.width,asphalt,0.035)
			counts.vehicle+=1
			continue
		# Handpicked PWL 1023 identifies East by its sign: only nearby existing walks.
		var warm_pavers: bool=road.kind=="path" and mid.distance_to(east_door)<14.0 and a.distance_to(b)<25.0 and closest_entry_is_east(mid,world.registry)
		if warm_pavers:
			strip(parent,a,b,road.width+0.16,border,0.055)
			strip(parent,a,b,road.width,Pavers.material(true),0.065,1.2)
			if a.distance_to(b)>5:
				var tangent:=Vector3(b.x-a.x,0,b.z-a.z).normalized()
				var side:=Vector3(-tangent.z,0,tangent.x)
				var center: Vector3=(a+b)*0.5
				strip(parent,center-side*road.width*0.5,center+side*road.width*0.5,0.14,border,0.075)
			counts.east_pavers+=1
		elif road.kind=="path" and near_townhouse(mid,world.registry):
			# User townhouse images show fine grey surfacing, not plaza blocks.
			strip(parent,a,b,road.width,walkway,0.050,2.0)
			counts.townhouse_grey+=1
		else:
			strip(parent,a,b,road.width,concrete,0.045)
			counts.concrete+=1
	parent.set_meta("surface_finish_counts",counts)
	Geo.merge_surfaces(parent)
	print("PHOTO_PAVING ",counts)
