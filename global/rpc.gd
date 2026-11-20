extends Node


@rpc("any_peer", "call_remote")
func _funciona(text:String):
	global.crear_juez.emit(text)

@rpc("any_peer", "call_remote")
func _juez_aceptado(grupo: int,nombre:String):
	pass
	
@rpc("any_peer", "call_remote")
func _juez_rechazado(text:String):
	pass

@rpc("any_peer", "call_remote")
func _crear_jugador(nombre:String, numero:String, juez: int):
	pass

@rpc("any_peer", "call_remote")
func _crear_lista():
	pass

@rpc("any_peer", "call_remote")
func _empezar_combates():
	pass

@rpc("any_peer", "call_remote")
func _entrar_resultados( grupo: int, perdedor:int,ganador: int, resultado: int):
	global.actualizar_combate.emit(grupo, perdedor,ganador, resultado)
	
