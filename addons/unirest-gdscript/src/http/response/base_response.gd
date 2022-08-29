extends EmptyResponse
class_name BaseResponse

var raw_body: PoolByteArray

func _init(body: PoolByteArray, headers: PoolStringArray, status: int, code: int, props: Dictionary = {}) \
.(headers, status, code, body, props) -> void:
    if code == 0:
        self.raw_body = body
        _parse_body(raw_body)

# @override
func _parse_body(body: PoolByteArray) -> void:
    pass

func get_body():
    return raw_body
