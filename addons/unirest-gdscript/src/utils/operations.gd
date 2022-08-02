extends Reference
class_name Operations


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
