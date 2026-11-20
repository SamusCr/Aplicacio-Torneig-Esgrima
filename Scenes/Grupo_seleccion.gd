extends Node
class_name Grupo

var juez : String = ""

func nombre_Juez(Nombre : String):
	juez = Nombre
	$Juez.text = Nombre

#mini animació del moviment del grup
func mover_part_grupo(grupo_final: Array[Participant], participante : Participant):

	for n in grupo_final:
			if participante.numero == n.numero:
				var tween = create_tween()
				for s in 10:
					if s%2 ==0:
						tween.tween_property(participante,"modulate:a",0,0.2)
					else:
						tween.tween_property(participante,"modulate:a",1,0.2)

				
				tween.finished.connect(func():participante.reparent($".".get_child(1)))
				Rpc._crear_jugador.rpc(participante.nombre,participante.numero,participante.grupo)
				
				await tween.finished
	
