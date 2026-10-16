extends RefCounted
const Kit=preload("res://scripts/FacadeKit.gd")
const Geo=preload("res://scripts/Geometry.gd")
const MASTER_ID="res://scripts/TownhouseBlockExterior.gd"
static var bay_width:=5.2

static func build(root: Node3D, data: Dictionary, points: Array, base: float, height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+1.6)
	var kit:=Kit.new()
	var story: float=height/int(data.floors)
	var poly:=PackedVector2Array()
	for p in points: poly.append(Vector2(p[0],p[1]))
	var center2:=Vector2.ZERO
	for p in poly: center2+=p
	center2/=poly.size()
	var xx:=0.0
	var zz:=0.0
	var xz:=0.0
	for p in poly:
		var d:=p-center2
		xx+=d.x*d.x
		zz+=d.y*d.y
		xz+=d.x*d.y
	var angle:=0.5*atan2(2*xz,xx-zz)
	var axis:=Vector3(cos(angle),0,sin(angle))
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var edge:=Vector3(q[0]-a.x,0,q[1]-a.z)
		var length:=edge.length()
		if length<0.1: continue
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		var bays:=maxi(1,int(round(length/bay_width)))
		var spacing:=length/bays
		var house_front: bool=absf(tangent.dot(axis))>0.85 and length>4
		for bay in bays:
			var mid:=a+tangent*((bay+0.5)*spacing)
			var mirror: float=1.0 if bay%2==0 else -1.0
			for level in int(data.floors):
				var center:=mid+Vector3.UP*((level+0.5)*story)
				kit.part("siding",center+normal*0.10,Vector3(spacing,story,0.20),yaw)
				var width:=minf(3.5,spacing*0.76) if house_front else minf(1.5,spacing*0.45)
				var wh:=1.55 if level<2 else 1.75
				if level==0 and house_front:
					kit.window(center-tangent*mirror*spacing*0.23+normal*0.22,tangent,normal,spacing*0.36,1.6,yaw,true,"white_frame")
					var door:=mid+tangent*mirror*spacing*0.30+Vector3.UP*1.18+normal*0.24
					kit.part("door",door,Vector3(0.95,2.22,0.10),yaw)
					for side in [-1,1]:
						kit.part("white_frame",door+tangent*side*0.52+normal*0.08,Vector3(0.10,2.38,0.13),yaw)
					kit.part("white_frame",door+Vector3.UP*1.16+normal*0.08,Vector3(1.14,0.10,0.13),yaw)
					kit.part("frame",door+tangent*0.34+normal*0.10,Vector3(0.045,0.15,0.08),yaw)
				else:
					var projection:=0.45 if house_front and level==1 else 0.30
					kit.window(center+normal*projection,tangent,normal,width,wh,yaw,true,"white_frame")
					if house_front and level==1:
						for side in [-1,1]: kit.part("white_frame",center+tangent*side*(width*0.5+0.055)+normal*0.28,Vector3(0.11,wh+0.18,0.68),yaw)
				if house_front and level==2:
					var balcony:=center-tangent*spacing*0.16-Vector3.UP*(wh*0.5)+normal*0.82
					var bw:=minf(2.25,spacing*0.48)
					kit.part("white_frame",balcony,Vector3(bw,0.18,1.18),yaw)
					kit.part("white_frame",balcony+Vector3.UP*0.95+normal*0.56,Vector3(bw,0.07,0.07),yaw)
					for bar in range(int(bw/0.13)+1): kit.part("white_frame",balcony+tangent*(-bw*0.5+bar*0.13)+Vector3.UP*0.48+normal*0.56,Vector3(0.028,0.95,0.028),yaw)
					for side in [-1,1]:
						kit.part("white_frame",balcony+tangent*side*bw*0.5+Vector3.UP*0.95,Vector3(0.07,0.07,1.18),yaw)
				kit.part("white_frame",center-tangent*spacing*0.5+normal*0.25,Vector3(0.12,story,0.18),yaw)
				for course in range(1,14):
					kit.part("course",mid+Vector3.UP*(level*story+course*story/14)+normal*0.205,Vector3(spacing,0.012,0.015),yaw)
			kit.part("stone",mid+Vector3.UP*0.38+normal*0.12,Vector3(spacing,0.76,0.24),yaw)
			if house_front and bay%2==0:
				# Mirrored neighboring doors share a porch, as in the Chilcotin plan.
				var porch_mid:=mid+tangent*(spacing*0.5 if bay+1<bays else 0.0)
				# Shallow pitched cover and substantial posts.
				var porch_width:=spacing*0.94
				for side in [-1,1]:
					kit.part("white_frame",porch_mid+tangent*side*(porch_width*0.5-0.12)+normal*1.55+Vector3.UP*1.3,Vector3(0.22,2.6,0.22),yaw)
					kit.part("stone",porch_mid+tangent*side*(porch_width*0.5-0.12)+normal*1.55+Vector3.UP*0.12,Vector3(0.38,0.24,0.38),yaw)
				kit.part("white_frame",porch_mid+normal*1.60+Vector3.UP*2.64,Vector3(porch_width,0.23,0.22),yaw)
				var left:=porch_mid-tangent*porch_width*0.5
				var right:=porch_mid+tangent*porch_width*0.5
				var pa:=left+Vector3.UP*3.18
				var pb:=right+Vector3.UP*3.18
				var pc:=right+normal*1.85+Vector3.UP*2.77
				var pd:=left+normal*1.85+Vector3.UP*2.77
				Geo.mesh_from_vertices(root,PackedVector3Array([pa,pb,pc,pa,pc,pd]),Kit.material("roof"))
		kit.part("white_frame",a+edge*0.5+Vector3.UP*height+normal*0.45,Vector3(length+0.35,0.20,1.1),yaw)
		for rafter in range(int(length/0.65)+1):
			kit.part("white_frame",a+tangent*(rafter*0.65)+Vector3.UP*(height-0.1)+normal*0.45,Vector3(0.07,0.15,1.15),yaw)
	var custom: Dictionary={"siding":Geo.material(Color("3c5577")),"course":Geo.material(Color("30445e")),"door":Geo.material(Color("a43c2b")),"stone":Geo.material(Color("777566"))}
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,custom[key] if custom.has(key) else Kit.material(key),null,380).name="Townhouse"+key.capitalize()
	var vertices:=PackedVector3Array()
	var indices:=Geometry2D.triangulate_polygon(poly)
	for i in range(0,indices.size(),3):
		roof_triangle(poly[indices[i]],poly[indices[i+1]],poly[indices[i+2]],poly,base+height,vertices)
	Geo.mesh_from_vertices(root,vertices,Kit.material("roof")).name="PitchedRoof"

static func roof_height(p: Vector2, poly: PackedVector2Array, base: float) -> float:
	var distance:=INF
	for i in poly.size(): distance=minf(distance,p.distance_to(Geometry2D.get_closest_point_to_segment(p,poly[i],poly[(i+1)%poly.size()])))
	return base+0.08+minf(1.52,distance*0.5)

static func roof_triangle(a: Vector2,b: Vector2,c: Vector2,poly: PackedVector2Array,base: float,vertices: PackedVector3Array) -> void:
	if maxf(a.distance_to(b),maxf(b.distance_to(c),c.distance_to(a)))>3:
		# Uniform subdivision preserves shared edges across the original triangulation.
		var ab:=(a+b)*0.5
		var bc:=(b+c)*0.5
		var ca:=(c+a)*0.5
		roof_triangle(a,ab,ca,poly,base,vertices)
		roof_triangle(ab,b,bc,poly,base,vertices)
		roof_triangle(ca,bc,c,poly,base,vertices)
		roof_triangle(ab,bc,ca,poly,base,vertices)
	else:
		var va:=Vector3(a.x,roof_height(a,poly,base),a.y)
		var vb:=Vector3(b.x,roof_height(b,poly,base),b.y)
		var vc:=Vector3(c.x,roof_height(c,poly,base),c.y)
		if (vb-va).cross(vc-va).y<0: vertices.append_array([va,vc,vb])
		else: vertices.append_array([va,vb,vc])
