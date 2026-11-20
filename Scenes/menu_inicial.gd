extends Control

@export var nombre_torneo:LineEdit 
@export var numero_jueces : OptionButton
@export var online: CheckButton


func _on_empezar_torneo_pressed():
	global.titulo = nombre_torneo.text.to_upper()
	global.num_jueces = numero_jueces.get_selected_id()
	get_tree().change_scene_to_packed(global.escenea_aplicacion)
	if online.button_pressed:
		_server_on()


func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		if $Menu.visible == false:
			$Menu.visible = true
		else:
			$Menu.visible = false
			

func _server_on():
	Network_Handler.start_server()
	Network_Handler.setBradCast(nombre_torneo.text)
	rpc("_enviar_texto","ha entrado un jugador")
	
