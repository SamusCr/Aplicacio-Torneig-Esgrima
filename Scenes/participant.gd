extends HBoxContainer
class_name Participant

@export var numero :String
@export var nombre:String
@export var button_Eliminar : Button 


var grupo :int = 0
var orden_comabte: int =0
var es_juez : bool = false
@export var puntos_vicotria: int
@export var puntos_contra: int

@export var Text_numero : TextEdit
@export var Text_nombre: LineEdit
#classe participant, tambe ho gaste per mostrar el 
func _ready():
	if numero != null && nombre !=null:
		Text_numero.text= numero
		Text_nombre.text = nombre


#
func actualizar_nombre_grupo(nombre_nuevo : String,  numero_nuevo : String):

	numero = numero_nuevo
	nombre = nombre_nuevo
	
	if Text_numero != null && Text_nombre !=null:
		Text_numero.text= numero
		Text_nombre.text = nombre
#per quan sols vols que aparegui el nom
func eliminar_botones():
	button_Eliminar.hide()



func _on_boton_eliminar_pressed():
	global.borrar_participante.emit(self)
	queue_free()


func _on_nombre_text_submitted(new_text):
	nombre = Text_nombre.text 


func _on_nombre_focus_exited():
	nombre = Text_nombre.text 
