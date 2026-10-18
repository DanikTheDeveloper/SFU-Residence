extends RefCounted
# Shallow eastern covered exterior, photo DIALOG0058. Dimensions provisional.
const Geo=preload("res://scripts/Geometry.gd")
const DEPTH=3.4

static func layout(data: Dictionary) -> Dictionary:
	var a:=Vector3(data.footprint[10][0],0,data.footprint[10][1])
	var b:=Vector3(data.footprint[12][0],0,data.footprint[12][1])
	var tangent: Vector3=(b-a).normalized()
	var outward: Vector3=tangent.cross(Vector3.UP)
	var cut:=PackedVector2Array()
	for p in [a-tangent*0.15+outward,b+tangent*0.15+outward,b+tangent*0.15-outward*DEPTH,a-tangent*0.15-outward*DEPTH]:
		cut.append(Vector2(p.x,p.z))
	return {"a":a,"b":b,"tangent":tangent,"outward":outward,"cut":cut,"height":float(data.height_m)/int(data.floors)*2}

static func contains(data: Dictionary,p: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(p,layout(data).cut)

static func build(root: Node3D,data: Dictionary,base: float,kit: RefCounted) -> void:
	var d:=layout(data)
	var a: Vector3=d.a+Vector3.UP*base
	var b: Vector3=d.b+Vector3.UP*base
	var tangent: Vector3=d.tangent
	var normal: Vector3=d.outward
	var mid: Vector3=(a+b)*0.5-normal*DEPTH*0.5
	var yaw: float=-atan2(tangent.z,tangent.x)
	var length: float=a.distance_to(b)
	var concrete:=Geo.material(Color("cecdc5"),0.92)
	root.set_meta("east_portico",d)
	var apron: Array=[]
	for corner in [a+normal*0.65,b+normal*0.65,b-normal*DEPTH,a-normal*DEPTH]: apron.append([corner.x,corner.z])
	var paving=preload("res://scripts/ResidencePavers.gd")
	var paving_mesh:=Geo.polygon(root,apron,paving.material(),0.065)
	paving_mesh.name="EastPorticoGreyPavers"
	paving.align(paving_mesh,a,tangent,1.6)
	# Closed soffit and rear boundary: exterior space only, no residential interior.
	var ceiling:=Geo.box(root,mid+Vector3.UP*(d.height+0.05),Vector3(length,0.10,DEPTH),concrete,true)
	ceiling.rotation.y=yaw; ceiling.name="EastPorticoSoffit"
	for fraction in [0.12,0.50,0.88]:
		var center: Vector3=a.lerp(b,fraction)-normal*0.30+Vector3.UP*d.height*0.5
		var pier:=Geo.box(root,center,Vector3(0.82,d.height,0.95),concrete,true)
		pier.rotation.y=yaw; pier.name="EastPorticoPier"
	# Recessed opaque glazing behind the supports; upper-level walkway indication.
	var rear: Vector3=(a+b)*0.5-normal*(DEPTH-0.05)
	var bays:=6
	for bay in bays:
		var center: Vector3=rear+tangent*((float(bay)+0.5)/bays-0.5)*length
		kit.window(center+Vector3.UP*1.45,tangent,normal,length/bays-0.16,2.75,yaw,false)
		kit.window(center+Vector3.UP*4.65,tangent,normal,length/bays-0.16,2.80,yaw,false)
	kit.part("cap",rear+normal*0.6+Vector3.UP*3.05,Vector3(length,0.20,1.2),yaw)
	# Thin glass-like opaque rail avoids transparency sorting on Compatibility.
	kit.part("glass",rear+normal*1.15+Vector3.UP*3.62,Vector3(length,0.95,0.035),yaw)
	kit.part("frame",rear+normal*1.15+Vector3.UP*4.10,Vector3(length,0.06,0.08),yaw)
	for i in 7:
		kit.part("frame",rear+tangent*(float(i)/6-0.5)*length+normal*1.15+Vector3.UP*3.60,Vector3(0.05,1.0,0.06),yaw)
	# Narrow repeated ceiling fins visible at pedestrian eye height.
	for i in int(length/0.22):
		kit.part("cap",mid+tangent*(i*0.22-length*0.5)+Vector3.UP*(d.height-0.04),Vector3(0.035,0.08,DEPTH),yaw)
