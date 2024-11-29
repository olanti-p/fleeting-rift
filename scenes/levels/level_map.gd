extends Level

const LEVEL_CLOUDS: int = 0
const LEVEL_BASTION: int = 1
const LEVEL_NORTH: int = 2

@onready var path_to_north: TileMapLayer = $Ground/PathToNorth
@onready var path_to_bastion: TileMapLayer = $Ground/PathToBastion


var current_level: int = LEVEL_CLOUDS
var is_bastion_unlocked: bool = false:
	set(value):
		is_bastion_unlocked = value
		_update_graphics()
var is_north_unlocked: bool = false:
	set(value):
		is_north_unlocked = value
		_update_graphics()
var is_all_unlocked: bool = false:
	set(value):
		is_all_unlocked = value
		_update_graphics()


func _update_graphics() -> void:
	$Respawns.get_child(LEVEL_CLOUDS).appear_checked = is_bastion_unlocked || is_all_unlocked
	$Respawns.get_child(LEVEL_NORTH).appear_checked = is_north_unlocked || is_all_unlocked
	if path_to_bastion:
		path_to_bastion.visible = is_bastion_unlocked || is_all_unlocked
	if path_to_north:
		$Respawns.get_child(LEVEL_BASTION).appear_checked = is_north_unlocked || is_all_unlocked
		path_to_north.visible = is_north_unlocked || is_all_unlocked

func _ready() -> void:
	$Respawns.get_child(LEVEL_CLOUDS).appear_checked = true
	$Player.is_control_hackably_disabled = true
	_update_player_position(true)
	is_north_unlocked = is_north_unlocked
	is_bastion_unlocked = is_bastion_unlocked
	super()

func _update_player_position(first: bool) -> void:
	var respawn_point: RespawnPoint = $Respawns.get_child(current_level)
	var respawn_pos = respawn_point.get_respawn_position()
	if first:
		respawn_pos.y += 2
	create_tween().tween_property($Player, "global_position", respawn_pos, 0.1)

func _process(delta: float) -> void:
	super(delta)
	
	if !$Player.is_control_hackably_disabled:
		return
	
	if is_bastion_unlocked || is_north_unlocked || is_all_unlocked:
		if Input.is_action_just_pressed("left"):
			if current_level == LEVEL_BASTION:
				current_level = LEVEL_CLOUDS
			elif current_level == LEVEL_CLOUDS:
				if is_north_unlocked || is_all_unlocked:
					current_level = LEVEL_NORTH
				else:
					current_level = LEVEL_BASTION
			else:
				current_level = LEVEL_BASTION
			_update_player_position(false)
		if Input.is_action_just_pressed("right"):
			if current_level == LEVEL_CLOUDS:
				current_level = LEVEL_BASTION
			elif current_level == LEVEL_BASTION:
				if is_north_unlocked || is_all_unlocked:
					current_level = LEVEL_NORTH
				else:
					current_level = LEVEL_CLOUDS
			else:
				current_level = LEVEL_CLOUDS
			_update_player_position(false)
	if Input.is_action_just_pressed("jump"):
		match current_level:
			LEVEL_BASTION:
				pass # TODO
			LEVEL_CLOUDS:
				get_tree().change_scene_to_file("res://scenes/levels/level_clouds.tscn")
			LEVEL_NORTH:
				pass # TODO
