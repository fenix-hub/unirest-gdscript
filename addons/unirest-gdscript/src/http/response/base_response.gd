extends Reference
class_name BaseResponse

var raw_body: PoolByteArray
var headers: Dictionary
var status: int

func _init(body: PoolByteArray, headers: PoolStringArray, status: int) -> void:
    self.raw_body = body
    self.headers = Operations.dictionary_to_headers(headers)
    self.status = status
    _parse_body(raw_body)

# @override
func _parse_body(body: PoolByteArray) -> void:
    pass

func get_headers() -> Dictionary:
    return headers

func get_status() -> int:
    return status
