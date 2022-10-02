extends BaseRequest
class_name HttpRequestWithBody

func _init(uri: String, method: int) -> void:
    super(uri, method)

func body(body: Object) -> HttpRequestWithBody:
    return dict_body(UniOperations.class_to_json(body))

func raw_body(body: PackedByteArray, content_type: String = "application/octet-stream") -> HttpRequestWithBody:
    self.content_type = content_type
    self._body = body
    return self

func str_body(string_body: String, content_type: String = "text/plain") -> HttpRequestWithBody:
    return raw_body(string_body.to_utf8_buffer(), content_type)

func dict_body(dictionary_body: Dictionary) -> HttpRequestWithBody:
    return str_body(str(dictionary_body), "application/json")

func field(name: String, value: String, filename: String = "") -> MultipartRequest:
    return MultipartRequest.new(self as BaseRequest).field(name, value, filename)
