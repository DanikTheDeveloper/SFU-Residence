extends RefCounted

static func contains_point(p: Vector2, polygon: PackedVector2Array) -> bool:
	# Horizontal crossing avoids the engine's rare ray-through-vertex false negatives.
	var inside:=false
	for i in polygon.size():
		var a:=polygon[i]
		var b:=polygon[(i+1)%polygon.size()]
		if p.distance_to(Geometry2D.get_closest_point_to_segment(p,a,b))<0.001: return true
		if (a.y>p.y)!=(b.y>p.y):
			if p.x<(b.x-a.x)*(p.y-a.y)/(b.y-a.y)+a.x: inside=not inside
	return inside

static func elevation(x: float, z: float) -> float:
	return preload("res://scripts/TerrainController.gd").height(x,z)

static func point(p: Array, offset: float = 0.0) -> Vector3:
	return Vector3(p[0], elevation(p[0], p[1]) + offset, p[1])

static func material(color: Color, roughness: float = 0.85) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = roughness
	return mat

static func box(parent: Node3D, pos: Vector3, size: Vector3, mat: Material, solid: bool = false) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.material_override = mat
	parent.add_child(node)
	node.position = pos
	if solid: node.create_trimesh_collision()
	return node

static func ground_normal(p: Vector3) -> Vector3:
	return Vector3(elevation(p.x-2,p.z)-elevation(p.x+2,p.z),4,elevation(p.x,p.z-2)-elevation(p.x,p.z+2)).normalized()

static func mesh_from_vertices(parent: Node3D, vertices: PackedVector3Array, mat: Material, solid: bool = false, smooth_ground: bool=false) -> MeshInstance3D:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(0,vertices.size(),3):
		st.set_normal((vertices[i+1]-vertices[i]).cross(vertices[i+2]-vertices[i]).normalized())
		for j in [0,2,1]:
			if smooth_ground: st.set_normal(ground_normal(vertices[i+j]))
			st.set_uv(Vector2(vertices[i+j].x+vertices[i+j].z,vertices[i+j].y))
			st.add_vertex(vertices[i+j])
	var node := MeshInstance3D.new()
	node.mesh = st.commit()
	node.material_override = mat
	parent.add_child(node)
	if solid: node.create_trimesh_collision()
	return node

static func merge_surfaces(parent: Node3D) -> void:
	var batches: Dictionary={}
	for child in parent.get_children():
		if not child is MeshInstance3D: continue
		var key: Material=child.material_override
		if not batches.has(key):
			var st := SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLES)
			batches[key]=st
		batches[key].append_from(child.mesh,0,child.transform)
		parent.remove_child(child)
		child.queue_free()
	for mat in batches:
		var node := MeshInstance3D.new()
		node.mesh=batches[mat].commit()
		node.material_override=mat
		node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		parent.add_child(node)

static func polygon(parent: Node3D, points: Array, mat: Material, offset: float = 0.05) -> MeshInstance3D:
	var poly := PackedVector2Array()
	for p in points: poly.append(Vector2(p[0],p[1]))
	var verts := PackedVector3Array()
	var bounds := Rect2(poly[0],Vector2.ZERO)
	for p in poly: bounds=bounds.expand(p)
	# Clip pavement against the exact terrain triangles: no stretched floating strips.
	for x in range(int(floor(bounds.position.x/2))*2,int(ceil(bounds.end.x/2))*2,2):
		for z in range(int(floor(bounds.position.y/2))*2,int(ceil(bounds.end.y/2))*2,2):
			var a:=Vector2(x,z)
			var b:=Vector2(x+2,z)
			var c:=Vector2(x+2,z+2)
			var d:=Vector2(x,z+2)
			for tri in [PackedVector2Array([a,b,c]),PackedVector2Array([a,c,d])]:
				for clipped in Geometry2D.intersect_polygons(poly,tri):
					var indices := Geometry2D.triangulate_polygon(clipped)
					for i in range(0,indices.size(),3):
						var va:=point([clipped[indices[i]].x,clipped[indices[i]].y],offset)
						var vb:=point([clipped[indices[i+1]].x,clipped[indices[i+1]].y],offset)
						var vc:=point([clipped[indices[i+2]].x,clipped[indices[i+2]].y],offset)
						if (vb-va).cross(vc-va).y<0: verts.append_array([va,vc,vb])
						else: verts.append_array([va,vb,vc])
	return mesh_from_vertices(parent,verts,mat,false,true)

static func strip(parent: Node3D, a: Vector3, b: Vector3, width: float, mat: Material, offset: float = 0.035) -> void:
	var side := Vector3(-(b-a).z,0,(b-a).x).normalized()*width*0.5
	var points: Array = []
	for p in [a+side,b+side,b-side,a-side]: points.append([p.x,p.z])
	polygon(parent,points,mat,offset)

static func instances(parent: Node3D, transforms: Array[Transform3D], mat: Material, mesh: Mesh = null, distance: float = 260.0) -> MultiMeshInstance3D:
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.mesh = mesh if mesh != null else BoxMesh.new()
	multi.instance_count = transforms.size()
	for i in transforms.size(): multi.set_instance_transform(i,transforms[i])
	var node := MultiMeshInstance3D.new()
	node.multimesh = multi
	node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	node.material_override = mat
	node.visibility_range_end = distance
	parent.add_child(node)
	return node

static func transform(pos: Vector3, size: Vector3, yaw: float = 0.0) -> Transform3D:
	return Transform3D(Basis(Vector3.UP,yaw).scaled_local(size),pos)
