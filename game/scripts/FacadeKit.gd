extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
static var materials: Dictionary={}
var batches: Dictionary={}

static func material(key: String) -> Material:
	if not materials.has(key):
		var colors: Dictionary={"cladding":"e0dfd5","brick":"c8c2ac","frame":"303b3e","glass":"52696b","reveal":"68716e","orange":"bd7847","cap":"b8bdb6","teal":"598d88"}
		var m:=Geo.material(Color(colors[key]),0.32 if key=="glass" else 0.82)
		if key=="glass": m.metallic_specular=0.65
		materials[key]=m
	return materials[key]

func part(key: String, center: Vector3, size: Vector3, yaw: float) -> void:
	if size.x<=0.001 or size.y<=0.001: return
	if not batches.has(key): batches[key]=[]
	batches[key].append(Geo.transform(center,size,yaw))

func window(center: Vector3, tangent: Vector3, normal: Vector3, width: float, height: float, yaw: float, split: bool=true) -> void:
	# Glazing sits behind a deep four-sided opening, with an operable narrow light.
	part("glass",center+normal*0.025,Vector3(width,height,0.035),yaw)
	for side in [-1,1]:
		part("reveal",center+tangent*side*(width*0.5+0.035)+normal*0.12,Vector3(0.07,height+0.14,0.23),yaw)
		part("frame",center+tangent*side*(width*0.5-0.025)+normal*0.16,Vector3(0.065,height,0.085),yaw)
		part("reveal",center+Vector3.UP*side*(height*0.5+0.035)+normal*0.12,Vector3(width,0.07,0.23),yaw)
		part("frame",center+Vector3.UP*side*(height*0.5-0.025)+normal*0.16,Vector3(width,0.065,0.085),yaw)
	if split:
		part("frame",center+tangent*width*0.18+normal*0.16,Vector3(0.055,height,0.085),yaw)
		part("frame",center+Vector3.UP*height*0.20+normal*0.16,Vector3(width,0.055,0.085),yaw)
	part("frame",center-Vector3.UP*(height*0.5+0.06)+normal*0.22,Vector3(width+0.15,0.06,0.3),yaw)

func finish(parent: Node3D, prefix: String) -> void:
	for key in batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(batches[key])
		Geo.instances(parent,transforms,material(key),null,420).name=prefix+key.capitalize()
