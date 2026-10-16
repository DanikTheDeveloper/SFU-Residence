extends RefCounted
const Kit=preload("res://scripts/FacadeKit.gd")
const Geo=preload("res://scripts/Geometry.gd")
const MASTER_ID="res://scripts/TownhouseBlockExterior.gd"
static var bay_width:=3.5

static func build(root: Node3D, data: Dictionary, points: Array, base: float, height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+1.6)
	var kit:=Kit.new()
	var story: float=height/int(data.floors)
	var poly:=PackedVector2Array()
	for p in points: poly.append(Vector2(p[0],p[1]))
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
		var entry:=Vector2(data.entrance[0],data.entrance[1])
		var entry_face: bool=entry.distance_to(Geometry2D.get_closest_point_to_segment(entry,Vector2(a.x,a.z),Vector2(q[0],q[1])))<0.5
		for level in int(data.floors):
			for bay in bays:
				var center:=a+tangent*((bay+0.5)*spacing)+Vector3.UP*((level+0.5)*story)
				var width: float=spacing*0.70
				var wh: float=1.6 if level<2 else 1.85
				kit.part("siding",center+normal*0.1,Vector3(spacing,story,0.2),yaw)
				var projection: float=0.42 if entry_face and level==1 else 0.12
				kit.window(center+normal*projection,tangent,normal,width,wh,yaw,true,"white_frame")
				if entry_face and level==1:
					for side in [-1,1]:
						kit.part("white_frame",center+tangent*side*(width*0.5+0.055)+normal*0.25,Vector3(0.11,wh+0.18,0.65),yaw)
				if entry_face and level==2 and bay%2==0:
					var balcony:=center-Vector3.UP*(wh*0.5)+normal*0.75
					kit.part("white_frame",balcony,Vector3(width+0.25,0.16,1.05),yaw)
					kit.part("white_frame",balcony+Vector3.UP*0.9+normal*0.48,Vector3(width+0.25,0.06,0.06),yaw)
					for bar in range(0,int(width/0.14)+1):
						kit.part("white_frame",balcony+tangent*(-width*0.5+bar*0.14)+Vector3.UP*0.45+normal*0.48,Vector3(0.025,0.9,0.025),yaw)
				kit.part("white_frame",center-tangent*spacing*0.5+normal*0.26,Vector3(0.12,story,0.18),yaw)
				# Fine horizontal weatherboard courses in original procedural geometry.
				for course in range(1,12):
					var y: float=level*story+course*story/12.0
					if absf(y-(level+0.5)*story)<wh*0.5: continue
					kit.part("roof",a+tangent*((bay+0.5)*spacing)+Vector3.UP*y+normal*0.205,Vector3(spacing,0.015,0.02),yaw)
		kit.part("white_frame",a+edge*0.5+Vector3.UP*height+normal*0.25,Vector3(length+0.35,0.18,0.75),yaw)
	kit.finish(root,"Townhouse")
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
