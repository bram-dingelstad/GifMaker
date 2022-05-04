extends Camera

func _process(_delta):
	look_at(get_node('../Suzanne').global_transform.origin, Vector3.UP)
