import Foundation

public class JsonDataStorage {
    let fileManager = FileManager.default
    let homeDirectory: URL
    let baseDirectory: URL
    public init(appName: String) {
        homeDirectory = fileManager.homeDirectoryForCurrentUser
        self.baseDirectory = homeDirectory.appendingPathComponent(".config").appendingPathComponent(appName)
        do {
            try fileManager.createDirectory(at: self.baseDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch{
            print(error)
            exit(EXIT_FAILURE)
        }
    }
    public init(baseDirectory: URL) {
        self.baseDirectory = baseDirectory
        homeDirectory = fileManager.homeDirectoryForCurrentUser
        do {
            try fileManager.createDirectory(at: self.baseDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch{
            print(error)
            exit(EXIT_FAILURE)
        }
    }
    func pathForIdentifier(_ identifier: String)->URL {
        return baseDirectory.appendingPathComponent("\(identifier).json")
    }
    func createStorageIfNotExists(_ identifier: String) {
        let path = pathForIdentifier(identifier)
        fileManager.createFile(atPath: path.path, contents: nil, attributes: nil)
    }
    func save(data: Data, to identifier: String) {
        let path = pathForIdentifier(identifier)
        createStorageIfNotExists(identifier)
        do {
            try data.write(to: path)
        } catch{
            print(error)
            exit(EXIT_FAILURE)
        }
    }
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    public func get<T>(item identifier: String, as type: T.Type) -> T? where T: Codable{
        let url = pathForIdentifier(identifier)
        let data = (try? Data(contentsOf: url)) ?? Data(capacity: 0)
        let a = try? decoder.decode(type, from: data)
        return a
    }
    public func save<T>(data: T, to identifier: String) where T: Codable {
        let url = pathForIdentifier(identifier)
        let data = (try? encoder.encode(data)) ?? Data(capacity: 0)
        try! data.write(to: url)
    }
}
