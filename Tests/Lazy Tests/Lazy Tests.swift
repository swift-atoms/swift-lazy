import Lazy
import Testing

@Suite
struct `Lazy Tests` {

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
