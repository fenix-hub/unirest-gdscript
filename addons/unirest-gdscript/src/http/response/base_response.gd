extends EmptyResponse
class_name BaseResponse

var raw_body: PoolByteArray

func _init(body: PoolByteArray, headers: PoolStringArray, status: int).(headers, status) -> void:
    self.raw_body = body
    _parse_body(raw_body)
    self.error.body = raw_body

# @override
func _parse_body(body: PoolByteArray) -> void:
    pass

func get_body():
    return raw_body
