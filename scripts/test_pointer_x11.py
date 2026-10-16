"""Inject relative X11 test motion into our explicitly named QA window only."""
import ctypes as C,time,json
from pathlib import Path
x=C.CDLL('libX11.so.6');t=C.CDLL('libXtst.so.6')
x.XOpenDisplay.restype=C.c_void_p;d=x.XOpenDisplay(None);assert d
x.XDefaultRootWindow.argtypes=[C.c_void_p];x.XDefaultRootWindow.restype=C.c_ulong
x.XQueryTree.argtypes=[C.c_void_p,C.c_ulong,C.POINTER(C.c_ulong),C.POINTER(C.c_ulong),C.POINTER(C.POINTER(C.c_ulong)),C.POINTER(C.c_uint)]
x.XFetchName.argtypes=[C.c_void_p,C.c_ulong,C.POINTER(C.c_char_p)]
x.XFree.argtypes=[C.c_void_p]
x.XSetInputFocus.argtypes=[C.c_void_p,C.c_ulong,C.c_int,C.c_ulong]
x.XRaiseWindow.argtypes=[C.c_void_p,C.c_ulong];x.XFlush.argtypes=[C.c_void_p]
t.XTestFakeRelativeMotionEvent.argtypes=[C.c_void_p,C.c_int,C.c_int,C.c_ulong]
def find(w,depth=0):
 name=C.c_char_p()
 if x.XFetchName(d,w,C.byref(name)) and name.value:
  title=name.value.decode(errors='replace');x.XFree(name)
  if title=='SFU Pointer QA':return w
 if depth>4:return
 root=C.c_ulong();parent=C.c_ulong();children=C.POINTER(C.c_ulong)();n=C.c_uint()
 if x.XQueryTree(d,w,C.byref(root),C.byref(parent),C.byref(children),C.byref(n)):
  ids=[children[i] for i in range(n.value)]
  if children:x.XFree(children)
  for c in ids:
   result=find(c,depth+1)
   if result:return result
for attempt in range(30):
 win=find(x.XDefaultRootWindow(d))
 if win:break
 time.sleep(.3)
assert win,'QA window missing; no input injected'
x.XRaiseWindow(d,win);x.XSetInputFocus(d,win,1,0);x.XFlush(d);time.sleep(.4)
for i in range(160):
 t.XTestFakeRelativeMotionEvent(d,40,0,0);x.XFlush(d);time.sleep(.025)
print('Injected 6400 physical X11 pixels into dedicated QA window; expected ~16 radians yaw.')
