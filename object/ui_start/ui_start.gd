# 開始介面(主要是用於標題介面場景的)
extends CanvasLayer

var choose = 0
var is_confirm = false
var effect = preload("res://autoload/effect_canvasl/effect_canvasl.tscn")

@onready var button = $Button # 按鈕
@onready var button_single_player = $Button/SinglePlayer # 單人
@onready var button_two_player = $Button/TwoPlayer # 雙人
@onready var timer = $Timer # 計時器
@onready var timer_change_scene = $ChangeScene # 轉場用的計時器

# 準備
func _ready():
	pass


# 每一幀運行
func _process(delta):
	# 上下更換選擇
	if (Input.is_action_just_pressed("ui_left")):
		if (is_confirm != true):
			if (choose == -1): choose = 0
			if (choose > 0): choose -= 1
		_update()
		
		# 調試資訊
		if (GlobalData.debug_mode == true):
			print("目前選擇的是 " + str(choose) + ": " + str(button.get_child(choose)))
	elif Input.is_action_just_pressed("ui_right"):
		if (is_confirm != true):
			if (choose < button.get_child_count()-1): choose += 1
		_update()
		
		# 調試資訊
		if (GlobalData.debug_mode == true):
			print("目前選擇的是 " + str(choose) + ": " + str(button.get_child(choose)))
	
	if (Input.is_action_just_pressed("ui_confirm")):
		match choose:
			0:
				var eff = effect.instantiate()
				add_child(eff)
				eff.layer = 3
				eff.diamond_screen_transition(false, 1.0)
				timer_change_scene.start()
			1:
				timer.start()
				button_two_player.text = "尚未實現"


# 更新選擇
func _update():
	# 聚焦
	button.get_child(choose).grab_focus()
	
# 單人按鈕被按下
func _on_single_player_button_down():
	var eff = effect.instantiate()
	add_child(eff)
	eff.layer = 3
	eff.diamond_screen_transition(false, 1.0)
	timer_change_scene.start()


# 雙人按鈕被按下
func _on_two_player_button_down():
	timer.start()
	button_two_player.text = "尚未實現"


# 計時器結束
func _on_timer_timeout():
	button_two_player.text = "雙人"


# 轉場用的計時器
func _on_change_scene_timeout():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
