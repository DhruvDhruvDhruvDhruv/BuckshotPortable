extends Control

#var is_loading : bool = false
#var shell_array : Array = [1,1,1,0,0,0]
const BLANK_SHELL_TEXTURE = preload("res://assets/sprites/BlankShell.png")
const LIVE_SHELL_TEXTURE = preload("res://assets/sprites/LiveShell.png")
@onready var ammo_array: Control = %AmmoArray
@onready var load_shell_sound: AudioStreamPlayer2D = $LoadShellSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func load_shells(shells: Array) -> void:
	for val in shells:
		var texture_rect = TextureRect.new()
		texture_rect.texture = LIVE_SHELL_TEXTURE if val == 1 else BLANK_SHELL_TEXTURE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.rotation_degrees = 90
		texture_rect.scale = Vector2(10, 10)
		var control_holder = Control.new()
		control_holder.add_child(texture_rect)
		control_holder.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		await get_tree().create_timer(0.4).timeout
		load_shell_sound.pitch_scale = randf_range(0.975,1.05)
		load_shell_sound.play()
		ammo_array.add_child(control_holder)

func resume():
	animation_player.play_backwards("fade")
	await get_tree().create_timer(0.5).timeout
	visible = false

func pause():
	visible = true
	animation_player.play("fade")

func _on_panel_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and !GlobalScript.is_loading:
		resume()


func _on_shotgun_scene_shots_send(value: Array) -> void:
	pause()
	GlobalScript.is_loading = true
	await get_tree().create_timer(0.2).timeout
	await load_shells(value)
	await get_tree().create_timer(0.2).timeout
	resume()
	await get_tree().create_timer(0.2).timeout
	GlobalScript.is_loading = false
	for n in ammo_array.get_children():
		ammo_array.remove_child(n)
		n.queue_free()


##########################################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GlobalScript.is_loading = true
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
