### Struct to Manage Types and Keys for Dependency Injection
```swift
/// 의존성 주입 시 타입과 키값을 저장하는 구조체
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

/// Hashable 프로토콜을 활용하여 비교 가능하도록
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
    /// 의존성 가져오기
    func resolve<V>(_ indentifier: InjectIdentifier<V>) throws -> V
}

public protocol Injectable: Resolvable, AnyObject {
    var dependencies: [AnyHashable: Any] { get set }
    
    func remove<V>(_ indentifier: InjectIdentifier<V>)
    func register<V>(_ indentifier: InjectIdentifier<V>, _ resolve: (Resolvable) throws -> V )
}

public extension Injectable {
    
    /// 의존성 가져오기
    func resolve<V>(_ identifier: InjectIdentifier<V>) throws -> V {
        guard let dependency = dependencies[identifier] as? V else {
            throw ResolvableError.dependencyNotFound(identifier.type, identifier.key)
        }
        return dependency
    }
    
    /// 의존성 삭제
    func remove<V>(_ indentifier: InjectIdentifier<V>) {
        dependencies.removeValue(forKey: indentifier)
    }
    
    /// 의존성 등록
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

It's uncomfortable to take out the dependency like this every time, so I'll try to improve it with property wrapper.
```swift
appNavigator = try! Container.standard.resolve(type: AppNavigator.self)
```

