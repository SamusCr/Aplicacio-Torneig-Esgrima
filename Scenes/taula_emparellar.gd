extends CenterContainer
class_name Taula_emparellar

@export var Grupo_Participantes : Array[Participant]
@export var campeon: Participant
@export var subcampeon : Participant
@export var columna_participantes: VBoxContainer
@export var fila_contrincantes: HBoxContainer
@export var tabla_combates : GridContainer
#Utilitze la casella buida com ha modelo de la configuracio de les caselles del nom participants/contricants
@export var modelo_gradilla_Nombre: Label
@export var puntauciones_victoria: VBoxContainer
@export var puntauciones_contra : VBoxContainer



var main_theme = preload("res://assets/MinimalUI/MinimalUI.tres")
var casillas  = preload("res://Scenes/casila_tabla.tscn")
var puntuacion = preload("res://Scenes/puntuacion.tscn")
var sprite_espadas  = preload("res://assets/Icono_EspadasCruzadas.jpg")
var size_casillas: Vector2= Vector2(70,60)
var empates: bool = false
var ganadores : Array[Participant]
var combates : Array[Casilla]


func crear_columna(grupo_Participantes : Array[Participant]):
	var numer= 1
	Grupo_Participantes = grupo_Participantes
	#Netejar la taula de participants
	for n in tabla_combates.get_children():
		n.queue_free()
	for n in fila_contrincantes.get_children():
		n.queue_free()
	for n in columna_participantes.get_children():
		n.queue_free()
	for n in puntauciones_contra.get_children():
		n.queue_free()
	for n in puntauciones_victoria.get_children():
		n.queue_free()
	#Fer columenes en la taula igual al numero de participants
	tabla_combates.columns = grupo_Participantes.size()
	
	#Funcio per ordenar i posar en primer lloc el Jutge en el llistat
	grupo_Participantes.sort_custom(func(a_obj :Participant):
		if a_obj.es_juez == false: return false
		else: return true)
	var np : int = 1
	
#creació de la propia taula, anar afegint participants al grid de combates
	for participantes in grupo_Participantes:
		var nombre_columna = modelo_gradilla_Nombre.duplicate()
		nombre_columna.theme = main_theme
		nombre_columna.text=participantes.nombre +" "+ str(np)
		
		numer = numer +1
		columna_participantes.add_child(nombre_columna)

	
		var nombre_fila = modelo_gradilla_Nombre.duplicate()
		nombre_fila.theme = main_theme
		nombre_fila.text = str(np)
		fila_contrincantes.add_child(nombre_fila)
	
		for n in grupo_Participantes:
			
			var combate : Casilla = casillas.instantiate() as Casilla
			combate.taula = $"."
			combate.id = numer
			combate.combtatiente = participantes
			combate.contrincante  = n
			tabla_combates.add_child(combate)
			combates.append(combate)
			if n.numero == participantes.numero:
				combate._desactivar_casilla()

				
#columnes de puntaucions
		var puntuacion_contra = puntuacion.instantiate()
		puntuacion_contra.participante = participantes
		puntauciones_contra.add_child(puntuacion_contra)
		
		var puntuacion_victoria = puntuacion.instantiate()
		puntuacion_victoria.participante = participantes
		puntauciones_victoria.add_child(puntuacion_victoria)

		
		
		numer = numer+1
		np= np+1

	
	var nombre_Contra= modelo_gradilla_Nombre.duplicate()
	nombre_Contra.theme = main_theme
	nombre_Contra.text="V"
	fila_contrincantes.add_child(nombre_Contra)
	
	var nombre_Vicotria= modelo_gradilla_Nombre.duplicate()
	nombre_Vicotria.theme = main_theme
	nombre_Vicotria.text="C"
	fila_contrincantes.add_child(nombre_Vicotria)
	
	get_child(0).add_child(puntauciones_victoria)
	get_child(0).add_child(puntauciones_contra)

		
#calcular els punts en contra i a favor d'un jugador
func calcular_puntos(participante : Participant):
	participante.puntos_vicotria = 0
	participante.puntos_contra = 0
	var nombre_combatiente : String = ""
	var combatiente
	
	for fila in tabla_combates.get_children():
		
		if fila.combtatiente.numero  == participante.numero && (fila.text =="v"||fila.text =="V"):
			participante.puntos_vicotria +=1

		if fila.contrincante.numero  == participante.numero && (fila.text !="v"||fila.text !="V"):
			if fila.text == "" || fila.text == "0":
				participante.puntos_contra = participante.puntos_contra +0
			else:
				participante.puntos_contra = participante.puntos_contra + int(fila.text)
			
		if fila.contrincante.numero == participante.numero && (fila.text =="v"||fila.text =="V") :
			participante.puntos_contra = participante.puntos_contra+  3
			
	for n in puntauciones_victoria.get_children():
		if n.has_method("actualizar_puntuacion"):
			if n.participante == participante:
				n.actualizar_puntuacion(participante.puntos_vicotria)
	for n in puntauciones_contra.get_children():
		if n.has_method("actualizar_puntuacion"):
			if n.participante == participante:
				n.actualizar_puntuacion(participante.puntos_contra)
	print("La puntuación de victor es "+ participante.nombre+ " es " +str(participante.puntos_vicotria) +" i la puntuacion en contra es "+str(participante.puntos_contra))
	

func caluclar_ganadores()->bool:
	var empatados : Array[Participant]

	Grupo_Participantes.sort_custom(func(a_obj :Participant, b_obj:Participant):
		# Primero ordenem pels punts de victoria cada participant, qui mes V mes amunt
		if a_obj.puntos_vicotria != b_obj.puntos_vicotria:
			if a_obj.puntos_vicotria > b_obj.puntos_vicotria:
				return true
			else:
				return false
		# Encas de V igual, passara avant qui tinga menys punts en contra
		else:
			if a_obj.puntos_contra < b_obj.puntos_contra:
				return true
			else:
				return false
	)

	for participante in Grupo_Participantes:
		if participante != Grupo_Participantes[1]:
			if participante.puntos_contra == Grupo_Participantes[1].puntos_contra && participante.puntos_vicotria == Grupo_Participantes[1].puntos_vicotria:
				empatados.append(participante)
		
	if empatados.size()>0:
		#Si  hi ha 2 participants en empat en empat i un es el guanyador, vol dir que el campeo i subcampeo han quedat empat 
		if (empatados[0] == Grupo_Participantes[0] && empatados.size()==1) && campeon == null:
			campeon = Grupo_Participantes[0]
			subcampeon = Grupo_Participantes[1]
			return true
		empates = true
		campeon = Grupo_Participantes[0]
		empatados.append(Grupo_Participantes[1])
		crear_columna(empatados)
		$VBoxContainer/Label2.show()
		return false
		
	else:
		if empates == true:
			empates = false
			subcampeon = Grupo_Participantes[0]
			return true
		else:
			campeon = Grupo_Participantes[0]
			subcampeon = Grupo_Participantes[1]
			return true
	


	
