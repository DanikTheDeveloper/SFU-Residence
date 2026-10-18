extends SceneTree
func _initialize():
 var geo=preload("res://scripts/Geometry.gd")
 var terrain=preload("res://scripts/TerrainController.gd")
 var data=JSON.parse_string(FileAccess.get_file_as_string("res://data/buildings.json"))
 for building in data:
  if building.type!="townhouse": continue
  var base: float=terrain.foundation(building.id)-0.1
  var gap:=0.0
  var worst:=Vector2.ZERO
  var outward:=Vector2.ZERO
  var poly:=PackedVector2Array()
  for point in building.footprint: poly.append(Vector2(point[0],point[1]))
  if Geometry2D.is_polygon_clockwise(poly): poly.reverse()
  for i in poly.size():
   var a:=poly[i]
   var b:=poly[(i+1)%poly.size()]
   var edge: Vector2=b-a
   var normal:=Vector2(edge.y,-edge.x).normalized()
   for j in range(21):
    var p: Vector2=a.lerp(b,j/20.0)+normal*0.24
    if base-geo.elevation(p.x,p.y)>gap:
     gap=base-geo.elevation(p.x,p.y)
     worst=p
     outward=normal
  print("CONTACT_AUDIT ",building.id," max_facade_gap_m=",gap," worst=",worst," normal=",outward)
 quit()
