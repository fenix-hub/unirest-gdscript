extends BaseResponse
class_name StringResponse

var _body: String

func _parse_body(raw_body: PoolByteArray) -> void:
    _body = raw_body.get_string_from_utf8()

func _init(body: PoolByteArray, headers: PoolStringArray, status: int).(body, headers, status) -> void:
    pass

func get_body() -> String:
    return _body

func _to_string() -> String:
    return ._to_string().format({
        body = self._body
       })
