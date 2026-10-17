extends RefCounted
# Original restrained colour detail only: terrain heights/normals/collision unchanged.
const Geo=preload("res://scripts/Geometry.gd")
static var cached: StandardMaterial3D

static func grass() -> StandardMaterial3D:
	if cached: return cached
	cached=Geo.material(Color("6e8056"),0.98)
	var pixels:=Image.create(256,256,false,Image.FORMAT_RGB8)
	var noise:=FastNoiseLite.new()
	noise.seed=32814
	noise.frequency=0.035
	noise.fractal_octaves=3
	var fine:=RandomNumberGenerator.new()
	fine.seed=9401
	for y in 256:
		for x in 256:
			# Blend opposite noise fields so the repeated patch has no hard seam.
			var u: float=float(x)/256.0
			var v: float=float(y)/256.0
			var near: float=lerpf(noise.get_noise_2d(x,y),noise.get_noise_2d(x-256,y),u)
			var far: float=lerpf(noise.get_noise_2d(x,y-256),noise.get_noise_2d(x-256,y-256),u)
			var shade: float=clampf(0.93+lerpf(near,far,v)*0.16+fine.randf_range(-0.025,0.025),0.80,1.0)
			pixels.set_pixel(x,y,Color(shade,shade,shade))
	pixels.generate_mipmaps()
	cached.albedo_texture=ImageTexture.create_from_image(pixels)
	cached.uv1_triplanar=true
	cached.uv1_world_triplanar=true
	cached.uv1_scale=Vector3.ONE*0.125
	cached.texture_filter=BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	return cached
