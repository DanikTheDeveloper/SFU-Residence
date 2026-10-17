extends RefCounted
# Original texture based on supplied PWL 1001/1029 observations, not photo pixels.
const Geo=preload("res://scripts/Geometry.gd")
static var paving: StandardMaterial3D

static func material() -> StandardMaterial3D:
	if paving: return paving
	paving=Geo.material(Color.WHITE,0.94)
	var pixels:=Image.create(256,256,false,Image.FORMAT_RGB8)
	var colors: Array[Color]=[Color("707671"),Color("7b807b"),Color("686f6a"),Color("858981"),Color("777b72"),Color("6d746f")]
	# One 1.6m tile: 0.4 x 0.2m running-bond pavers with narrow joints.
	for y in 256:
		for x in 256:
			var row:=int(y/32)
			var shifted: int=x+32*(row%2)
			var cell:=int(shifted/64)
			var color: Color=colors[(row*7+cell*11)%colors.size()]
			if y%32==0 or shifted%64==0: color=Color("555d55")
			pixels.set_pixel(x,y,color)
	pixels.generate_mipmaps()
	paving.albedo_texture=ImageTexture.create_from_image(pixels)
	paving.texture_filter=BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	return paving

static func align(node: MeshInstance3D,origin: Vector3,tangent: Vector3) -> void:
	var side:=Vector3(tangent.z,0,-tangent.x).normalized()
	var arrays: Array=node.mesh.surface_get_arrays(0)
	var uv:=PackedVector2Array()
	for point in arrays[Mesh.ARRAY_VERTEX]:
		var relative: Vector3=point-origin
		uv.append(Vector2(relative.dot(tangent),relative.dot(side))/1.6)
	arrays[Mesh.ARRAY_TEX_UV]=uv
	var mesh:=ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	node.mesh=mesh
