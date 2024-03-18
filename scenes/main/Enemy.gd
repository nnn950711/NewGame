extends Node


# 敵人(雜魚)
func make_popcorn(sprite_image, _x, _y, to_x, to_y , _rotation, x_scale, y_scale, color, duration=1, trans=Tween.TRANS_SINE):
	var enemy = preload("res://object/enemy/popcorn/popcorn.tscn")
	var inst = enemy.instantiate()
	inst.modulate = color
	inst.position = Vector2(_x, _y)
	inst.rotation = deg_to_rad(_rotation)
	inst.scale = Vector2(x_scale, y_scale)
	inst._on_area_2d_area_entered($"../Airplane")
	
	var tween = create_tween()
	tween.tween_property(inst, "position", Vector2(to_x, to_y), duration).from(Vector2(_x, _y)).set_trans(trans)
	
	add_child(inst)
	return inst
