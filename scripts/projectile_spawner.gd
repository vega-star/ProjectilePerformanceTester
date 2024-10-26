extends Node2D

@onready var spawn_timer : Timer = $SpawnTimer

@export var start_paused : bool = true
@export var spawn_cooldown : float = 0.5
@export var process_callback : Timer.TimerProcessCallback: set = set_process_callback

func _ready() -> void:
	spawn_timer.set_wait_time(spawn_cooldown)
	set_paused(start_paused)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('space'): set_paused(!spawn_timer.paused)

func set_paused(toggle : bool = true) -> void: spawn_timer.set_paused(toggle)

func set_process_callback(set_process : Timer.TimerProcessCallback) -> void:
	spawn_timer.set_timer_process_callback(set_process)
	process_callback = set_process
