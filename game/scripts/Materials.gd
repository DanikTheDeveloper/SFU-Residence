extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")
static var textures: Dictionary={}

static func facade(color: Color, style: String) -> StandardMaterial3D:
	var mat := Geo.material(color)
	if not textures.has(style):
		var image := Image.create(128,128,false,Image.FORMAT_RGB8)
		var rng := RandomNumberGenerator.new()
		rng.seed=27
		for y in 128:
			for x in 128:
				var value := rng.randf_range(0.88,1.0)
				if style=="modern_tower":
					if y%16<1 or (x+(64 if (y/16)%2==0 else 0))%64<1: value=0.65
				elif style=="townhouse":
					if y%16<2: value=0.68
				elif x<1 or y<1: value=0.76
				image.set_pixel(x,y,Color(value,value,value))
		image.generate_mipmaps()
		textures[style]=ImageTexture.create_from_image(image)
	mat.albedo_texture=textures[style]
	mat.uv1_scale=Vector3(1,1,1) if style in ["townhouse","modern_tower"] else Vector3(0.2,0.2,0.2)
	return mat
