extends Area2D

@export var speed = 400
@export var max_health = 100
var current_health
var bullet = preload("res://bullet.tscn")
var bullet_speed = 2000
var screen_size
signal hit
var can_fire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	can_fire = false
	current_health = max_health  # Initialize health to maximum value
	get_parent().get_node("HUD/ProgressBar").value = current_health  # Update the health bar value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO

	# Movement
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_just_pressed("player_fire") and can_fire == true:
		fire()

	# Play/stop animations (if there are any)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	look_at(get_global_mouse_position())

# Handles taking damage
func take_damage(amount: int) -> void:
	current_health -= amount
	print("Current Health after taking damage: ", current_health)  # Debugging line

	# Ensure current_health doesn't drop below zero
	if current_health <= 0:
		current_health = 0
		die()  # Call die() only when health reaches 0
	else:
		get_parent().get_node("HUD/ProgressBar").value = current_health  # Update the health bar if not dead

# Called when the player gets hit
func _on_body_entered(body: Node2D) -> void:
	print("Collision detected with: ", body, " of type: ", body.get_class())  # Debugging line

	# Check if the collision is with a mob by group
	if body.is_in_group("mobs"):
		print("Collision with mob detected.")
		take_damage(20)  # Adjust the damage amount as needed
		can_fire = true  # Allow the player to keep firing after getting hit
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", false)  # Ensure collision is enabled for future hits

# Handles player death
func die() -> void:
	print("die() function called with health: ", current_health)  # Debugging line
	if current_health == 0:  # Ensure die() only runs when health is zero
		print("Player has died with health at 0.")  # Debugging confirmation line
		hide()  # Hide the player when they die
		can_fire = false
		get_parent().get_node("HUD/ProgressBar").value = current_health  # Update the health bar to zero
		get_parent().get_node("HUD").show_game_over() # Trigger game over sequence in the main script
	else :
		print("die() function attempted to run, but health is not 0: ", current_health)

# Starts the game
func start(pos):
	position = pos
	show()
	can_fire = true
	$CollisionShape2D.disabled = false
	current_health = max_health  # Reset health when the game starts
	get_parent().get_node("HUD/ProgressBar").value = current_health  # Reset the health bar value

# Shoots the gun
func fire():
	$Pew.play()
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.position = get_global_position()
	bullet_instance.linear_velocity = Vector2(bullet_speed, 0).rotated(rotation)
	get_tree().get_root().add_child(bullet_instance)
