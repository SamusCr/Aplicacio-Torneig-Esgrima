extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_salir_pressed():
	get_tree().quit()


func _on_reiniciar_pressed():
	global.reset_participantes()
	get_tree().reload_current_scene()


func _on_menu_principal_pressed():
	global.reset_participantes()
	get_tree().change_scene_to_packed(global.scena_menu_prin)
