"""WSLg mouse bridge: Win32 relative mouse counts for one foreground game window.
No installation, keyboard hook, persistent service or external network connection.
Only localhost TCP; closes on parent disconnect. Esc/focus loss release clipping.
"""
import ctypes as C
from ctypes import wintypes as W
import json, socket, sys, time
from pathlib import Path
if not any(arg in sys.argv for arg in ["--self-test","--inspect"]):
 log_path=Path(__file__).resolve().parent.parent/"game/docs/raw_mouse_host.log"
 sys.stdout=sys.stderr=open(log_path,"w",buffering=1,encoding="utf-8")
 print("Host raw mouse starting",flush=True)

u=C.WinDLL('user32',use_last_error=True)
k=C.WinDLL('kernel32',use_last_error=True)
LRESULT=C.c_ssize_t
WNDPROC=C.WINFUNCTYPE(LRESULT,W.HWND,W.UINT,W.WPARAM,W.LPARAM)
class WC(C.Structure):
 _fields_=[('style',W.UINT),('proc',WNDPROC),('cls_extra',C.c_int),('wnd_extra',C.c_int),('instance',W.HINSTANCE),('icon',W.HICON),('cursor',W.HANDLE),('brush',W.HBRUSH),('menu',W.LPCWSTR),('name',W.LPCWSTR)]
class RID(C.Structure):
 _fields_=[('page',W.USHORT),('usage',W.USHORT),('flags',W.DWORD),('target',W.HWND)]
class HEADER(C.Structure):
 _fields_=[('kind',W.DWORD),('size',W.DWORD),('device',W.HANDLE),('param',W.WPARAM)]
class MOUSE(C.Structure):
 _fields_=[('flags',W.USHORT),('buttons',W.ULONG),('raw_buttons',W.ULONG),('dx',W.LONG),('dy',W.LONG),('extra',W.ULONG)]
class RAW(C.Structure):
 _fields_=[('header',HEADER),('mouse',MOUSE)]

def api(name,args,result):
 f=getattr(u,name); f.argtypes=args; f.restype=result; return f
api('DefWindowProcW',[W.HWND,W.UINT,W.WPARAM,W.LPARAM],LRESULT)
api('RegisterClassW',[C.POINTER(WC)],W.ATOM)
api('CreateWindowExW',[W.DWORD,W.LPCWSTR,W.LPCWSTR,W.DWORD,C.c_int,C.c_int,C.c_int,C.c_int,W.HWND,W.HMENU,W.HINSTANCE,W.LPVOID],W.HWND)
api('RegisterRawInputDevices',[C.POINTER(RID),W.UINT,W.UINT],W.BOOL)
api('GetRawInputData',[W.HANDLE,W.UINT,W.LPVOID,C.POINTER(W.UINT),W.UINT],W.UINT)
api('GetForegroundWindow',[],W.HWND)
api('GetWindowTextW',[W.HWND,W.LPWSTR,C.c_int],C.c_int)
api('GetClientRect',[W.HWND,C.POINTER(W.RECT)],W.BOOL)
api('ClientToScreen',[W.HWND,C.POINTER(W.POINT)],W.BOOL)
api('ClipCursor',[C.POINTER(W.RECT)],W.BOOL)
api('GetAsyncKeyState',[C.c_int],W.SHORT)
api('PeekMessageW',[C.POINTER(W.MSG),W.HWND,W.UINT,W.UINT,W.UINT],W.BOOL)
api('TranslateMessage',[C.POINTER(W.MSG)],W.BOOL)
api('DispatchMessageW',[C.POINTER(W.MSG)],LRESULT)
api('DestroyWindow',[W.HWND],W.BOOL)
k.GetModuleHandleW.argtypes=[W.LPCWSTR];k.GetModuleHandleW.restype=W.HMODULE
try:
 api('SetProcessDpiAwarenessContext',[W.HANDLE],W.BOOL)(W.HANDLE(-4))
except AttributeError: pass

if '--inspect' in sys.argv:
 ENUM=C.WINFUNCTYPE(W.BOOL,W.HWND,W.LPARAM)
 @ENUM
 def inspect_window(handle,param):
  title=C.create_unicode_buffer(512);u.GetWindowTextW(handle,title,512)
  if 'SFU' in title.value or 'Godot' in title.value:
   print('WINDOW',int(handle),repr(title.value),flush=True)
  return True
 api('EnumWindows',[ENUM,W.LPARAM],W.BOOL)(inspect_window,0)
 class MI(C.Structure):
  _fields_=[('size',W.DWORD),('monitor',W.RECT),('work',W.RECT),('flags',W.DWORD)]
 MON=C.WINFUNCTYPE(W.BOOL,W.HANDLE,W.HDC,C.POINTER(W.RECT),W.LPARAM)
 api('GetMonitorInfoW',[W.HANDLE,C.POINTER(MI)],W.BOOL)
 @MON
 def inspect_monitor(handle,hdc,rect,param):
  info=MI();info.size=C.sizeof(info);u.GetMonitorInfoW(handle,C.byref(info))
  print('MONITOR',list((info.monitor.left,info.monitor.top,info.monitor.right,info.monitor.bottom)),'primary',bool(info.flags&1),flush=True)
  return True
 api('EnumDisplayMonitors',[W.HDC,C.POINTER(W.RECT),MON,W.LPARAM],W.BOOL)(None,None,inspect_monitor,0)
 sys.exit(0)

# Self-test checks native ABI and registration without capturing the pointer.
self_test='--self-test' in sys.argv
active=False; dx=dy=0
@WNDPROC
def proc(hwnd,msg,wp,lp):
 global dx,dy
 if msg==0x00FF and active:
  raw=RAW(); size=W.UINT(C.sizeof(raw))
  n=u.GetRawInputData(W.HANDLE(lp),0x10000003,C.byref(raw),C.byref(size),C.sizeof(HEADER))
  if n!=0xFFFFFFFF and raw.header.kind==0 and not raw.mouse.flags&1:
   dx+=raw.mouse.dx;dy+=raw.mouse.dy
 return u.DefWindowProcW(hwnd,msg,wp,lp)

instance=k.GetModuleHandleW(None)
cls=WC();cls.proc=proc;cls.instance=instance;cls.name='SFURawMouse_'+str(__import__('os').getpid())
assert u.RegisterClassW(C.byref(cls)),C.get_last_error()
hwnd=u.CreateWindowExW(0,cls.name,cls.name,0,0,0,0,0,W.HWND(-3),None,instance,None)
assert hwnd,C.get_last_error()
rid=RID(1,2,0x100,hwnd)
assert u.RegisterRawInputDevices(C.byref(rid),1,C.sizeof(rid)),C.get_last_error()
if self_test:
 assert C.sizeof(HEADER)==24 and C.sizeof(MOUSE)==24 and MOUSE.dx.offset==12
 u.DestroyWindow(hwnd)
 print('PASS Win32 raw mouse ABI, hidden window, device registration; no capture requested')
 sys.exit(0)

port=int(sys.argv[1]);token=sys.argv[2]
fullscreen=len(sys.argv)>3 and sys.argv[3]=='fullscreen'
api('SetWindowPos',[W.HWND,W.HWND,C.c_int,C.c_int,C.c_int,C.c_int,W.UINT],W.BOOL)
class MONITORINFO(C.Structure):
 _fields_=[('size',W.DWORD),('monitor',W.RECT),('work',W.RECT),('flags',W.DWORD)]
api('MonitorFromPoint',[W.POINT,W.DWORD],W.HANDLE)
api('GetMonitorInfoW',[W.HANDLE,C.POINTER(MONITORINFO)],W.BOOL)
placed=False
sock=None
for attempt in range(60):
 try:
  sock=socket.create_connection(('127.0.0.1',port),.5);break
 except OSError:time.sleep(.1)
if sock is None:sys.exit(2)
sock.setsockopt(socket.IPPROTO_TCP,socket.TCP_NODELAY,1)
sock.setblocking(False)
sock.sendall((json.dumps({'hello':token})+'\n').encode())
print("Localhost connected",flush=True)
buffer=b'';last_command=time.monotonic();last_send=0;armed=False;revision=-1;clipped=False
try:
 while True:
  now=time.monotonic()
  try:
   data=sock.recv(8192)
   if not data:break
   buffer+=data
   if len(buffer)>65536:break
   while b'\n' in buffer:
    line,buffer=buffer.split(b'\n',1);command=json.loads(line)
    last_command=now
    if command.get('quit'):raise SystemExit
    if command.get('revision')!=revision:
     revision=command.get('revision');armed=bool(command.get('capture'))
    if not command.get('capture'):armed=False
  except BlockingIOError:pass
  if now-last_command>1.0:
   # Release promptly during a stalled frame, but allow shader/startup stalls
   # to recover without silently killing the helper.
   armed=False
  if now-last_command>30.0:break
  foreground=u.GetForegroundWindow();title=C.create_unicode_buffer(512)
  u.GetWindowTextW(foreground,title,512)
  # WSLg Wayland ignores title changes after initial window creation on this
  # installed version. Accept its immutable project title, not arbitrary paths.
  matches=token in title.value or title.value.startswith('SFU Residences | Burnaby')
  if matches and armed and not placed:
   monitor=u.MonitorFromPoint(W.POINT(0,0),1)
   info=MONITORINFO();info.size=C.sizeof(info)
   if u.GetMonitorInfoW(monitor,C.byref(info)):
    r=info.monitor
    if fullscreen:
     success=u.SetWindowPos(foreground,None,r.left,r.top,r.right-r.left,r.bottom-r.top,0x14)
    else:
     success=u.SetWindowPos(foreground,None,r.left+80,r.top+80,0,0,0x15)
    print('Primary monitor placement',bool(success),'fullscreen',fullscreen,flush=True)
   placed=True
  if not matches or u.GetAsyncKeyState(0x1B)&0x8000:armed=False
  previous_active=active
  active=armed and matches
  if active!=previous_active:print("Capture",active,"foreground_match",matches,flush=True)
  if active:
   rect=W.RECT();point=W.POINT()
   if u.GetClientRect(foreground,C.byref(rect)):
    point.x=(rect.right-rect.left)//2;point.y=(rect.bottom-rect.top)//2
    if u.ClientToScreen(foreground,C.byref(point)):
     clip=W.RECT(point.x,point.y,point.x+1,point.y+1)
     clipped=bool(u.ClipCursor(C.byref(clip)))
     active=active and clipped
  elif clipped:
   u.ClipCursor(None);clipped=False
  msg=W.MSG()
  while u.PeekMessageW(C.byref(msg),None,0,0,1):
   u.TranslateMessage(C.byref(msg));u.DispatchMessageW(C.byref(msg))
  if now-last_send>.008:
   keys=sum((1<<i) for i,key in enumerate([0x57,0x41,0x53,0x44,0x10,0x20]) if active and u.GetAsyncKeyState(key)&0x8000)
   sock.sendall((json.dumps({'dx':dx,'dy':dy,'active':active,'keys':keys})+'\n').encode())
   dx=dy=0;last_send=now
  time.sleep(.002)
finally:
 print("Host raw mouse stopping; release cursor",flush=True)
 if clipped:u.ClipCursor(None)
 u.DestroyWindow(hwnd)
 sock.close()
