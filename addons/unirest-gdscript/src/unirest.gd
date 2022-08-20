tool
extends Node

var configuration: UnirestConfiguration

func _ready() -> void:
    var conf: UnirestConfiguration = load("res://addons/unirest-gdscript/src/configuration/configuration.tres")
    configuration = UnirestConfiguration.new(conf.http_log_format, conf.http_proxy, conf.default_base_url)

func _get_request(url: String, method: int) -> GetRequest:
    var http_request: GetRequest = GetRequest.new(url, method)
    add_child(http_request)
    return http_request
    
func _http_request(url: String, method: int) -> HttpRequestWithBody:
    var http_request: HttpRequestWithBody = HttpRequestWithBody.new(url, method)
    add_child(http_request)
    return http_request

func options(url: String) -> HttpRequestWithBody:
    return _http_request(url, HTTPClient.METHOD_OPTIONS)

func head(url: String) -> GetRequest:
    return _get_request(url, HTTPClient.METHOD_HEAD)

func get(url: String) -> GetRequest:
    return _get_request(url, HTTPClient.METHOD_GET)

func post(url: String) -> HttpRequestWithBody:
    return _http_request(url, HTTPClient.METHOD_POST)

func put(url: String) -> HttpRequestWithBody:
    return _http_request(url, HTTPClient.METHOD_PUT)

func patch(url: String) -> HttpRequestWithBody:
    return _http_request(url, HTTPClient.METHOD_PATCH)

func delete(url: String) -> HttpRequestWithBody:
    return _http_request(url, HTTPClient.METHOD_DELETE)

func config() -> UnirestConfiguration:
    return configuration
