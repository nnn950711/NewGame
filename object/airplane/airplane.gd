# 自機
extends Node2D

@onready var player = $CharacterBody2D
@onready var timer = $Timer
@onready var bullet = preload("res://object/bullet/bullet.tscn")


# 準備
func _ready():
	pass


# 每一幀運行
func _process(delta):
	# 發射彈幕
	if (Input.is_action_pressed("ui_confirm")):
		if (timer.is_stopped() != false):
			timer.start()
		# 調試資訊
		if (GlobalData.debug_mode == true):
			print("發射彈幕！")
	
	# 慢速模式
	if (Input.is_action_pressed("ui_cancel")):
		player.speed = 200
		
		# 調試資訊
		if (GlobalData.debug_mode == true):
			print("慢速模式！")
	
	# 恢復常速
	elif (Input.is_action_just_released("ui_cancel")):
		player.speed = 400
		
		# 調試資訊
		if (GlobalData.debug_mode == true):
			print("恢復常速！")


func _on_area_2d_body_entered(body):
	queue_free()
	print("NICE")


func _on_timer_timeout():
	var inst = bullet.instantiate()
	inst.position = Vector2(player.position.x, player.position.y)
	add_child(inst)
