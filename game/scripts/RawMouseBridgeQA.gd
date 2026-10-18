extends SceneTree
func _initialize():
 var player=preload("res://scripts/PlayerController.gd").new()
 root.add_child(player)
 await process_frame
 player.release_pointer()
 await create_timer(2).timeout
 # Simulate a slow first rendered frame: helper must release but stay alive.
 OS.delay_msec(1800)
 await create_timer(2).timeout
 var ok: bool=player.raw_mouse.connected
 print("RAW_MOUSE_LOCALHOST_QA connected=",ok)
 quit(0 if ok else 1)
