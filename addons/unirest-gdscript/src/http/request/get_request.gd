extends BaseRequest
class_name GetRequest

func _init(url: String, method: int).(url, method) -> void:
    pass

func basic_auth(username: String, password: String) -> GetRequest:
    self.headers["Authorization"] = "Basic " + UniOperations.basic_auth_str(username, password)
    return self

func bearer_auth(token: String) -> GetRequest:
    self.headers["Authorization"] = "Bearer " + token
    return self

func header(name: String, value: String) -> GetRequest:
    self.headers[name] = value
    return self

func headers(headers: Dictionary) -> GetRequest:
    self.headers = headers
    return self

func query_string(name: String, value) -> GetRequest:
    self.query_params[name] = value
    return self

func route_param(name: String, value: String) -> GetRequest:
    self.route_params[name] = value
    return self
