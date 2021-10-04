extends Node2D

# signals
signal build(station_name)
signal update_display(vapor, ore)
signal explode_stations
signal build_grav_field
signal game_over(message)

# enums

# constants

# exported variables
export var background_speed := 100

# variables
var _ignore
var _is_not_drifting := true
var _is_game_running := true
var _comet_is_in_view := true

# onready variables
onready var _parallax_background := $ParallaxBackground


func _ready()->void:
	randomize()


func _process(delta:float)->void:
	if _is_not_drifting:
		_parallax_background.scroll_offset.x -= background_speed * delta
	elif not _is_not_drifting and _comet_is_in_view:
		$Comet.position.x += background_speed*delta


func _on_HUD_build(station_name:String)->void:
	emit_signal("build", station_name)


func _on_Comet_update_display(vapor:int, ore:int)->void:
	emit_signal("update_display", vapor, ore)


func _on_HUD_game_over_lose()->void:
	if _is_game_running:
		emit_signal("explode_stations")
		_is_game_running = false


func _on_HUD_build_grav_field()->void:
	emit_signal("build_grav_field")


func _on_Comet_won()->void:
	emit_signal("game_over", "You have stabilized the comet!")
	_is_game_running = false


func _on_Comet_explosions_finished()->void:
	_is_not_drifting = false
	emit_signal("game_over", "Ephemera has become too unstable...")


func _on_Comet_out_of_view():
	_comet_is_in_view = false
