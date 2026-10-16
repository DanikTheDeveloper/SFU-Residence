extends RefCounted
# One sampled triangle surface drives terrain rendering, collision and props.
static var grid: Dictionary = {}

static func initialize() -> void:
	if grid.is_empty():
		grid=JSON.parse_string(FileAccess.get_file_as_string("res://data/terrain_grid.json"))

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
