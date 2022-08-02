extends HTTPRequest
class_name BaseRequest

signal completed(http_response)


enum ResponseType {
    BINARY,
    STRING,
    DICTIONARY
}

var response_type: int

var method: int = 0
var url: String = ""
var uri: String = ""
var headers: Dictionary = {}
var query_params: Dictionary = {}
var route_params: Dictionary = {}
var fields: Dictionary = {}
var body: PoolByteArray = []

func _init(url: String, method: int) -> void:
    connect("request_completed", self, "_on_http_request_completed")
    self.url = url
    self.method = method

func make_request() -> int:
    var r_url: String = url.format(route_params)
    if !uri.empty():
        r_url += "/" + uri
    var query_string: String = Operations.query_string_from_dict(query_params)
    if !query_string.empty():
        r_url += "?" + query_string
    return request_raw(
        r_url, 
        Operations.headers_from_dictionary(headers), 
        true, 
        method, 
        body
    )

func as_binary_async() -> void:
    response_type = ResponseType.BINARY
    make_request()
    
func as_binary() -> BaseRequest:
    as_binary_async()
    return self

func as_json_async() -> void:
    response_type = ResponseType.DICTIONARY
    make_request()

func as_json() -> BaseRequest:
    as_json_async()
    return self

func as_string_async() -> void:
    response_type = ResponseType.STRING
    make_request()

func as_string() -> BaseRequest:
    as_string_async()
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
