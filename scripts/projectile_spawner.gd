extends Node2D

const TIMER_HARDLIMIT : int = 50 ## Timers eventually will reach a limit due to being already at 0.01. It uses this value to calculate how many additional projectiles it will have to spawn to compensate!
# const PROJECTILE_SCENE : PackedScene = preload("res://projectiles/projectile.tscn")

enum PROJECTILE_SPAWN_MODES {
	INSTANTIATED,
	HARDCODED,
	RESOURCE_BASED
}

@onready var spawn_timer : Timer = $SpawnTimer
@onready var projectile_container: Node2D = $ProjectileContainer

@export var projectile : PackedScene
@export var projectile_spawn_mode : PROJECTILE_SPAWN_MODES
@export var start_paused : bool = true
@export var spawn_default_cooldown : float = 0.5
@export var process_callback : Timer.TimerProcessCallback: set = set_process_callback

var projectile_ref : Projectile

func _ready() -> void:
	spawn_timer.set_wait_time(spawn_default_cooldown / Info.pps_quantity_value)
	Info.pps_quantity_set.connect(_on_pps_quantity_updated)
	Info.set_pause(start_paused)

func _on_pps_quantity_updated(new_q : int) -> void: spawn_timer.set_wait_time(spawn_default_cooldown / new_q)

func set_process_callback(set_process : Timer.TimerProcessCallback) -> void:
	spawn_timer.set_timer_process_callback(set_process)
	process_callback = set_process

func _on_spawn_timer_timeout() -> void:
	match projectile_spawn_mode:
		PROJECTILE_SPAWN_MODES.INSTANTIATED:
			for i in roundi(Info.pps_quantity_value / TIMER_HARDLIMIT) + 1:
				projectile_ref = projectile.instantiate()
				projectile_ref.global_position = get_viewport().get_visible_rect().get_center()
				projectile_ref.global_rotation = get_angle()
				projectile_container.add_child(projectile_ref)
		PROJECTILE_SPAWN_MODES.HARDCODED: print('NOT IMPLEMENTED YET')
		PROJECTILE_SPAWN_MODES.RESOURCE_BASED: print('NOT IMPLEMENTED YET')
		_: push_error("INVALID SPAWN MODE!")

func get_angle( target_position : Vector2 = Vector2.ZERO ) -> float:
	var direction : Vector2
	if target_position != Vector2.ZERO: direction = global_position.direction_to(target_position)
	else: direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	return transform.x.angle_to(direction)
