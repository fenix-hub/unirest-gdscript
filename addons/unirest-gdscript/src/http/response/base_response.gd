extends Reference
class_name BaseResponse

var raw_body: PoolByteArray
var headers: PoolStringArray
var status: int

func _init(body: PoolByteArray, headers: PoolStringArray, status: int) -> void:
    self.raw_body = body
    self.headers = headers
    self.status = status
    _parse_body(raw_body)

# This function should be overridden
func _parse_body(body: PoolByteArray) -> void:
    pass
