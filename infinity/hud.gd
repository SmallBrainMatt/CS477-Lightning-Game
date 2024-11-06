extends CanvasLayer

signal start_game
# No need to use back_to_start signal

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	print("show_game_over() called in hud.gd")
	show_message("Game Over")
	await $MessageTimer.timeout
	await get_tree().create_timer(2.0).timeout
	$StartButton.show()
	$BackToStartButton.hide()

# Function called when the "Start" button is pressed
func _on_start_button_pressed():
	$StartButton.hide()
	$BackToStartButton.show()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()

func _ready() -> void:
	$BackToStartButton.hide()
