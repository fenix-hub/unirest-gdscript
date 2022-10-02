@tool
extends HTTPRequest
class_name BaseRequest

signal completed(http_response)

enum ResponseType {
    EMPTY,
    BINARY,
    STRING,
    UJSON,
    OBJECT,
}

var http_log_format: HttpLogFormat
var http_proxy: HttpProxy

var response_type: ResponseType
var content_type: String

var method: int = 0
var uri: String = ""
var _headers: Dictionary = {}
var _body: PackedByteArray = []
var query_params: Dictionary = {}
var route_params: Dictionary = {}
var verify_ssl: bool = false

func _init(
    uri: String, method: int, _headers: Dictionary = {},
    query_params: Dictionary = {}, route_params: Dictionary = {}, _body: PackedByteArray = PackedByteArray([])
    ) -> void:
        request_completed.connect(_on_http_request_completed)
        self.uri = uri
        self.method = method
        self._headers = _headers
        self.query_params = query_params
        self.route_params = route_params
        self._body = _body 

func _ready() -> void:
    http_proxy = get_parent().config.http_proxy
    http_log_format = get_parent().config.http_log_format
        
    # Check if proxy is enabled from configuration
    if (http_proxy.host != null and http_proxy.port != null):
        proxy(http_proxy.host, http_proxy.port)
        if !(http_proxy.username.is_empty() and http_proxy.password.is_empty()):
            self._headers["Proxy-Authorization"] = \
            "Basic %s" % UniOperations.basic_auth_str(http_proxy.username, http_proxy.password)
    
    # Base Url
    if not get_parent().config.default_base_url.is_empty():
        set_meta("base_url", get_parent().config.default_base_url)

func _get_url() -> String:
    return (get_meta("base_url", "") + uri)

func make_request(response_type: ResponseType) -> int:
    self.response_type = response_type
    
    # URL
    var URL: String = UniOperations.get_full_url(
        _get_url(), route_params, query_params
    )
    
    # PROXY
    if get_meta("proxying", false):
        if URL.begins_with("https"):
            set_https_proxy(get_meta("proxy_host"), get_meta("proxy_port"))
        else:
            set_http_proxy(get_meta("proxy_host"), get_meta("proxy_port"))
    
    # _body
    self._body = _parse_body()

    # _headers
    self._headers["Content-Type"] = self.content_type
    self._headers["Content-Length"] = self._body.size()
    
    var headers: PackedStringArray = UniOperations.headers_from_dictionary(_headers)
    
    set_meta("t0_ttr", Time.get_ticks_msec())
    return request_raw(
        URL, 
        headers, 
        verify_ssl, 
        method, 
        self._body
    )

func _parse_body() -> PackedByteArray:
    return self._body

func _as(type: ResponseType) -> BaseResponse:
    make_request(type)
    return await completed

func _as_async(type: ResponseType, callback: Callable = Callable()) -> BaseRequest:
    if not callback.is_null():
        self.completed.connect(callback, Object.ConnectFlags.CONNECT_ONE_SHOT)
    make_request(type)
    return self
    

## EMPTY
func as_empty() -> EmptyResponse:
    return await _as(ResponseType.EMPTY)

func as_empty_async(callback: Callable = Callable()) -> BaseRequest:
    return _as_async(ResponseType.EMPTY, callback)


## BINARY
func as_binary() -> BaseResponse:
    return await _as(ResponseType.BINARY)

func as_binary_async(callback: Callable = Callable()) -> BaseRequest:
    return _as_async(ResponseType.BINARY, callback)


## STRING
func as_string() -> StringResponse:
    return await _as(ResponseType.STRING)

func as_string_async(callback: Callable = Callable()) -> BaseRequest:
    return _as_async(ResponseType.STRING, callback)


## JSON
func as_json() -> JsonResponse:
    return await _as(ResponseType.UJSON)

func as_json_async(callback: Callable = Callable()) -> BaseRequest:
    return _as_async(ResponseType.UJSON, callback)


## OBJECT
func as_object(object: Object) -> ObjectResponse:
    set_meta("object", object)
    return await _as(ResponseType.OBJECT)

func as_object_async(object: Object, callback: Callable = Callable()) -> BaseRequest:
    set_meta("object", object)
    return _as_async(ResponseType.OBJECT, callback)



func proxy(host: String, port: int) -> BaseRequest:
    set_meta("proxying", !(host.is_empty() and port == -1))
    set_meta("proxy_host", host)
    set_meta("proxy_port", port)
    return self

func with_verify_ssl(verify_ssl: bool = false) -> BaseRequest:
    self.verify_ssl = verify_ssl
    return self

func using_threads(use_threads: bool = false) -> BaseRequest:
    self.use_threads = use_threads
    return self

func _on_http_request_completed(result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
    var ttr: int = Time.get_ticks_msec() - get_meta("t0_ttr")
    var response: EmptyResponse
    match response_type:
        ResponseType.EMPTY:
            response = EmptyResponse.new(_headers, response_code, result, _body)
        ResponseType.BINARY:
            response = BaseResponse.new(_body, _headers, response_code, result)
        ResponseType.STRING:
            response = StringResponse.new(_body, _headers, response_code, result)
        ResponseType.UJSON:
            response = JsonResponse.new(_body, _headers, response_code, result)
        ResponseType.OBJECT:
            response = ObjectResponse.new(_body, _headers, response_code, result, get_meta("object"))
    response.set_meta("ttr", ttr)
    response.set_meta("host", UniOperations.get_host(_get_url()))
    response.set_meta("log_format", http_log_format.response)
    emit_signal("completed", response)
    queue_free()

func _to_string() -> String:
    return http_log_format.request \
    .format({
        host = IP.get_local_addresses()[0] if !get_meta("proxying") else get_meta("proxy_host"),
        date = Time.get_datetime_string_from_system(),
        method = UniOperations.http_method_int_to_string(method),
        URL = UniOperations.get_full_url(_get_url(), route_params, query_params),
        query = UniOperations.query_string_from_dict(query_params),
        protocol = "HTTP/1.1",
        bytes = _body.size(),
        agent = "Unirest/1.2 (Godot Engine %s)" % Engine.get_version_info().hex 
       })


##### SHARED METHODS ####
func basic_auth(username: String, password: String) -> GetRequest:
    header("Authorization", "Basic " + UniOperations.basic_auth_str(username, password))
    return self

func bearer_auth(token: String) -> GetRequest:
    header("Authorization", "Bearer " + token)
    return self

func header(name: String, value: String) -> GetRequest:
    _headers[name] = value
    return self

func headers(headers: Dictionary) -> GetRequest:
    _headers = headers
    return self

func query_string(name: String, value) -> GetRequest:
    self.query_params[name] = value
    return self

func route_param(name: String, value: String) -> GetRequest:
    self.route_params[name] = value
    return self
