extends BaseResponse
class_name ObjectResponse

var _dict: Dictionary = {}
var _body: Object = null

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
        _dict = json.data
        _body = UniOperations.json_to_class(_dict, self.props.obj)

func _init(
    body: PackedByteArray, headers: PackedStringArray, 
    status: int, code: int, obj: Object
    ) -> void:
        super(body, headers, status, code, { obj = obj })

func get_dict() -> Dictionary:
    return self._dict

func get_body() -> Object:
    return self._body

func _to_string() -> String:
    return super._to_string().format({
        body = self._obj
    })
