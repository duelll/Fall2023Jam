extends Area2D

@onready var Camera = get_tree().current_scene.get_node("MainCamera")
	
func _on_area_entered(area):
	if area.is_in_group("win"):
		get_tree().change_scene_to_file("res://Menus/EndScreen.tscn")
	if area.is_in_group("speedChange"):
		Camera.scroll_speed = area.newSpeed
