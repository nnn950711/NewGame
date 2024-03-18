# 用於畫面效果的畫布層
extends CanvasLayer

var color = Color.BLACK # 顏色
var color_alpha = 0 # 透明度
var shader_file = null # 著色器文件

@onready var color_rect = $ColorRect #彩色矩形


# 準備
func _ready():
	# 初始設定
	color_rect.color.a = color_alpha
	
	# 測試用(非需要時請註解化)
	#diamond_screen_transition(true ,1.0) # 鑽石型過場動畫
	#simple_blur(false ,2.0) # 簡單的模糊


# 每一幀運行
func _process(delta):
	pass


# 鑽石型過場動畫
func diamond_screen_transition(remove = false, final_val = 0.0, duration = 1.0, from = 0.0, trans = Tween.TRANS_SINE, ease = Tween.EASE_IN_OUT):
	if (shader_file != load("res://shader/diamond_screen_transition.gdshader")):
		shader_file = load("res://shader/diamond_screen_transition.gdshader")
		color_rect.color = Color.BLACK
		color_rect.color.a = 1
		color_rect.material = ShaderMaterial.new()
		color_rect.material.shader = shader_file
		color_rect.material["shader_parameter/progress"] = 1.0
	
	var tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/progress", final_val, duration).from(from).set_trans(trans).set_ease(ease)
	
	# Tween 跑完後移除著色器
	if (remove == true):
		await tween.finished
		shader_file = null
		color_rect.color.a = 0
		color_rect.material.shader = shader_file


# 簡單的模糊
func simple_blur(remove = false, final_val = 0.0, duration = 1.0, from = 0.0, trans = Tween.TRANS_SINE, ease = Tween.EASE_IN_OUT):
	if (shader_file != load("res://shader/simple_blur.gdshader")):
		shader_file = load("res://shader/simple_blur.gdshader")
		color_rect.color = Color.BLACK
		color_rect.color.a = 1
		color_rect.material = ShaderMaterial.new()
		color_rect.material.shader = shader_file
		color_rect.material["shader_parameter/blur_amount"] = 1.0
	
	var tween = create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/blur_amount", final_val, duration).from(from).set_trans(trans).set_ease(ease)
	
	# Tween 跑完後移除著色器
	if (remove == true):
		await tween.finished
		shader_file = null
		color_rect.color.a = 0
		color_rect.material.shader = shader_file
