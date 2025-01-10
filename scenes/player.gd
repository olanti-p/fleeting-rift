extends CharacterBody2D
class_name Player

const SPEED = 100.0
const AIRJUMP_VELOCITY = 180.0
const WALLJUMP_VELOCITY = 200.0
const JUMP_VELOCITY_IMMEDIATE = 180.0
const JUMP_VELOCITY_DIVIDE_FACTOR = 2.0

var was_on_floor: bool = false
var looking_right: bool = true
var is_grabbing: bool = false:
	set(value):
		is_grabbing = value
		stamina_bar.visible = value
var is_grabbing_right: bool = false
var stamina: float = 100.0:
	set(value):
		stamina = clampf(value, MIN_STAMINA, MAX_STAMINA)
		stamina_bar.value = value
var ignore_continued_grabbing: bool = false
var is_dead: bool = false
var respawn_position: Vector2
var checked_respawn_point: RespawnPoint = null
var air_jumps_remaining: int = 0
var is_jumping: bool = false
var is_dashing: bool = false
var is_unassisted_walljump: bool = false

var nearby_door: ExitDoor = null
var is_entering_door: bool = false
var is_control_hackably_disabled: bool = false

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var continued_grab_timer: Timer = $ContinuedGrabTimer
@onready var flippable_nodes: Node2D = $FlippableNodes
@onready var grab_detector: ShapeCast2D = $FlippableNodes/GrabDetector
@onready var player_sprite: AnimatedSprite2D = $FlippableNodes/Sprite
@onready var stamina_bar: TextureProgressBar = %StaminaBar

const MIN_STAMINA: float = 0.0
const MAX_STAMINA: float = 100.0
const STAMINA_LOSS_RATE: float = 30.0
const STAMINA_LOSS_PER_JUMP: float = 30.0
const STAMINA_LOSS_PER_JUMP_EASY: float = 35.0
const GRAB_ICE_SLIP_SPEED: float = 8.0
const DASH_VELOCITY: float = 200.0
const NOCLIP_FLOAT_SPEED: float = 150

func _ready() -> void:
	stamina_bar.visible = false
	respawn_position = global_position
	_reset_air_jump_counter()


func make_walljump_vector() -> Vector2:
	var do_up = Input.is_action_pressed("up")
	var do_down = Input.is_action_pressed("down")
	var do_left = Input.is_action_pressed("left") && is_grabbing_right
	var do_right = Input.is_action_pressed("right") && !is_grabbing_right
	var direction: Vector2
	if !do_left && !do_right && !do_up:
		if do_down:
			direction = Vector2.ZERO
		elif is_grabbing_right:
			direction = Vector2.DOWN + Vector2.RIGHT
		else:
			direction = Vector2.DOWN + Vector2.LEFT
	else:
		direction = \
		  (Vector2.DOWN if do_up else Vector2.ZERO) \
		+ (Vector2.RIGHT if do_left else Vector2.ZERO) \
		+ (Vector2.LEFT if do_right else Vector2.ZERO)
	return direction.normalized()


func _reset_air_jump_counter() -> void:
	air_jumps_remaining = 1 if ThisRun.is_double_jump_enabled else 0


func _play_ground_jump_sound() -> void:
	match randi_range(1, 4):
		1:
			$SFX/Jump1.play()
		2:
			$SFX/Jump2.play()
		3:
			$SFX/Jump3.play()
		4:
			$SFX/Jump4.play()


func _play_air_jump_sound() -> void:
	match randi_range(1, 4):
		1:
			$SFX/AirJump1.play()
		2:
			$SFX/AirJump2.play()
		3:
			$SFX/AirJump3.play()
		4:
			$SFX/AirJump4.play()


func _play_dash_sound() -> void:
	$SFX/Dash.play()


func _is_on_ice() -> bool:
	return ThisRun.current_level == 2 && !get_parent().is_glitch_level


func _physics_process(delta: float) -> void:
	if is_dead || is_entering_door:
		return
	
	if !is_control_hackably_disabled && \
	  Input.is_action_just_pressed("restart"):
		_on_restart_pressed()
		return
	
	# Entering door
	if !is_control_hackably_disabled && \
	  !is_entering_door && \
	  nearby_door && \
	  Input.is_action_just_pressed("up"):
		is_entering_door = true
		flippable_nodes.visible = false
		nearby_door.do_enter()
		await nearby_door.has_been_entered
		is_entering_door = false
		flippable_nodes.visible = true
		return
	
	var should_noclip = ThisRun.is_noclip_enabled && !get_parent().is_glitch_level
	
	set_collision_mask_value(1, !should_noclip)
	if ThisRun.is_spike_damage_disabled:
		$Hitbox.set_collision_mask_value(2, false)
	if ThisRun.is_star_damage_disabled:
		$Hitbox.set_collision_mask_value(5, false)
	if ThisRun.is_laser_damage_disabled:
		$Hitbox.set_collision_mask_value(4, false)
	if ThisRun.is_stamina_hack_enabled:
		stamina = MAX_STAMINA
	
	if should_noclip:
		var dir = Input.get_vector("left", "right", "up", "down")
		position += dir * NOCLIP_FLOAT_SPEED * delta
		_update_anim()
		move_and_slide()
		return
	
	if !is_control_hackably_disabled && \
	  ThisRun.is_dash_enabled && \
	  !is_dashing && \
	  Input.is_action_just_pressed("dash"):
		is_jumping = false
		is_grabbing = false
		was_on_floor = false
		is_dashing = true
		$DashTimer.start()
		_play_dash_sound()
	
	if is_grabbing && !grab_detector.is_colliding():
		# Slipped down
		is_grabbing = false
		ignore_continued_grabbing = false
	
	# Add the gravity
	if not is_on_floor() || ThisRun.is_gravity_flipped:
		var dv = get_gravity() * delta
		if ThisRun.is_gravity_flipped:
			dv = -dv
		velocity += dv
	
	# Handle Coyote Timer
	if is_on_floor():
		was_on_floor = true
		coyote_timer.stop()
		_reset_air_jump_counter()
	elif was_on_floor:
		was_on_floor = false
		coyote_timer.start()
	
	# Handle jumping
	if !is_control_hackably_disabled && \
	  is_jumping && \
	  Input.is_action_just_released("jump") && \
	  velocity.y < 0.0:
		velocity.y /= JUMP_VELOCITY_DIVIDE_FACTOR
	if !Input.is_action_pressed("jump"):
		is_jumping = false
	if !is_control_hackably_disabled && \
	  !is_dashing && \
	  Input.is_action_just_pressed("jump"):
		if is_grabbing:
			_play_ground_jump_sound()
			is_grabbing = false
			was_on_floor = false
			ignore_continued_grabbing = true
			continued_grab_timer.start()
			velocity = -WALLJUMP_VELOCITY * make_walljump_vector()
			if GlobalState.get_difficulty_stamina_decay():
				stamina -= STAMINA_LOSS_PER_JUMP
			else:
				stamina -= STAMINA_LOSS_PER_JUMP_EASY
			is_unassisted_walljump = \
			  !Input.is_action_pressed("left") && \
			  !Input.is_action_pressed("right") && \
			  !Input.is_action_pressed("up")
		elif is_on_floor() || !coyote_timer.is_stopped():
			_play_ground_jump_sound()
			coyote_timer.stop()
			was_on_floor = false
			is_jumping = true
			velocity.y = -JUMP_VELOCITY_IMMEDIATE
		elif air_jumps_remaining > 0:
			_play_air_jump_sound()
			air_jumps_remaining -= 1
			velocity.y = -AIRJUMP_VELOCITY
			is_jumping = true
	
	var direction = Input.get_axis("left", "right")
	if direction != 0 || is_on_floor() || is_grabbing || is_dashing:
		is_unassisted_walljump = false
	if is_control_hackably_disabled:
		direction = 0
	if is_unassisted_walljump:
		if velocity.x > 0:
			if !looking_right:
				looking_right = true
				flippable_nodes.apply_scale(Vector2(-1, 1))
		elif velocity.x < 0:
			if looking_right:
				looking_right = false
				flippable_nodes.apply_scale(Vector2(-1, 1))
	elif !is_grabbing:
		if direction > 0:
			if !looking_right:
				looking_right = true
				flippable_nodes.apply_scale(Vector2(-1, 1))
		elif direction < 0:
			if looking_right:
				looking_right = false
				flippable_nodes.apply_scale(Vector2(-1, 1))
	if direction != 0:
		# FIXME: joystick
		# While in air, or on ice, we want to conserve extra velocity gained from wall jump
		if (is_on_floor() and !_is_on_ice()) or \
		   (direction > 0 and velocity.x < SPEED) or \
		   (direction < 0 and velocity.x > -SPEED):
			velocity.x = direction * SPEED
	else:
		if is_on_floor() and _is_on_ice():
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * 4.0)
		elif !is_unassisted_walljump:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle grab
	if !is_control_hackably_disabled && \
	  !is_grabbing && \
	  !is_dashing && \
	  grab_detector.is_colliding() && \
	  Input.is_action_pressed("grab") && \
	  !ignore_continued_grabbing && \
	  !is_on_floor() && \
	  stamina != MIN_STAMINA:
		is_grabbing = true
		is_grabbing_right = looking_right
		was_on_floor = false
	if Input.is_action_just_released("grab"):
		is_grabbing = false
		ignore_continued_grabbing = false
	if !is_grabbing && is_on_floor():
		stamina = MAX_STAMINA
	if is_grabbing:
		if GlobalState.get_difficulty_stamina_decay():
			stamina = move_toward(stamina, MIN_STAMINA, STAMINA_LOSS_RATE * delta)
		if stamina == MIN_STAMINA:
			is_grabbing = false
	
	if !grab_detector.is_colliding():
		ignore_continued_grabbing = false
	
	if is_grabbing:
		if _is_on_ice():
			velocity = Vector2(0.0, GRAB_ICE_SLIP_SPEED)
		else:
			velocity = Vector2.ZERO
	
	if is_dashing:
		velocity.y = 0
		if looking_right:
			velocity.x = DASH_VELOCITY
		else:
			velocity.x = -DASH_VELOCITY
	
	_update_anim()
	move_and_slide()


func _update_anim() -> void:
	if is_dashing:
		player_sprite.play("dash")
	elif is_grabbing:
		player_sprite.play("grab")
	elif !is_on_floor():
		player_sprite.play("jump")
	elif velocity.x != 0:
		player_sprite.play("run")
	else:
		player_sprite.play("idle")


func _on_continued_grab_timer_timeout() -> void:
	ignore_continued_grabbing = false


func queue_camera_reset() -> void:
	get_parent().reset_camera_interpolation()


func _respawn() -> void:
	global_position = respawn_position
	queue_camera_reset()
	velocity = Vector2.ZERO
	is_grabbing = false
	was_on_floor = false
	player_sprite.set_speed_scale(GlobalState.get_animation_correction())
	player_sprite.play("respawn")
	$SFX/Respawn.play()
	await player_sprite.animation_finished
	player_sprite.set_speed_scale(1.0)
	is_dead = false


func _on_hit() -> void:
	if is_dead || is_entering_door:
		return
	is_dead = true
	player_sprite.set_speed_scale(GlobalState.get_animation_correction())
	player_sprite.play("death")
	$SFX/Death.play()
	await player_sprite.animation_finished
	player_sprite.set_speed_scale(1.0)
	_respawn()


func fell_beyond_map_edge() -> void:
	if is_dead || is_entering_door:
		return
	is_dead = true
	
	_respawn()


func _on_restart_pressed() -> void:
	if is_dead || is_entering_door:
		return
	is_dead = true
	player_sprite.set_speed_scale(GlobalState.get_animation_correction())
	player_sprite.play("death")
	await player_sprite.animation_finished
	player_sprite.set_speed_scale(1.0)
	_respawn()


func set_respawn_point(rp: RespawnPoint) -> void:
	if checked_respawn_point:
		checked_respawn_point.uncheck()
	checked_respawn_point = rp
	respawn_position = rp.get_respawn_position()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	_on_hit()


func _on_hitbox_body_entered(_body: Node2D) -> void:
	_on_hit()


func _on_dash_timer_timeout() -> void:
	is_dashing = false


func _do_win() -> void:
	SceneTransition.do_glitched("res://scenes/ui/victory_screen.tscn")


func _on_win_scanner_body_entered(_body: Node2D) -> void:
	call_deferred("_do_win")
