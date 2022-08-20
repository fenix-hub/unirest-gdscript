extends Reference
class_name UnirestError

enum Cause {
    NONE
    REQUEST
    PARSING
   }

var cause: int
var message: String
var body: PoolByteArray

func _init(cause: int = Cause.NONE, message: String = "", body: PoolByteArray = []) -> void:
    self.cause = cause
    self.message = message
    self.body = body

func body_as_string() -> String:
    return body.get_string_from_utf8()

func body_as_json() -> JsonNode:
    var parse: JSONParseResult = JSON.parse(body.get_string_from_utf8())
    if !parse.error:
        return JsonNode.new(parse.result)
    else:
        return null
