# 標題介面
extends Node2D

var choose = 0 # 選擇
var menu_mode = MENU_MODE.TITLE # 選單模式
var is_confirm = false # 已按下確定
var ui_start_inst = null

@onready var label_title = $Title # 標題
@onready var label = $Label # 標籤
@onready var label_start = $Label/Start # 開始遊戲
@onready var label_multiplayer = $Label/Multiplayer # 多人連線
@onready var label_instruction = $Label/Instruction # 操作說明
@onready var label_exit = $Label/Exit # 退出遊戲
@onready var label_version = $Version # 版本
@onready var timer = $Timer # 計時器s
@onready var ui_start = preload("res://object/ui_start/ui_start.tscn")

# 枚舉
enum MENU_MODE{ # 選單模式
	TITLE, # 標題
	START, # 開始遊戲
	MULTIPLAYER, # 多人連線
	INSTRUCTION # 操作說明
}


# 準備
func _ready():
	# 初始化
	label_version.text = GlobalData.version
	
	# 更新聚焦模式
	_update_label_focus(Control.FOCUS_ALL)
	
	# 更新顏色
	_update_label_color()


# 每一幀運行
func _process(delta):
	# 根據選單模式做出相應的功能
	if (menu_mode == MENU_MODE.TITLE): # 標題
		# 上下更換選擇
		if (Input.is_action_just_pressed("ui_up")):
			if (is_confirm != true):
				if (choose == -1): choose = 0
				if (choose > 0): choose -= 1
			_update_label_color()
			
			# 調試資訊
			if (GlobalData.debug_mode == true):
				print("目前選擇的是 " + str(choose) + ": " + str(label.get_child(choose)))
		elif Input.is_action_just_pressed("ui_down"):
			if (is_confirm != true):
				if (choose < label.get_child_count()-1): choose += 1
			_update_label_color()
			
			# 調試資訊
			if (GlobalData.debug_mode == true):
				print("目前選擇的是 " + str(choose) + ": " + str(label.get_child(choose)))
		
		# 確認
		if (Input.is_action_just_pressed("ui_confirm")):
			if (is_confirm != true):
				_choose_confirm()
	elif (menu_mode == MENU_MODE.START): # 開始遊戲
		if (Input.is_action_just_pressed("ui_cancel")):
			is_confirm = false
			menu_mode = MENU_MODE.TITLE
			_update_label_focus(Control.FOCUS_ALL)
			_update_label_input(Control.MOUSE_FILTER_PASS)
			# 刪除實例
			if (is_instance_valid(ui_start_inst)):
				ui_start_inst.free()
			EffectCanvasl.simple_blur(true, 0.0, 0.25, 2.0)
	elif (menu_mode == MENU_MODE.MULTIPLAYER): # 多人連線
		pass
		
	elif (menu_mode == MENU_MODE.INSTRUCTION): # 操作說明
		if (Input.is_action_just_pressed("ui_cancel")):
			var tween = create_tween()
			tween.tween_property(GlobalCamera, "offset:y", 0, 1).set_trans(Tween.TRANS_EXPO)
			is_confirm = false
			menu_mode = MENU_MODE.TITLE
			_update_label_focus(Control.FOCUS_ALL)
			_update_label_input(Control.MOUSE_FILTER_PASS)


# 更新聚焦模式
func _update_label_focus(focus_mods=Control.FOCUS_NONE):
	for i in label.get_child_count():
		label.get_child(i).set_focus_mode(focus_mods)


# 更新輸入事件
func _update_label_input(mouse_filter=Control.MOUSE_FILTER_IGNORE):
	for i in label.get_child_count():
		label.get_child(i).mouse_filter = mouse_filter


# 更新標籤顏色
func _update_label_color():
	label.get_child(choose).grab_focus()
	for i in label.get_child_count():
		var _label = label.get_child(i)
		if (_label.has_focus()):
			_label.add_theme_color_override("font_color", Color.YELLOW)
			
			# 調試資訊
			if (GlobalData.debug_mode == true):
				print(str(i) + " 已被聚焦！")
		else:
			_label.add_theme_color_override("font_color", Color.WHITE)
			
			# 調試資訊
			if (GlobalData.debug_mode == true):
				print(str(i) + " 未被聚焦...")


# 確定選擇
func _choose_confirm():
	# 根據選擇做出對應的動作
	match choose:
		0: # 開始遊戲
			is_confirm = true
			ui_start_inst = ui_start.instantiate()
			add_child(ui_start_inst)
			menu_mode = MENU_MODE.START
			_update_label_focus(Control.FOCUS_NONE)
			_update_label_input()
			EffectCanvasl.simple_blur(false ,2.0, 0.25)
		1: # 多人連線
			label_multiplayer.text = "尚未實現"
			timer.start()
			
			#is_confirm = true
			#menu_mode = MENU_MODE.MULTIPLAYER
		2: # 操作說明
			is_confirm = true
			menu_mode = MENU_MODE.INSTRUCTION
			var tween = create_tween()
			tween.tween_property(GlobalCamera, "offset:y", 960, 1).set_trans(Tween.TRANS_EXPO)
			
			_update_label_focus(Control.FOCUS_NONE)
			_update_label_input()
		3: # 退出遊戲
			get_tree().quit()
		_: # 其他
			pass
	
	# 調試資訊
	if (GlobalData.debug_mode == true):
		print("已按下確定 " + str(label.get_child(choose)))


# (Label Start) 處理輸入事件
func _on_start_gui_input(event):
	# 按下左鍵
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_choose_confirm()


# (Label Multiplayer) 處理輸入事件
func _on_multiplayer_gui_input(event):
	# 按下左鍵
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_choose_confirm()


# (Label Instruction) 處理輸入事件
func _on_instruction_gui_input(event):
	# 按下左鍵
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_choose_confirm()


# (Label Exit) 處理輸入事件
func _on_exit_gui_input(event):
	# 按下左鍵
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		get_tree().quit()


# (Label Start) 當游標進入控件時
func _on_start_mouse_entered():
	choose = 0
	_update_label_color()
	label_start.add_theme_color_override("font_color", Color.YELLOW)


# (Label Multiplayer) 當游標進入控件時
func _on_multiplayer_mouse_entered():
	choose = 1
	_update_label_color()
	label_multiplayer.add_theme_color_override("font_color", Color.YELLOW)


# (Label Instruction) 當游標進入控件時
func _on_instruction_mouse_entered():
	choose = 2
	_update_label_color()
	label_instruction.add_theme_color_override("font_color", Color.YELLOW)


# (Label Exit) 當游標進入控件時
func _on_exit_mouse_entered():
	choose = 3
	_update_label_color()
	label_exit.add_theme_color_override("font_color", Color.YELLOW)


# (Label Start) 當游標離開控件時
func _on_start_mouse_exited():
	choose = -1
	label_start.add_theme_color_override("font_color", Color.WHITE)


# (Label Multiplayer) 當游標離開控件時
func _on_multiplayer_mouse_exited():
	choose = -1
	label_multiplayer.add_theme_color_override("font_color", Color.WHITE)


# (Label Instruction) 當游標離開控件時
func _on_instruction_mouse_exited():
	choose = -1
	label_instruction.add_theme_color_override("font_color", Color.WHITE) 


# (Label Exit) 當游標離開控件時
func _on_exit_mouse_exited():
	choose = -1
	label_exit.add_theme_color_override("font_color", Color.WHITE)


# 計時器
func _on_timer_timeout():
	label_multiplayer.text = "多人連線"
