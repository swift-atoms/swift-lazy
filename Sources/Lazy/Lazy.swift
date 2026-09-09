/// A repeatable factory. Each access produces a fresh value, which may be noncopyable.
/// Neither values nor failures are cached; accessing the value again retries the factory.
public struct Lazy<Value: ~Copyable, FactoryFailure: Swift.Error> {

    @usableFromInline
    internal let build: () throws(FactoryFailure) -> Value

    @inlinable
    public init(_ build: @escaping @autoclosure () throws(FactoryFailure) -> Value) {
        self.build = build
    }

    @inlinable
    public init(_ build: @escaping () throws(FactoryFailure) -> Value) {
        self.build = build
    }

    @inlinable
    public func callAsFunction() throws(FactoryFailure) -> Value {
        try build()
    }
}


extension Lazy where Value: ~Copyable, FactoryFailure == Never {
    @inlinable
    public init(_ build: @escaping @autoclosure () -> Value) {
        self.build = build
    }

    @inlinable
    public init(_ build: @escaping () -> Value) {
        self.build = build
    }

    @inlinable
    public var value: Value { build() }
}
