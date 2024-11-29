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
var air_jumps_remaining: int = NUM_AIR_JUMPS
var is_jumping: bool = false

var nearby_door: ExitDoor = null
var is_entering_door: bool = false

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
const NUM_AIR_JUMPS: int = 0

func _ready() -> void:
	stamina_bar.visible = false
	respawn_position = global_position


func make_walljump_vector() -> Vector2:
	var do_up = Input.is_action_pressed("up")
	var do_down = Input.is_action_pressed("down")
	var do_left = Input.is_action_pressed("left") && is_grabbing_right
	var do_right = Input.is_action_pressed("right") && !is_grabbing_right
	var direction = \
		  (Vector2.DOWN if do_up else Vector2.ZERO) \
		+ (Vector2.UP if do_down else Vector2.ZERO) \
		+ (Vector2.RIGHT if do_left else Vector2.ZERO) \
		+ (Vector2.LEFT if do_right else Vector2.ZERO)
	return direction.normalized()


func _physics_process(delta: float) -> void:
	if is_dead || is_entering_door:
		return
	
	# Entering door
	if !is_entering_door && nearby_door && Input.is_action_just_pressed("up"):
		is_entering_door = true
		flippable_nodes.visible = false
		nearby_door.do_enter()
		await nearby_door.has_been_entered
		is_entering_door = false
		flippable_nodes.visible = true
		return
		
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle Coyote Timer
	if is_on_floor():
		was_on_floor = true
		coyote_timer.stop()
		air_jumps_remaining = NUM_AIR_JUMPS
	elif was_on_floor:
		was_on_floor = false
		coyote_timer.start()
	
	# Handle jumping
	if is_jumping && Input.is_action_just_released("jump") && velocity.y < 0.0:
		velocity.y /= JUMP_VELOCITY_DIVIDE_FACTOR
	if !Input.is_action_pressed("jump"):
		is_jumping = false
	if Input.is_action_just_pressed("jump"):
		if is_grabbing:
			is_grabbing = false
			was_on_floor = false
			ignore_continued_grabbing = true
			continued_grab_timer.start()
			velocity = -WALLJUMP_VELOCITY * make_walljump_vector()
			stamina -= STAMINA_LOSS_PER_JUMP
		elif is_on_floor() || !coyote_timer.is_stopped():
			coyote_timer.stop()
			was_on_floor = false
			is_jumping = true
			velocity.y = -JUMP_VELOCITY_IMMEDIATE
		elif air_jumps_remaining > 0:
			air_jumps_remaining -= 1
			velocity.y = -AIRJUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if !is_grabbing:
		if direction > 0:
			if !looking_right:
				looking_right = true
				flippable_nodes.apply_scale(Vector2(-1, 1))
		elif direction < 0:
			if looking_right:
				looking_right = false
				flippable_nodes.apply_scale(Vector2(-1, 1))
	if direction:
		# While in air, we want to conserve extra velocity gained from wall jump
		if is_on_floor() or \
		   (direction > 0 and velocity.x < SPEED) or \
		   (direction < 0 and velocity.x > -SPEED):
			velocity.x = direction * SPEED
	elif direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle grab
	if !is_grabbing && \
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
		stamina = move_toward(stamina, MIN_STAMINA, STAMINA_LOSS_RATE * delta)
		if stamina == MIN_STAMINA:
			is_grabbing = false
			
	
	if !grab_detector.is_colliding():
		ignore_continued_grabbing = false
	
	if is_grabbing:
		velocity = Vector2.ZERO
	
	# Animation
	if is_grabbing:
		player_sprite.play("grab")
	elif !is_on_floor():
		player_sprite.play("jump")
	elif velocity.x != 0:
		player_sprite.play("run")
	else:
		player_sprite.play("idle")
	
	move_and_slide()


func _on_continued_grab_timer_timeout() -> void:
	ignore_continued_grabbing = false


func _respawn() -> void:
	global_position = respawn_position
	velocity = Vector2.ZERO
	is_grabbing = false
	was_on_floor = false
	player_sprite.play("respawn")
	await player_sprite.animation_finished
	is_dead = false


func _on_hit() -> void:
	if is_dead || is_entering_door:
		return
	is_dead = true
	player_sprite.play("death")
	await player_sprite.animation_finished
	_respawn()


func fell_beyond_map_edge() -> void:
	if is_dead || is_entering_door:
		return
	is_dead = true
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
