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

func _init(base_request: BaseRequest) -> void:
    super(
        base_request.uri, base_request.method, base_request._headers,
        base_request.query_params, base_request.route_params, base_request._body
    )

func field(name: String, value: String, filename: String = "") -> MultipartRequest:
    self.fields.append(MultipartField.new(name, value, filename))
    return self

func _parse_body() -> PackedByteArray:
    self.content_type = "multipart/form-data; boundary=" + boundary
    var body: String = ""
    for field in fields:
        body += "--%s\n" % boundary
        body += "Content-Disposition: form-data; name=" + field.name
        if !field.filename.empty():
            body += "; filename=" + field.filename
        body += "\n\n%s\n" % field.value
    body += "--%s--" % boundary
    return body.to_utf8_buffer()
