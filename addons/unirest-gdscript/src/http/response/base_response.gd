extends EmptyResponse
class_name BaseResponse

var raw_body: PackedByteArray

func _init(
    body: PackedByteArray, headers: PackedStringArray, status: int, 
    code: int, props: Dictionary = {}
    ) -> void:
    super(headers, status, code, body, props)
    if code == 0:
        self.raw_body = body
        _parse_body(raw_body)

# @override
func _parse_body(body: PackedByteArray) -> void:
    pass

func get_body():
    return raw_body
