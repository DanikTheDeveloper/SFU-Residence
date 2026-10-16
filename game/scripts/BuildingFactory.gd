extends RefCounted
const Geo = preload("res://scripts/Geometry.gd")
const Materials = preload("res://scripts/Materials.gd")

static func build(parent: Node3D, data: Dictionary) -> Node3D:
	var root := Node3D.new()
	root.name = data.id
	root.set_meta("building",data)
	parent.add_child(root)
	var points: Array = data.footprint.duplicate()
	var poly := PackedVector2Array()
	for p in points: poly.append(Vector2(p[0],p[1]))
	# Positive polygon area => outward is edge.cross(UP) in X/Z space.
	if Geometry2D.is_polygon_clockwise(poly):
		points.reverse()
		poly.reverse()
	var base: float=preload("res://scripts/TerrainController.gd").foundation(data.id)-0.10
	root.set_meta("foundation_world_y",base)
	var height: float = data.height_m
	var top := base + height
	var walls := PackedVector3Array()
	var roof := PackedVector3Array()
	var trim: Array[Transform3D] = []
	var glass: Array[Transform3D] = []
	var frames: Array[Transform3D] = []
	var panels: Array[Transform3D] = []
	var palette: Array = data.facade.palette
	var body_mat := Materials.facade(Color(palette[0]),data.type)
	var accent_mat := Geo.material(Color(palette[1]))
	var roof_mat := Geo.material(Color("555a59"))
	var frame_mat := Geo.material(Color("d3d8d4"))
	if data.type in ["modern_tower","modern_residence","dining"]: frame_mat=Geo.material(Color("3c4241"))
	var glass_mat := Geo.material(Color("284653"),0.27)
	var floors: int = data.floors
	var story: float = height / floors
	for i in points.size():
		var p: Array = points[i]
		var q: Array = points[(i+1)%points.size()]
		var a := Vector3(p[0],base,p[1])
		var b := Vector3(q[0],base,q[1])
		var edge := b-a
		var length := edge.length()
		if length < 0.05: continue
		var outward := Vector3.UP.cross(edge).normalized()
		var up := Vector3.UP*height
		walls.append_array([a,b+up,b,a,a+up,b+up])
		var yaw := -atan2(edge.z,edge.x)
		var middle := (a+b)*0.5
		trim.append(Geo.transform(middle+Vector3.UP*(height+0.16),Vector3(length+0.12,0.32,0.4),yaw))
		if length < 2.2: continue
		var bays := maxi(1,int(length/float(data.facade.bay_m)))
		var spacing := length/bays
		for floor_index in floors:
			var y := 1.5+floor_index*story
			if data.type in ["north_tower","lowrise_hall","dining"]:
				trim.append(Geo.transform(middle+Vector3.UP*(floor_index*story+0.2)+outward*0.07,Vector3(length,0.18,0.16),yaw))
			for bay in bays:
				var pos := a+edge*((bay+0.5)/bays)+Vector3.UP*y+outward*0.10
				var width := minf(1.55,spacing*0.65)
				var wh := 1.55
				if data.type in ["modern_tower","modern_residence"]:
					wh=2.05
					if floor_index < 2: width=spacing*0.82
				if data.type == "dining":
					width=spacing*0.88
					wh=2.8
				frames.append(Geo.transform(pos,Vector3(width+0.16,wh+0.16,0.12),yaw))
				glass.append(Geo.transform(pos+outward*0.08,Vector3(width,wh,0.08),yaw))
				if data.type in ["modern_tower","modern_residence"] and (bay+floor_index)%3==0:
					panels.append(Geo.transform(pos-Vector3.UP*(wh*0.5+0.32),Vector3(width,0.45,0.1),yaw))
				elif data.type=="north_tower" and bay%4==0:
					panels.append(Geo.transform(pos+edge.normalized()*spacing*0.43,Vector3(0.35,story,0.13),yaw))
		if data.type=="townhouse":
			for bay in bays:
				var pos := a+edge*((bay+0.5)/bays)+outward*0.14
				panels.append(Geo.transform(pos+Vector3.UP*(height*0.5),Vector3(0.16,height,0.2),yaw))
	var indices := Geometry2D.triangulate_polygon(poly)
	for i in range(0,indices.size(),3):
		var a := Vector3(poly[indices[i]].x,top,poly[indices[i]].y)
		var b := Vector3(poly[indices[i+1]].x,top,poly[indices[i+1]].y)
		var c := Vector3(poly[indices[i+2]].x,top,poly[indices[i+2]].y)
		if (b-a).cross(c-a).y<0: roof.append_array([a,c,b])
		else: roof.append_array([a,b,c])
	if data.id in ["EAT","WET"]:
		body_mat=preload("res://scripts/FacadeKit.gd").material("reveal")
	var wall_mesh := Geo.mesh_from_vertices(root,walls,body_mat,true)
	wall_mesh.name="ExteriorCollision"
	Geo.mesh_from_vertices(root,roof,roof_mat,true).name="Roof"
	if data.id in ["EAT","WET"]:
		preload("res://scripts/ModernTowerExterior.gd").build(root,data,points,base,height)
		accent_mat=preload("res://scripts/FacadeKit.gd").material("teal" if data.id=="EAT" else "frame")
	else:
		Geo.instances(root,trim,roof_mat,null,650).name="RooflineAndBands"
		Geo.instances(root,frames,frame_mat,null,350).name="WindowFrames"
		Geo.instances(root,glass,glass_mat,null,350).name="Glazing"
		Geo.instances(root,panels,accent_mat,null,350).name="FacadeAccents"
	# A closed door and canopy on the data-defined entrance; no interior opening.
	var door := Geo.point(data.entrance)
	var anchor := Geo.point(data.outdoor_anchor)
	var normal := (anchor-door).normalized()
	normal.y=0
	var door_yaw := atan2(normal.x,normal.z)
	var door_mesh := Geo.box(root,door+Vector3.UP*1.15+normal*0.15,Vector3(2.1,2.3,0.16),glass_mat)
	door_mesh.rotation.y=door_yaw
	var canopy := Geo.box(root,door+Vector3.UP*2.85+normal*0.9,Vector3(3.6,0.22,2.1),accent_mat,true)
	canopy.rotation.y=door_yaw
	var label := Label3D.new()
	label.name="NameSign"
	label.text=data.name
	label.font_size=40
	label.pixel_size=0.012
	label.outline_size=10
	label.modulate=Color("f4eee0")
	root.add_child(label)
	label.position=door+Vector3.UP*3.35+normal*0.27
	label.rotation.y=door_yaw
	var debug := Label3D.new()
	debug.name="MapLabel"
	debug.text=data.id+" · "+data.name
	debug.font_size=32
	debug.pixel_size=0.025
	debug.billboard=BaseMaterial3D.BILLBOARD_ENABLED
	debug.no_depth_test=true
	debug.visible=false
	root.add_child(debug)
	debug.position=Vector3(data.centroid[0],top+3,data.centroid[1])
	debug.add_to_group("building_labels")
	return root
