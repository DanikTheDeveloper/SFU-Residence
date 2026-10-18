extends RefCounted
const Geo=preload("res://scripts/Geometry.gd")

static func build(root: Node3D,points: Array,base: float) -> void:
 var vertices:=PackedVector3Array()
 var maximum_gap:=0.0
 # Follow actual terrain below the projecting stone plinth, not a global Y shift.
 for i in points.size():
  var a:=Vector3(points[i][0],base,points[i][1])
  var q: Array=points[(i+1)%points.size()]
  var b:=Vector3(q[0],base,q[1])
  var normal:=Vector3.UP.cross(b-a).normalized()
  var count:=maxi(1,int(ceil(a.distance_to(b)/0.25)))
  for j in count:
   var left: Vector3=a.lerp(b,float(j)/count)+normal*0.235
   var right: Vector3=a.lerp(b,float(j+1)/count)+normal*0.235
   var low_left:=Vector3(left.x,minf(base-0.06,Geo.elevation(left.x,left.z)-0.08),left.z)
   var low_right:=Vector3(right.x,minf(base-0.06,Geo.elevation(right.x,right.z)-0.08),right.z)
   maximum_gap=maxf(maximum_gap,maxf(base-low_left.y,base-low_right.y)-0.08)
   left.y=base+0.12
   right.y=base+0.12
   vertices.append_array([low_left,right,low_right,low_left,left,right])
 var material:=Geo.material(Color("777566"),0.95)
 var skirt:=Geo.mesh_from_vertices(root,vertices,material,true)
 skirt.name="TerrainContactPlinth"
 root.set_meta("contact_gap_closed_m",maximum_gap)
 # Existing porch footing locations come from the approved townhouse master.
 var feet: MultiMeshInstance3D=root.get_node("TownhouseStone")
 var supports: Array[Transform3D]=[]
 for i in feet.multimesh.instance_count:
  var transform:=feet.multimesh.get_instance_transform(i)
  var size:=transform.basis.get_scale()
  if size.x>0.5 or size.z>0.5: continue
  var bottom: float=transform.origin.y-size.y*0.5
  var ground: float=Geo.elevation(transform.origin.x,transform.origin.z)-0.08
  if bottom-ground<0.09: continue
  var support:=transform
  support.origin.y=(bottom+ground)*0.5
  support.basis=transform.basis.orthonormalized().scaled_local(Vector3(size.x,bottom-ground+0.02,size.z))
  supports.append(support)
 Geo.instances(root,supports,material,null,380).name="PorchFootingExtensions"
