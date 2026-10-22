extends RefCounted
# DIALOG0058: grey/tan pavers, concrete curb and small trees at east entrance.
# Extents, tree spacing and finished levels estimated; source grid is unchanged.
const Geo=preload("res://scripts/Geometry.gd")
const Pavers=preload("res://scripts/ResidencePavers.gd")
static func extend_boundary(original: PackedVector2Array) -> PackedVector2Array:
	var d: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/courtyard_grade.json"))
	var apron:=PackedVector2Array()
	for p in d.asphalt_apron: apron.append(Vector2(p[0],p[1]))
	var expanded:=Geometry2D.offset_polygon(apron,5.0)
	var merged:=Geometry2D.merge_polygons(original,expanded[0])
	assert(merged.size()==1,"Courtyard apron must connect to existing precinct")
	return merged[0]

static func build(root: Node3D) -> void:
	var d: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/courtyard_grade.json"))
	Geo.polygon(root,d.asphalt_apron,preload("res://scripts/PavementMaterials.gd").material("road"),0.025).name="PhotoAsphaltApron"
	var surface: StandardMaterial3D=Pavers.material(true).duplicate()
	# Photo0058 is mostly pale grey with restrained warm blocks, not saturated tan.
	var pixels: Image=surface.albedo_texture.get_image()
	pixels.convert(Image.FORMAT_RGB8)
	for y in pixels.get_height():
		for x in pixels.get_width():
			var c: Color=pixels.get_pixel(x,y)
			pixels.set_pixel(x,y,c.lerp(Color("b0b0a4"),0.42))
	pixels.generate_mipmaps()
	surface.albedo_texture=ImageTexture.create_from_image(pixels)
	var paving:=Geo.polygon(root,d.polygon,surface,0.07)
	paving.name="EasternForecourtPavers"
	Pavers.align(paving,Vector3(342,0,10),Vector3(0.225,0,-0.974))
	var concrete:=Geo.material(Color("bbbdb4"),0.94)
	# Segmented terrain-following curb. Low height is stepable; omit central entry gap.
	for i in d.outer_edge.size()-1:
		var a:=Vector2(d.outer_edge[i][0],d.outer_edge[i][1])
		var b:=Vector2(d.outer_edge[i+1][0],d.outer_edge[i+1][1])
		var count:=maxi(1,int(ceil(a.distance_to(b))))
		for j in count:
			var p: Vector2=a.lerp(b,(j+0.5)/count)
			if p.y> -18 and p.y< -13: continue
			var edge:=Geo.box(root,Geo.point([p.x,p.y],0.065),Vector3(a.distance_to(b)/count+0.015,0.13,0.25),concrete,false)
			edge.rotation.y=-atan2(b.y-a.y,b.x-a.x)
	var mulch:=Geo.material(Color("625242"),0.98)
	var trees: Array[Transform3D]=[]
	for p in [[348.5,6.0],[350.2,-1.5],[344.6,-12.0],[350.9,-24.0]]:
		var center:=Geo.point(p,0.085)
		Geo.box(root,center,Vector3(1.3,0.03,1.3),mulch,false)
		trees.append(Geo.transform(center,Vector3(0.42,0.72,0.42),0.3))
	var leaves:=Geo.material(Color.WHITE,0.96)
	leaves.vertex_color_use_as_albedo=true
	leaves.cull_mode=BaseMaterial3D.CULL_DISABLED
	Geo.instances(root,trees,leaves,preload("res://scripts/PhotoVegetation.gd").tree(false),180).name="ForecourtYoungTrees"
