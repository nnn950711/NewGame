extends Node2D

var score = 0 # 分數
var lives = 3 # 分數
var bomb = 3 # 分數
var _time = 0 # 時間

@onready var enemy = $Enemy # 敵人
@onready var label_score = $UI/Score # 分數
@onready var label_lives = $UI/Lives # 殘機
@onready var label_bomb = $UI/Bomb # Bomb
@onready var label_time = $UI/Time # 時間(調試用)
@onready var timer = $Timer # 計時器


# 準備
func _ready():
	# 初始化文本
	label_score.text = "分數：" + str(score)
	label_lives.text = "殘機：" + str(lives)
	label_bomb.text = "bomb：" + str(bomb)
	
	# 過場效果
	EffectCanvasl.diamond_screen_transition(true, 0.0, 1, 1.0)


# 每一幀運行
func _process(delta):
	# 調試資訊
	if(GlobalData.debug_mode == true):
		label_time.visible = true
		label_time.text = "時間：" + str(_time)
		# 調試用
		if(Input.is_action_just_pressed("ui_confirm")):
			var _x = randf_range(0, 770)
			enemy.make_popcorn(null, _x, -40, _x, randf_range(100, 300), 180, 0.5, 0.5, Color.RED)
	else:
		label_time.visible = false
		
	# 關卡 1
	_time += 1
	if(_time == 100):
		var _x = 0
		var _y = 0
		for n in 6:
			_x += 60
			_y += 30
			enemy.make_popcorn(null, _x, -40, _x, _y, 180, 0.5, 0.5, Color.RED, 1, Tween.TRANS_QUART)
	if(_time == 300):
		var _x = 820
		var _y = 0
		for n in 6:
			_x -= 60
			_y += 30
			enemy.make_popcorn(null, _x, -40, _x, _y, 180, 0.5, 0.5, Color.RED, 1, Tween.TRANS_QUART)
	if(_time == 600):
		timer.start()
		
	if(_time == 5000):
		timer.stop()
	
	if(_time == 6000):
		enemy.free()


# 計時器
func _on_timer_timeout():
	var _x = randf_range(0, 770)
	enemy.make_popcorn(null, _x, -40, _x, randf_range(100, 400), 180, 0.5, 0.5, Color.RED)
