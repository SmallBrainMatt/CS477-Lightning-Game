extends Node

@export var mob_scene: PackedScene
var score
var spawn_wait_time = 2
var speed_range_min = 150
var speed_range_max = 250

# Function to return to the start menu
func return_to_start_menu():
	print("Returning to start menu...")
	$Player.hide()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_message("Press Start to Begin")
	
	# Attempt to show StartButton and hide BackToStartButton
	if $HUD.has_node("StartButton") and $HUD.has_node("BackToStartButton"):
		$HUD.get_node("StartButton").show()
		$HUD.get_node("BackToStartButton").hide()
	else:
		print("Error: StartButton or BackToStartButton not found.")

# Begins the game
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_message("Get Ready")

func _on_start_timer_timeout():
	$MobTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(randf_range(speed_range_min, speed_range_max), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Optional: Connect button signals here if not done in the editor
	pass

# Function for Back to Start button
func _on_back_to_start_button_pressed() -> void:
	print("Back to Start button clicked")  # Debugging statement
	$HUD.get_node("StartButton").show()  # Show the start button
	$HUD.get_node("BackToStartButton").hide()  # Hide the back to start button
	return_to_start_menu()
