extends CanvasLayer

const QUANTITY_CLAMP : Vector2i = Vector2i(1,5000)
const DEFAULT_QUANTITY_VALUE : int = 5
const TICK_DEFINITION : int = 100

signal pps_quantity_set(new_q : int)

@onready var pause_info: Label = $Screen/InfoBar/Counters/PauseInfo
@onready var fps_counter : Label = $Screen/InfoBar/Counters/FPSCounter
@onready var quantity_slider: HSlider = $Screen/QuantitySlider
@onready var quantity_label: Label = $Screen/QuantitySlider/QuantityLabel

var paused : bool = false: set = set_pause
var pps_quantity_value : int = DEFAULT_QUANTITY_VALUE: set = _set_pps_quantity

func _ready() -> void:
	config_quantity(QUANTITY_CLAMP)

func config_quantity(clamp_vector : Vector2i) -> void:
	quantity_slider.min_value = QUANTITY_CLAMP.x
	quantity_slider.max_value = QUANTITY_CLAMP.y
	quantity_slider.tick_count = quantity_slider.max_value / TICK_DEFINITION

func _process(delta: float) -> void:
	fps_counter.set_text("FPS: " + str(Engine.get_frames_per_second()))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('space'): set_pause(!get_tree().paused)

func _set_pps_quantity(new_q : int) -> int:
	new_q = clampi(new_q, QUANTITY_CLAMP.x, QUANTITY_CLAMP.y)
	pps_quantity_value = new_q
	quantity_label.set_text('PROJECTILES PER SECOND (PPS): ' + str(pps_quantity_value))
	pps_quantity_set.emit(pps_quantity_value)
	return pps_quantity_value

func _on_quantity_slider_value_changed(value : float) -> void: pps_quantity_value = value

func set_pause(new_b : bool) -> void:
	paused = new_b
	get_tree().set_pause(paused)
	if paused: pause_info.set_text("PAUSED ||")
	else: pause_info.set_text("RUNNING ->")
