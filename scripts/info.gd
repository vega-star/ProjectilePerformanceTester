extends CanvasLayer

@onready var fps_counter : Label = $Screen/InfoBar/Counters/FPSCounter

func _process(delta: float) -> void:
	fps_counter.set_text("FPS: " + str(Engine.get_frames_per_second()))
