extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
static var cache: Dictionary={}

static func material(kind: String) -> StandardMaterial3D:
	if cache.has(kind): return cache[kind]
	var colors: Dictionary={"concrete":Color("96988e"),"walkway":Color("717776"),"road":Color("51575a"),"border":Color("babbb0")}
	var result:=Geo.material(colors[kind],0.96)
	var pixels:=Image.create(256,256,false,Image.FORMAT_RGB8)
	var rng:=RandomNumberGenerator.new()
	rng.seed=6841
	for y in 256:
		for x in 256:
			var shade: float=rng.randf_range(0.90,1.0)
			if kind=="concrete":
				shade=rng.randf_range(0.96,1.0)
				# 2m control-joint spacing on a 4m tile; estimated construction rhythm.
				if x%128==0: shade=0.76
			elif kind=="border": shade=rng.randf_range(0.97,1.0)
			elif rng.randf()<0.06: shade=0.72
			pixels.set_pixel(x,y,Color(shade,shade,shade))
	pixels.generate_mipmaps()
	result.albedo_texture=ImageTexture.create_from_image(pixels)
	result.texture_filter=BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	# Unaligned parking polygons use world projection; path strips override this below.
	result.uv1_triplanar=kind=="road"
	result.uv1_world_triplanar=kind=="road"
	result.uv1_scale=Vector3.ONE*0.5 if kind=="road" else Vector3.ONE
	cache[kind]=result
	return result
