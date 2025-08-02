extends Camera2D


@export var base_pan_speed: float = 950.0
@export var edge_margin: float = 150.0
@export var scroll_pan_speed: float = 3.0

@export var zoom_speed: float = 0.3
@export var min_zoom: float = 0.4
@export var max_zoom: float = 2.0

var lock_camera_move = false

var is_dragging: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO

var target_position: Vector2 = Vector2.ZERO
var target_zoom: Vector2 = Vector2.ONE


func _process(delta: float):
	move_camera_wsad(delta)
	lock_camera_movement()
	if !lock_camera_move:
		handle_edge_pan(delta)

	global_position = lerp(global_position, target_position, 0.2)
	zoom = lerp(zoom, target_zoom, 0.2)

func _unhandled_input(event: InputEvent):
	handle_zoom(event)
	handle_scroll_drag(event)
	
func move_camera_wsad(delta):
	var movement_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	target_position += movement_vector * 500 * delta

func lock_camera_movement():
	if Input.is_action_just_pressed("camera_mouse_move"):
		lock_camera_move=!lock_camera_move
		print("CAMERA LOCKED:"+ str(lock_camera_move))
		

func handle_edge_pan(delta: float):
	var movement_direction = Vector2.ZERO
	var mouse_position = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	var pan_speed = 0.0

	if mouse_position.x < edge_margin:
		movement_direction.x = -1
		pan_speed = base_pan_speed * (1.0 - mouse_position.x / edge_margin)
	elif mouse_position.x > viewport_size.x - edge_margin:
		movement_direction.x = 1
		pan_speed = base_pan_speed * ((mouse_position.x - (viewport_size.x - edge_margin)) / edge_margin)

	if mouse_position.y < edge_margin:
		movement_direction.y = -1
		pan_speed = max(pan_speed, base_pan_speed * (1.0 - mouse_position.y / edge_margin))
	elif mouse_position.y > viewport_size.y - edge_margin:
		movement_direction.y = 1
		pan_speed = max(pan_speed, base_pan_speed * ((mouse_position.y - (viewport_size.y - edge_margin)) / edge_margin))

	pan_speed = min(pan_speed, 500)
	if movement_direction != Vector2.ZERO:
		target_position += movement_direction.normalized() * pan_speed * delta


func handle_zoom(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				target_zoom -= Vector2(zoom_speed, zoom_speed)
				target_zoom = target_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				target_zoom += Vector2(zoom_speed, zoom_speed)
				target_zoom = target_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func handle_scroll_drag(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_dragging = event.is_pressed()
			if is_dragging:
				last_mouse_position = get_viewport().get_mouse_position()
			get_viewport().set_input_as_handled()

	if is_dragging and event is InputEventMouseMotion:
		var mouse_delta = last_mouse_position - get_viewport().get_mouse_position()
		target_position += mouse_delta * scroll_pan_speed * target_zoom * 0.5
		last_mouse_position = get_viewport().get_mouse_position()
