# 功能鍵
extends Node


# 每一幀運行
func _process(_delta):
	# 關閉遊戲
	if(Input.is_action_just_pressed("ui_escape")):
		get_tree().quit()
		
	# [全螢幕/視窗] 模式切換
	if(Input.is_action_just_pressed("ui_f4")):
		if(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
		# 視窗置中
		var position
		var window_size = DisplayServer.window_get_size()
		var screen_size = DisplayServer.screen_get_size()
		var screen_position = DisplayServer.screen_get_position()
		
		# 適應多解析度的同時也能將視窗置中
		# 螢幕位置(以左上角像素點為原點) + 螢幕解析度*0.5 - 視窗大小*0.5
		position = Vector2(screen_position) + screen_size*0.5 - window_size*0.5
		
		DisplayServer.window_set_position(position)
