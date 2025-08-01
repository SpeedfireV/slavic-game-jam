class_name MainCamera extends Camera2D



func _process(delta):
	var movement_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	global_position += movement_vector * 500 * delta