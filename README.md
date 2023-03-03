# unirest-gdscript (4.x)
Unirest in GDScript: Simplified, lightweight HTTP client library. Godot Engine HTTPClient extension inspired by Kong Unirest.

👉 [3.x](https://github.com/fenix-hub/unirest-gdscript)

### sync example
```gdscript
func _ready() -> void:
    var json_response: JsonResponse = await Unirest.Get("https://jsonplaceholder.typicode.com/posts/{id}") \
    .header("Accept", "application/json") \
    .route_param("id", "1") \
    .as_json()
    
    # Execution will stop until Unirest receives a response
    
    var json_node: JsonNode = json_response.get_body()
    print(json_node.as_dictionary().get("title"))
```

### async example (lambda function)
```gdscript
func _ready() -> void:
    Unirest.Get("https://jsonplaceholder.typicode.com/posts/{id}") \
    .header("Accept", "application/json") \
    .route_param("id", "1") \
    .as_json_async(
        func(json_response: JsonResponse) -> void:
            var title: String = json_response.get_body().as_dictionary().get("title")
            print("Title of 1st post is: %s" % title)
    )
    
    # Execution won't stop, and the anonymous function will be executed automatically
```

### async example (signals)
```gdscript
func _ready() -> void:
    GetRequest = Unirest.get("https://jsonplaceholder.typicode.com/posts/{id}") \
    .header("Accept", "application/json") \
    .route_param("id", "1") \
    .as_json_async() \
    .completed.connect(handle_response)
    
    # Execution won't stop here, and your function will be called upon signal emission


func handle_response(json_response: JsonResponse) -> void:
    var title: String = json_response.get_body().as_dictionary().get("title")
    print("Title of 1st post is: %s" % title)
```
