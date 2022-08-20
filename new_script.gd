tool
extends EditorScript

func _run() -> void:
    unirest_get()

func unirest_get() -> void:
    var get_request: GetRequest = \
        Unirest.get("https://62eaa4fa3a5f1572e880928c.mockapi.io/api/v1/{endpoint}") \
        .route_param("endpoint", "users")
#        .proxy("51.222.111.115", 3128)
    print(get_request)
    
    var json_response: JsonResponse = yield(get_request.as_json(), "completed")
    print(json_response)
    var json_node: JsonNode = json_response.get_body()
    
    print("ARRAY RESULT" if json_node.is_array() else "DICTIONARY RESULT")
