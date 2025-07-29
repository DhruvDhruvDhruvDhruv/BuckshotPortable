extends Node2D
@onready var animation_player: AnimationPlayer = $CanvasLayer/Shotgun/AnimationPlayer
@onready var shotgunsound: AudioStreamPlayer2D = $shotgunsound
@onready var shotreset_timer: Timer = $shotreset_timer
@onready var popup_box: Control = $CanvasLayer/PopupBox
signal shots_send(value : Array)
@onready var shot_blank_label: Label = $CanvasLayer/ShotBlankLabel

var shot_reset : bool = true

func fire_shot():
	print("boom")
	shot_blank_label.text = "SHOT"
	animation_player.play("fire")
	shotgunsound.pitch_scale = randf_range(0.925,1.1)
	shotgunsound.play(0)
	#animation_player.play("RESET")

func fire_blank():
	print("pew")
	shot_blank_label.text = "BLANK"
	animation_player.play("blank")
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and shot_reset and !GlobalScript.is_loading:
		if GlobalScript.shots.is_empty():
			reload_gun()
		else:
			var is_a_shot : bool = !(GlobalScript.shots[0] % 2 == 0)
			shot_reset = false
			shotreset_timer.start()
			GlobalScript.shots.pop_front()
			if is_a_shot:
				fire_shot()
			else:
				fire_blank()

func _on_shotreset_timer_timeout() -> void:
	shot_reset = true

func reload_gun():
	var num_shots : int = randi_range(2,4)
	for i in range(6):
		if i < num_shots:
			GlobalScript.shots.append(1)
		else:
			GlobalScript.shots.append(0)
	print(GlobalScript.shots)
	emit_signal("shots_send",GlobalScript.shots)
	await get_tree().create_timer(0.5).timeout
	await GlobalScript.is_loading == false
	#get_tree().paused = true
	while popup_box.visible:
			await get_tree().create_timer(0.5).timeout
	GlobalScript.shots.shuffle()
	print(GlobalScript.shots)

#################################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	reload_gun()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
