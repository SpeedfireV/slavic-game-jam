class_name RainEffect extends CPUParticles2D


func _process(delta):
	var viewport_size = get_viewport_rect().size
	position = Vector2(randf() * viewport_size.x, 0)