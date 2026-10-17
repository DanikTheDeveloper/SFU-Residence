extends RefCounted
# PWL 1025: charcoal open-frame courtyard light. Existing placement is estimated.
const Geo=preload("res://scripts/Geometry.gd")
var bodies: Array[Transform3D]=[]
var lenses: Array[Transform3D]=[]

func append(position: Vector3,tangent: Vector3) -> void:
	var along:=Vector3(tangent.x,0,tangent.z).normalized()
	var yaw: float=-atan2(along.z,along.x)
	# Opaque lower column and two narrow upper rails, with a recessed downward lens.
	bodies.append(Geo.transform(position+Vector3.UP*0.95,Vector3(0.38,1.9,0.20),yaw))
	for side in [-1,1]:
		bodies.append(Geo.transform(position+along*side*0.16+Vector3.UP*2.65,Vector3(0.06,1.5,0.20),yaw))
	bodies.append(Geo.transform(position+Vector3.UP*3.43,Vector3(0.38,0.10,0.24),yaw))
	lenses.append(Geo.transform(position+Vector3.UP*3.37,Vector3(0.25,0.025,0.14),yaw))

func finish(root: Node3D) -> void:
	if bodies.is_empty(): return
	var charcoal:=Geo.material(Color("45494a"),0.80)
	var lens:=Geo.material(Color("e2d7b9"),0.45)
	Geo.instances(root,bodies,charcoal,null,160).name="PhotoCourtyardLightFrames"
	Geo.instances(root,lenses,lens,null,160).name="PhotoCourtyardLightLenses"
