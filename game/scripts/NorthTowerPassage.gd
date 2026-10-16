extends RefCounted
# Photo-supported exterior passage; exact survey dimensions remain estimated.
const Geo=preload("res://scripts/Geometry.gd")
const CLEAR_HEIGHT=2.9
const WIDTH=24.0
const CORE_WIDTH=5.0
const WALK_LANE=8.0

static func layout(data: Dictionary, base: float) -> Dictionary:
	var p: Array=data.footprint
	# Central courtyard bar, not the side wing: established by the user's full courtyard photo.
	var west:=Vector3(p[21][0],base,p[21][1])
	var east:=Vector3(p[20][0],base,p[20][1])
	var side: Vector3=(east-west).normalized()
	var axis:=Vector3(side.z,0,-side.x)
	var start: Vector3=(west+east)*0.5
	var distance:=20.0
	# Find the opposite exterior face, preserving the registered footprint.
	for i in p.size():
		var hit=Geometry2D.segment_intersects_segment(Vector2(start.x,start.z)+Vector2(axis.x,axis.z)*0.05,Vector2(start.x,start.z)+Vector2(axis.x,axis.z)*20,Vector2(p[i][0],p[i][1]),Vector2(p[(i+1)%p.size()][0],p[(i+1)%p.size()][1]))
		if hit!=null:
			distance=minf(distance,Vector2(start.x,start.z).distance_to(hit))
	return {"start":start,"end":start+axis*distance,"axis":axis,"side":side,"length":distance,"base":base}

static func interval(a: Vector3,b: Vector3,plan: Dictionary,margin: float=0.0) -> Vector2:
	var lo:=0.0
	var hi:=1.0
	var origin: Vector3=plan.start
	for dim in 2:
		var axis: Vector3=plan.axis if dim==0 else plan.side
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
	var mid: Vector3=(plan.start+plan.end)*0.5
	var yaw: float=-atan2(plan.axis.z,plan.axis.x)
	for sign_value in [-1,1]:
		var wall:=Geo.box(root,mid+plan.side*sign_value*(WIDTH*0.5+0.1)+Vector3.UP*CLEAR_HEIGHT*0.5,Vector3(plan.length, CLEAR_HEIGHT,0.2),material,true)
		wall.name="PassageSideWall"
		wall.rotation.y=yaw
	# Broad undercroft supported by piers; central pedestrian lane stays clear.
	for offset in [-4.0,4.0]:
		for depth in [0.3,plan.length-0.3]:
			var column:=Geo.box(root,plan.start+plan.side*offset+plan.axis*depth+Vector3.UP*CLEAR_HEIGHT*0.5,Vector3(0.75,CLEAR_HEIGHT,0.75),material,true)
			column.name="UndercroftColumn"
			column.rotation.y=yaw
	# The lounge/entry stack is enclosed at ground level in the courtyard photographs.
	# Keep it sealed while preserving exterior circulation on either side.
	var core:=Geo.box(root,mid+Vector3.UP*CLEAR_HEIGHT*0.5,Vector3(plan.length,CLEAR_HEIGHT,CORE_WIDTH),material,true)
	core.name="ClosedGroundLoungeCore"
	core.rotation.y=yaw
	var ceiling:=Geo.box(root,mid+Vector3.UP*(CLEAR_HEIGHT+0.12),Vector3(plan.length,0.24,WIDTH),material,true)
	ceiling.name="PassageSoffit"
	ceiling.rotation.y=yaw


	# Thin visual paving follows existing terrain triangles; terrain remains the collider.
	var paving: Array=[]
	for corner in [plan.start-plan.axis*0.4-plan.side*WIDTH*0.5,plan.end+plan.axis*0.4-plan.side*WIDTH*0.5,plan.end+plan.axis*0.4+plan.side*WIDTH*0.5,plan.start-plan.axis*0.4+plan.side*WIDTH*0.5]:
		paving.append([corner.x,corner.z])
	Geo.polygon(root,paving,preload("res://scripts/NorthTowerMaterials.gd").material("paving"),0.025).name="PassagePaving"

	# Courtyard-side concrete apron shown in the wide reference photo.
	# Visual surface only: follows the original terrain and leaves routes unchanged.
	var apron: Array=[]
	for corner in [plan.start-plan.side*16.0-plan.axis*3.0,plan.start+plan.side*16.0-plan.axis*3.0,plan.start+plan.side*16.0-plan.axis*0.4,plan.start-plan.side*16.0-plan.axis*0.4]:
		apron.append([corner.x,corner.z])
	Geo.polygon(root,apron,preload("res://scripts/NorthTowerMaterials.gd").material("paving"),0.027).name="CourtyardApron"
