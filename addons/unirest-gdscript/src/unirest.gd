extends Node

func _request(url: String, method: int) -> UnirestRequest:
    var ur: UnirestRequest = UnirestRequest.new(url, method)
    add_child(ur)
    return ur

func options(url: String) -> UnirestRequest:
    return _request(url, HTTPClient.METHOD_OPTIONS)

func head(url: String) -> UnirestRequest:
    return _request(url, HTTPClient.METHOD_HEAD)

func Get(url: String) -> UnirestRequest:
    return _request(url, HTTPClient.METHOD_POST)

func post(url: String) -> UnirestRequest:
    return _request(url, HTTPClient.METHOD_POST)

func put(url: String) -> UnirestRequest:
    return _request(url, HTTPClient.METHOD_PUT)

func patch(url: String) -> UnirestRequest:
    return _request(url, HTTPClient.METHOD_PATCH)

func delete(url: String) -> UnirestRequest:
    return _request(url, HTTPClient.METHOD_DELETE)
