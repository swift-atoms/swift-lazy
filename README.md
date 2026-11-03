# swift-lazy

Use this package when you need to pass a computation around as a value and run it later, possibly more than once, including one that throws a typed error or produces a noncopyable value. Start from `Lazy<Value, FactoryFailure>`. It is a deferred builder, not a memoized cell: if you need the result computed once and then kept, store the result yourself.

## Laws

- Creating a `Lazy` never runs the builder, in the autoclosure form as well.
- Every access (`value` or a call) runs the builder again. Nothing is cached, so each access returns a new value and repeats any side effects the builder has.
- A throwing access leaves nothing behind. The next access runs the builder again and can succeed.
- State the builder captures is shared by all accesses, so one access can change what the next one returns.
