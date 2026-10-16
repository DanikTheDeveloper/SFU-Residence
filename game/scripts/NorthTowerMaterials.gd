extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
static var cache: Dictionary={}

static func material(key: String) -> Material:
	if key not in ["concrete","stair_screen","glass","blind","paving"]: return Kit.material(key)
	if cache.has(key): return cache[key]
	if key=="glass":
		var glazing:=Geo.material(Color("60777e"),0.32)
		glazing.metallic_specular=0.55
		cache[key]=glazing
		return glazing
	var mat:=Geo.material(Color("b4b1a5") if key=="concrete" else (Color("b8c0ba") if key=="blind" else (Color("b9b7ad") if key=="paving" else Color("535654"))),0.94)
	var pixels:=Image.create(128,128,false,Image.FORMAT_RGB8)
	var rng:=RandomNumberGenerator.new()
	rng.seed=4387
	for y in 128:
		for x in 128:
			var shade:=0.96+rng.randf_range(-0.025,0.025)
			if key=="concrete":
				shade-=0.035 if y%16==0 else 0.0
				shade-=0.055 if x%64==10 and y%32==8 else 0.0
			elif key!="paving":
				shade-=0.14 if y%4==0 else 0.0
			pixels.set_pixel(x,y,Color(shade,shade,shade))
	mat.albedo_texture=ImageTexture.create_from_image(pixels)
	mat.uv1_triplanar=true
	mat.uv1_world_triplanar=true
	mat.uv1_scale=Vector3.ONE*0.5
	cache[key]=mat
	return mat

static func finish(kit: RefCounted,root: Node3D) -> void:
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,material(key),null,420).name="North"+key.capitalize()
