### Struct to Manage Types and Keys for Dependency Injection
```swift
public struct InjectIdentifier<V> {
    private(set) var type: V.Type?
    private(set) var key: String?
    
    init(
        type: V.Type? = nil,
        key: String? = nil
    ) {
        self.type = type
        self.key = key
    }
}

extension InjectIdentifier: Hashable {
    public static func == (
        lhs: InjectIdentifier<V>,
        rhs: InjectIdentifier<V>
    ) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
        if let type = type {
            hasher.combine(ObjectIdentifier(type))
        }
    }
}
```
<br>

### DIContainer for Dependency Management

```swift
public protocol Resolvable {
    func resolve<V>(_ indentifier: InjectIdentifier<V>) throws -> V
}

public protocol Injectable: Resolvable, AnyObject {
    var dependencies: [AnyHashable: Any] { get set }
    
    func remove<V>(_ indentifier: InjectIdentifier<V>)
    func register<V>(_ indentifier: InjectIdentifier<V>, _ resolve: (Resolvable) throws -> V )
}

public extension Injectable {
    
    func resolve<V>(_ identifier: InjectIdentifier<V>) throws -> V {
        guard let dependency = dependencies[identifier] as? V else {
            throw ResolvableError.dependencyNotFound(identifier.type, identifier.key)
        }
        return dependency
    }
    
    func remove<V>(_ indentifier: InjectIdentifier<V>) {
        dependencies.removeValue(forKey: indentifier)
    }
    
    func register<V>(
        _ indentifier: InjectIdentifier<V>,
        _ resolve: (Resolvable) throws -> V
    ) {
        do {
            self.dependencies[indentifier] = try resolve(self)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

```
**"Cannot use mutating member on immutable value: 'self' is immutable"** error resolved by adopting **AnyObject**


When registering dependencies, you must create an InjectIdentifier instance each time and put it as a parameter as follows.
```swift
let container = Container.standard

container.register(InjectIdentifier(type: AppNavigator.self)) { _ in
    AppNavigator(window: self.window!, navigationController: UINavigationController())
}
```

It's uncomfortable, so I'll add a register function.
```swift
func resolve<V>(
    type: V.Type? = nil,
    key: String? = nil
) throws -> V {
    try self.resolve(.by(type: type, key: key))
}
```

then
``` swift
container.register(type: AppNavigator.self) { _ in  AppNavigator(window: self.window!, navigationController: UINavigationController())
```
<br>


### Utilize property wrapper to get dependencies

It's uncomfortable to take out the dependency like this every time, so I'll try to improve it with **property wrapper.**
```swift
appNavigator = try! Container.standard.resolve(type: AppNavigator.self)
```

```swift
@propertyWrapper
public struct Injected<V> {
    
    public let identifier: InjectIdentifier<V>
    
    public init() {
        self.identifier = .by(type: V.self)
    }
    
    public lazy var wrappedValue: V = {
        let contianer = Container.standard
        
        do {
            let value = try contianer.resolve(identifier)
            return value
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
}
```
It's easy to get dependency. like this
```swift
@Injected var appNaviagtor: AppNavigatorProtocol
```

### SwiftData 

Create a repository that provides CRUD of **SwiftData**

```swift
public final class SwiftDataRepository<T: PersistentModel>: SwiftDataRepositoryProtocol {
    
    public init() {
        let configure = ModelConfiguration("\(T.self)")
        do {
            print("configure Init")
            container = try ModelContainer(for: T.self, configurations: configure)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    let container: ModelContainer
    
    
    public func insertData(data: T) {
        Task { @MainActor in
            let context = container.mainContext
            context.insert(data)
            
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    public func fetchData() async throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: nil)
        
        let context = container.mainContext
        let data = try context.fetch(descriptor)
        return data
    }
    
    public func deleteData(data: T) async {
        let context = await container.mainContext
        context.delete(data)
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    public func deleteAllData() async {
        do {
            let data = try await fetchData()
            for item in data {
                await deleteData(data: item)
            }
        } catch {
            print("Error fetching or deleting all data: \(error.localizedDescription)")
        }
    }
}
```

