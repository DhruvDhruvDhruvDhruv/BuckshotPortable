extends Control

const SHOTGUN_SCENE = preload("res://scenes/shotgun_scene.tscn")
var show_howto : bool = false
@onready var how_to_play_panel: Control = $HowToPlayPanel
@onready var how_to_panel_anim: AnimationPlayer = $HowToPlayPanel/HowToPanelAnim2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	how_to_play_panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_panel():
	how_to_panel_anim.play_backwards("fade")
	await get_tree().create_timer(0.5).timeout
	how_to_play_panel.visible = false

func show_panel():
	how_to_play_panel.visible = true
	how_to_panel_anim.play("fade")



func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(SHOTGUN_SCENE)


func _on_button_button_down() -> void:
	show_panel()


func _on_button_button_up() -> void:
	hide_panel()
