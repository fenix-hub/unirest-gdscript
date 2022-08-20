extends BaseResponse
class_name JsonResponse

var _body: JsonNode = null

func _parse_body(raw_body: PoolByteArray) -> void:
    var parse: JSONParseResult = JSON.parse(raw_body.get_string_from_utf8())
    if parse.error == OK:
        self._body = JsonNode.new(parse.result)
    else:
        self.error.cause = UnirestError.Cause.PARSING
        self.error.message = "error while parsing the response"
        self.error.body = JSON.print(({
            code = parse.error,
            line = parse.error_line,
            string = parse.error_string
           })).to_utf8()

func _init(body: PoolByteArray, headers: PoolStringArray, status: int).(body, headers, status) -> void:
    pass

func get_body() -> JsonNode:
    return self._body

func _to_string() -> String:
    return ._to_string().format({
        body = self._body
       })
