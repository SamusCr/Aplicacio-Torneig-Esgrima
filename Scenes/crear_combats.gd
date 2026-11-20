extends CanvasLayer
class_name Pantalla_torneig

@export var tabla_participantes : VBoxContainer
@export var fase_final:CanvasLayer
@export var anim:ColorRect 
var grupo_tablas: Array[Taula_emparellar]
var jueces: GridContainer
var participant = preload("res://Scenes/participant.tscn")
var hay_empates: bool = false
var temp : bool =false
var num : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	if global.get_jueces()==4:
		jueces =$"CenterContainer/4Jugadores"
		
	else:
		$PantallaCombats/HBoxContainer/Grupo3.hide()
		$PantallaCombats/HBoxContainer/Grupo4.hide()
		jueces =$"CenterContainer2/2Jugadores"
		
	global.grupos_tablas = jueces.get_children()
	jueces.get_parent().show()
	$Timer.timeout.connect(anim_pamtalla)
	
	
func crear_tablas():
	var numero_grupo = 0
	var grupo_participantes =global.grupo_Participantes
	#crear les taules, enviar davant el judge per que siga sempre el primer de la taula
	for n in grupo_participantes:
		if n.grupo == 1:
		
			if n.es_juez == true:
				global.grupos_tablas[0].Grupo_Participantes.push_front(n)
			else:
				global.grupos_tablas[0].Grupo_Participantes.append(n)
		if n.grupo == 2:
			if n.es_juez == true:
				global.grupos_tablas[1].Grupo_Participantes.push_front(n)
			else:
				global.grupos_tablas[1].Grupo_Participantes.append(n)
		if global.grupos_tablas.size() !=2:
			if n.grupo == 3:
				if n.es_juez == true:
					global.grupos_tablas[2].Grupo_Participantes.push_front(n)
				else:
					global.grupos_tablas[2].Grupo_Participantes.append(n)
			if n.grupo == 4:
				if n.es_juez == true:
					global.grupos_tablas[3].Grupo_Participantes.push_front(n)
				else:
					global.grupos_tablas[3].Grupo_Participantes.append(n)

	#per petició de la sala, ordenar per a que els combats surtin en el mateix ordre que han aparegut en la pantalla eleccion de grupos
	for grupo in global.grupos_tablas:
		grupo.Grupo_Participantes.sort_custom(func orden(a,b): return a.orden_comabte<b.orden_comabte)
		grupo.crear_columna(grupo.Grupo_Participantes)

		
	global.grupo_Participantes= grupo_participantes

	$PantallaCombats/Button.show()
	jueces.show()
	_on_todos_pressed()


#botó per acabar partida
func _on_button_pressed():
	#reiniciar boolean de empates
	hay_empates = false
	#calcular punts de les taules
	for tabla in global.grupos_tablas:
		if tabla.is_in_group("Tabla"):
			for participante in tabla.Grupo_Participantes:
				tabla.calcular_puntos(participante)

			if tabla.caluclar_ganadores() == false:
				hay_empates = true
			else:
				global.grupo_Quartos.append(tabla.campeon)
				global.grupo_Quartos.append(tabla.subcampeon)
			
#si no hi ha empates anirem als quarts de finals
	if hay_empates == false:
		jueces.hide()
		global.acaba_fase.emit(get_node("."),fase_final)
		fase_final.CrearFinales(global.grupo_Quartos)
#en cas contrari eliminarem els que han anat a quarts
	else:
		global.grupo_Quartos.clear()
		
		


#boto per mostrar grupo 1
func _on_grupo_1_pressed():
	$Timer.stop()
	$CenterContainer.scale = Vector2(1,1)
	var tween2 = create_tween()
	tween2.tween_property(anim, "scale", Vector2(0,0),1)
	for n in global.grupos_tablas:
		n.hide()
	global.grupos_tablas[0].show()



#boto per mostrar grupo 2
func _on_grupo_2_pressed():
	$Timer.stop()
	$CenterContainer.scale = Vector2(1,1)
	var tween2 = create_tween()
	tween2.tween_property(anim, "scale", Vector2(0,0),1)
	for n in global.grupos_tablas:
		n.hide()
	global.grupos_tablas[1].show()

#boto per mostrar grupo 3
func _on_grupo_3_pressed():
	$Timer.stop()
	$CenterContainer.scale = Vector2(1,1)
	var tween2 = create_tween()
	tween2.tween_property(anim, "scale", Vector2(0,0),1)
	for n in global.grupos_tablas:
		n.hide()
	global.grupos_tablas[2].show()

#boto per mostrar grupo 4
func _on_grupo_4_pressed():
	$Timer.stop()
	$CenterContainer.scale = Vector2(1,1)
	var tween2 = create_tween()
	tween2.tween_property(anim, "scale", Vector2(0,0),1)
	for n in global.grupos_tablas:
		n.hide()
	global.grupos_tablas[3].show()

#boto per mostrar tots els grups
func _on_todos_pressed():
	$Timer.stop()
	if global.grupo_Participantes.size() > 24:
		$CenterContainer.scale = Vector2(0.85,0.85)
	if global.grupo_Participantes.size() > 28:
		$CenterContainer.scale = Vector2(0.75,0.75)
	if global.grupo_Participantes.size() > 32:
		$CenterContainer.scale = Vector2(0.65,0.65)
	if global.grupo_Participantes.size() > 36:
		$CenterContainer.scale = Vector2(0.55,0.55)
	if global.grupo_Participantes.size() > 40:
		$CenterContainer.scale = Vector2(0.50,0.50)
	if global.grupo_Participantes.size() > 52:
			$CenterContainer.scale = Vector2(0.40,0.40)
	var tween2 = create_tween()
	tween2.tween_property(anim, "scale", Vector2(0,0),1)
	for n in jueces.get_children():
		n.show()

#boto per a que vagin apareguent tots els grups 
func anim_pamtalla():
	var tween = create_tween()
	tween.tween_property(anim, "scale", Vector2(1,1),1)
	await tween.finished
	$CenterContainer.scale = Vector2(1,1)
	if num ==global.num_jueces+1:
		num = 1
	if num == 1:
		for n in global.grupos_tablas:
			n.hide()
		global.grupos_tablas[0].show()
	if num == 2:
		for n in global.grupos_tablas:
			n.hide()
		global.grupos_tablas[1].show()
		
	if num == 3:
		for n in global.grupos_tablas:
			n.hide()
		global.grupos_tablas[2].show()
		
	if num == 4:
		for n in global.grupos_tablas:
			n.hide()
		global.grupos_tablas[3].show()
	num = num +1
	var tween2 = create_tween()
	tween2.tween_property(anim, "scale", Vector2(0,0),1)


#petit loop per a que vagin passant els grups per pantalla
func _on_loop_pressed():
	anim_pamtalla()
	$Timer.start(5)

#boto test per crear una funcio que serveixi per 
func _on_button_test_pressed():
	global.actualizar_combate.emit(1,4,1,1)
