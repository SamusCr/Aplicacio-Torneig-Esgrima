extends Control

var integrantes : Array[Participant]=[]

var participant = preload("res://Scenes/participant.tscn")
@export var nom_participant: LineEdit 
@export var so_participant :AudioStream
@export var grup_participantesPar: VBoxContainer
@export var grup_participantesImpar: VBoxContainer
@export var eleccion_grupo: Eleccion_grupo

@export var pantalla_entrar_part: CanvasLayer
@export var pantalla_torneig: Pantalla_torneig
#HAS DE POSAR-TE EN FER QUE S'EMPLENEN ESTOS ARRAY I QUE TOT FUNCIONE A APRTIR D'AQUI
var grupo_1: Array[Participant]=[]
var grupo_2: Array[Participant]=[]
var grupo_3: Array[Participant]=[]
var grupo_4: Array[Participant]=[]

var grupos: Array[Array]=[grupo_1,grupo_2,grupo_3,grupo_4]

@export var titulo_label : Label 
#Classe principal, la idea es que estiga tot montat en aquesta rama a partir de les escenes. 
#Antoni es horrible, recorda que si vas a continuar amb aquesta idea, homogenitza
#Has de passar la vista de creació de particiapnts a una escena apart per poder homogentizar
#Sols deixar els metodes generics que poden gastar tots: Menu, pasar fase, etc
func _ready():
	titulo_label.text = global.titulo
	global.acaba_fase.connect(_pasar_fase)
	global.borrar_participante.connect(_borrar_jugador)
	global.crear_participante.connect(nuevo_participante)

#crear nou participant
func _on_button_pressed():
	if nom_participant.text != "":
		nuevo_participante(nom_participant.text)
	nom_participant.text = ""
	
#modificar un nom de participant
func _on_nom_participant_text_submitted(new_text):
	if nom_participant.text != "":
		nuevo_participante(nom_participant.text)
	nom_participant.text = ""

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		if $Menu.visible == false:
			$Menu.visible = true
		else:
			$Menu.visible = false
#anar a la pantalla de grup. S'asignaran de manera aletaoria a quin grup anira cada participant abans de fer apareixer el següent menu
func _on_button_pass_pressed():
	if global.grupo_Participantes.size() >= global.get_jueces()*2:
		crear_grupo()
		eleccion_grupo.mostrar_listado()
		global.acaba_fase.emit(pantalla_entrar_part,eleccion_grupo)

	
#crear nou participant i fer que aparega en un dels grups
func nuevo_participante(Nombre : String):
	if Nombre != null &&  global.grupo_Participantes.size()/global.num_jueces < 13:
		var participant_pre = participant.instantiate() as Participant
		participant_pre.actualizar_nombre_grupo(Nombre,str(integrantes.size()+1))
		integrantes.append(participant_pre)
		global.grupo_Participantes.append(participant_pre)

		if integrantes.size()%2:
			grup_participantesPar.add_child(participant_pre) 
		else:
			grup_participantesImpar.add_child(participant_pre) 
		return participant_pre
		
	else:
		print("No se ha podido añadir")
	
	nom_participant.text = ""
	
	
	

#asignar a cada participant no juez un grup
func crear_grupo():
	var numero_grupo = 1
	var grupo_participantes =global.grupo_Participantes
	var grupo_final:Array[Participant] =[]
	for n in grupo_participantes.size():
		if numero_grupo > global.get_jueces():
			numero_grupo = 1
		var participante_nuevo = grupo_participantes.pick_random() as Participant
		if participante_nuevo.es_juez ==false:
			grupo_participantes.erase(participante_nuevo)
			participante_nuevo.grupo = numero_grupo 
			grupo_final.append(participante_nuevo)
			numero_grupo = numero_grupo+1
		else:
			grupo_final.append(participante_nuevo)
			
		grupo_participantes.erase(participante_nuevo)
	global.grupo_Participantes = grupo_final 




	
func _borrar_jugador(paticipante_eliminar:Participant):
	for n in global.grupo_Participantes.size():
		if global.grupo_Participantes[n-1] == paticipante_eliminar:
			global.grupo_Participantes.erase(paticipante_eliminar)
			
			

#funciona que deuría de mantenir en la pantalla principal
#aquesta es
func _pasar_fase(Actual_Fase: CanvasLayer , Next_fase :CanvasLayer ):
	Actual_Fase.hide()
	Next_fase.show()
	
