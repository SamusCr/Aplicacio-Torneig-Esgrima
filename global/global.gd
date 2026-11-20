extends Node
class_name Global
#Señales fase
signal acaba_fase(Actual_Fase: String , Next_fase :String )

#Señales animacion
signal acaba_animacion()
#Señales de participantes
signal jueces_selecionados(Jueces : Array[String])
var jueces_online: Array[int]
signal crear_juez(Nombre :String)
signal borrar_participante(participante: Participant)
signal crear_participante(Nombre : String) 
signal actualizar_combate(tabla: int, perdedor_ID: int, ganador_ID: int, puntos: int)


var grupo_Participantes : Array[Participant] =[]
var grupos_tablas: Array[Node]

var grupo_Quartos: Array[Participant] =[]
var grupo_Semifinales: Array[Participant] =[]
var grupo_Finales: Array[Participant] =[]


var titulo: String = "Falta nombre"
@export var num_jueces= 4

var scena_menu_prin : PackedScene = preload("res://Scenes/menu_inicial.tscn")
var escenea_aplicacion: PackedScene = preload("res://Scenes/pantalla_inicial_torneig.tscn")


func _ready():
	#acaba_fase.connect(_pasar_fase)
	actualizar_combate.connect(_actualizar_combate)
	
	
func get_jueces() -> int:
	return num_jueces

#func _deferred_goto_scene(path):
	#var current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	#var s = ResourceLoader.load(path)
	#current_scene = s.instantiate()
	#get_tree().root.add_child(current_scene)
	#get_tree().current_scene = current_scene
	

func reset_participantes():
	grupo_Participantes.clear()

#funcio passada a global
#func _pasar_fase(Actual_Fase: CanvasLayer , Next_fase :CanvasLayer ):
	#Actual_Fase.hide()
	#Next_fase.show()
	#
#revisar per modificar els valors de manera externa
func _actualizar_combate(tabla: int, perdedor_ID: int, ganador_ID: int, puntos: int):
	
	for n in grupos_tablas[tabla-1].combates:
		if n.combtatiente.numero.to_int() == perdedor_ID && n.contrincante.numero.to_int() == ganador_ID:
			n.modificar_puntuación(str(puntos))
			
