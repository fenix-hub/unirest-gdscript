extends BaseResponse
class_name JsonResponse

var _body: JsonNode = null

func _parse_body(raw_body: PackedByteArray) -> void:
    var json: JSON = JSON.new()
    var err: int = json.parse(raw_body.get_string_from_utf8())
    if err != OK:
        var cause: Dictionary = {
            code = err,
            line = json.get_error_line(),
            string = json.get_error_message()
        }
        self.error = UnirestError.new(
            cause,
            "error while parsing the response",
            raw_body.get_string_from_utf8()
        )
    else:
        _body = JsonNode.new(json.data)

func _init(body: PackedByteArray, headers: PackedStringArray, status: int, code: int) -> void:
    super(body, headers, status, code)

func get_body() -> JsonNode:
    return self._body

func _to_string() -> String:
    return super._to_string().format({
        body = self._body
       })
