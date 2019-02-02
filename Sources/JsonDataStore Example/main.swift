import JsonDataStore

struct TestObject: Codable, EmptyInitializable {
    var name: String
    var test: String
    init() {
        name = "Empty"
        test = "Empty"
    }
}

let store = JsonDataStorage(appName: "Json DataStoreExample")

var array = store.get(item: "list", as: [TestObject].self) ?? []
print(array)

array.append(TestObject())

print(array)
store.save(data: array, to: "list")
