extends Reference
class_name JsonNode

var result = null

func _init(result) -> void:
    self.result = result

func is_array() -> bool:
    return (typeof(result) == TYPE_ARRAY)

func to_string() -> String:
    return JSON.print(result)

# Untyped return
func get_result():
    return result

func get_array() -> Array:
    return result as Array

func get_dictionary() -> Dictionary:
    return result as Dictionary
