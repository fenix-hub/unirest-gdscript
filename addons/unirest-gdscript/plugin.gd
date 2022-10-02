@tool
extends EditorPlugin

func _enter_tree() -> void:
    add_autoload_singleton("Unirest", "res://addons/unirest-gdscript/src/unirest.gd")


func _exit_tree() -> void:
    remove_autoload_singleton("Unirest")
