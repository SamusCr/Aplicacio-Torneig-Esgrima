extends CanvasLayer

@export var quart : Array[Combate]
@export var semi : Array[Combate]
@export var timer: Timer
var participant = preload("res://Scenes/participant.tscn")
var pantalla_ganador = preload("res://Scenes/canvas_ganador.tscn")
var sound_sword = preload("res://assets/Colp.ogg")

#crear final els combats per a la final. Es començara amb els quarts de final o semifinal en cas de ser soles 2 judtges.

#Perfavor, tens que canviar per organtizar millor, utilitza containers i que tot quede mes escalat.

func CrearFinales(finalistats : Array[Participant]):
	timer.start()
	
	if finalistats.size() == 8:
		$Quart.show()
		for n in 4:
			var combatiene1 = finalistats.pick_random()
			finalistats.erase(combatiene1)
			var combatiene2 = finalistats.pick_random()
			finalistats.erase(combatiene2)
			quart[n-1].create_combat(combatiene1,combatiene2)
			await timer.timeout


	if finalistats.size()==4:
		$Semifinals.show()
		for n in 2:
			var combatiene1 = finalistats.pick_random()
			finalistats.erase(combatiene1)
			var combatiene2 = finalistats.pick_random()
			finalistats.erase(combatiene2)
			semi[n-1].create_combat(combatiene1,combatiene2)
			await timer.timeout
	timer.stop()


#crear semifinals 
func _on_button_semifinales_pressed():
	timer.start()
	if $Quart/Combate.ganador != null && $Quart/Combate2.ganador!= null && $Quart/Combate3.ganador!= null && $Quart/Combate4.ganador!= null: 
		global.acaba_fase.emit($Quart, $Semifinals)
		semi[1].create_combat(quart[2].ganador,quart[3].ganador)
		await timer.timeout
		semi[0].create_combat(quart[0].ganador,quart[1].ganador)
		await timer.timeout

	timer.stop()


#crear combat final
func _on_button_finales_pressed():

	if $Semifinals/Semifinal1.ganador != null && $Semifinals/Semifinal2.ganador != null:
		$Finals/Final.create_combat($Semifinals/Semifinal1.ganador,$Semifinals/Semifinal2.ganador)
		global.acaba_fase.emit($Semifinals,$Finals)

#Mostrar combat final
func _on_button_pressed():
	if $Finals/Final.ganador != null:
		var combate_final :Combate = $Finals/Final
		var Canvas_ganador : Canvas_Ganador = pantalla_ganador.instantiate() as Canvas_Ganador
		add_child(Canvas_ganador)
		Canvas_ganador.ganador(combate_final.ganador.nombre)
		Canvas_ganador.animar_Ganador()
