extends RefCounted
# One sampled triangle surface drives terrain rendering, collision and props.
static var grid: Dictionary = {}

static func initialize() -> void:
	if grid.is_empty():
		grid=JSON.parse_string(FileAccess.get_file_as_string("res://data/terrain_grid.json"))
		var extension: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/field2_terrain_extension.json"))
		assert(int(grid.depth)==int(extension.original_depth),"Terrain extension base depth mismatch")
		grid.heights.append_array(extension.heights)
		grid.depth=extension.depth
		var grading: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/parking_grade.json"))
		for sample in grading.changes: grid.heights[int(sample[0])]=sample[1]
		var field: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/beedie_grade.json"))
		for sample in field.changes: grid.heights[int(sample[0])]=sample[1]
		var field4: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/field4_grade.json"))
		for sample in field4.changes: grid.heights[int(sample[0])]=sample[1]
		var field2: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/field2_grade.json"))
		for sample in field2.changes: grid.heights[int(sample[0])]=sample[1]
		var shelters: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/field4_shelter_grade.json"))
		for sample in shelters.changes: grid.heights[int(sample[0])]=sample[1]
		var courtyard: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/courtyard_grade.json"))
		for sample in courtyard.changes: grid.heights[int(sample[0])]=sample[1]

static func height(x: float, z: float) -> float:
	initialize()
	var gx := clampf((x-float(grid.origin_x))/float(grid.step),0,float(grid.width)-1.001)
	var gz := clampf((z-float(grid.origin_z))/float(grid.step),0,float(grid.depth)-1.001)
	var ix := int(floor(gx))
	var iz := int(floor(gz))
	var u := gx-ix
	var v := gz-iz
	var index: int=iz*int(grid.width)+ix
	var a: float=grid.heights[index]
	var b: float=grid.heights[index+1]
	var c: float=grid.heights[index+int(grid.width)+1]
	var d: float=grid.heights[index+int(grid.width)]
	# Same a-c diagonal as the rendered grid; bilinear interpolation would diverge.
	return a+(b-a)*u+(c-b)*v if u>=v else a+(c-d)*u+(d-a)*v

static func foundation(id: String) -> float:
	initialize()
	return float(grid.pads[id].height)


