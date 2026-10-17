extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
static var paving: StandardMaterial3D

static func material() -> StandardMaterial3D:
	if paving: return paving
	paving=Geo.material(Color.WHITE,0.95)
	# Original procedural grey/brown pavers; no reference photograph pixels.
	var pixels:=Image.create(256,256,false,Image.FORMAT_RGB8)
	var colors: Array[Color]=[Color("898c86"),Color("797e79"),Color("9a9587"),Color("8c8172"),Color("a4a49a"),Color("6e7775")]
	for y in 256:
		for x in 256:
			var row:=int(y/16)
			var shifted: int=x+16*(row%2)
			var cell:=int(shifted/32)
			var color: Color=colors[(row*7+cell*11)%colors.size()]
			if y%16==0 or shifted%32==0: color=Color("626862")
			elif y<8: color=Color("c5c7ba")
			else: color*=0.98+0.025*sin(float(x*13+y*31))
			pixels.set_pixel(x,y,color)
	pixels.generate_mipmaps()
	paving.albedo_texture=ImageTexture.create_from_image(pixels)
	paving.texture_filter=BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	return paving

static func build(root: Node3D,door: Vector3,normal: Vector3) -> void:
	# Reference confirms pattern. Only an estimated small entrance apron is treated;
	# the original site path/parking polygons and all collision heights remain intact.
	var tangent:=Vector3(normal.z,0,-normal.x)
	var polygon: Array=[]
	for corner in [door-tangent*6.0+normal*0.05,door+tangent*6.0+normal*0.05,door+tangent*6.0+normal*3.4,door-tangent*6.0+normal*3.4]:
		polygon.append([corner.x,corner.z])
	var node:=Geo.polygon(root,polygon,material(),0.045)
	node.name="HamiltonPhotoPaverApron"
	var arrays: Array=node.mesh.surface_get_arrays(0)
	var uv:=PackedVector2Array()
	for point in arrays[Mesh.ARRAY_VERTEX]:
		var relative: Vector3=point-door
		uv.append(Vector2(relative.dot(tangent),relative.dot(normal))/3.2)
	arrays[Mesh.ARRAY_TEX_UV]=uv
	var mesh:=ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	node.mesh=mesh
