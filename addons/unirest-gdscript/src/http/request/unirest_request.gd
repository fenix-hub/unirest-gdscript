extends BaseRequest
class_name UnirestRequest

func _init(url: String, method: int).(url, method) -> void:
    pass

func basic_auth(username: String, password: String) -> UnirestRequest:
    headers["Authorization"] = Marshalls.utf_to_base64("Basic %s:%s" % [username, password])
    return self

func bearer_auth(token: String) -> UnirestRequest:
    headers["Authorization"] = Marshalls.utf_to_base64("Bearer %s" % token)
    return self

func body(body: PoolByteArray) -> UnirestRequest:
    self.body = body
    return self

func str_body(string_body: String) -> UnirestRequest:
    return body(string_body.to_utf8())

func dict_body(dictionary_body: Dictionary) -> UnirestRequest:
    return str_body(String(dictionary_body))

func field() -> void:
    pass

func header(name: String, value: String) -> UnirestRequest:
    headers[name] = value
    return self

func headers(headers: Dictionary) -> UnirestRequest:
    self.headers = headers
    return self

func query_string(name: String, value) -> UnirestRequest:
    query_params[name] = value
    return self

func route_param(name: String, value: String) -> UnirestRequest:
    route_params[name] = value
    return self
