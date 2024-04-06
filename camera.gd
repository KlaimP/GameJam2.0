extends Camera2D


var zoom_step: float = 0.75
var zoom_max: float = 2.0
var zoom_min: float = 0.5

var edge_left: float = -1000
var edge_right: float = 1000
var edge_up: float = -1000
var edge_down: float = 1000

var zoom_default: float = 1.0





func _ready() -> void:
	zoom = Vector2(zoom_default, zoom_default)
	check_position()




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("cam_zoom_in"):
		zoom_camera(-1)
		check_position()
	if event.is_action("cam_zoom_out"):
		zoom_camera(1)
		check_position()
	if Input.is_action_pressed("lmb"):
		if event is InputEventMouseMotion:
			move_camera_pan(event.relative)
			check_position()





func check_position():
	var viewport_size = get_viewport_rect().size
	var offset_x = viewport_size.x / (zoom.x * 2)
	var offset_y = viewport_size.y / (zoom.y * 2)
	var pos = position
	
	if pos.x + offset_x > edge_right:
		position.x -= pos.x + offset_x - edge_right
	elif pos.x - offset_x < edge_left:
		position.x -= pos.x - offset_x - edge_left
	if pos.y + offset_y > edge_down:
		position.y -= pos.y + offset_y - edge_down
	elif pos.y - offset_y < edge_up:
		position.y -= pos.y - offset_y - edge_up
	
	if pos.x + offset_x > edge_right and pos.x - offset_x < edge_left:
		position.x = (edge_left + edge_right)/2
	if pos.y + offset_y > edge_down and pos.y - offset_y < edge_up:
		position.y = (edge_up + edge_down)/2
	





func zoom_camera(zooming: int):
	var mouse_pos = get_global_mouse_position()
	
	zoom *= pow(zoom_step, zooming)
	
	if zoom > Vector2(zoom_max, zoom_max):
		zoom = Vector2(zoom_max, zoom_max)
		return
	if zoom < Vector2(zoom_min, zoom_min):
		zoom = Vector2(zoom_min, zoom_min)
		return
	
	position = lerp(position, mouse_pos, (zoom_step-1) * zooming)





# Передвижение камеры, зажимая кнопку
func move_camera_pan(move_direction):
	position -= move_direction * 1/zoom


#func move_camera_buttons(_direction: Vector2):
	#var current_pos = position
	#_direction.normalized()
	#position = lerp(current_pos, current_pos + _direction, speed * 1/zoom.x)
