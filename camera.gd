extends Camera2D


var zoomStep: float = 0.75
var zoomMax: float = 0.75
var zoomMin: float = 2.0

var edgeLeft: float = -1000
var edgeRight: float = 1000
var edgeUp: float = -1000
var edgeDown: float = 1000
var edgeOffset: float = 50

var screenResolution: Vector2
var gameCenter: Vector2

var zoomDefault: float = 1.5





func _ready() -> void: 
	screenResolution = get_canvas_transform().get_origin() * 2
	EventBus.calculate_edges.connect(set_edges)
	check_position()


func set_edges(arr: Array):
	var posVec = arr[0]
	var negVec = arr[1]
	edgeLeft = negVec.x - edgeOffset
	edgeRight = posVec.x + edgeOffset
	edgeUp = negVec.y - edgeOffset
	edgeDown = posVec.y + edgeOffset
	set_center()
	set_zoom_settings()

func set_center():
	gameCenter = Vector2((edgeLeft + edgeRight)/2, (edgeUp + edgeDown)/2)
	position = gameCenter

func set_zoom_settings():
	var sumX = abs(edgeLeft) + abs(edgeRight)
	var sumY = abs(edgeUp) + abs(edgeDown)
	var max = sumX if sumX > sumY else sumY
	zoomMax = screenResolution.x / max
	zoomDefault = zoomMax
	zoom = Vector2(zoomDefault, zoomDefault)
	check_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("cam_zoom_in"):
		zoom_camera(-1)
		check_position()
	if event.is_action("cam_zoom_out"):
		zoom_camera(1)
		check_position()
	if Input.is_action_pressed("rmb"):
		if event is InputEventMouseMotion:
			move_camera_pan(event.relative)
			check_position()





func check_position():
	var viewport_size = get_viewport_rect().size
	var offset_x = viewport_size.x / (zoom.x * 2)
	var offset_y = viewport_size.y / (zoom.y * 2)
	var pos = position
	
	if pos.x + offset_x > edgeRight:
		position.x -= pos.x + offset_x - edgeRight
	elif pos.x - offset_x < edgeLeft:
		position.x -= pos.x - offset_x - edgeLeft
	if pos.y + offset_y > edgeDown:
		position.y -= pos.y + offset_y - edgeDown
	elif pos.y - offset_y < edgeUp:
		position.y -= pos.y - offset_y - edgeUp
	
	if pos.x + offset_x > edgeRight and pos.x - offset_x < edgeLeft:
		position.x = (edgeLeft + edgeRight)/2
	if pos.y + offset_y > edgeDown and pos.y - offset_y < edgeUp:
		position.y = (edgeUp + edgeDown)/2
	





func zoom_camera(zooming: int):
	var mouse_pos = get_global_mouse_position()
	
	zoom *= pow(zoomStep, zooming)
	
	if zoom < Vector2(zoomMax, zoomMax):
		zoom = Vector2(zoomMax, zoomMax)
		return
	if zoom > Vector2(zoomMin, zoomMin):
		zoom = Vector2(zoomMin, zoomMin)
		return
	
	position = lerp(position, mouse_pos, (zoomStep-1) * zooming)





# Передвижение камеры, зажимая кнопку
func move_camera_pan(move_direction):
	position -= move_direction * 1/zoom


#func move_camera_buttons(_direction: Vector2):
	#var current_pos = position
	#_direction.normalized()
	#position = lerp(current_pos, current_pos + _direction, speed * 1/zoom.x)
