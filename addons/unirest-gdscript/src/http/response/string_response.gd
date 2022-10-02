extends BaseResponse
class_name StringResponse

var _body: String

func _parse_body(raw_body: PackedByteArray) -> void:
    _body = raw_body.get_string_from_utf8()

func _init(body: PackedByteArray, headers: PackedStringArray, status: int, code: int) -> void:
    super(body, headers, status, code)

func get_body() -> String:
    return _body

func _to_string() -> String:
    return super._to_string().format({
        body = self._body
    })
