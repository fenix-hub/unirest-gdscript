extends BaseRequest
class_name MultipartRequest

class_name MultipartField:
    var name: String = ""
    var filename: String = ""
    var value: String = ""

    func _init(name: String, value: String, filename: String = "") -> void:
        self.name = name
        self.value = value
        self.filename = filename

const boundary: String = "gdunirest"

var fields: Array = []

func _init(url: String, method: int).(url, method) -> void:
    pass

func field(name: String, value: String, filename: String = "") -> MultipartRequest:
    fields.append([MultipartField.new(name, value, filename)])
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