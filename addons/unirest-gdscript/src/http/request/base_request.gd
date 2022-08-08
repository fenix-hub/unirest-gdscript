extends HTTPRequest
class_name BaseRequest

signal completed(http_response)

enum ResponseType {
    EMPTY,
    BINARY,
    STRING,
    UJSON,
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

func _init(url: String, method: int, uri: String = "", headers: Dictionary = {},
    query_params: Dictionary = {}, route_params: Dictionary = {}, body: PoolByteArray = []) -> void:
    connect("request_completed", self, "_on_http_request_completed")
    self.url = url
    self.method = method
    self.uri = uri
    self.headers = headers
    self.query_params = query_params
    self.route_params = route_params
    self.body = body

func make_request() -> int:
    # URL
    var _url: String = url.format(route_params)
    if !uri.empty():
        _url += "/" + uri
    var query_string: String = Operations.query_string_from_dict(query_params)
    if !query_string.empty():
        _url += "?" + query_string
    
    # BODY
    self.body = _parse_body()

    # HEADERS
    self.headers["Content-Type"] = self.content_type
    self.headers["Content-Length"] = self.body.size()
    
    var _headers: PoolStringArray = Operations.headers_from_dictionary(headers)
    
    return request_raw(
        _url, 
        _headers, 
        verify_ssl, 
        method, 
        body
    )

func _parse_body() -> PoolByteArray:
    return self.body


func as_empty_async() -> int:
    self.response_type = ResponseType.EMPTY
    return make_request()

func as_empty() -> BaseRequest:
    as_empty_async()
    return self

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
    self.response_type = ResponseType.UJSON
    return make_request()

func as_json() -> BaseRequest:
    as_json_async()
    return self


func with_verify_ssl(verify_ssl: bool = false) -> BaseRequest:
    self.verify_ssl = verify_ssl
    return self

func using_threads(use_threads: bool = false) -> BaseRequest:
    self.use_threads = use_threads
    return self

func _on_http_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
    match response_type:
        ResponseType.EMPTY:
            emit_signal("completed", EmptyResponse.new(headers, response_code))
        ResponseType.BINARY:
            emit_signal("completed", BaseResponse.new(body, headers, response_code))
        ResponseType.STRING:
            emit_signal("completed", StringResponse.new(body, headers, response_code))
        ResponseType.UJSON:
            emit_signal("completed", JsonResponse.new(body, headers, response_code))
    queue_free()
