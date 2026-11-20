extends Node

func shake(thing: Button, strenght: float, orig_pos: Vector2, duration:float=0.2)->void:
	if not thing:
		return

	var shake_count=10
	var tween1=create_tween()
	
	for i in shake_count:
		var shake_offset= Vector2(randf_range(-1.0,1.0), randf_range(-1.0,1.0))
		var target= orig_pos+strenght*shake_offset
		if i %2==0:
			target=orig_pos
		tween1.tween_property(thing, "global_position",target, duration/float(shake_count))	
		strenght*=0.75
	await tween1.finished
	tween1.finished.connect(func(): if thing != null: thing.set_global_position(orig_pos) )
	 
