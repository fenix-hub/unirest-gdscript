extends Reference
class_name EmptyResponse

var headers: Dictionary
var status: int

func _init(headers: PoolStringArray, status: int) -> void:
    self.headers = Operations.dictionary_to_headers(headers)
    self.status = status

func get_headers() -> Dictionary:
    return headers

func get_status() -> int:
    return status
