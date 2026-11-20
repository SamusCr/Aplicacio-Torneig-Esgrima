extends LineEdit
class_name Casilla

@export var taula : Taula_emparellar
@export var nombre_fila : String
@export var combtatiente : Participant
@export var contrincante: Participant
@export var sprite: Sprite2D
@export var theme_Focus: StyleBoxFlat
@export var theme_Normal: StyleBoxFlat
var id : int

var casilla_contrincante: Casilla




func _ready():
	if casilla_contrincante ==null:
		casilla_contrincante = _encontrar_contrincante()
		

#desactivar casilla per afegir el sprite de les espases
func _desactivar_casilla():
	sprite.visible = true
	editable = false
	focus_mode = Control.FOCUS_NONE
	
#al canviar el text es modifica la puntuiacio
func _on_text_changed(new_text):
	modificar_puntuación(new_text)

#trobar els contrincant
func _encontrar_contrincante()-> Casilla:
		for combate in taula.tabla_combates.get_children():
			if combate.combtatiente.numero == contrincante.numero && combate.contrincante.numero == combtatiente.numero:
				return combate
		return null

#resaltar casilla seleccionada
func _on_focus_entered():
	if casilla_contrincante ==null:
		casilla_contrincante = _encontrar_contrincante()
	casilla_contrincante.add_theme_stylebox_override("normal",theme_Focus)

#tornar la casilla al seu lloc
func _on_focus_exited():
	casilla_contrincante.add_theme_stylebox_override("normal",theme_Normal)
	add_theme_stylebox_override("normal",theme_Normal)


#modificar la puntuació
func modificar_puntuación(puntuacion):
	if casilla_contrincante ==null:
		casilla_contrincante = _encontrar_contrincante()
	var nombre_participante = get_parent().get_child(0) as Label

	if puntuacion == "0" || puntuacion == "1" ||puntuacion == "2" || puntuacion == "3" || puntuacion == "v"  || puntuacion == "V"|| puntuacion == "0"|| puntuacion == "":
		self.text = puntuacion
		
		if puntuacion == "v" || puntuacion == "V":

			modulate= Color.GREEN
		else:
			modulate= Color.RED
			if puntuacion != "3" || puntuacion == "v" || puntuacion == "V":
				casilla_contrincante.text = "V"
				casilla_contrincante.modulate= Color.GREEN
	
			else:
				casilla_contrincante.text ="3"
				casilla_contrincante.modulate= Color.RED

		taula.calcular_puntos(combtatiente)
		taula.calcular_puntos(contrincante)
	else:
		text = ""
