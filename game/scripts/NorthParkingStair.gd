extends RefCounted
# OSM1159793611: steps, handrail=yes, down toward the gallery; 2023-09-05.
# Exact tread count and width are estimated against existing grade, not photo survey.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const Rail=preload("res://scripts/NorthDiningStair.gd")

static func build(world: Node3D) -> void:
	var a:=Geo.point([112.856,8.273])
	var b:=Geo.point([110.252,19.715])
	var u:=Vector3(b.x-a.x,0,b.z-a.z).normalized()
	var v:=Vector3(-u.z,0,u.x)
	var length:=Vector2(a.x,a.z).distance_to(Vector2(b.x,b.z))
	var root:=Node3D.new(); root.name="NorthParkingStair"; world.add_child(root)
	var top: float=a.y+0.045
	var lower_point: Vector3=a+u*5.9
	var low: float=Geo.elevation(lower_point.x,lower_point.z)+0.09
	var stations: Array[Vector2]=[Vector2(-0.7,a.y-0.08),Vector2(0,top),Vector2(1.7,top),Vector2(5.9,low),Vector2(length,b.y+0.035),Vector2(length+0.7,Geo.elevation(b.x+u.x*0.7,b.z+u.z*0.7)-0.08)]
	var kit:=Kit.new()
	var concrete:=Geo.material(Color("a9aaa0"),0.97)
	var steel:=Geo.material(Color("929c97"),0.65)
	var verts:=PackedVector3Array()
	var landings:=PackedVector3Array()
	var yaw: float=-atan2(u.z,u.x)
	var width:=2.6
	for i in range(stations.size()-1):
		var s: Vector3=a+u*stations[i].x; s.y=stations[i].y
		var e: Vector3=a+u*stations[i+1].x; e.y=stations[i+1].y
		var l: Vector3=s-v*width*0.5
		var r: Vector3=s+v*width*0.5
		var el: Vector3=e-v*width*0.5
		var er: Vector3=e+v*width*0.5
		verts.append_array([l,er,r,l,el,er,r,er,l,er,el,l])
		if i!=2: landings.append_array([l,er,r,l,el,er])
		if i==2:
			for step in 14:
				var d0: float=lerpf(stations[i].x,stations[i+1].x,float(step)/14)
				var d1: float=lerpf(stations[i].x,stations[i+1].x,float(step+1)/14)
				var y: float=lerpf(s.y,e.y,float(step)/14)
				var center: Vector3=a+u*(d0+d1)*0.5
				var bottom: float=minf(Geo.elevation(center.x,center.z)-0.08,y-0.2)
				kit.part("concrete",Vector3(center.x,(y+bottom)*0.5,center.z),Vector3(d1-d0+0.006,y-bottom,width),yaw)
		if i in [1,2,3]:
			for side in [-1,1]:
				var sa: Vector3=s+v*side*(width*0.5-0.06)
				var sb: Vector3=e+v*side*(width*0.5-0.06)
				for h in [0.5,0.96]: Rail.rail(kit,"steel",sa+Vector3.UP*h,sb+Vector3.UP*h,0.045,0.045)
				var n:=maxi(1,int(ceil(sa.distance_to(sb)/1.3)))
				for j in n+1:
					var q: Vector3=sa.lerp(sb,float(j)/n)
					Rail.rail(kit,"steel",q,q+Vector3.UP*0.96,0.045,0.045)
	var collision:=Geo.mesh_from_vertices(root,verts,concrete,true)
	collision.name="ContinuousStairCollision"
	collision.visible=false
	Geo.mesh_from_vertices(root,landings,concrete).name="VisibleLandings"
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]; transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,steel if key=="steel" else concrete,null,180)
	root.set_meta("start",a); root.set_meta("direction",u); root.set_meta("length",length)
	root.set_meta("source","https://www.openstreetmap.org/way/1159793611")
