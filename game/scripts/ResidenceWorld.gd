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
	site.parking.append(JSON.parse_string(FileAccess.get_file_as_string("res://data/main_parking.json")))
	for p in site.boundary: boundary.append(Vector2(p[0],p[1]))
	boundary=preload("res://scripts/BeedieField.gd").extend_boundary(boundary)
	boundary=preload("res://scripts/Field4.gd").extend_boundary(boundary)
	boundary=preload("res://scripts/Field2.gd").extend_boundary(boundary)
	configure_inputs()
	build_light()
	build_ground()
	var paths := group_node("Paths")
	preload("res://scripts/SurfaceController.gd").build(self,paths)
	var buildings := group_node("Buildings")
	for data in registry: Buildings.build(buildings,data)
	preload("res://scripts/NorthTowerPassage.gd").connect_row(self)
	preload("res://scripts/NorthDiningStair.gd").build(self)
	vegetation=group_node("Vegetation")
	build_landscape()
	preload("res://scripts/SiteDetails.gd").build(self)
	preload("res://scripts/BeedieField.gd").build(self)
	preload("res://scripts/Field4.gd").build(self)
	preload("res://scripts/Field2.gd").build(self)
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
	if "--capture" in OS.get_cmdline_user_args() or "--capture-north" in OS.get_cmdline_user_args() or "--capture-hamilton" in OS.get_cmdline_user_args() or "--capture-shell" in OS.get_cmdline_user_args() or "--capture-dining" in OS.get_cmdline_user_args() or "--capture-landscape" in OS.get_cmdline_user_args() or "--capture-mctaggart" in OS.get_cmdline_user_args() or "--capture-courtyard" in OS.get_cmdline_user_args() or "--capture-paving" in OS.get_cmdline_user_args() or "--capture-parking" in OS.get_cmdline_user_args() or "--capture-contact" in OS.get_cmdline_user_args() or "--capture-field" in OS.get_cmdline_user_args() or "--capture-field4" in OS.get_cmdline_user_args() or "--capture-field2" in OS.get_cmdline_user_args() or "--capture-links" in OS.get_cmdline_user_args() or "--capture-gallery" in OS.get_cmdline_user_args(): capture_views.call_deferred()
	if "--verify" in OS.get_cmdline_user_args(): get_node("UI").run_verification.call_deferred()
	if "--pointer-qa" in OS.get_cmdline_user_args(): pointer_qa.call_deferred()

func pointer_qa() -> void:
	DisplayServer.window_set_title("SFU Pointer QA")
	print("POINTER_QA_READY warp=",player.pointer_warp_mode)
	await get_tree().create_timer(20).timeout
	var report:=FileAccess.open("res://docs/pointer_qa.json",FileAccess.WRITE)
	report.store_string(JSON.stringify({"yaw_travel_radians":player.total_look_yaw,"warp_mode":player.pointer_warp_mode,"mouse_mode":Input.mouse_mode,"yaw":player.pivot.rotation.y},"  "))
	print("POINTER_QA_COMPLETE yaw=",player.total_look_yaw)
	get_tree().quit()

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
	for x in range(-350,400,2):
		for z in range(-180,280,2):
			var a := Geo.point([x,z])
			var b := Geo.point([x+2,z])
			var c := Geo.point([x+2,z+2])
			var d := Geo.point([x,z+2])
			verts.append_array([a,c,b,a,d,c])
	Geo.mesh_from_vertices(ground,verts,preload("res://scripts/GroundMaterials.gd").grass(),true,true).name="Terrain"
	var edge_mat := Geo.material(Color("425c3f"))
	for i in boundary.size():
		var a := Geo.point([boundary[i].x,boundary[i].y])
		var b := Geo.point([boundary[(i+1)%boundary.size()].x,boundary[(i+1)%boundary.size()].y])
		var wall := Geo.box(ground,(a+b)*0.5+Vector3.UP*1.15,Vector3(a.distance_to(b),2.3,1.1),edge_mat,true)
		wall.rotation.y=-atan2((b-a).z,(b-a).x)
	# Field4 replaces the old anonymous quadrilateral; see mapped site module.

func build_landscape() -> void:
	var props := group_node("Props")
	preload("res://scripts/PhotoVegetation.gd").build(self,vegetation)
	var photo_lights=preload("res://scripts/CourtyardLighting.gd").new()
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
		var courtyard_fixture:=false
		for building in registry:
			if building.id not in ["EAT","WET"]: continue
			var centre:=Vector2(building.centroid[0],building.centroid[1])
			if centre.distance_to(Vector2(p.x,p.z))<45.0: courtyard_fixture=true
		if courtyard_fixture:
			photo_lights.append(p,b-a)
		else:
			poles.append(Geo.transform(p+Vector3.UP*2,Vector3(0.12,4,0.12)))
			lamps.append(Geo.transform(p+Vector3.UP*4,Vector3(0.65,0.16,0.65)))
		if i%21==0:
			var yaw := -atan2((b-a).z,(b-a).x)
			seats.append(Geo.transform(p+Vector3(1,0.48,0),Vector3(1.7,0.16,0.5),yaw))
			backs.append(Geo.transform(p+Vector3(1,0.8,0.22),Vector3(1.7,0.5,0.10),yaw))
	photo_lights.finish(props)
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
	if event.is_action_pressed("labels"):
		for label in get_tree().get_nodes_in_group("building_labels"): label.visible=not label.visible
	if event.is_action_pressed("quality"):
		low_quality=not low_quality
		sun.shadow_enabled=not low_quality
		vegetation.visible=not low_quality
		get_viewport().msaa_3d=Viewport.MSAA_DISABLED if low_quality else Viewport.MSAA_2X

func _process(_delta: float) -> void:
	if player and not Geo.contains_point(Vector2(player.position.x,player.position.z),boundary): player.reset("boundary")

func capture_views() -> void:
	var capture_kind: String=""
	for kind in ["north","hamilton","shell","dining","landscape","mctaggart","courtyard","paving","parking","contact","field","field4","field2","links","gallery"]:
		if ("--capture-"+kind) in OS.get_cmdline_user_args(): capture_kind=kind
	DisplayServer.window_set_title("SFU automated screenshot capture - controls disabled")
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	for frame in 40: await get_tree().physics_frame
	player.enabled=false
	var views := [[Geo.point([-180,75],1.68),Geo.point([-100,65],5)], [Geo.point([133,62],1.68),Geo.point([133,77],7)], [Geo.point([60,88],1.68),Geo.point([62,68],7)], [Geo.point([-171,145],1.68),Geo.point([-170,115],1.68)], [Geo.point([85,25],1.68),Geo.point([85,-5],8)]]
	var capture := Camera3D.new()
	for building in registry:
		if building.id in ["MCH","CYR","PEN"]:
			var door:=Geo.point(building.entrance)
			var direction:=Geo.point(building.outdoor_anchor)-door
			direction.y=0
			var eye:=door+direction.normalized()*(25 if building.id=="CYR" else (10 if building.id=="PEN" else 15))
			eye.y=Geo.elevation(eye.x,eye.z)+1.68
			views.append([eye,door+Vector3.UP*(9 if building.id=="CYR" else 4.5)])
	var north: Node3D=get_node("Buildings/BRH")
	var passage: Dictionary=north.get_meta("exterior_passage")
	views.append([passage.start-passage.axis*12.0+Vector3.UP*1.68,passage.start+Vector3.UP*6.0])
	views.append([Geo.point([91.75513,38.2138],1.68),Geo.point([92.683,34.237],1.5)])
	for id in ["PJH","SBH"]:
		var entry_data: Dictionary=get_node("Buildings/"+id).get_meta("building")
		views.append([Geo.point(entry_data.outdoor_anchor,1.68),Geo.point(entry_data.entrance,1.5)])
	views.append([passage.gallery_start+passage.side*2+Vector3.UP*1.68,passage.gallery_end+Vector3.UP*1.68])
	if capture_kind in ["north","landscape"]:
		var apron_eye: Vector3=passage.start-passage.axis*1.6+passage.side*7
		apron_eye.y=Geo.elevation(apron_eye.x,apron_eye.z)+1.68
		var apron_target: Vector3=passage.start-passage.axis*1.6+passage.side*3
		apron_target.y=Geo.elevation(apron_target.x,apron_target.z)
		views.append([apron_eye,apron_target])
		var fixture: MultiMeshInstance3D=get_node("Props/PhotoCourtyardLightFrames")
		var light_base: Vector3=fixture.multimesh.get_instance_transform(0).origin-Vector3.UP*0.95
		var light_eye: Vector3=light_base+Vector3(3,0,3)
		light_eye.y=Geo.elevation(light_eye.x,light_eye.z)+1.68
		views.append([light_eye,light_base+Vector3.UP*1.9])
	if "--capture-hamilton" in OS.get_cmdline_user_args():
		views=[[Geo.point([42,49],1.68),Geo.point([30.437,43.0935],4.8)],[Geo.point([-5,70],1.68),Geo.point([-4,44],5.0)],[Geo.point([5,9],1.68),Geo.point([1.345,23.6235],4.0)]]
		var ham: Node3D=get_node("Buildings/HAM")
		var door: Vector3=ham.get_meta("photo_entrance")
		var normal: Vector3=ham.get_meta("photo_entrance_normal")
		var eye: Vector3=door+normal*4.8+Vector3(normal.z,0,-normal.x)*3.0
		eye.y=Geo.elevation(eye.x,eye.z)+1.68
		views.append([eye,door+Vector3.UP*1.6])
	if "--capture-shell" in OS.get_cmdline_user_args():
		views=[[Geo.point([245,146],1.68),Geo.point([253,136.6],4.0)],[Geo.point([242,103],1.68),Geo.point([260,100],5.0)],[Geo.point([286,97],1.68),Geo.point([273,96],5.0)],[Geo.point([247,95],1.68),Geo.point([252,92],0.65)],[Geo.point([249,73],1.68),Geo.point([257,72],0.70)]]
	if "--capture-dining" in OS.get_cmdline_user_args():
		views=[[Geo.point([171,11],1.68),Geo.point([186,17],5.0)],[Geo.point([216,-9],1.68),Geo.point([215,8],5.0)],[Geo.point([250,62],1.68),Geo.point([237,55],5.0)],[Geo.point([205,76],1.68),Geo.point([210,58],5.0)]]
	if capture_kind=="mctaggart":
		var data: Dictionary=get_node("Buildings/MCH").get_meta("building")
		var door:=Geo.point(data.entrance)
		var outward:=Geo.point(data.outdoor_anchor)-door
		outward.y=0
		outward=outward.normalized()
		var side:=Vector3(outward.z,0,-outward.x)
		views=[]
		for offset in [outward*12, outward*4+side*3]:
			var eye: Vector3=door+offset
			eye.y=Geo.elevation(eye.x,eye.z)+1.68
			views.append([eye,door+Vector3.UP*3])
	if capture_kind=="courtyard":
		views=[[Geo.point([353,17],1.68),Geo.point([337,-13],9)],[Geo.point([319,-60],1.68),Geo.point([320,-35],6)],[Geo.point([279,-1],1.68),Geo.point([280,-15],9)],[Vector3(375,65,65),Vector3(307,12,-15)]]
	if capture_kind=="courtyard":
		var portico: Dictionary=get_node("Buildings/CYR").get_meta("east_portico")
		var eye: Vector3=portico.a.lerp(portico.b,0.25)-portico.outward*1.8
		eye.y=Geo.elevation(eye.x,eye.z)+1.68
		views.append([eye,eye+portico.tangent*8+Vector3.UP*0.6])
	if capture_kind=="links":
		var stair: Node3D=get_node("NorthDiningStair")
		var a: Vector3=stair.get_meta("start")
		var u: Vector3=stair.get_meta("direction")
		var top: Vector3=a+u*10.9
		top.y=preload("res://scripts/TerrainController.gd").foundation("DC")
		views=[[a-u*2+Vector3.UP*1.68,top+Vector3.UP*0.5],[top+Vector3.UP*1.68,a+Vector3.UP*1.68]]
	if capture_kind in ["courtyard","gallery"]:
		if capture_kind=="gallery": views=[]
		var gallery: Dictionary=get_node("Buildings/CYR").get_meta("court_gallery")
		var eye: Vector3=gallery.a.lerp(gallery.b,0.25)-gallery.outward*1.8
		eye.y=Geo.elevation(eye.x,eye.z)+1.68
		views.append([eye,eye+gallery.outward*8])
		views.append([eye,eye+gallery.tangent*15])
	if capture_kind=="field2":
		views=[[Geo.point([170,170],1.68),Geo.point([235,220],2.5)],[Geo.point([230,245],1.68),Geo.point([175,200],2.0)],[Vector3(300,65,285),Geo.point([175,185])]]
	if capture_kind=="field4":
		views=[[Geo.point([35,80],1.68),Geo.point([8,115],1.0)],[Geo.point([-50,98],1.68),Geo.point([55,124],1.2)],[Vector3(90,45,180),Geo.point([8,110])]]
	if capture_kind=="field4":
		var shelter: Dictionary=get_node("Props/Field4/SidelineContext").get_meta("shelter_17")
		var eye: Vector3=shelter.center+shelter.u*3+shelter.v*7
		eye.y=Geo.elevation(eye.x,eye.z)+1.68
		views.append([eye,shelter.center+Vector3.UP*1.3])
		views.append([shelter.center+shelter.u*3+Vector3.UP*1.68,shelter.center+shelter.v*15+Vector3.UP*1.2])
	if capture_kind=="field":
		views=[[Geo.point([89,133],1.68),Geo.point([112,173],1.0)],[Geo.point([120,190],1.68),Geo.point([91,139],2.5)],[Geo.point([63,175],1.68),Geo.point([97,160],2.0)],[Vector3(165,45,213),Geo.point([109,167])]]
	if capture_kind=="parking":
		views=[[Geo.point([15,-45],1.68),Geo.point([70,-30],1.0)],[Geo.point([100,-30],1.68),Geo.point([100,0],8)],[Vector3(80,55,-90),Geo.point([85,-20],0)],[Geo.point([-168,125],1.68),Geo.point([-176,123],0.8)],[Geo.point([-167,117],1.68),Geo.point([-175,112],1.0)],[Geo.point([-172,110],1.68),Geo.point([-160,124],1.2)]]
	if capture_kind=="contact":
		views=[[Geo.point([-87,-50],1.68),Geo.point([-88.72,-43.93],0.65)],[Geo.point([-222,25],1.68),Geo.point([-223.41,31.90],0.65)]]
	if capture_kind=="paving":
		views=[[Geo.point([130,90],1.68),Geo.point([130,86.8],0.1)],[Geo.point([-180,63],1.68),Geo.point([-179,59],0.2)],[Geo.point([61,72],1.68),Geo.point([68,68],0.1)]]
	if capture_kind=="landscape": views=views.slice(13)
	add_child(capture)
	capture.far=1200
	capture.fov=72
	capture.current=true
	DirAccess.make_dir_recursive_absolute("res://docs/screenshots")
	var measurements: Array=[]
	for i in range(8 if "--capture-north" in OS.get_cmdline_user_args() else 0,views.size()):
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
		measurements.append({"view":i,"camera_xyz":[capture.position.x,capture.position.y,capture.position.z],"look_at":[views[i][1].x,views[i][1].y,views[i][1].z],"viewport_size":[get_viewport().get_visible_rect().size.x,get_viewport().get_visible_rect().size.y],"fov":capture.fov,"eye_height_m":1.68,"fps_mean":90.0/((Time.get_ticks_usec()-start)/1000000.0),"frame_ms_p95":frame_times[85],"draw_calls":Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)})
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://docs/screenshots/%s_%d.png"%["view" if capture_kind in ["","north"] else capture_kind,i])
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
	var report:=FileAccess.open("res://docs/performance%s.json"%("" if capture_kind=="" else "_"+capture_kind),FileAccess.WRITE)
	report.store_string(JSON.stringify({"device":RenderingServer.get_video_adapter_name(),"renderer":RenderingServer.get_current_rendering_method(),"resolution":[get_viewport().get_visible_rect().size.x,get_viewport().get_visible_rect().size.y],"tier":"medium","samples":measurements},"  "))
	print("CAPTURE_COMPLETE fps=",Engine.get_frames_per_second()," draws=",Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	get_tree().quit()




