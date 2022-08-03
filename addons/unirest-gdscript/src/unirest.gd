extends Node

func _request(url: String, method: int) -> HttpRequestWithBody:
    var http_request: HttpRequestWithBody = HttpRequestWithBody.new(url, method)
    add_child(http_request)
    return http_request

func options(url: String) -> HttpRequestWithBody:
    return _request(url, HTTPClient.METHOD_OPTIONS)

func head(url: String) -> HttpRequestWithBody:
    return _request(url, HTTPClient.METHOD_HEAD)

func get(url: String) -> HttpRequestWithBody:
    return _request(url, HTTPClient.METHOD_GET)

func post(url: String) -> HttpRequestWithBody:
    return _request(url, HTTPClient.METHOD_POST)

func put(url: String) -> HttpRequestWithBody:
    return _request(url, HTTPClient.METHOD_PUT)

func patch(url: String) -> HttpRequestWithBody:
    return _request(url, HTTPClient.METHOD_PATCH)

func delete(url: String) -> HttpRequestWithBody:
    return _request(url, HTTPClient.METHOD_DELETE)
