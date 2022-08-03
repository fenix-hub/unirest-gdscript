extends HTTPRequest
class_name BaseRequest

signal completed(http_response)

enum ResponseType {
    BINARY,
    STRING,
    DICTIONARY
}

var response_type: int
var content_type: String

var method: int = 0
var url: String = ""
var uri: String = ""
var headers: Dictionary = {}
var query_params: Dictionary = {}
var route_params: Dictionary = {}
var body: PoolByteArray = []
var verify_ssl: bool = false

func _init(url: String, method: int) -> void:
    connect("request_completed", self, "_on_http_request_completed")
    self.url = url
    self.method = method

func make_request() -> int:
    # URL
    var r_url: String = url.format(route_params)
    if !uri.empty():
        r_url += "/" + uri
    var query_string: String = Operations.query_string_from_dict(query_params)
    if !query_string.empty():
        r_url += "?" + query_string
    
    # BODY
    self.body = _parse_body()

    # HEADERS
    headers["Content-Type"] = self.content_type
    headers["Content-Length"] = self.body.size()

    return request_raw(
        r_url, 
        Operations.headers_from_dictionary(headers), 
        verify_ssl, 
        method, 
        body
    )

func _parse_body() -> PoolByteArray:
    return self.body

func as_binary_async() -> int:
    self.response_type = ResponseType.BINARY
    return make_request()
    
func as_binary() -> BaseRequest:
    as_binary_async()
    return self

func as_string_async() -> int:
    self.response_type = ResponseType.STRING
    return make_request()

func as_string() -> BaseRequest:
    as_string_async()
    return self

func as_json_async() -> int:
    self.response_type = ResponseType.DICTIONARY
    return make_request()

func as_json() -> BaseRequest:
    as_json_async()
    return self

func with_verify_ssl(verify_ssl: bool) -> BaseRequest:
    self.verify_ssl = verify_ssl
    return self

func _on_http_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
    match response_type:
        ResponseType.BINARY:
            emit_signal("completed", BaseResponse.new(body, headers, response_code))
        ResponseType.STRING:
            emit_signal("completed", StringResponse.new(body, headers, response_code))
        ResponseType.DICTIONARY:
            emit_signal("completed", JsonResponse.new(body, headers, response_code))
    queue_free()
