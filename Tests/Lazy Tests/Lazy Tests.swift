import Lazy
import Testing

@Suite
struct `Lazy evaluates its builder on each value access` {

    @Test
    func `value returns what the builder produces`() {
        let lazy = Lazy(42)

        #expect(lazy.value == 42)
    }

    @Test
    func `autoclosure form defers evaluation until access`() {
        final class Box {
            var invoked = false
        }
        let box = Box()

        func build() -> Int {
            box.invoked = true
            return 1
        }

        let lazy = Lazy(build())
        #expect(!box.invoked)

        _ = lazy.value
        #expect(box.invoked)
    }

    @Test
    func `builder is re-invoked on every access`() {
        final class Box {
            var count = 0
        }
        let box = Box()

        let lazy = Lazy { () -> Int in
            box.count += 1
            return box.count
        }

        #expect(lazy.value == 1)
        #expect(lazy.value == 2)
        #expect(box.count == 2)
    }
}

private enum FactoryError: Error, Equatable { case unavailable }
private struct Token: ~Copyable { let value: Int }

extension `Lazy evaluates its builder on each value access` {
    @Test func `throwing factories retry and produce noncopyable values`() throws {
        var attempts = 0
        let lazy = Lazy { () throws(FactoryError) -> Token in
            attempts += 1
            if attempts == 1 { throw .unavailable }
            return Token(value: attempts)
        }
        #expect(attempts == 0)
        #expect(throws: FactoryError.unavailable) { _ = try lazy() }
        let second = try lazy()
        #expect(second.value == 2)
        let third = try lazy()
        #expect(third.value == 3)
    }

    @Test func `throwing autoclosures defer evaluation`() throws {
        var calls = 0
        func produce() throws(FactoryError) -> Int { calls += 1; return calls }
        let lazy = Lazy<Int, FactoryError>(try produce())
        #expect(calls == 0)
        #expect(try lazy() == 1)
        #expect(try lazy() == 2)
    }

    @Test func `infallible factories infer Never and support both access styles`() {
        let lazy: Lazy<Int, Never> = Lazy(42)
        #expect(lazy.value == 42)
        #expect(lazy() == 42)
        let owned = Lazy { Token(value: 1) }
        let token = owned.value
        #expect(token.value == 1)
    }
}
