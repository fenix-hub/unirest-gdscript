extends BaseRequest
class_name MultipartRequest

class MultipartField:
    var name: String = ""
    var filename: String = ""
    var value: String = ""

    func _init(name: String, value: String, filename: String = "") -> void:
        self.name = name
        self.value = value
        self.filename = filename

const boundary: String = "gdunirest"

var fields: Array = []

func _init(base_request: BaseRequest) \
    .(base_request.url, base_request.method, base_request.uri, base_request.headers, \
    base_request.query_params, base_request.route_params, base_request.body) -> void:
        pass
    
func basic_auth(username: String, password: String) -> MultipartRequest:
    self.headers["Authorization"] = "Basic " + Marshalls.utf_to_base64("%s:%s" % [username, password])
    return self

func bearer_auth(token: String) -> MultipartRequest:
    self.headers["Authorization"] = "Bearer " + token
    return self

func field(name: String, value: String, filename: String = "") -> MultipartRequest:
    self.fields.append(MultipartField.new(name, value, filename))
    return self

func _parse_body() -> PoolByteArray:
    self.content_type = "multipart/form-data; boundary=" + boundary
    var body: String = ""
    for field in fields:
        body += "--%s\n" % boundary
        body += "Content-Disposition: form-data; name=" + field.name
        if !field.filename.empty():
            body += "; filename=" + field.filename
        body += "\n\n%s\n" % field.value
    body += "--%s--" % boundary
    return body.to_utf8()
