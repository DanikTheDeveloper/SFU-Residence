extends SceneTree
func _initialize():
 var player=preload("res://scripts/PlayerController.gd").new()
 root.add_child(player)
 await process_frame
 player.position=Vector3(0,100,0)
 player.raw_mouse.connected=true
 player.raw_mouse.requested=true
 player.raw_mouse.movement_keys=1
 var start: Vector3=player.position
 for i in 30: await physics_frame
 var forward_ok: bool=player.position.z<start.z-1.0
 player.raw_mouse.movement_keys=8|16
 start=player.position
 for i in 30: await physics_frame
 var right_sprint_ok: bool=player.position.x>start.x+2.0
 player.release_pointer()
 for i in 30: await physics_frame
 var stop_ok: bool=absf(player.velocity.x)<0.01 and absf(player.velocity.z)<0.01 and player.raw_mouse.movement_keys==0
 player.raw_mouse.jump_requested=true
 var jump_ok: bool=player.raw_mouse.consume_jump() and not player.raw_mouse.consume_jump()
 print("HOST_MOVEMENT_QA forward=",forward_ok," sprint_right=",right_sprint_ok," release_stops=",stop_ok," jump_consumed_once=",jump_ok)
 quit(0 if forward_ok and right_sprint_ok and stop_ok and jump_ok else 1)
