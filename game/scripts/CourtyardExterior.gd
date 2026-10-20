extends RefCounted
# Courtyard-specific precast facade, distinct from both tower families.
# Photo-supported vocabulary; bay counts and wing-specific exceptions provisional.
const Geo=preload("res://scripts/Geometry.gd")
const Kit=preload("res://scripts/FacadeKit.gd")
const Portico=preload("res://scripts/CourtyardPortico.gd")
const Gallery=preload("res://scripts/CourtyardGallery.gd")
const MASTER_ID="res://scripts/CourtyardExterior.gd"
static var bay_width:=2.85
static var palette: Dictionary={}

static func material(key: String) -> Material:
	if palette.is_empty():
		palette={"panel":Geo.material(Color("cecdc5"),0.9),"ribbed":Geo.material(Color("bbbdb7"),0.92),"glass":Geo.material(Color("416775"),0.29),"frame":Geo.material(Color("293638"),0.72),"reveal":Geo.material(Color("454b48")),"timber":Geo.material(Color("ad9562"),0.75),"red":Geo.material(Color("a74c3c")),"cap":Geo.material(Color("a6aaa5"))}
		var image:=Image.create(128,128,false,Image.FORMAT_RGB8)
		for y in 128:
			for x in 128:
				var v: float=0.80 if x%8<2 else 1.0
				image.set_pixel(x,y,Color(v,v,v))
		image.generate_mipmaps()
		palette.ribbed.albedo_texture=ImageTexture.create_from_image(image)
		palette.ribbed.uv1_scale=Vector3(2,1,1)
	return palette[key]

# Subdivide the unchanged OSM outline at its existing re-entrant corners.
# Southern long wing = highrise; northern short wing = three-storey lowrise.
# SFU level-2 plan establishes long east-west axis and visitor parking at east.
static func zones(data: Dictionary) -> Array:
	var p: Array=data.footprint
	return [
		{"name":"Highrise","points":p.slice(3,15),"floors":int(data.floors),"height":float(data.height_m)},
		{"name":"Lowrise","points":[p[0],p[1],p[2],p[15],p[16],p[17]],"floors":3,"height":10.8},
		{"name":"Atrium","points":[p[2],p[3],p[14],p[15]],"floors":2,"height":8.0}
	]

static func shell(root: Node3D,points: Array,base: float,height: float,title: String,grade_stem: bool=true) -> void:
	var poly:=PackedVector2Array()
	for point in points: poly.append(Vector2(point[0],point[1]))
	var walls:=PackedVector3Array()
	var grade:=PackedVector3Array()
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var b:=Vector3(q[0],base,q[1])
		var up:=Vector3.UP*height
		walls.append_array([a,b+up,b,a,a+up,b+up])
		var normal:=Vector3.UP.cross(b-a).normalized()
		var segments:=maxi(1,int(ceil(a.distance_to(b))))
		for segment in segments:
			var left: Vector3=a.lerp(b,float(segment)/segments)+normal*0.18
			var right: Vector3=a.lerp(b,float(segment+1)/segments)+normal*0.18
			var bottom_left:=Vector3(left.x,minf(base-0.05,Geo.elevation(left.x,left.z)-0.05),left.z)
			var bottom_right:=Vector3(right.x,minf(base-0.05,Geo.elevation(right.x,right.z)-0.05),right.z)
			left.y=base+0.10
			right.y=base+0.10
			grade.append_array([bottom_left,right,bottom_right,bottom_left,left,right])
	if grade_stem: Geo.mesh_from_vertices(root,grade,material("panel"),true).name=title+"GradeStem"
	Geo.mesh_from_vertices(root,walls,material("reveal"),true).name=title+"Shell"
	var indices:=Geometry2D.triangulate_polygon(poly)
	var roof:=PackedVector3Array()
	for i in range(0,indices.size(),3):
		var a:=Vector3(poly[indices[i]].x,base+height,poly[indices[i]].y)
		var b:=Vector3(poly[indices[i+1]].x,base+height,poly[indices[i+1]].y)
		var c:=Vector3(poly[indices[i+2]].x,base+height,poly[indices[i+2]].y)
		if (b-a).cross(c-a).y<0: roof.append_array([a,c,b])
		else: roof.append_array([a,b,c])
	Geo.mesh_from_vertices(root,roof,material("cap"),true).name=title+"Roof"

static func build(root: Node3D,data: Dictionary,_points: Array,base: float,height: float) -> void:
	root.set_meta("family_master",MASTER_ID)
	root.set_meta("floor_count",data.floors)
	root.set_meta("roof_world_y",base+height+0.20)
	root.set_meta("height_zones",zones(data))
	var kit:=Kit.new()
	for zone in zones(data):
		var points: Array=zone.points.duplicate()
		var poly:=PackedVector2Array()
		for point in points: poly.append(Vector2(point[0],point[1]))
		if Geometry2D.is_polygon_clockwise(poly): points.reverse()
		if zone.name=="Highrise":
			var portico:=Portico.layout(data)
			var lower_polys:=Geometry2D.clip_polygons(poly,portico.cut)
			assert(lower_polys.size()==1,"Portico cut must retain one closed lower shell")
			var lower: Array=[]
			for p in lower_polys[0]: lower.append([p.x,p.y])
			var lower_poly: PackedVector2Array=lower_polys[0]
			if Geometry2D.is_polygon_clockwise(lower_poly): lower.reverse()
			var gallery:=Gallery.layout(data)
			var lowest_polys:=Geometry2D.clip_polygons(lower_poly,gallery.cut)
			assert(lowest_polys.size()==1,"Gallery must retain one closed ground shell")
			var lowest: Array=[]
			for p in lowest_polys[0]: lowest.append([p.x,p.y])
			if Geometry2D.is_polygon_clockwise(lowest_polys[0]): lowest.reverse()
			shell(root,lowest,base,Gallery.HEIGHT,"HighriseGalleryLower")
			shell(root,lower,base+Gallery.HEIGHT,portico.height-Gallery.HEIGHT,"HighrisePorticoMiddle",false)
			shell(root,points,base+portico.height,zone.height-portico.height,"HighriseUpper",false)
		else:
			shell(root,points,base,zone.height,zone.name)
		facade(kit,data,points,base,zone.height,zone.floors,zone.name)
	Portico.build(root,data,base,kit)
	Gallery.build(root,data,base,kit)
	preload("res://scripts/CourtyardBridge.gd").build(root,base)
	preload("res://scripts/CourtyardForecourt.gd").build(root)
	# Closed eastern atrium entrance, inferred from the supplied frontal photograph.
	# Original western route entrance remains an accessible secondary facade.
	var door:=Vector3(339.9,base,-14.7)
	var normal:=Vector3(0.976,0,0.218)
	var tangent:=Vector3(normal.z,0,-normal.x)
	kit.window(door+Vector3.UP*1.4,tangent,normal,3.4,2.8,atan2(normal.x,normal.z),true)
	root.set_meta("photo_entrance",door)
	for key in kit.batches:
		var transforms: Array[Transform3D]=[]
		transforms.assign(kit.batches[key])
		Geo.instances(root,transforms,material(key),null,450).name="Courtyard"+key.capitalize()

static func facade(kit: RefCounted,data: Dictionary,points: Array,base: float,height: float,floors: int,zone: String) -> void:
	var story: float=height/floors
	for i in points.size():
		var a:=Vector3(points[i][0],base,points[i][1])
		var q: Array=points[(i+1)%points.size()]
		var edge:=Vector3(q[0]-a.x,0,q[1]-a.z)
		var length:=edge.length()
		if length<0.2: continue
		var tangent:=edge/length
		var normal:=Vector3.UP.cross(tangent)
		var yaw: float=-atan2(edge.z,edge.x)
		var mid:=a+edge*0.5
		var glazed_end: bool=zone=="Highrise" and normal.x>0.85 and length>8 and mid.x>330
		if zone=="Atrium":
			# Exterior timber/bronze curtain-wall grid; opaque glass, no interior.
			var bays:=maxi(1,int(round(length/1.5)))
			for bay in bays:
				var center: Vector3=a+tangent*((bay+0.5)*length/bays)+Vector3.UP*(height*0.5)
				kit.window(center,tangent,normal,length/bays-0.10,height-0.35,yaw,false,"timber")
				for level in [1,2]:
					kit.part("timber",center+Vector3.UP*(level*height/3-height*0.5)+normal*0.20,Vector3(length/bays,0.10,0.18),yaw)
			kit.part("panel",mid+Vector3.UP*(height+0.1)+normal*0.3,Vector3(length+0.1,0.22,0.9),yaw)
			continue
		if glazed_end:
			# Full-height glazed eastern lounge/stair end, framed by pale concrete.
			var glazed_width:=length*0.70
			for level in floors:
				if level<2: continue
				var center: Vector3=mid+Vector3.UP*((level+0.5)*story)
				kit.window(center,tangent,normal,glazed_width,story-0.10,yaw,false)
				for line in [-1,0,1]:
					kit.part("frame",center+tangent*line*glazed_width/4+normal*0.18,Vector3(0.065,story,0.13),yaw)
				for side in [-1,1]:
					kit.part("panel",center+tangent*side*(glazed_width*0.5+length*0.075)+normal*0.19,Vector3(length*0.15,story,0.38),yaw)
		else:
			var bays:=maxi(1,int(round(length/bay_width)))
			var spacing:=length/bays
			for bay in bays:
				var center_xz:=a+tangent*((bay+0.5)*spacing)
				for level in floors:
					if zone=="Highrise" and level==0 and Gallery.contains(data,Vector2(center_xz.x,center_xz.z)): continue
					if zone=="Highrise" and level<2 and Portico.contains(data,Vector2(center_xz.x,center_xz.z)): continue
					if level==0 and Vector2(center_xz.x,center_xz.z).distance_to(Vector2(data.entrance[0],data.entrance[1]))<2.1: continue
					var center:=center_xz+Vector3.UP*((level+0.5)*story)
					var podium: bool=level<2 and zone=="Highrise"
					var width: float=spacing*0.79 if podium else minf(1.1,spacing*0.40)
					var wh: float=story-0.16
					kit.window(center,tangent,normal,width,wh,yaw,false)
					kit.part("frame",center+Vector3.UP*(wh*0.18)+normal*0.17,Vector3(width,0.055,0.10),yaw)
					var pier: float=(spacing-width)*0.5
					for side in [-1,1]:
						kit.part("ribbed" if (bay+side)%2==0 else "panel",center+tangent*side*(width*0.5+pier*0.5)+normal*0.19,Vector3(pier,story,0.38),yaw)
					if level>=2 and length>20 and zone=="Highrise":
						kit.part("red",center-tangent*(width*0.5+0.045)+normal*0.18,Vector3(0.10,wh,0.28),yaw)
					if level%2==0 or level==2 or zone=="Lowrise":
						kit.part("frame",center_xz+Vector3.UP*(level*story)+normal*0.23,Vector3(spacing,0.10,0.48),yaw)
		kit.part("panel",mid+Vector3.UP*(height-0.38)+normal*0.18,Vector3(length,0.76,0.40),yaw)
		kit.part("cap",mid+Vector3.UP*(height+0.10)+normal*0.20,Vector3(length+0.12,0.20,0.48),yaw)
