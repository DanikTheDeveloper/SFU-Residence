extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
static func point(base: float) -> Vector3:
	var d: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/shell_main_entrance.json"))
	return Vector3(d.point[0],base,d.point[1])
static func build(root: Node3D,base: float,kit: RefCounted,concrete: Material) -> void:
	var door:=point(base+0.10)
	var tangent:=Vector3(11.686,0,-49.726).normalized()
	var normal:=Vector3(tangent.z,0,-tangent.x)
	var yaw: float=-atan2(tangent.z,tangent.x)
	var center:=door+normal*0.30+Vector3.UP*1.27
	kit.window(center,tangent,normal,3.0,2.5,yaw,true,"frame")
	kit.part("frame",center+normal*0.19,Vector3(0.07,2.5,0.10),yaw)
	for side in [-1,1]:
		kit.part("fin",center+tangent*side*0.20+normal*0.24,Vector3(0.04,0.38,0.05),yaw)
	var canopy:=Geo.box(root,door+normal*1.0+Vector3.UP*2.88,Vector3(5.8,0.18,2.4),concrete,true)
	canopy.rotation.y=yaw;canopy.name="MappedMainEntryCanopy"
	kit.part("fascia",door+normal*2.20+Vector3.UP*2.88,Vector3(5.8,0.12,0.08),yaw)
	var poly: Array=[]
	for offset in [Vector2(-2.4,0.25),Vector2(2.4,0.25),Vector2(2.4,5.5),Vector2(-2.4,5.5)]:
		var p: Vector3=door+tangent*offset.x+normal*offset.y
		poly.append([p.x,p.z])
	Geo.polygon(root,poly,preload("res://scripts/PavementMaterials.gd").material("walkway"),0.09).name="MainEntryAsphaltApproach"
	var threshold: Array=[]
	for offset in [Vector2(-1.7,0.25),Vector2(1.7,0.25),Vector2(1.7,1.0),Vector2(-1.7,1.0)]:
		var p: Vector3=door+tangent*offset.x+normal*offset.y
		threshold.append([p.x,p.z])
	Geo.polygon(root,threshold,preload("res://scripts/PavementMaterials.gd").material("concrete"),0.10).name="MainEntryThreshold"
	root.set_meta("photo_main_entrance",door)
	root.set_meta("photo_main_normal",normal)
