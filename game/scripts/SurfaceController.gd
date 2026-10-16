extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")

static func build(world: Node3D, parent: Node3D) -> void:
	var asphalt:=Geo.material(Color("51575a"))
	var concrete:=Geo.material(Color("aaa99f"))
	var edge:=Geo.material(Color("9a9b91"))
	# Preserve mapped lot outlines as areas, independent of access centre-lines.
	for area in world.site.parking: Geo.polygon(parent,area.points,asphalt,0.025)
	for road in world.roads:
		var a:=Geo.point(road.points[0])
		var b:=Geo.point(road.points[1])
		var pedestrian: bool=road.kind=="path" or road.name=="Residence Lane"
		# Residence Lane's internal promenade is unmarked concrete in supplied aerial.
		# Other mapped vehicular/service access remains asphalt, unmarked until evidenced.
		if not pedestrian: Geo.strip(parent,a,b,road.width+0.5,edge,0.025)
		Geo.strip(parent,a,b,road.width,concrete if pedestrian else asphalt,0.045 if pedestrian else 0.035)
	Geo.merge_surfaces(parent)
