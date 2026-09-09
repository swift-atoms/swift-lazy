# swift-lazy

`Lazy<Value, FactoryFailure>` stores a repeatable factory. Each invocation creates
a fresh value; neither successful results nor failures are cached.

```swift
let answer = Lazy(42) // Lazy<Int, Never>
let value = answer.value
let another = answer()

let deferred = Lazy { () throws(LoadError) -> Resource in
    try loadResource()
}
let resource = try deferred()
```

Values may be noncopyable. Throwing factories use `callAsFunction` because Swift
currently does not support throwing getters returning noncopyable values.
Infallible factories also retain the `.value` property.

Explicit annotations formerly written `Lazy<Value>` become `Lazy<Value, Never>`.
Nonthrowing factory expressions infer `Never` automatically.

Values must be escapable. Supporting scoped results requires a lifetime contract
relating those results to the stored factory; relaxing the generic constraint
alone would not establish that relationship.
