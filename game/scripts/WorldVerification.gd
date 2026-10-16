extends Node
const Geo=preload("res://scripts/Geometry.gd")
var world: Node3D
var results: Array=[]

func check(label: String, success: bool, evidence: String="") -> void:
	results.append({"check":label,"passed":success,"evidence":evidence})
	print("PASS " if success else "FAIL ",label," ",evidence)

func frames(count: int) -> void:
	for i in count: await get_tree().physics_frame

func ray(a: Vector3,b: Vector3) -> Dictionary:
	var query := PhysicsRayQueryParameters3D.create(a,b,1)
	return world.get_world_3d().direct_space_state.intersect_ray(query)

func run() -> void:
	world=get_parent()
	if "--routes" in OS.get_cmdline_user_args():
		await run_routes()
		return
	await frames(5)
	check("19 scene buildings",world.get_node("Buildings").get_child_count()==19)
	check("Compatibility selected",RenderingServer.get_current_rendering_method()=="gl_compatibility")
	var player: CharacterBody3D=world.player
	player.enabled=true
	player.test_input=true
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	for data in world.registry:
		var anchor := Geo.point(data.outdoor_anchor)
		check(data.id+" anchor outside",not world.inside_building(Vector2(anchor.x,anchor.z),0.15))
		var hit := ray(anchor+Vector3.UP*2,anchor-Vector3.UP*2)
		check(data.id+" ground",not hit.is_empty() and absf(hit.position.y-anchor.y)<0.15)
		player.position=anchor+Vector3.UP*0.3
		player.velocity=Vector3.ZERO
		await frames(24)
		check(data.id+" stable player",player.is_on_floor() and absf(player.position.y-anchor.y)<0.15)
		var poly := PackedVector2Array()
		for p in data.footprint: poly.append(Vector2(p[0],p[1]))
		if Geometry2D.is_polygon_clockwise(poly): poly.reverse()
		var edge_count:=0
		var edge_hits:=0
		for i in poly.size():
			var a:=poly[i]
			var b:=poly[(i+1)%poly.size()]
			if a.distance_to(b)<1: continue
			var midpoint: Vector2=(a+b)*0.5
			var center:=Geo.point([midpoint.x,midpoint.y],1)
			var direction:=Vector3.UP.cross(Vector3(b.x-a.x,0,b.y-a.y)).normalized()
			edge_count+=1
			if not ray(center+direction*0.4,center-direction*0.4).is_empty(): edge_hits+=1
		check(data.id+" solid facade edges",edge_count==edge_hits,"%d/%d"%[edge_hits,edge_count])
	# Use an unobstructed part of Field 4 edge for reproducible movement checks.
	player.position=Geo.point([-25,110],0.3)
	player.velocity=Vector3.ZERO
	player.pivot.rotation=Vector3(-0.16,0,0)
	await frames(30)
	var start: Vector3=player.position
	Input.action_press("move_forward")
	await frames(60)
	Input.action_release("move_forward")
	var walk: float=player.position.distance_to(start)
	check("W movement",walk>3.5 and walk<5.5,"metres=%f"%walk)
	await frames(20)
	start=player.position
	Input.action_press("sprint")
	Input.action_press("move_forward")
	await frames(60)
	Input.action_release("sprint")
	Input.action_release("move_forward")
	check("Sprint faster",player.position.distance_to(start)>walk+2)
	await frames(20)
	var jump_start: float=player.position.y
	Input.action_press("jump")
	await frames(2)
	Input.action_release("jump")
	await frames(10)
	check("Jump rises",player.position.y>jump_start+0.5)
	await frames(65)
	check("Jump lands",player.is_on_floor())
	var yaw_before: float=player.pivot.rotation.y
	var mouse := InputEventMouseMotion.new()
	mouse.relative=Vector2(50,20)
	player._unhandled_input(mouse)
	check("Mouse look",absf(player.pivot.rotation.y-yaw_before)>0.05)
	# Approach a known long Hamilton edge, then keep walking into it.
	var data: Dictionary=world.registry[7]
	var door:=Geo.point(data.entrance)
	var anchor:=Geo.point(data.outdoor_anchor)
	var outward: Vector3=(anchor-door).normalized()
	outward.y=0
	player.position=door+outward*3
	player.position.y=Geo.elevation(player.position.x,player.position.z)+0.3
	player.velocity=Vector3.ZERO
	player.pivot.rotation.y=atan2(outward.x,outward.z)
	await frames(30)
	Input.action_press("move_forward")
	await frames(90)
	Input.action_release("move_forward")
	check("Character blocked by facade",not world.inside_building(Vector2(player.position.x,player.position.z)) and Vector2(player.position.x,player.position.z).distance_to(Vector2(door.x,door.z))<1.0)
	player.pivot.rotation.y+=PI
	await frames(10)
	check("First person fixed eye height",absf(player.camera.global_position.y-player.global_position.y-1.68)<0.001)
	check("First person camera centered in collider",Vector2(player.camera.global_position.x-player.global_position.x,player.camera.global_position.z-player.global_position.z).length()<0.001)
	player.position.y=-50
	await frames(3)
	check("Fall recovery",player.position.distance_to(player.spawn)<2)
	verify_families()
	var terrain_matches:=0
	var terrain_samples:=0
	for road in world.roads:
		var p:=Geo.point(road.points[0])
		if world.inside_building(Vector2(p.x,p.z),1): continue
		var hit:=ray(p+Vector3.UP*0.5,p-Vector3.UP*0.5)
		terrain_samples+=1
		if not hit.is_empty() and absf(hit.position.y-p.y)<0.015: terrain_matches+=1
	check("Terrain mesh collision parity at route vertices",terrain_samples==terrain_matches,"%d/%d"%[terrain_matches,terrain_samples])
	var failures:=0
	for result in results:
		if not result.passed: failures+=1
	var file:=FileAccess.open("res://docs/verification.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"failures":failures,"checks":results},"  "))
	print("VERIFICATION_COMPLETE checks=",results.size()," failures=",failures)
	get_tree().quit(0 if failures==0 else 1)

func verify_families() -> void:
	var master=preload("res://scripts/ModernTowerExterior.gd")
	for id in ["EAT","WET"]:
		var building: Node3D=world.get_node("Buildings/"+id)
		var data: Dictionary=building.get_meta("building")
		check(id+" shared modern master",building.get_meta("family_master")==master.MASTER_ID)
		check(id+" independent floors",building.get_meta("floor_count")== (7 if id=="EAT" else 8))
		var counts: Array=[]
		for width in [3.0,4.5]:
			master.bay_width=width
			var probe:=Node3D.new()
			world.add_child(probe)
			master.build(probe,data,data.footprint,0,data.height_m)
			counts.append(probe.get_node("ModernGlass").multimesh.instance_count)
			probe.free()
		check(id+" shared master edit propagates",counts[0]!=counts[1],str(counts))
		master.bay_width=3.0

func run_routes() -> void:
	var routes: Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/test_routes.json"))
	var player: CharacterBody3D=world.player
	player.test_input=true
	player.enabled=true
	var failures:=0
	for loop in routes:
		player.position=Geo.point(loop.points[0],0.3)
		player.velocity=Vector3.ZERO
		await frames(30)
		var reached:=0
		for p in loop.points:
			var target:=Vector2(p[0],p[1])
			var ticks:=0
			while Vector2(player.position.x,player.position.z).distance_to(target)>0.22 and ticks<500:
				var direction: Vector2=target-Vector2(player.position.x,player.position.z)
				player.pivot.rotation.y=atan2(-direction.x,-direction.y)
				Input.action_press("move_forward")
				await frames(1)
				ticks+=1
			if ticks>=500:
				print("ROUTE_BLOCKED target=",p," player=",player.position)
				break
			reached+=1
		Input.action_release("move_forward")
		var ok: bool=reached==loop.points.size()
		check("Walk loop "+str(loop.buildings),ok,"%d/%d checkpoints"%[reached,loop.points.size()])
		if not ok: failures+=1
	var file:=FileAccess.open("res://docs/routes_verification.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"failures":failures,"checks":results},"  "))
	print("ROUTES_COMPLETE failures=",failures)
	get_tree().quit(0 if failures==0 else 1)
