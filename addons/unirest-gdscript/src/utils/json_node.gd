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

func as_array() -> Array:
    if not is_array():
        printerr("Result is not an array!")
        return []
    var _res: Array = result
    return _res

func as_dictionary() -> Dictionary:
    if not is_dict():
        printerr("Result is not a dictionary!")
        return {}
    var _res: Dictionary = result
    return _res

func _to_string() -> String:
    return JSON.stringify(result)
