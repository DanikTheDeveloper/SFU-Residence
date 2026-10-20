extends CanvasLayer
var title: Label
var detail: Label
var help: PanelContainer
var world: Node3D
var location_index := 0

func _ready() -> void:
	world=get_parent()
	var panel := PanelContainer.new()
	panel.position=Vector2(24,24)
	add_child(panel)
	var style := StyleBoxFlat.new()
	style.bg_color=Color(0.045,0.075,0.09,0.92)
	style.content_margin_left=18
	style.content_margin_right=18
	style.content_margin_top=12
	style.content_margin_bottom=12
	style.border_width_left=3
	style.border_color=Color("c46a47")
	panel.add_theme_stylebox_override("panel",style)
	var stack := VBoxContainer.new()
	panel.add_child(stack)
	var eyebrow := Label.new()
	eyebrow.text="SFU / BURNABY RESIDENCES"
	eyebrow.add_theme_font_size_override("font_size",14)
	eyebrow.modulate=Color("d7b591")
	stack.add_child(eyebrow)
	title=Label.new()
	title.add_theme_font_size_override("font_size",23)
	stack.add_child(title)
	detail=Label.new()
	detail.add_theme_font_size_override("font_size",13)
	stack.add_child(detail)
	var footer := Label.new()
	add_child(footer)
	footer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	footer.position=Vector2(24,650)
	footer.text="WASD walk · Mouse look · Shift run · Space jump · F1 help\n© OpenStreetMap contributors · ODbL | Terrain: City of Burnaby · Open Government Licence\nExterior study · not an official SFU product"
	footer.add_theme_font_size_override("font_size",14)
	footer.add_theme_color_override("font_shadow_color",Color.BLACK)
	footer.add_theme_constant_override("shadow_offset_x",1)
	footer.add_theme_constant_override("shadow_offset_y",1)
	help=PanelContainer.new()
	help.position=Vector2(24,150)
	help.add_theme_stylebox_override("panel",style)
	add_child(help)
	var instructions := Label.new()
	instructions.text="EXPLORE THE PRECINCT\n\nW A S D  —  move     Shift  —  run\nMouse  —  look     Space  —  jump\nEsc  —  release pointer     Click  —  resume\nR  —  return to Residence Lane\nTab  —  building names\nN  —  visit next building (19 locations)\nF2  —  low / medium graphics\n[ / ]  —  mouse sensitivity\nF1  —  close this guide\n\nAll buildings are closed exterior models.\nHedges mark this study's playable boundary."
	instructions.add_theme_font_size_override("font_size",16)
	help.add_child(instructions)
	help.visible=false

var info_elapsed:=0.0

func _process(_delta: float) -> void:
	info_elapsed+=_delta
	if info_elapsed<0.1: return
	info_elapsed=0.0
	if not world.player: return
	var active_camera:=get_viewport().get_camera_3d()
	var observer: Vector3=active_camera.global_position if active_camera else world.player.global_position
	var nearest:=nearest_building_name(Vector2(observer.x,observer.z))
	title.text="Precinct overview" if world.map_mode else nearest
	var heading: float=fposmod(-rad_to_deg(active_camera.global_rotation.y if active_camera else world.player.pivot.rotation.y),360)
	detail.text="%s  ·  %s  ·  %d FPS  ·  F2 graphics"%["N ↑" if world.map_mode else "Heading %03d°"%int(heading),"LOW" if world.low_quality else "MEDIUM",Engine.get_frames_per_second()]

	if world.player.raw_mouse!=null and world.player.raw_mouse.connected:
		detail.text+="  ·  "+("Mouse locked" if world.player.raw_mouse.host_active else "Click to lock mouse")
	else:
		detail.text+="  ·  Native mouse"

func nearest_building_name(observer: Vector2) -> String:
	# A long U-shaped tower's centroid can be farther away than a neighboring hall.
	# Measure the actual footprint so a person at its door sees the right name.
	var nearest: String="Residence Lane"
	var distance: float=INF
	for data in world.registry:
		var polygon:=PackedVector2Array()
		for vertex in data.footprint: polygon.append(Vector2(vertex[0],vertex[1]))
		var d: float=0.0 if world.Geo.contains_point(observer,polygon) else INF
		if d>0:
			for i in polygon.size():
				d=minf(d,observer.distance_to(Geometry2D.get_closest_point_to_segment(observer,polygon[i],polygon[(i+1)%polygon.size()])))
		if d<distance:
			distance=d
			nearest=data.name
	return nearest

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("help"): help.visible=not help.visible
	if event.is_action_pressed("next_location"):
		var data: Dictionary=world.registry[location_index]
		world.player.position=world.Geo.point(data.outdoor_anchor,0.25)
		world.player.velocity=Vector3.ZERO
		var target := Vector3(data.centroid[0],0,data.centroid[1])
		var direction: Vector3=target-world.player.position
		world.player.pivot.rotation.y=atan2(-direction.x,-direction.z)
		location_index=(location_index+1)%world.registry.size()
	if event is InputEventKey and event.pressed:
		if event.keycode==KEY_BRACKETLEFT: world.player.sensitivity=maxf(0.0005,world.player.sensitivity-0.00025)
		if event.keycode==KEY_BRACKETRIGHT: world.player.sensitivity=minf(0.008,world.player.sensitivity+0.00025)

func run_verification() -> void:
	var verifier:=Node.new()
	verifier.set_script(preload("res://scripts/WorldVerification.gd"))
	world.add_child(verifier)
	verifier.run()
