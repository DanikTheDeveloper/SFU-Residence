extends SceneTree
func _initialize():
 var geo=preload("res://scripts/Geometry.gd")
 for p in [[89,131],[151,147],[145,167],[126,194],[100,201],[69,196],[84,148],[110,170]]:
  print("FIELD_GRADE ",p," ",geo.elevation(p[0],p[1]))
 quit()
