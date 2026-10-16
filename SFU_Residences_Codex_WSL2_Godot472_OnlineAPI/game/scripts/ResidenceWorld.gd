extends Node3D
const Geo = preload("res://scripts/Geometry.gd")
const Buildings = preload("res://scripts/BuildingFactory.gd")
const PlayerScene = preload("res://scenes/Player.tscn")
const HudScript = preload("res://scripts/HUD.gd")
var registry: Array
var roads: Array
var site: Dictionary
var player: CharacterBody3D
var sun: DirectionalLight3D
var overview: Camera3D
var vegetation: Node3D
var map_mode := false
var low_quality := false
var boundary := PackedVector2Array()

func group_node(title: String) -> Node3D:
	var node := Node3D.new()
	node.name=title
	add_child(node)
	return node

func _ready() -> void:
	registry=JSON.parse_string(FileAccess.get_file_as_string("res://data/buildings.json"))
	roads=JSON.parse_string(FileAccess.get_file_as_string("res://data/roads.json"))
	site=JSON.parse_string(FileAccess.get_file_as_string("res://data/site.json"))
	for p in site.boundary: boundary.append(Vector2(p[0],p[1]))
	configure_inputs()
	build_light()
	build_ground()
	var paths := group_node("Paths")
	var asphalt := Geo.material(Color("454c50"))
	var concrete := Geo.material(Color("b0afa3"))
	for area in site.parking: Geo.polygon(paths,area.points,asphalt,0.025)
	for road in roads:
		if road.kind=="road": Geo.strip(paths,Geo.point(road.points[0]),Geo.point(road.points[1]),road.width+0.5,concrete,0.025)
		Geo.strip(paths,Geo.point(road.points[0]),Geo.point(road.points[1]),road.width,concrete if road.kind=="path" else asphalt,0.045 if road.kind=="path" else 0.035)
	Geo.merge_surfaces(paths)
	var buildings := group_node("Buildings")
	for data in registry: Buildings.build(buildings,data)
	vegetation=group_node("Vegetation")
	build_landscape()
	preload("res://scripts/SiteDetails.gd").build(self)
	player=PlayerScene.instantiate()
	add_child(player)
	player.spawn=Geo.point([35,80],0.25)
	player.reset()
	player.pivot.rotation.y=-0.35
	overview=Camera3D.new()
	add_child(overview)
	overview.position=Vector3(35,360,300)
	overview.look_at(Vector3(35,0,30))
	overview.projection=Camera3D.PROJECTION_ORTHOGONAL
	overview.size=400
	overview.far=1200
	var hud := CanvasLayer.new()
	hud.name="UI"
	hud.set_script(HudScript)
	add_child(hud)
	print("WORLD_READY buildings=",registry.size()," paths=",roads.size()," renderer=",RenderingServer.get_current_rendering_method())
	if "--capture" in OS.get_cmdline_user_args(): capture_views.call_deferred()
	if "--verify" in OS.get_cmdline_user_args(): get_node("UI").run_verification.call_deferred()

func configure_inputs() -> void:
	var keys := {"move_forward":KEY_W,"move_back":KEY_S,"move_left":KEY_A,"move_right":KEY_D,"sprint":KEY_SHIFT,"jump":KEY_SPACE,"release_mouse":KEY_ESCAPE,"respawn":KEY_R,"map":KEY_M,"labels":KEY_TAB,"quality":KEY_F2,"help":KEY_F1,"next_location":KEY_N}
	for action in keys:
		if not InputMap.has_action(action): InputMap.add_action(action)
		if InputMap.action_get_events(action).is_empty():
			var event := InputEventKey.new()
			event.physical_keycode=keys[action]
			InputMap.action_add_event(action,event)

func build_light() -> void:
	var lighting := group_node("Lighting")
	var environment := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode=Environment.BG_SKY
	var sky := Sky.new()
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color=Color("739cb8")
	sky_material.sky_horizon_color=Color("d9e2de")
	sky_material.ground_bottom_color=Color("7d8a7a")
	sky_material.ground_horizon_color=Color("c6d0ca")
	sky.sky_material=sky_material
	env.sky=sky
	env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color=Color("c7d5df")
	env.ambient_light_energy=0.35
	env.tonemap_mode=Environment.TONE_MAPPER_LINEAR
	environment.environment=env
	lighting.add_child(environment)
	sun=DirectionalLight3D.new()
	lighting.add_child(sun)
	sun.rotation_degrees=Vector3(-48,-35,0)
	sun.light_color=Color("fff1d6")
	sun.light_energy=0.75
	sun.shadow_enabled=true
	sun.directional_shadow_max_distance=180

func build_ground() -> void:
	var ground := group_node("Ground")
	var verts := PackedVector3Array()
	for x in range(-1200,1201,200):
		for z in range(-1200,1201,200):
			var a := Geo.point([x,z])
			var b := Geo.point([x+200,z])
			var c := Geo.point([x+200,z+200])
			var d := Geo.point([x,z+200])
			verts.append_array([a,c,b,a,d,c])
	Geo.mesh_from_vertices(ground,verts,Geo.material(Color("6e8056")),true).name="Terrain"
	var edge_mat := Geo.material(Color("425c3f"))
	for i in boundary.size():
		var a := Geo.point([boundary[i].x,boundary[i].y])
		var b := Geo.point([boundary[(i+1)%boundary.size()].x,boundary[(i+1)%boundary.size()].y])
		var wall := Geo.box(ground,(a+b)*0.5+Vector3.UP*1.15,Vector3(a.distance_to(b),2.3,1.1),edge_mat,true)
		wall.rotation.y=-atan2((b-a).z,(b-a).x)
	Geo.polygon(ground,[[-66,74],[55,100],[40,160],[-80,137]],Geo.material(Color("4c7754")),0.02)

func build_landscape() -> void:
	var props := group_node("Props")
	var trunks: Array[Transform3D]=[]
	var crowns: Array[Transform3D]=[]
	var pines: Array[Transform3D]=[]
	var rng := RandomNumberGenerator.new()
	rng.seed=1948
	for i in 1600:
		var p := Vector2(rng.randf_range(-295,360),rng.randf_range(-125,185))
		if not Geometry2D.is_point_in_polygon(p,boundary): continue
		if occupied(p,4): continue
		if p.x>-90 and p.x<55 and p.y>70: continue
		var pos := Geo.point([p.x,p.y])
		var h := rng.randf_range(5,11)
		trunks.append(Geo.transform(pos+Vector3.UP*h*0.4,Vector3(0.3,h*0.8,0.3)))
		if i%3==0: crowns.append(Geo.transform(pos+Vector3.UP*h*0.75,Vector3(h*0.55,h*0.55,h*0.55)))
		else:
			for layer in 3:
				pines.append(Geo.transform(pos+Vector3.UP*h*(0.48+0.19*layer),Vector3(h*(0.62-0.14*layer),h*0.57,h*(0.62-0.14*layer))))
		if trunks.size()>=150: break
	Geo.instances(vegetation,trunks,Geo.material(Color("655744")),null,500)
	var sphere := SphereMesh.new()
	sphere.radial_segments=10
	sphere.rings=5
	Geo.instances(vegetation,crowns,Geo.material(Color("516d3b")),sphere,500)
	var cone := CylinderMesh.new()
	cone.top_radius=0
	cone.bottom_radius=0.5
	cone.height=1
	cone.radial_segments=9
	Geo.instances(vegetation,pines,Geo.material(Color("365b48")),cone,500)
	var poles: Array[Transform3D]=[]
	var lamps: Array[Transform3D]=[]
	var seats: Array[Transform3D]=[]
	var backs: Array[Transform3D]=[]
	for i in range(0,roads.size(),7):
		var road: Dictionary=roads[i]
		var a := Geo.point(road.points[0])
		var b := Geo.point(road.points[1])
		if a.distance_to(b)<4: continue
		var side := (b-a).cross(Vector3.UP).normalized()
		var p: Vector3 = (a+b)*0.5+side*(road.width*0.5+0.8)
		p.y=Geo.elevation(p.x,p.z)
		if inside_building(Vector2(p.x,p.z),1): continue
		poles.append(Geo.transform(p+Vector3.UP*2,Vector3(0.12,4,0.12)))
		lamps.append(Geo.transform(p+Vector3.UP*4,Vector3(0.65,0.16,0.65)))
		if i%21==0:
			var yaw := -atan2((b-a).z,(b-a).x)
			seats.append(Geo.transform(p+Vector3(1,0.48,0),Vector3(1.7,0.16,0.5),yaw))
			backs.append(Geo.transform(p+Vector3(1,0.8,0.22),Vector3(1.7,0.5,0.10),yaw))
	Geo.instances(props,poles,Geo.material(Color("3c4849")),null,200)
	Geo.instances(props,lamps,Geo.material(Color("e6d9b5")),null,200)
	Geo.instances(props,seats,Geo.material(Color("9f7950")),null,180)
	Geo.instances(props,backs,Geo.material(Color("9f7950")),null,180)

func inside_building(p: Vector2, margin: float = 0.0) -> bool:
	for data in registry:
		var polygon := PackedVector2Array()
		for v in data.footprint: polygon.append(Vector2(v[0],v[1]))
		if Geometry2D.is_point_in_polygon(p,polygon): return true
		if margin>0:
			for i in polygon.size():
				if p.distance_to(Geometry2D.get_closest_point_to_segment(p,polygon[i],polygon[(i+1)%polygon.size()]))<margin: return true
	return false

func occupied(p: Vector2, margin: float) -> bool:
	if inside_building(p,margin): return true
	for road in roads:
		var a := Vector2(road.points[0][0],road.points[0][1])
		var b := Vector2(road.points[1][0],road.points[1][1])
		if p.distance_to(Geometry2D.get_closest_point_to_segment(p,a,b))<road.width*0.5+margin: return true
	for area in site.parking:
		var polygon := PackedVector2Array()
		for v in area.points: polygon.append(Vector2(v[0],v[1]))
		if Geometry2D.is_point_in_polygon(p,polygon): return true
	return false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		map_mode=not map_mode
		player.enabled=not map_mode
		overview.current=map_mode
		player.camera.current=not map_mode
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE if map_mode else Input.MOUSE_MODE_CAPTURED
		for label in get_tree().get_nodes_in_group("building_labels"):
			label.visible=map_mode
			label.pixel_size=0.12 if map_mode else 0.025
			label.text=str(label.get_parent().name) if map_mode else label.get_parent().get_meta("building").name
	if event.is_action_pressed("labels"):
		for label in get_tree().get_nodes_in_group("building_labels"): label.visible=not label.visible
	if event.is_action_pressed("quality"):
		low_quality=not low_quality
		sun.shadow_enabled=not low_quality
		vegetation.visible=not low_quality
		get_viewport().msaa_3d=Viewport.MSAA_DISABLED if low_quality else Viewport.MSAA_2X

func _process(_delta: float) -> void:
	if player and not Geometry2D.is_point_in_polygon(Vector2(player.position.x,player.position.z),boundary): player.reset()

func capture_views() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	for frame in 40: await get_tree().physics_frame
	player.enabled=false
	var views := [[Vector3(-120,24,100),Vector3(70,10,25)], [Vector3(55,12,115),Vector3(140,18,45)], [Vector3(270,17,70),Vector3(315,19,-20)]]
	var capture := Camera3D.new()
	add_child(capture)
	capture.far=1200
	capture.current=true
	DirAccess.make_dir_recursive_absolute("res://docs/screenshots")
	var measurements: Array=[]
	for i in views.size():
		capture.position=views[i][0]
		capture.look_at(views[i][1])
		for frame in 50: await get_tree().process_frame
		var start:=Time.get_ticks_usec()
		var frame_times: Array[float]=[]
		for frame in 90:
			var previous:=Time.get_ticks_usec()
			await get_tree().process_frame
			frame_times.append((Time.get_ticks_usec()-previous)/1000.0)
		frame_times.sort()
		measurements.append({"view":i,"fps_mean":90.0/((Time.get_ticks_usec()-start)/1000000.0),"frame_ms_p95":frame_times[85],"draw_calls":Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)})
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://docs/screenshots/view_%d.png"%i)
	overview.current=true
	map_mode=true
	for label in get_tree().get_nodes_in_group("building_labels"):
		label.visible=true
		label.text=str(label.get_parent().name)
		label.pixel_size=0.2
	for frame in 25: await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://docs/screenshots/site_overview.png")
	map_mode=false
	for label in get_tree().get_nodes_in_group("building_labels"): label.visible=false
	player.camera.current=true
	for frame in 40: await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://docs/screenshots/player_view.png")
	var report:=FileAccess.open("res://docs/performance.json",FileAccess.WRITE)
	report.store_string(JSON.stringify({"device":RenderingServer.get_video_adapter_name(),"renderer":RenderingServer.get_current_rendering_method(),"resolution":[1280,720],"tier":"medium","samples":measurements},"  "))
	print("CAPTURE_COMPLETE fps=",Engine.get_frames_per_second()," draws=",Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	get_tree().quit()
