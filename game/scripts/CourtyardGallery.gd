extends RefCounted
# DIALOG 0027: courtyard-facing exterior gallery. Dimensions are estimates.
const Geo=preload("res://scripts/Geometry.gd")
const DEPTH=3.6
const HEIGHT=3.1

static func layout(data: Dictionary) -> Dictionary:
	var a:=Vector3(data.footprint[3][0],0,data.footprint[3][1])
	var b:=Vector3(data.footprint[4][0],0,data.footprint[4][1])
	var tangent: Vector3=(b-a).normalized()
	var outward: Vector3=tangent.cross(Vector3.UP)
	var cut:=PackedVector2Array()
	for p in [a-tangent*0.12+outward,b+tangent*0.12+outward,b+tangent*0.12-outward*DEPTH,a-tangent*0.12-outward*DEPTH]: cut.append(Vector2(p.x,p.z))
	return {"a":a,"b":b,"tangent":tangent,"outward":outward,"cut":cut,"height":HEIGHT,"depth":DEPTH}

static func contains(data: Dictionary,p: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(p,layout(data).cut)

static func build(root: Node3D,data: Dictionary,base: float,kit: RefCounted) -> void:
	var d:=layout(data)
	root.set_meta("court_gallery",d)
	var a: Vector3=d.a+Vector3.UP*base
	var b: Vector3=d.b+Vector3.UP*base
	var tangent: Vector3=d.tangent
	var normal: Vector3=d.outward
	var length: float=a.distance_to(b)
	var yaw: float=-atan2(tangent.z,tangent.x)
	var mid: Vector3=(a+b)*0.5-normal*DEPTH*0.5
	var concrete:=Geo.material(Color("cecdc5"),0.94)
	var soffit:=Geo.box(root,mid+Vector3.UP*(HEIGHT+0.06),Vector3(length,0.12,DEPTH),concrete,true)
	soffit.rotation.y=yaw; soffit.name="CourtGallerySoffit"
	for fraction in [0.08,0.36,0.64,0.92]:
		var center: Vector3=a.lerp(b,fraction)-normal*0.3+Vector3.UP*HEIGHT*0.5
		var pier:=Geo.box(root,center,Vector3(0.75,HEIGHT,0.48),concrete,true)
		pier.rotation.y=yaw; pier.name="CourtGalleryPier"
	for i in int(length/0.23):
		kit.part("panel",mid+tangent*(i*0.23-length*0.5)+Vector3.UP*(HEIGHT-0.08),Vector3(0.045,0.16,DEPTH),yaw)
	# Opaque rear closure with recessed glazing; no residential interior.
	var rear: Vector3=(a+b)*0.5-normal*(DEPTH-0.06)
	for i in 10:
		var center: Vector3=rear+tangent*((i+0.5)/10.0-0.5)*length+Vector3.UP*1.45
		kit.window(center,tangent,normal,length/10.0-0.18,2.7,yaw,false)
	var paving=preload("res://scripts/ResidencePavers.gd")
	var polygon: Array=[]
	for q in [a+normal*0.7,b+normal*0.7,b-normal*DEPTH,a-normal*DEPTH]: polygon.append([q.x,q.z])
	var mesh:=Geo.polygon(root,polygon,paving.material(),0.065)
	mesh.name="CourtGalleryGreyPaving"
	paving.align(mesh,a,tangent,1.6)

	# Photo0027 shows hardscape across the internal courtyard, not an open lawn.
	# Use the existing re-entrant footprint vertices; retain present planter islands.
	var court: Array=[data.footprint[1],data.footprint[2],data.footprint[3],data.footprint[4]]
	var court_mesh:=Geo.polygon(root,court,paving.material(),0.068)
	court_mesh.name="InternalCourtGreyPavers"
	paving.align(court_mesh,a,tangent,1.6)
