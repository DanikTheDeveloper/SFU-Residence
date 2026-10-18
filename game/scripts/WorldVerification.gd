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
	check("Pauline Jewett entrance label uses footprint not neighboring centroid",world.get_node("UI").nearest_building_name(Vector2(19.57,21.05))=="Pauline Jewett House")
	var field_level: float=world.get_node("Props/BeedieField").get_meta("finished_level_estimate")
	for p in [[89,140],[140,155],[110,170],[95,195]]:
		check("Beedie level playing surface "+str(p),absf(Geo.elevation(p[0],p[1])-field_level)<0.02)
	check("Beedie outfield inside expanded study boundary",Geo.contains_point(Vector2(100,201),world.boundary))
	var field4_level: float=world.get_node("Props/Field4").get_meta("finished_level_estimate")
	for p in [[-35,90],[0,110],[50,120],[20,140]]:
		check("Field4 level surface "+str(p),absf(Geo.elevation(p[0],p[1])-field4_level)<0.02)
		var turf_hit:=ray(Vector3(p[0],field4_level+2,p[1]),Vector3(p[0],field4_level-2,p[1]))
		check("Field4 terrain collision "+str(p),not turf_hit.is_empty() and absf(turf_hit.position.y-field4_level)<0.1)
	var field2_level: float=world.get_node("Props/Field2").get_meta("finished_level_estimate")
	for p in [[170,190],[200,220],[220,239],[220,241],[240,250]]:
		check("Field2 level surface "+str(p),absf(Geo.elevation(p[0],p[1])-field2_level)<0.02)
		var turf_hit:=ray(Vector3(p[0],field2_level+2,p[1]),Vector3(p[0],field2_level-2,p[1]))
		check("Field2 extended terrain collision "+str(p),not turf_hit.is_empty() and absf(turf_hit.position.y-field2_level)<0.1)
		check("Field2 point inside study boundary "+str(p),Geo.contains_point(Vector2(p[0],p[1]),world.boundary))
	check("Field2 no old grid seam step",absf(Geo.elevation(220,239.9)-Geo.elevation(220,240.1))<0.02)
	check("19 scene buildings",world.get_node("Buildings").get_child_count()==19)
	check("Compatibility selected",RenderingServer.get_current_rendering_method()=="gl_compatibility")
	check("Interior boundary ray degeneracy regression",Geo.contains_point(Vector2(-216.3434,62),world.boundary))
	check("Exterior remains outside boundary",not Geo.contains_point(Vector2(-400,62),world.boundary))
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
			if data.type=="north_tower":
				var passage=preload("res://scripts/NorthTowerPassage.gd")
				if passage.interval(center,center,passage.layout(data,center.y)).x>=0: continue
			edge_count+=1
			if not ray(center+direction*0.4,center-direction*0.4).is_empty(): edge_hits+=1
		check(data.id+" solid facade edges",edge_count==edge_hits,"%d/%d"%[edge_hits,edge_count])
	var courtyard: Node3D=world.get_node("Buildings/CYR")
	var cy_base: float=courtyard.get_meta("foundation_world_y")
	for sample in [[320.0,-31.0,10.8,"Lowrise"],[320.0,-2.0,34.1,"Highrise"],[335.0,-15.0,8.0,"Atrium"]]:
		var top_hit:=ray(Vector3(sample[0],100,sample[1]),Vector3(sample[0],-100,sample[1]))
		check("Courtyard "+sample[3]+" roof matches configured zone height",not top_hit.is_empty() and absf(top_hit.position.y-(cy_base+sample[2]))<0.12,str(top_hit.get("position","missing")))
	var dining: Node3D=world.get_node("Buildings/DC")
	check("Dining retains distinct old and new exterior zones",dining.get_meta("exterior_zones").size()==2 and dining.get_meta("family_master")=="res://scripts/DiningExterior.gd")
	check("Dining three-level registry retained",dining.get_meta("floor_count")==3)
	var courtyard_tangent:=Vector3(11.686,0,-49.726).normalized()
	var courtyard_outward:=Vector3(courtyard_tangent.z,0,-courtyard_tangent.x)
	var table_point:=Vector3(255.533,0,109.004)+courtyard_tangent*16+ courtyard_outward*7
	table_point.y=Geo.elevation(table_point.x,table_point.z)
	var table_hit:=ray(table_point+Vector3.UP*1.5,table_point+Vector3.UP*0.6)
	check("Shell concrete tabletop solid at seating area",not table_hit.is_empty() and absf(table_hit.position.y-table_point.y-0.8)<0.02)
	var fence_point:=Vector3(255.533,0,109.004)+courtyard_tangent*10+courtyard_outward*3.2
	fence_point.y=Geo.elevation(fence_point.x,fence_point.z)+0.9
	check("Shell timber screen blocks capsule-height crossing",not ray(fence_point+courtyard_outward,fence_point-courtyard_outward).is_empty())
	var shell: Node3D=world.get_node("Buildings/SHR")
	check("Shell has distinct photo-based master",shell.get_meta("family_master")=="res://scripts/ShellExterior.gd")
	check("Shell official total four levels preserved",shell.get_meta("floor_count")==4)
	var hamilton: Node3D=world.get_node("Buildings/HAM")
	var ham_door: Vector3=hamilton.get_meta("photo_entrance")
	var ham_normal: Vector3=hamilton.get_meta("photo_entrance_normal")
	check("Hamilton primary portico faces north",ham_normal.z < -0.9)
	check("Hamilton exterior entry remains closed",not ray(ham_door+ham_normal+Vector3.UP*1.4,ham_door-ham_normal+Vector3.UP*1.4).is_empty())
	check("Hamilton portico overhead solid",not ray(ham_door+ham_normal*1.5+Vector3.UP*1.68,ham_door+ham_normal*1.5+Vector3.UP*3.5).is_empty())
	check("Hamilton separate four-floor master",hamilton.get_meta("family_master")=="res://scripts/HamiltonExterior.gd" and hamilton.get_meta("floor_count")==4)
	# Longitudinal exterior gallery: both directions through each existing footprint.
	for id in ["PJH","BRH","SBH"]:
		var passage: Dictionary=world.get_node("Buildings/"+id).get_meta("exterior_passage")
		var start: Vector3=passage.gallery_start-passage.side*0.8
		var end: Vector3=passage.gallery_end+passage.side*0.8
		check(id+" longitudinal gallery clear at eye level",ray(start+Vector3.UP*1.68,end+Vector3.UP*1.68).is_empty())
		var column: Vector3=passage.start+passage.side*2.8-passage.axis*0.15+Vector3.UP*1.4
		check(id+" courtyard column solid",not ray(column-passage.side,column+passage.side).is_empty())
		var mid: Vector3=(start+end)*0.5
		check(id+" rear residential boundary closed",not ray(mid+Vector3.UP*1.4,mid+passage.axis*3+Vector3.UP*1.4).is_empty())
		check(id+" gallery overhead collision",not ray(mid+Vector3.UP*1.68,mid+Vector3.UP*3.5).is_empty())
		for reverse in [false,true]:
			var origin: Vector3=end if reverse else start
			var direction: Vector3=-passage.side if reverse else passage.side
			player.position=Geo.point([origin.x,origin.z],0.3)
			player.velocity=Vector3.ZERO
			player.pivot.rotation=Vector3(0,atan2(-direction.x,-direction.z),0)
			await frames(30)
			Input.action_press("move_forward")
			await frames(int((passage.length+1.6)/4.5*60)+12)
			Input.action_release("move_forward")
			check(id+" longitudinal capsule traversal "+str(reverse),(player.position-origin).dot(direction)>passage.length+1.3 and player.is_on_floor(),str(player.position))
	# Walk continuously through all three buildings, including the graded links.
	for ids in [["PJH","BRH","SBH"],["SBH","BRH","PJH"]]:
		var reverse: bool=ids[0]=="SBH"
		var first: Dictionary=world.get_node("Buildings/"+ids[0]).get_meta("exterior_passage")
		var origin: Vector3=first.gallery_end if reverse else first.gallery_start
		player.position=Geo.point([origin.x,origin.z],0.3)
		player.velocity=Vector3.ZERO
		await frames(30)
		for id in ids:
			var passage: Dictionary=world.get_node("Buildings/"+id).get_meta("exterior_passage")
			var target: Vector3=passage.gallery_start if reverse else passage.gallery_end
			var reached:=false
			Input.action_press("move_forward")
			for frame in 1600:
				var delta: Vector3=target-player.position
				delta.y=0
				if delta.length()<0.35:
					reached=true
					break
				player.pivot.rotation.y=atan2(-delta.x,-delta.z)
				await frames(1)
			Input.action_release("move_forward")
			check("Continuous North row "+str(reverse)+" reaches "+id,reached and player.is_on_floor(),str(player.position))
	# Use an unobstructed part of Field 4 edge for reproducible movement checks.
	player.position=Geo.point([-25,110],0.3)
	player.velocity=Vector3.ZERO
	player.pivot.rotation=Vector3.ZERO
	player.camera.rotation.x=-0.16
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
	player._input(mouse)
	check("Mouse look",absf(player.pivot.rotation.y-yaw_before)>0.05)
	var turn_start: float=player.total_look_yaw
	for i in 120:
		var motion:=InputEventMouseMotion.new()
		motion.relative=Vector2(40,0)
		motion.screen_relative=motion.relative
		Input.parse_input_event(motion)
	Input.flush_buffered_events()
	check("Mouse input crosses 360 degrees through dispatcher",absf(player.total_look_yaw-turn_start)>TAU)
	turn_start=player.total_look_yaw
	for i in 120: player.apply_look(Vector2(-40,0))
	check("Mouse turns 360 degrees in reverse",absf(player.total_look_yaw-turn_start)>TAU)
	player.apply_look(Vector2(0,10000))
	check("Pitch remains bounded without restricting yaw",absf(player.camera.rotation.x)<=1.451 and absf(player.pivot.rotation.x)<0.001)
	var stable:=true
	for step in 240:
		player.apply_look(Vector2(25,-20 if step<120 else 20))
		stable=stable and player.camera.global_basis.y.dot(Vector3.UP)>0.1 and absf(player.pivot.rotation.x)<0.001 and absf(player.camera.rotation.y)<0.001
	check("Pitch extremes preserve upright camera during full turns",stable)
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
	var north=preload("res://scripts/NorthTowerExterior.gd")
	var saved_north_bay_width: float=north.bay_width
	for id in ["PJH","BRH","SBH"]:
		var building: Node3D=world.get_node("Buildings/"+id)
		check(id+" distinct North master",building.get_meta("family_master")==north.MASTER_ID and north.MASTER_ID!=master.MASTER_ID)
		check(id+" eight floors",building.get_meta("floor_count")==8)
		var data: Dictionary=building.get_meta("building")
		var counts: Array=[]
		for width in [3.6,5.0]:
			north.bay_width=width
			var probe:=Node3D.new()
			world.add_child(probe)
			north.build(probe,data,data.footprint,0,data.height_m)
			counts.append(probe.get_node("NorthGlass").multimesh.instance_count)
			probe.free()
		check(id+" North master edit propagates",counts[0]!=counts[1],str(counts))
		north.bay_width=saved_north_bay_width
	var lot: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/main_parking.json"))
	for sample in [[10,-40],[60,-30],[110,-20],[165,0]]:
		check("Main parking level "+str(sample),absf(Geo.elevation(sample[0],sample[1])-lot.height_estimate_m)<0.03)
	var parking:=world.get_node("Props/ParkingLots")
	check("Parking stalls arranged in mapped polygons",parking.get_meta("estimated_stalls")>15,str(parking.get_meta("estimated_stalls")))
	var town=preload("res://scripts/TownhouseBlockExterior.gd")
	var count:=0
	for data in world.registry:
		if data.type!="townhouse": continue
		count+=1
		var building: Node3D=world.get_node("Buildings/"+data.id)
		check(data.id+" shared townhouse master",building.get_meta("family_master")==town.MASTER_ID)
		check(data.id+" pitched roof generated",building.get_node("PitchedRoof").mesh.get_surface_count()==1)
		var counts: Array=[]
		for width in [3.5,5.0]:
			town.bay_width=width
			var probe:=Node3D.new()
			world.add_child(probe)
			town.build(probe,data,data.footprint,0,data.height_m)
			counts.append(probe.get_node("TownhouseGlass").multimesh.instance_count)
			probe.free()
		check(data.id+" townhouse master edit propagates",counts[0]!=counts[1],str(counts))
		town.bay_width=5.2
	check("Exactly nine original townhouse blocks",count==9)
	var mch:=world.get_node("Buildings/MCH")
	check("McTaggart uses distinct renewed-envelope master",mch.get_meta("family_master")==preload("res://scripts/McTaggartExterior.gd").MASTER_ID)
	check("McTaggart retains four-floor registry",mch.get_meta("floor_count")==4)
	check("McTaggart facade batching",mch.get_node("McTaggartBronze").multimesh.instance_count>100 and mch.get_node("McTaggartGlass").multimesh.instance_count>20)
	var courtyard:=world.get_node("Buildings/CYR")
	check("Courtyard uses distinct precast master",courtyard.get_meta("family_master")==preload("res://scripts/CourtyardExterior.gd").MASTER_ID)
	check("Courtyard preserves eleven-floor registry",courtyard.get_meta("floor_count")==11)
	check("Courtyard uses ribbed panels and recessed glazing",courtyard.get_node("CourtyardRibbed").multimesh.instance_count>50 and courtyard.get_node("CourtyardGlass").multimesh.instance_count>50)

func run_routes() -> void:
	var routes: Array=JSON.parse_string(FileAccess.get_file_as_string("res://data/test_routes.json"))
	routes.append({"buildings":["Residence Main Lot access and aisle"],"points":[[-30,-40],[0,-40],[25,-35],[50,-30],[75,-25],[100,-20],[125,-15],[150,-10]]})
	routes.append({"buildings":["Shell courtyard fence opening"],"points":[[248.33,86.854],[251,87.452],[254,88.124],[257,88.796],[254,88.124],[251,87.452],[248.33,86.854]]})
	routes.append({"buildings":["Field4 spawn approach and pitch"],"points":[[35,80],[30,92],[20,110],[0,105],[-20,100],[-35,110],[-18,115],[0,120],[20,125],[40,130],[55,120],[42,106],[30,92],[35,80]]})
	routes.append({"buildings":["Field2 approach and extended ground"],"points":[[170,145],[170,165],[175,185],[195,200],[215,215],[235,230],[240,245],[220,245],[205,230],[190,215],[175,195],[170,175],[170,155]]})
	routes.append({"buildings":["Beedie entrance and outfield"],"points":[[102,129],[102,137],[108,150],[112,170],[110,192],[95,185],[90,170],[97,145],[102,137],[102,129]]})
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



