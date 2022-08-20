extends Reference
class_name UniOperations

static func http_method_int_to_string(method: int) -> String:
    var str_method: String = "GET"
    match method:
        HTTPClient.METHOD_HEAD:
            str_method = "HEAD"
        HTTPClient.METHOD_GET:
            pass
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
        array.append("%s=%s" % [key, query.get(key)])
    return PoolStringArray(array)

static func query_string_from_dict(query: Dictionary) -> String:
    return query_array_from_dict(query).join("&")
