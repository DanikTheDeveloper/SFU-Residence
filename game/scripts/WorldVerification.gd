extends Node
const Geo=preload("res://scripts/Geometry.gd")
var world: Node3D
var results: Array=[]

func check(label: String, success: bool, evidence: String="") -> void:
	results.append({"check":label,"passed":success,"evidence":evidence})
	print("PASS " if success else "FAIL ",label," ",evidence)

func frames(count: int) -> void:
	for i in count: await get_tree().physics_frame

func ray(a: Vector3,b: Vector3,exclude: Array[RID]=[]) -> Dictionary:
	var query := PhysicsRayQueryParameters3D.create(a,b,1)
	query.exclude=exclude
	return world.get_world_3d().direct_space_state.intersect_ray(query)

func run() -> void:
	world=get_parent()
	if "--routes" in OS.get_cmdline_user_args():
		await run_routes()
		return
	await frames(5)
	check("Pauline Jewett entrance label uses footprint not neighboring centroid",world.get_node("UI").nearest_building_name(Vector2(19.57,21.05))=="Pauline Jewett House")
	var mch_entry: Node3D=world.get_node("Props/McTaggartApproach")
	var mch_door: Vector3=mch_entry.get_meta("door")
	var mch_n: Vector3=mch_entry.get_meta("normal")
	var mch_top: Vector3=mch_entry.get_meta("top")
	var mch_low: Vector3=mch_entry.get_meta("low")
	check("McTaggart entry uses west connector near East Tower",mch_door.x>144 and mch_door.x<150 and mch_n.z< -0.9)
	check("McTaggart entry stair descends toward door",mch_top.y-mch_low.y>1.0)
	check("McTaggart photo door closes building",not ray(mch_door+mch_n+Vector3.UP*1.4,mch_door-mch_n+Vector3.UP*1.4).is_empty())
	check("McTaggart entry canopy solid",not ray(mch_door+mch_n+Vector3.UP*1.68,mch_door+mch_n+Vector3.UP*3.4).is_empty())
	var stair_mid: Vector3=mch_top.lerp(mch_low,0.5)
	var mch_stair_hit:=ray(stair_mid+Vector3.UP*0.4,stair_mid-Vector3.UP*0.4)
	check("McTaggart approach collision follows steps",not mch_stair_hit.is_empty() and absf(mch_stair_hit.position.y-stair_mid.y)<0.02)
	var recreation: Node3D=world.get_node("Props/EastWestRecreation")
	check("East West practice area has two adjacent hoops",recreation.get_meta("hoop_count")==2)
	var court_u:=Vector3(0.973475,0,0.228793)
	var court_v:=Vector3(-court_u.z,0,court_u.x)
	for local in [Vector2(-5.5,-3),Vector2(5.5,-3),Vector2(-5.5,3),Vector2(5.5,3),Vector2.ZERO]:
		var q: Vector3=Vector3(104,5.3,48)+court_u*local.x+court_v*local.y
		var hit:=ray(q+Vector3.UP*0.4,q-Vector3.UP*0.4)
		check("Practice court finished plane "+str(local),not hit.is_empty() and absf(hit.position.y-5.3)<0.015)
	var d: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/east_west_recreation.json"))
	var ramp_length:=0.0
	for j in d.ramp.size()-1:ramp_length+=Vector2(d.ramp[j][0],d.ramp[j][1]).distance_to(Vector2(d.ramp[j+1][0],d.ramp[j+1][1]))
	check("Switchback estimated average slope below 5 percent",(d.upper_y-d.middle_y)/ramp_length<0.05)
	for j in d.ramp.size()-1:
		var length:=Vector2(d.ramp[j][0],d.ramp[j][1]).distance_to(Vector2(d.ramp[j+1][0],d.ramp[j+1][1]))
		check("Switchback run grade "+str(j),absf(d.ramp_levels[j]-d.ramp_levels[j+1])/length<=1.0/12.0)

	var field_level: float=world.get_node("Props/BeedieField").get_meta("finished_level_estimate")
	for p in [[89,140],[140,155],[110,170],[95,195]]:
		check("Beedie level playing surface "+str(p),absf(Geo.elevation(p[0],p[1])-field_level)<0.02)
	check("Beedie outfield inside expanded study boundary",Geo.contains_point(Vector2(100,201),world.boundary))
	var field_shelter: Dictionary=world.get_node("Props/Field4/SidelineContext").get_meta("shelter_17")
	var shelter_eye: Vector3=field_shelter.center+field_shelter.u*3+Vector3.UP*1.5
	check("Field4 dark shelter has open front",ray(shelter_eye,shelter_eye+field_shelter.v*1.8).is_empty())
	check("Field4 shelter closed rear",not ray(shelter_eye,shelter_eye-field_shelter.v*2).is_empty())
	check("Field4 shelter solid roof",not ray(shelter_eye,shelter_eye+Vector3.UP*2).is_empty())
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
			if data.id=="CYR" and (preload("res://scripts/CourtyardPortico.gd").contains(data,midpoint) or preload("res://scripts/CourtyardGallery.gd").contains(data,midpoint)): continue
			edge_count+=1
			if not ray(center+direction*0.4,center-direction*0.4).is_empty(): edge_hits+=1
		check(data.id+" solid facade edges",edge_count==edge_hits,"%d/%d"%[edge_hits,edge_count])
	var courtyard: Node3D=world.get_node("Buildings/CYR")
	var cy_base: float=courtyard.get_meta("foundation_world_y")
	var portico: Dictionary=courtyard.get_meta("east_portico")
	var portico_mid: Vector3=(portico.a+portico.b)*0.5-portico.outward*1.8+Vector3.UP*(cy_base+1.5)
	check("Courtyard eastern exterior recess open",ray(portico_mid-portico.tangent*2,portico_mid+portico.tangent*2).is_empty())
	check("Courtyard portico rear remains closed",not ray(portico_mid,portico_mid-portico.outward*3).is_empty())
	check("Courtyard portico soffit collision",not ray(portico_mid,portico_mid+Vector3.UP*6).is_empty())

	for sample in [[320.0,-31.0,10.8,"Lowrise"],[320.0,-2.0,34.1,"Highrise"],[335.0,-15.0,8.0,"Atrium"]]:
		var top_hit:=ray(Vector3(sample[0],100,sample[1]),Vector3(sample[0],-100,sample[1]))
		check("Courtyard "+sample[3]+" roof matches configured zone height",not top_hit.is_empty() and absf(top_hit.position.y-(cy_base+sample[2]))<0.12,str(top_hit.get("position","missing")))
	var gallery: Dictionary=courtyard.get_meta("court_gallery")
	var gallery_eye: Vector3=gallery.a.lerp(gallery.b,0.5)-gallery.outward*1.6+Vector3.UP*(cy_base+1.6)
	check("Courtyard inner gallery front open",ray(gallery_eye,gallery_eye+gallery.outward*2.5).is_empty())
	check("Courtyard inner gallery rear closed",not ray(gallery_eye,gallery_eye-gallery.outward*3).is_empty())
	check("Courtyard inner gallery overhead solid",not ray(gallery_eye,gallery_eye+Vector3.UP*2).is_empty())
	var link: Dictionary=courtyard.get_meta("west_mall_link")
	check("Courtyard link faces south to mapped West Mall parkade",link.end.z>link.start.z+10 and link.end.x<link.start.x)
	var link_mid: Vector3=(link.start+link.end)*0.5
	check("Courtyard link deck collision",not ray(link_mid+Vector3.UP,link_mid-Vector3.UP).is_empty())
	check("Courtyard link closed roof",not ray(link_mid+Vector3.UP*(link.height+1),link_mid+Vector3.UP*(link.height-0.3)).is_empty())
	var dining: Node3D=world.get_node("Buildings/DC")
	check("Dining retains distinct old and new exterior zones",dining.get_meta("exterior_zones").size()==2 and dining.get_meta("family_master")=="res://scripts/DiningExterior.gd")
	check("Dining three-level registry retained",dining.get_meta("floor_count")==3)
	var courtyard_tangent:=Vector3(11.686,0,-49.726).normalized()
	var courtyard_outward:=Vector3(courtyard_tangent.z,0,-courtyard_tangent.x)
	var table_point:=Vector3(255.533,0,109.004)+courtyard_tangent*16+ courtyard_outward*7
	table_point.y=Geo.elevation(table_point.x,table_point.z)
	var table_hit:=ray(table_point+Vector3.UP*1.5,table_point+Vector3.UP*0.6)
	check("Shell concrete tabletop solid at seating area",not table_hit.is_empty() and absf(table_hit.position.y-table_point.y-0.8)<0.02)
	var fence_point:=Vector3(255.533,0,109.004)+courtyard_tangent*30+courtyard_outward*3.2
	fence_point.y=Geo.elevation(fence_point.x,fence_point.z)+0.9
	check("Shell timber screen blocks capsule-height crossing",not ray(fence_point+courtyard_outward,fence_point-courtyard_outward).is_empty())
	var shell: Node3D=world.get_node("Buildings/SHR")
	check("Shell has distinct photo-based master",shell.get_meta("family_master")=="res://scripts/ShellExterior.gd")
	check("Shell official total four levels preserved",shell.get_meta("floor_count")==4)
	var annex_eye:=Vector3(255.533,0,109.004)+courtyard_tangent*8+courtyard_outward*3.95
	annex_eye.y=preload("res://scripts/TerrainController.gd").foundation("SHR")+1.4
	check("Shell annex front glazing closes residential space",not ray(annex_eye,annex_eye-courtyard_outward*1.2).is_empty())
	var annex_roof: Vector3=annex_eye-courtyard_outward*2.2
	check("Shell annex sloped roof collidable",not ray(annex_roof+Vector3.UP*3,annex_roof).is_empty())
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
		# Check both end corners as well as the middle: one midpoint ray missed
		# the exposed wall backs originally reported by the user.
		for fraction in [0.03,0.25,0.75,0.97]:
			var eye: Vector3=passage.gallery_start.lerp(passage.gallery_end,fraction)+Vector3.UP*1.68
			check(id+" gallery rear closure "+str(fraction),not ray(eye,eye+passage.axis*2.2).is_empty())
			check(id+" gallery soffit closure "+str(fraction),not ray(eye,eye+Vector3.UP*1.5).is_empty())
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
	# At both different-grade joins, test the seam on the left, middle and right.
	# Mid-gallery rays cannot detect small daylight slots at canopy interfaces.
	for pair in [["PJH","BRH"],["BRH","SBH"]]:
		var left: Dictionary=world.get_node("Buildings/"+pair[0]).get_meta("exterior_passage")
		var right: Dictionary=world.get_node("Buildings/"+pair[1]).get_meta("exterior_passage")
		for plan_and_end in [[left,left.gallery_end],[right,right.gallery_start]]:
			var plan: Dictionary=plan_and_end[0]
			var endpoint: Vector3=plan_and_end[1]
			for offset in [-1.6,0.0,1.6]:
				var eye: Vector3=endpoint+plan.axis*offset+Vector3.UP*1.68
				var hit:=ray(eye,eye+Vector3.UP*1.6)
				check(str(pair)+" canopy seam closed "+str(endpoint)+" offset "+str(offset),not hit.is_empty() and absf(hit.position.y-endpoint.y-2.9)<0.08)
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
	# Test terrain itself beneath the new mapped stair, not its raised treads.
	# Actual stair traversal is independently covered by the ascent/descent route.
	var stair_shapes: Array[RID]=[]
	for body in world.get_node("NorthParkingStair").find_children("*","StaticBody3D",true,false): stair_shapes.append(body.get_rid())
	for body in world.get_node("Props/EastWestRecreation").find_children("*","StaticBody3D",true,false): stair_shapes.append(body.get_rid())
	for body in world.get_node("Props/McTaggartApproach").find_children("*","StaticBody3D",true,false): stair_shapes.append(body.get_rid())
	var stair_start: Vector3=world.get_node("NorthParkingStair").get_meta("start")
	var stair_u: Vector3=world.get_node("NorthParkingStair").get_meta("direction")
	var stair_probe: Vector3=stair_start+stair_u*3
	var stair_hit:=ray(stair_probe+Vector3.UP*2,stair_probe-Vector3.UP*4)
	check("Mapped parking stair collision above underlying hillside",not stair_hit.is_empty() and stair_hit.position.y>Geo.elevation(stair_probe.x,stair_probe.z)+0.2)
	var terrain_matches:=0
	var terrain_samples:=0
	for road in world.roads:
		var p:=Geo.point(road.points[0])
		if world.inside_building(Vector2(p.x,p.z),1): continue
		var hit:=ray(p+Vector3.UP*0.5,p-Vector3.UP*0.5,stair_shapes)
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
	var portico: Dictionary=world.get_node("Buildings/CYR").get_meta("east_portico")
	var portico_points: Array=[]
	for item in [[0.3,2.0],[0.3,-1.8],[0.7,-1.8],[0.7,2.0]]:
		var p: Vector3=portico.a.lerp(portico.b,item[0])+portico.outward*item[1]
		portico_points.append([p.x,p.z])
	routes.append({"buildings":["Courtyard eastern portico entry crossing exit"],"points":portico_points})
	var gallery: Dictionary=world.get_node("Buildings/CYR").get_meta("court_gallery")
	var gallery_points: Array=[]
	for sample in [[0.2,1.2],[0.2,-1.6],[0.5,-1.6],[0.8,-1.6],[0.8,1.2]]:
		var p: Vector3=gallery.a.lerp(gallery.b,sample[0])+gallery.outward*sample[1]
		gallery_points.append([p.x,p.z])
	routes.append({"buildings":["Courtyard lower gallery entry crossing exit"],"points":gallery_points})
	var shelter: Dictionary=world.get_node("Props/Field4/SidelineContext").get_meta("shelter_17")
	var shelter_points: Array=[]
	for side in [5.0,3.0,0.4,3.0,5.0]:
		var p: Vector3=shelter.center+shelter.u*3+shelter.v*side
		shelter_points.append([p.x,p.z])
	routes.append({"buildings":["Field4 dark shelter entry and exit"],"points":shelter_points})
	var stair: Node3D=world.get_node("NorthDiningStair")
	var stair_start: Vector3=stair.get_meta("start")
	var stair_direction: Vector3=stair.get_meta("direction")
	var stair_points: Array=[]
	for distance in [-1.0,1.0,3.0,5.0,6.4,8.0,10.5,8.0,6.4,5.0,3.0,1.0,-1.0]:
		var p: Vector3=stair_start+stair_direction*distance
		stair_points.append([p.x,p.z])
	routes.append({"buildings":["North gallery to Dining stair ascent and descent"],"points":stair_points})
	var turn_points: Array=[]
	var stair_u: Vector3=stair.get_meta("direction")
	var stair_v:=Vector3(-stair_u.z,0,stair_u.x)
	for coordinate in [Vector2(-1,0),Vector2(8,0),Vector2(10.5,0),Vector2(11.1,0),Vector2(11.1,-1.4),Vector2(11.1,-2.6),Vector2(11.1,-1.4),Vector2(11.1,0),Vector2(10.5,0),Vector2(8,0),Vector2(-1,0)]:
		var p: Vector3=stair_start+stair_u*coordinate.x+stair_v*coordinate.y
		turn_points.append([p.x,p.z])
	routes.append({"buildings":["Dining mapped west door landing turn and return"],"points":turn_points})
	var parking_stair: Node3D=world.get_node("NorthParkingStair")
	var parking_points: Array=[]
	for distance in [-1.0,1.0,3.0,5.9,8.0,11.7,14.0,11.7,8.0,5.9,3.0,1.0,-1.0]:
		var p: Vector3=parking_stair.get_meta("start")+parking_stair.get_meta("direction")*distance
		parking_points.append([p.x,p.z])
	routes.append({"buildings":["Mapped North parking stair descent and return"],"points":parking_points})
	routes.append({"buildings":["Courtyard eastern paved forecourt"],"points":[[351,10],[352,-2],[347,-10],[348,-20],[352,-32],[348,-20],[347,-10],[352,-2],[351,10]]})
	var shell: Node3D=world.get_node("Buildings/SHR")
	var shell_door: Vector3=shell.get_meta("photo_main_entrance")
	var shell_normal: Vector3=shell.get_meta("photo_main_normal")
	var shell_points: Array=[]
	for offset in [7.0,5.0,3.0,1.0,3.0,5.0,7.0]:
		var p: Vector3=shell_door+shell_normal*offset
		shell_points.append([p.x,p.z])
	routes.append({"buildings":["Shell mapped main entrance approach and return"],"points":shell_points})
	var annex: Node3D=world.get_node("Props/ShellAnnexExterior")
	var annex_points: Array=[]
	for distance in [17.0,14.5,12.0,9.5,7.0,4.0,7.0,9.5,12.0,14.5,17.0]:
		var p: Vector3=annex.get_meta("origin")+annex.get_meta("along")*distance+annex.get_meta("outward")*3.95
		annex_points.append([p.x,p.z])
	routes.append({"buildings":["Shell exterior pergola walk and return"],"points":annex_points})
	var recreation_data: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/east_west_recreation.json"))
	var recreation_points: Array=[[104,52],[104.703,57.377]]
	for p in recreation_data.ramp:recreation_points.append(p)
	recreation_points.append_array([[96.789,63.303],[96.2,67],[95.106,70.131],[93.887,75.39],[96.68,76.002],[95.585,80.75],[94.424,86.098]])
	routes.append({"buildings":["East West court ramp picnic stair descent"],"points":recreation_points})
	var recreation_reverse: Array=recreation_points.duplicate();recreation_reverse.reverse()
	routes.append({"buildings":["East West recreation ascent"],"points":recreation_reverse})
	var mch_entry: Node3D=world.get_node("Props/McTaggartApproach")
	var mch_points: Array=[]
	var mch_door: Vector3=mch_entry.get_meta("door")
	var mch_n: Vector3=mch_entry.get_meta("normal")
	var mch_top: Vector3=mch_entry.get_meta("top")
	var mch_low: Vector3=mch_entry.get_meta("low")
	for q in [mch_entry.get_meta("approach"),mch_entry.get_meta("outer"),mch_top,mch_top.lerp(mch_low,0.5),mch_low,mch_door+mch_n*1.2,mch_low,mch_top.lerp(mch_low,0.5),mch_top,mch_entry.get_meta("outer"),mch_entry.get_meta("approach")]:mch_points.append([q.x,q.z])
	routes.append({"buildings":["McTaggart west connector descent and return"],"points":mch_points})
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



