extends SceneTree
func _initialize():
 var player=preload("res://scripts/PlayerController.gd").new()
 root.add_child(player)
 await process_frame
 player.release_pointer()
 await create_timer(4).timeout
 var ok: bool=player.raw_mouse.connected
 print("RAW_MOUSE_LOCALHOST_QA connected=",ok)
 quit(0 if ok else 1)
