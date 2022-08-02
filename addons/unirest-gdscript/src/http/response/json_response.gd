extends BaseResponse
class_name JsonResponse

var body: JsonNode

func _parse_body(raw_body: PoolByteArray) -> void:
    var parse: JSONParseResult = JSON.parse(raw_body.get_string_from_utf8())
    if parse.error == OK:
        body = JsonNode.new(parse.result)

func _init(body: PoolByteArray, headers: PoolStringArray, status: int).(body, headers, status) -> void:
    pass

# Returns either an ARRAY or a DICTIONARY
func get_body() -> JsonNode:
    return body
