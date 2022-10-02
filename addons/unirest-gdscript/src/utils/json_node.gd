extends RefCounted
class_name JsonNode

var result = null

func _init(result) -> void:
    self.result = result

func is_array() -> bool:
    return (typeof(result) == TYPE_ARRAY)

func is_dict() -> bool:
    return (typeof(result) == TYPE_DICTIONARY)

# Untyped return
func get_result():
    return result

func get_array() -> Array:
    assert(is_array(), "Result is not an array!")
    var _res: Array = result
    return _res

func get_dictionary() -> Dictionary:
    assert(is_dict(), "Result is not a dictionary!")
    var _res: Dictionary = result
    return _res

func _to_string() -> String:
    return JSON.stringify(result)
