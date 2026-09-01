public struct Lazy<Value> {

    @usableFromInline
    internal let build: () -> Value

    @inlinable
    public init(_ build: @escaping @autoclosure () -> Value) {
        self.build = build
    }

    @inlinable
    public init(_ build: @escaping () -> Value) {
        self.build = build
    }

    @inlinable
    public var value: Value {
        build()
    }
}
