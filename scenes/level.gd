extends Node2D
class_name Level

@onready var projectiles: Node2D = $Projectiles
@onready var main_camera: Camera2D = $MainCamera

var active_camera_area: CameraArea = null
var is_glitch_level: bool = false

var is_debug_spawn_enabled: bool = false

func _ready() -> void:
	AllRuns.current_level = self
	if is_debug_spawn_enabled and $DebugPlayerSpawner.spawn_enabled:
		$Player.global_position = $DebugPlayerSpawner.global_position
		$Player.respawn_position = $Player.global_position
	for child in $Emitters.get_children():
		child.register_owner_level(self)
	for area in $CameraAreas.get_children():
		area.owner_level = self
		area.connect("player_entered", _on_camera_area_entered)
	for door in $Doors.get_children():
		door.connect("has_been_entered", _on_player_entered_door)
	for door in $GlitchEntries.get_children():
		door.connect("player_entered", _on_player_entered_glitch)


func _on_camera_area_entered(_player: Player, area: CameraArea) -> void:
	if active_camera_area:
		active_camera_area.detach_camera()
	active_camera_area = area
	active_camera_area.attach_camera(main_camera)


func _on_player_entered_door(new_scene: String, buggy: bool) -> void:
	$Player.visible = false
	if buggy:
		SceneTransition.do_glitched(new_scene)
	else:
		SceneTransition.do_normal(new_scene)


func _enter_glitch_deferred(new_scene: String) -> void:
	SceneTransition.do_glitched(new_scene)


func _on_player_entered_glitch(new_scene: String) -> void:
	call_deferred("_enter_glitch_deferred", new_scene)


func has_fake_wall() -> bool:
	return false


func reveal_fake_wall() -> void:
	pass


func _process(_delta: float) -> void:
	var cakewalk = GlobalState.get_difficulty_extra_platforms()
	%CakewalkPlatforms.visible = cakewalk
	%CakewalkPlatforms.collision_enabled = cakewalk


func add_projectile(projectile: Node2D, pos: Vector2) -> void:
	projectiles.add_child(projectile)
	projectile.global_position = pos
	projectile.reset_physics_interpolation()


func get_player() -> Player:
	return $Player


func get_player_global_pos() -> Vector2:
	return $Player.global_position


func _on_world_boundaries_body_entered(body: Node2D) -> void:
	if ThisRun.is_fall_damage_disabled and !is_glitch_level:
		call_deferred("_enter_glitch_deferred", "res://scenes/levels/glitch_level_3.tscn")
	else:
		var player = body as Player
		player.fell_beyond_map_edge()
