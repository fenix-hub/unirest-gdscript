tool
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
var proxying: bool = false

onready var http_log_format: HttpLogFormat = get_parent().config().http_log_format
onready var http_proxy: HttpProxy = get_parent().config().http_proxy

var proxy_host: String
var proxy_port: int

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

func _ready() -> void:
    # Check if proxy is enabled from configuration
    proxy(http_proxy.host, http_proxy.port)
    if !(http_proxy.username.empty() and http_proxy.password.empty()):
        self.headers["Proxy-Authorization"] = \
        "Basic %s" % UniOperations.basic_auth_str(http_proxy.username, http_proxy.password)

func make_request() -> int:
    # URL
    var _url: String = UniOperations.get_full_url(url, uri, route_params, query_params)
    
    # BODY
    self.body = _parse_body()

    # HEADERS
    self.headers["Content-Type"] = self.content_type
    self.headers["Content-Length"] = self.body.size()
    
    var _headers: PoolStringArray = UniOperations.headers_from_dictionary(headers)
    
    set_meta("t0_ttr", Time.get_ticks_msec())
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

func proxy(host: String, port: int) -> BaseRequest:
    self.proxying = !(host.empty() and port == -1)
    self.proxy_host = host
    self.proxy_port = port
    if url.begins_with("https"):
        set_https_proxy(host, port)
    else:
        set_http_proxy(host, port)
    return self

func with_verify_ssl(verify_ssl: bool = false) -> BaseRequest:
    self.verify_ssl = verify_ssl
    return self

func using_threads(use_threads: bool = false) -> BaseRequest:
    self.use_threads = use_threads
    return self

func _on_http_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
    var ttr: int = Time.get_ticks_msec() - get_meta("t0_ttr")
    var response: EmptyResponse
    match response_type:
        ResponseType.EMPTY:
            response = EmptyResponse.new(headers, response_code)
        ResponseType.BINARY:
            response = BaseResponse.new(body, headers, response_code)
        ResponseType.STRING:
            response = StringResponse.new(body, headers, response_code)
        ResponseType.UJSON:
            response = JsonResponse.new(body, headers, response_code)
    response.set_meta("ttr", ttr)
    emit_signal("completed", response)
    queue_free()

func _to_string() -> String:
    return http_log_format.request \
    .format({
        host = IP.get_local_addresses()[0] if !proxying else proxy_host,
        date = Time.get_datetime_string_from_system(),
        method = UniOperations.http_method_int_to_string(method),
        URL = UniOperations.get_full_url(url, uri, route_params, query_params),
        query = UniOperations.query_string_from_dict(query_params),
        protocol = "HTTP/1.0",
        bytes = body.size(),
        agent = "Unirest/1.0 (Godot Engine %s)" % Engine.get_version_info().hex 
       })
