extends Control
class_name Canvas_Ganador

@export var Pantalla : ColorRect
@export var Text:RichTextLabel 
@export var Tganador:RichTextLabel 
var music : AudioStream = preload("res://assets/Musica/466133__humanoide9000__victory-fanfare.wav")
# Called when the node enters the scene tree for the first time.
func animar_Ganador():
	SFXPlayer.play(music,true)
	var tween = create_tween()
	tween.tween_property(Pantalla, "global_position", Vector2(0,1180),5)



func ganador(Ganador: String)-> void:
	Text.text ="[center]EL GANADOR DEL " + global.titulo
	Tganador.text =  "[center]" +  Ganador.to_upper()
