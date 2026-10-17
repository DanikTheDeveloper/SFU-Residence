extends RefCounted
# CC0 assets by Cosmo; see assets/vehicles/cosmo/SOURCE.md.
const Geo=preload("res://scripts/Geometry.gd")
const MODELS=["coupe","mobil","jeep","van"]
static var cache: Dictionary={}

static func collect(node: Node,transform: Transform3D,parts: Array) -> void:
	var local:=transform
	if node is Node3D: local=transform*node.transform
	if node is MeshInstance3D and node.mesh:
		parts.append({"mesh":node.mesh,"transform":local})
	for child in node.get_children(): collect(child,local,parts)

static func model(index: int) -> ArrayMesh:
	var name: String=MODELS[index%MODELS.size()]
	if cache.has(name): return cache[name]
	var scene: PackedScene=load("res://assets/vehicles/cosmo/"+name+".glb")
	var source:=scene.instantiate()
	var parts: Array=[]
	collect(source,Transform3D.IDENTITY,parts)
	var bounds: AABB=parts[0].transform*parts[0].mesh.get_aabb()
	for part in parts: bounds=bounds.merge(part.transform*part.mesh.get_aabb())
	var turn:=Basis(Vector3.UP,PI*0.5) if bounds.size.x>bounds.size.z else Basis.IDENTITY
	var turned: AABB=Transform3D(turn,Vector3.ZERO)*bounds
	var scale_factor:=minf(1.82/turned.size.x,4.15/turned.size.z)
	var offset:=Vector3(-turned.get_center().x,-turned.position.y,-turned.get_center().z)*scale_factor
	var normalize:=Transform3D(turn.scaled(Vector3.ONE*scale_factor),offset)
	var merged:=ArrayMesh.new()
	for part in parts:
		for surface in part.mesh.get_surface_count():
			var builder:=SurfaceTool.new()
			builder.begin(Mesh.PRIMITIVE_TRIANGLES)
			builder.append_from(part.mesh,surface,normalize*part.transform)
			builder.set_material(part.mesh.surface_get_material(surface))
			builder.commit(merged)
	source.free()
	cache[name]=merged
	return merged

static func build(parent: Node3D,placements: Array[Transform3D]) -> void:
	for variant in MODELS.size():
		var transforms: Array[Transform3D]=[]
		for i in placements.size():
			if i%MODELS.size()==variant: transforms.append(placements[i])
		if transforms.is_empty(): continue
		Geo.instances(parent,transforms,null,model(variant),180).name="ParkedVehicle_"+MODELS[variant]
