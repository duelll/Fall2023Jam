extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Game/Levels/Level1.tscn")# Replace with function body.# Replace with function body.


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Menus/credits.tscn")
	
func _on_quit_pressed():
	get_tree().quit() 
