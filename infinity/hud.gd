extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	print("show_game_over() called in hud.gd")
	show_message("Game Over")
	await $MessageTimer.timeout  # Wait for the timer to finish
	await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds before showing the start button
	$StartButton.show()  # Show the start button after the delay

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
