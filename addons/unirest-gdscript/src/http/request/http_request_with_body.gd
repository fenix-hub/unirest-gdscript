extends BaseRequest
class_name HttpRequestWithBody

func _init(uri: String, method: int).(uri, method) -> void:
    pass

func basic_auth(username: String, password: String) -> HttpRequestWithBody:
    self.headers["Authorization"] = "Basic " + UniOperations.basic_auth_str(username, password)
    return self

func bearer_auth(token: String) -> HttpRequestWithBody:
    self.headers["Authorization"] = "Bearer " + token
    return self

func body(body: PoolByteArray, content_type: String = "application/octet-stream") -> HttpRequestWithBody:
    self.content_type = content_type
    self.body = body
    return self

func str_body(string_body: String, concent_type: String = "text/plain") -> HttpRequestWithBody:
    return body(string_body.to_utf8(), concent_type)

func dict_body(dictionary_body: Dictionary) -> HttpRequestWithBody:
    return str_body(String(dictionary_body), "application/json")

func field(name: String, value: String, filename: String = "") -> MultipartRequest:
    return MultipartRequest.new(self as BaseRequest).field(name, value, filename)

func header(name: String, value: String) -> HttpRequestWithBody:
    self.headers[name] = value
    return self

func headers(headers: Dictionary) -> HttpRequestWithBody:
    self.headers = headers
    return self

func query_string(name: String, value) -> HttpRequestWithBody:
    self.query_params[name] = value
    return self

func route_param(name: String, value: String) -> HttpRequestWithBody:
    self.route_params[name] = value
    return self
