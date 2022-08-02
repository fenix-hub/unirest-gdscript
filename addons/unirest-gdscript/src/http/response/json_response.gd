extends BaseResponse
class_name JsonResponse

var _body: JsonNode

func _parse_body(raw_body: PoolByteArray) -> void:
    var parse: JSONParseResult = JSON.parse(raw_body.get_string_from_utf8())
    if parse.error == OK:
        _body = JsonNode.new(parse.result)

func _init(body: PoolByteArray, headers: PoolStringArray, status: int).(body, headers, status) -> void:
    pass

func get_body() -> JsonNode:
    return _body
