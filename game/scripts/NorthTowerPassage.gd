extends RefCounted
# Photo-supported exterior passage; exact survey dimensions remain estimated.
const Geo=preload("res://scripts/Geometry.gd")
const CLEAR_HEIGHT=2.9
const WIDTH=3.6

static func layout(data: Dictionary, base: float) -> Dictionary:
	var p: Array=data.footprint
	var west:=Vector3(p[21][0],base,p[21][1])
	var east:=Vector3(p[20][0],base,p[20][1])
	# Legacy facade axes retained: side=east, axis=north. Travel is longitudinal.
	var side: Vector3=(east-west).normalized()
	var axis:=Vector3(side.z,0,-side.x)
	var start: Vector3=(west+east)*0.5
	var low:=0.0
	var high:=0.0
	for point in p:
		var projection: float=(Vector3(point[0],base,point[1])-start).dot(side)
		low=minf(low,projection)
		high=maxf(high,projection)
	var gallery_start: Vector3=start+side*(low-0.1)+axis*1.5
	var gallery_end: Vector3=start+side*(high+0.1)+axis*1.5
	return {"start":start,"axis":axis,"side":side,"base":base,"gallery_start":gallery_start,"gallery_end":gallery_end,"length":high-low+0.2}

static func interval(a: Vector3,b: Vector3,plan: Dictionary,margin: float=0.0) -> Vector2:
	var lo:=0.0
	var hi:=1.0
	var origin: Vector3=plan.gallery_start
	for dim in 2:
		var axis: Vector3=plan.side if dim==0 else plan.axis
		var low: float=-0.05-margin if dim==0 else -WIDTH*0.5-margin
		var high: float=plan.length+0.05+margin if dim==0 else WIDTH*0.5+margin
		var pos: float=(a-origin).dot(axis)
		var delta: float=(b-a).dot(axis)
		if absf(delta)<0.00001:
			if pos<low or pos>high: return Vector2(-1,-1)
		else:
			var t0: float=(low-pos)/delta
			var t1: float=(high-pos)/delta
			lo=maxf(lo,minf(t0,t1))
			hi=minf(hi,maxf(t0,t1))
			if lo>hi: return Vector2(-1,-1)
	return Vector2(lo,hi)

static func quad(vertices: PackedVector3Array,a: Vector3,b: Vector3,bottom: float,top: float) -> void:
	var low:=Vector3.UP*bottom
	var high:=Vector3.UP*top
	vertices.append_array([a+low,b+high,b+low,a+low,a+high,b+high])

static func append_wall(vertices: PackedVector3Array,a: Vector3,b: Vector3,height: float,data: Dictionary) -> void:
	var cut:=interval(a,b,layout(data,a.y))
	if cut.x<0:
		quad(vertices,a,b,0,height)
		return
	if cut.x>0.0001: quad(vertices,a,a.lerp(b,cut.x),0,height)
	quad(vertices,a.lerp(b,cut.x),a.lerp(b,cut.y),CLEAR_HEIGHT,height)
	if cut.y<0.9999: quad(vertices,a.lerp(b,cut.y),b,0,height)

static func build(root: Node3D,data: Dictionary,base: float,material: Material) -> void:
	var plan:=layout(data,base)
	root.set_meta("exterior_passage",plan)
	var mid: Vector3=(plan.gallery_start+plan.gallery_end)*0.5
	var yaw: float=-atan2(plan.side.z,plan.side.x)
	# Closed rear boundary: exterior circulation only, no access into residential rooms.
	var wall:=Geo.box(root,mid+plan.axis*(WIDTH*0.5+0.1)+Vector3.UP*CLEAR_HEIGHT*0.5,Vector3(plan.length,CLEAR_HEIGHT,0.2),material,true)
	wall.name="GalleryRearWall"
	wall.rotation.y=yaw
	for offset in [-12.0,-2.8,2.8,12.0]:
		var column:=Geo.box(root,plan.start+plan.side*offset-plan.axis*0.15+Vector3.UP*CLEAR_HEIGHT*0.5,Vector3(0.60,CLEAR_HEIGHT,0.60),material,true)
		column.name="GalleryCourtyardColumn"
		column.rotation.y=yaw
	# Courtyard photographs show a recessed central glazed entrance behind the gallery.
	# Closed exterior door only; exact width/depth are estimated.
	var kit=preload("res://scripts/FacadeKit.gd").new()
	var door_center: Vector3=mid+plan.axis*(WIDTH*0.5-0.05)+Vector3.UP*1.25
	kit.window(door_center,plan.side,-plan.axis,2.6,2.5,yaw,true,"white_frame")
	kit.part("white_frame",door_center-plan.axis*0.24,Vector3(0.07,2.5,0.08),yaw)
	for sign_value in [-1,1]:
		kit.part("white_frame",door_center+plan.side*sign_value*0.18-plan.axis*0.28,Vector3(0.035,0.45,0.045),yaw)
	preload("res://scripts/NorthTowerMaterials.gd").finish(kit,root)
	var ceiling:=Geo.box(root,mid+Vector3.UP*(CLEAR_HEIGHT+0.12),Vector3(plan.length,0.24,WIDTH),material,true)
	ceiling.name="GallerySoffit"
	ceiling.rotation.y=yaw
	pave(root,plan.gallery_start,plan.gallery_end,WIDTH,"GalleryPaving")
	pave(root,plan.start-plan.side*16-plan.axis*1.6,plan.start+plan.side*16-plan.axis*1.6,2.6,"CourtyardApron")

static func pave(root: Node3D,a: Vector3,b: Vector3,width: float,title: String) -> void:
	var tangent: Vector3=(b-a).normalized()
	var side:=Vector3(tangent.z,0,-tangent.x).normalized()*width*0.5
	var polygon: Array=[]
	for corner in [a-side,b-side,b+side,a+side]: polygon.append([corner.x,corner.z])
	Geo.polygon(root,polygon,preload("res://scripts/NorthTowerMaterials.gd").material("paving"),0.025).name=title

static func connect_row(world: Node3D) -> void:
	var root:=Node3D.new()
	root.name="NorthGalleryConnections"
	world.add_child(root)
	# User confirms connected circulation. Roof spans/dimensions are estimated, not surveyed.
	for pair in [["PJH","BRH"],["BRH","SBH"]]:
		var left: Dictionary=world.get_node("Buildings/"+pair[0]).get_meta("exterior_passage")
		var right: Dictionary=world.get_node("Buildings/"+pair[1]).get_meta("exterior_passage")
		var a: Vector3=left.gallery_end
		var b: Vector3=right.gallery_start
		pave(root,a-left.side*0.2,b+right.side*0.2,WIDTH,"ConnectingWalkway")
		var direction: Vector3=(b-a).normalized()
		var cross_axis:=Vector3(direction.z,0,-direction.x).normalized()
		var canopy:=Geo.box(root,(a+b)*0.5+Vector3.UP*(CLEAR_HEIGHT+0.12),Vector3(a.distance_to(b)+0.4,0.24,WIDTH),preload("res://scripts/NorthTowerMaterials.gd").material("concrete"),true)
		canopy.name="EstimatedGalleryConnectionCanopy"
		canopy.basis=Basis(direction,cross_axis.cross(direction).normalized(),cross_axis)
