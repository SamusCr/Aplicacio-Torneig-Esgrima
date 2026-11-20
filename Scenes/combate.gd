extends Node2D
class_name Combate

@export var contricante1: Button
@export var contricante2: Button
var grupo: int =0
@export var Pcontricante1 : Participant
@export var Pcontricante2 : Participant
@export var ganador: Participant

var sound_sword = preload("res://assets/Colp.ogg")

#eliminar vibració quan apareixen els combats, no els ha agradat
#func _ready():
	#mostrar_shacke()


func create_combat(participant1: Participant, participant2: Participant):
	Pcontricante1 = participant1
	Pcontricante2 = participant2
	
	if participant1 != null:
		contricante1.text = participant1.nombre
		$RichTextLabel.text = participant1.numero
	else:
		contricante1.text = ""
	#Shaker.shake(contricante1,0.2,contricante1.position)
	if participant2 != null:
		contricante2.text = participant2.nombre
		$RichTextLabel3.text = participant2.numero
	else:
		contricante2.text = ""
		
	mostrar_shacke()

#quan li dones la botó d'un dels participants el fas guanyador
func _on_participant_3_pressed():

		if ganador == null || ganador == Pcontricante2:
			if ganador ==Pcontricante2:
				contricante2.set_pressed_no_signal(false)
			ganador = Pcontricante1
		
		else:
			ganador = null


#quan li dones la botó d'un dels participants el fas guanyador
func _on_participant_4_pressed():

		if ganador == null || ganador == Pcontricante1:
			if ganador ==Pcontricante1:
				contricante1.set_pressed_no_signal(false)
			ganador = Pcontricante2
		
		else:
			ganador = null


#canviar 
func _on_button_pressed():
	if !$Participant3/LineEdit.is_visible_in_tree():
		$Participant3/LineEdit.text = $Participant3.text
		$Participant3.text= ""
		$Participant3/LineEdit.show()
	else:
		Pcontricante1.actualizar_nombre_grupo($Participant3/LineEdit.text, Pcontricante1.numero)
		$Participant3.text = $Participant3/LineEdit.text
		$Participant3/LineEdit.hide()


func _on_button_2_pressed():
	if !$Participant4/LineEdit2.is_visible_in_tree():
		$Participant4/LineEdit2.text = $Participant4.text
		$Participant4.text= ""
		$Participant4/LineEdit2.show()
	else:
		Pcontricante2.actualizar_nombre_grupo($Participant4/LineEdit2.text, Pcontricante2.numero)
		$Participant4.text = $Participant4/LineEdit2.text
		$Participant4/LineEdit2.hide()
		
func mostrar_shacke():
	var buttons :Array[Button]
	buttons.append(contricante1)
	buttons.append(contricante2)

	for n in buttons:
		n.show()
		SFXPlayer.play(sound_sword)
		await Shaker.shake(n,100,n.global_position, 0.75)

	
