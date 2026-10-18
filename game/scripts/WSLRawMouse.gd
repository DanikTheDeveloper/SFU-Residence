extends Node
# Local Windows raw-input adapter for WSLg. Gameplay remains Linux GDScript.
var player: CharacterBody3D
var server:=TCPServer.new()
var peer: StreamPeerTCP
var authenticated:=false
var token: String
var buffer:=""
var last_packet:=0
var last_send:=0
var revision:=0
var requested:=false
var connected:=false
var helper_pid:=-1

func start(owner_player: CharacterBody3D) -> void:
 player=owner_player
 var python:=OS.get_environment("SFU_WINDOWS_PYTHON")
 if python.is_empty() or DisplayServer.get_name()=="headless": return
 for arg in OS.get_cmdline_user_args():
  if arg.begins_with("--capture") or arg in ["--verify","--pointer-qa"]: return
 if server.listen(0,"127.0.0.1")!=OK: return
 token="SFU-"+Crypto.new().generate_random_bytes(8).hex_encode()
 var output: Array=[]
 var path:=ProjectSettings.globalize_path("res://../scripts/wsl_raw_mouse.py")
 if OS.execute("wslpath",["-w",path],output)!=0:
  server.stop()
  return
 DisplayServer.window_set_title("SFU Residences | "+token)
 helper_pid=OS.create_process(python,[str(output[0]).strip_edges(),str(server.get_local_port()),token])
 if helper_pid<0: server.stop()
 else: print("MOUSE_BRIDGE_START localhost port=",server.get_local_port())

func capture(value: bool) -> void:
 requested=value
 revision+=1
 send_state()

func send_state() -> void:
 if not authenticated: return
 var message:=JSON.stringify({"capture":requested,"revision":revision})+"\n"
 peer.put_data(message.to_utf8_buffer())
 last_send=Time.get_ticks_msec()

func _process(_delta: float) -> void:
 if not server.is_listening(): return
 if peer==null and server.is_connection_available():
  peer=server.take_connection()
  peer.set_no_delay(true)
  last_packet=Time.get_ticks_msec()
 if peer==null: return
 peer.poll()
 if peer.get_status()!=StreamPeerTCP.STATUS_CONNECTED:
  stop_bridge()
  return
 var available:=peer.get_available_bytes()
 if available>0:
  buffer+=peer.get_utf8_string(available)
  if buffer.length()>65536:
   stop_bridge()
   return
  while buffer.contains("\n"):
   var newline:=buffer.find("\n")
   var packet=JSON.parse_string(buffer.substr(0,newline))
   buffer=buffer.substr(newline+1)
   if not packet is Dictionary: continue
   if not authenticated:
    if packet.get("hello","")!=token:
     stop_bridge()
     return
    authenticated=true
    connected=true
    requested=Input.mouse_mode==Input.MOUSE_MODE_CAPTURED
    revision+=1
    Input.mouse_mode=Input.MOUSE_MODE_HIDDEN if requested else Input.MOUSE_MODE_VISIBLE
    print("MOUSE_BRIDGE_CONNECTED Win32 relative counts; click game to capture")
    send_state()
   elif requested and player.enabled and bool(packet.get("active",false)):
    player.apply_look(Vector2(float(packet.get("dx",0)),float(packet.get("dy",0))))
   last_packet=Time.get_ticks_msec()
 if Time.get_ticks_msec()-last_packet>1500:
  stop_bridge()
 elif Time.get_ticks_msec()-last_send>100: send_state()

func stop_bridge() -> void:
 if peer!=null: peer.disconnect_from_host()
 server.stop()
 authenticated=false
 connected=false
 requested=false
 Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
 print("MOUSE_BRIDGE_STOPPED cursor released; native capture available on click")

func _exit_tree() -> void:
 if peer!=null: peer.disconnect_from_host()
 server.stop()
