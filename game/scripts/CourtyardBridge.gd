extends RefCounted
# Closed exterior shell of the photo-supported elevated link toward West Mall.
# No interior circulation or invented stairs to the unmodeled parkade.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")

static func build(root: Node3D,base: float) -> void:
	var d: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/courtyard_link.json"))
	var a:=Vector3(d.start[0],base+d.floor_offset_estimate_m,d.start[1])
	var b:=Vector3(d.end[0],a.y,d.end[1])
	var u: Vector3=(b-a).normalized()
	var side:=Vector3(-u.z,0,u.x)
	var yaw: float=-atan2(u.z,u.x)
	var length: float=a.distance_to(b)
	var width: float=d.width_estimate_m
	var height: float=d.height_estimate_m
	var concrete:=Geo.material(Color("b1b2a9"),0.92)
	var dark:=Geo.material(Color("424a47"),0.75)
	var glass:=Geo.material(Color("536966"),0.35)
	var bronze:=Geo.material(Color("84734f"),0.7)
	var link:=Node3D.new(); link.name="WestMallLinkExterior"; root.add_child(link)
	var center: Vector3=(a+b)*0.5
	for item in [[center-Vector3.UP*0.14,Vector3(length,0.28,width),concrete],[center+Vector3.UP*(height+0.08),Vector3(length+0.2,0.16,width+0.3),dark]]:
		var box:=Geo.box(link,item[0],item[1],item[2],true); box.rotation.y=yaw
	var kit:=Kit.new()
	for sign_value in [-1,1]:
		var wall:=Geo.box(link,center+side*sign_value*(width*0.5-0.06)+Vector3.UP*height*0.5,Vector3(length,height,0.10),glass,true)
		wall.rotation.y=yaw
		for h in [0.08,0.95,height-0.05]:
			kit.part("bronze",center+side*sign_value*width*0.5+Vector3.UP*h,Vector3(length,0.08,0.14),yaw)
		var bays:=maxi(1,int(round(length/1.45)))
		for i in bays+1:
			kit.part("bronze",a.lerp(b,float(i)/bays)+side*sign_value*width*0.5+Vector3.UP*height*0.5,Vector3(0.07,height,0.14),yaw)
	# Opaque end panels preserve exterior-only scope. Parkade itself remains outside scope.
	for end in [a,b]:
		var wall:=Geo.box(link,end+Vector3.UP*height*0.5,Vector3(0.14,height,width),glass,true);wall.rotation.y=yaw
	# Provisional concrete landing support at the mapped parkade edge.
	var ground: float=Geo.elevation(b.x,b.z)
	var pier:=Geo.box(link,Vector3(b.x,(ground+b.y)*0.5,b.z),Vector3(0.75,b.y-ground,width),concrete,true);pier.rotation.y=yaw
	var transforms: Array[Transform3D]=[];transforms.assign(kit.batches.get("bronze",[]))
	Geo.instances(link,transforms,bronze,null,300)
	root.set_meta("west_mall_link",{"start":a,"end":b,"floor":a.y,"height":height,"width":width})
