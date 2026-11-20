extends CanvasLayer
class_name Eleccion_grupo
var participant = preload("res://Scenes/participant.tscn")
var grupo = preload("res://Scenes/grupo.tscn")

@export var tabla_par : VBoxContainer
@export var tabla_imp : VBoxContainer
@export var grupo_1: Grupo
@export var grupo_2: Grupo
@export var grupo_3: Grupo
@export var grupo_4: Grupo
@export var next_fase : CanvasLayer

var Canvas_jueces: Array[Grupo]

var participantes_grupo: Array[Participant] =[]



#vore si son 2 o 4 judges
func _ready():
	global.jueces_selecionados.connect(seleccionar_juces)
	if global.get_jueces() == 4:
		Canvas_jueces.append($"4 grupos/Grupo_1")
		Canvas_jueces.append($"4 grupos/Grupo_2")
		Canvas_jueces.append($"4 grupos/Grupo_3")
		Canvas_jueces.append($"4 grupos/Grupo_4")

	if global.get_jueces() == 2:
		Canvas_jueces.append($"2 grupos2/Grupo_1")
		Canvas_jueces.append($"2 grupos2/Grupo_2")

		
		

func mostrar_listado():
#Crear el listado lateral de los grupos 
	for participante in global.grupo_Participantes:
		if participante.es_juez==false:
			var nuevo_part =participant.instantiate() as Participant
			if int(participante.numero)%2 == 0:
				nuevo_part.eliminar_botones()
				nuevo_part.actualizar_nombre_grupo(participante.nombre,participante.numero)
				nuevo_part.grupo = participante.grupo
				tabla_imp.add_child(nuevo_part)
			else:
				nuevo_part.eliminar_botones()
				nuevo_part.actualizar_nombre_grupo(participante.nombre,participante.numero)			
				nuevo_part.grupo = participante.grupo
				tabla_par.add_child(nuevo_part)
			participantes_grupo.append(nuevo_part)
		else:
			var nuevo_juez =participant.instantiate() as Participant
			nuevo_juez.eliminar_botones()
			nuevo_juez.actualizar_nombre_grupo(participante.nombre,participante.numero)

	if global.get_jueces() == 4:
		$"4 grupos".show()
	if global.get_jueces() == 2:
		$"2 grupos2".show()

	



#actualitzem els noms per si hi han modificacions
func _on_button_empezar_pressed():
	for part in participantes_grupo:
		for n in global.grupo_Participantes:
			if part.numero == n.numero:
				n.actualizar_nombre_grupo(part.nombre,n.numero)
	
	Rpc._empezar_combates.rpc()
	next_fase.crear_tablas()
	$"2 grupos2".hide()
	$"4 grupos".hide()
	global.acaba_fase.emit(self, next_fase)

#començar la creació de grups amb una petita animació
func _on_button_grupos_pressed():
	
	if global.get_jueces() ==4:
		$"4 grupos/ButtonGrupos".hide()
	if global.get_jueces() ==2:
		$"2 grupos2/ButtonGrupos".hide()

	var part :Array[Participant]
	part.append_array(participantes_grupo)
	
	
	for n in part.size():
		var participant = part.pick_random()

		match participant.grupo:
			1:
				await Canvas_jueces[0].mover_part_grupo (part,participant)
			2:
				await Canvas_jueces[1].mover_part_grupo (part,participant)
			3:
				await Canvas_jueces[2].mover_part_grupo (part,participant)
			4:
				await Canvas_jueces[3].mover_part_grupo (part,participant)
		
		for x in global.grupo_Participantes:
			if x.numero == participant.numero:
				x.orden_comabte = n+1

		part.erase(participant)
		
	if global.get_jueces() ==4:
		$"4 grupos/ButtonEmpezar".show()
	if global.get_jueces() ==2:
		$"2 grupos2/ButtonEmpezar".show()
	
#fem diferen la selecció dels judges perque son els primers que apareixeran, abans de fer la selecció
func seleccionar_juces (jueces: Array[Participant]):

	var n = 0	
	for grupo in Canvas_jueces:
		var nuevo_juez =participant.instantiate() as Participant
		nuevo_juez.eliminar_botones()
		nuevo_juez.actualizar_nombre_grupo(jueces[n].nombre,jueces[n].numero)
		grupo.nombre_Juez(jueces[n].nombre)
		grupo.get_child(1).add_child(nuevo_juez)
		n = n+1
