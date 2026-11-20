extends CanvasLayer
@export var sig_fase: CanvasLayer

var _jueces : CanvasLayer
var jueces: Array[LineEdit]	

#seleccionar el numero de judges que tindra el torneig
func _ready():
	if global.get_jueces() == 4:
		_jueces = $"4_jueces"
		_jueces.show()
	if  global.get_jueces() == 2:
		_jueces = $"2_jueces"
		_jueces.show()
	for j in _jueces.get_children():
		if j.get_class()=="LineEdit":
			jueces.append(j)
			
	global.crear_juez.connect(_crear_juez)
	
#creació dels judges com a participants. 
#Emitir el rpc com a que els judges han sigut seleccionats.
func _on_epezar_torneo_pressed():
	var n = 1
	var lleno: bool = true
	
	for juez in jueces:
		if juez.text == "":
			lleno= false
	if lleno:
		for juez in jueces:
			global.crear_participante.emit(juez.text)
			global.grupo_Participantes[n-1].es_juez = true
			global.grupo_Participantes[n-1].eliminar_botones()
			global.grupo_Participantes[n-1].grupo =n
			n= n+1
		
		global.jueces_selecionados.emit(global.grupo_Participantes)
		Network_Handler.close_broadcaster()
		global.acaba_fase.emit(_jueces, sig_fase)

#crear judge a distancia. Pensat per a cridada de client buscara una casella buida, en cas que no hi hagi voldra dir que estan tots els judges pilalts
func _crear_juez(nombre: String) -> bool:

	var casilla_vacia : LineEdit
	var index : int = 1
	var grupo : int

	for n in jueces:
		if n.text=="" && casilla_vacia ==null:
			grupo= index
			casilla_vacia = n 
			
		index = index+1
	
	if casilla_vacia == null:
		Rpc._juez_rechazado.rpc("JUECES LLENO")
		return false

	else:
		casilla_vacia.text = nombre
		for n in global.jueces_online:
			if n == grupo:
				return true
		global.jueces_online.append(grupo)
		Rpc._juez_aceptado.rpc(grupo,nombre)
		return true
		

	
