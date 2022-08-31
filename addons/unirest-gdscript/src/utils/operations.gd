extends Reference
class_name UniOperations

static func http_method_int_to_string(method: int) -> String:
    var str_method: String = ""
    match method:
        HTTPClient.METHOD_HEAD:
            str_method = "HEAD"
        HTTPClient.METHOD_OPTIONS:
            str_method = "OPTIONS"
        HTTPClient.METHOD_DELETE:
            str_method = "DELETE"
        HTTPClient.METHOD_PATCH:
            str_method = "PATCH"
        HTTPClient.METHOD_PUT:
            str_method = "PUT"
        HTTPClient.METHOD_POST:
            str_method = "POST"
        HTTPClient.METHOD_TRACE:
            str_method = "TRACE"
        HTTPClient.METHOD_GET, _:
            str_method = "GET"
    return str_method

static func basic_auth_str(username: String, password: String) -> String:
    return Marshalls.utf_to_base64("%s:%s" % [username, password])

static func get_host(url: String) -> String:
    var host: String = url.split("/")[2]
    return host

static func resolve_host(host: String) -> String:
    return IP.resolve_hostname(host) if !(":" in host) else host.right(5)

static func get_full_url(base_url: String, route_params: Dictionary = {}, query_params: Dictionary = {}) -> String:
    var URL: String = base_url.format(route_params)
    var query_string: String = query_string_from_dict(query_params)
    if !query_string.empty():
        URL += "?" + query_string
    return URL

static func headers_from_dictionary(headers: Dictionary) -> PoolStringArray:
    var array: Array = []
    for key in headers.keys():
        array.append("%s: %s" % [key, headers.get(key)])
    return PoolStringArray(array)

static func dictionary_to_headers(headers: PoolStringArray) -> Dictionary:
    var dictionary: Dictionary = {}
    for header in headers:
        var kv: Array = header.split(": ")
        var name: String = kv[0]
        var value = kv[1]
        if (value.begins_with("{") and value.ends_with("}")) \
        or (value.begins_with("[") and value.ends_with("]")):
            var parse: JSONParseResult = JSON.parse(value)
            if parse.error == OK:
                value = parse.result
        dictionary[name] = value
    return dictionary

static func query_array_from_dict(query: Dictionary) -> PoolStringArray:
    var array: Array = []
    for key in query.keys():
        match typeof(query[key]):
            TYPE_ARRAY:
                for value in query.get(key):
                    array.append("%s=%s" % [key, value])
            TYPE_DICTIONARY:
                for k_key in query.get(key).keys():
                    array.append("%s=%s" % [k_key, ])
            _:
                array.append("%s=%s" % [key, query.get(key)])
    return PoolStringArray(array)

static func query_string_from_dict(query: Dictionary) -> String:
    return query_array_from_dict(query).join("&")

static func json_to_class(json: Dictionary, _class: Object) -> Object:
    var properties: Array = _class.get_property_list()
    for key in json.keys():
        for property in properties:
            if property.name == key and property.usage >= (1 << 13):
                if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
                    _class.set(key, json_to_class(json[key], _class.get(key)))
                else:
                    _class.set(key, json[key])
                break
            if key == property.hint_string and property.usage >= (1 << 13):
                if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
                    _class.set(property.name, json_to_class(json[key], _class.get(key)))
                else:
                    _class.set(property.name, json[key])
                break
    return _class

static func class_to_json(_class: Object) -> Dictionary:
    var dictionary: Dictionary = {}
    var properties: Array = _class.get_property_list()
    for property in properties:
        if not property["name"].empty() and property.usage >= (1 << 13):
            if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
                dictionary[property.name] = class_to_json(_class.get(property.name))
            else:
                dictionary[property.name] = _class.get(property.name)
        if not property["hint_string"].empty() and property.usage >= (1 << 13):
            if (property["class_name"] in ["Reference", "Object"] and property["type"] == 17):
                dictionary[property.hint_string] = class_to_json(_class.get(property.name))
            else:
                dictionary[property.hint_string] = _class.get(property.name)
    return dictionary
