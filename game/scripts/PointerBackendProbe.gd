extends SceneTree
func _initialize():
 for i in DisplayServer.get_screen_count():
  print("SCREEN ",i," pos=",DisplayServer.screen_get_position(i)," size=",DisplayServer.screen_get_size(i)," primary=",DisplayServer.get_primary_screen())
 DisplayServer.window_set_title("SFU-Title-Probe-4382")
 await create_timer(35).timeout
 quit()
