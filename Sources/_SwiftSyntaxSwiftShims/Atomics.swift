public struct AtomicBool {
  public var value: Bool  // FIXME: This should be atomic.
}

public func swiftsyntax_atomic_bool_create(_ initialValue: Bool) -> UnsafeMutablePointer<AtomicBool> {
  let ptr = UnsafeMutablePointer<AtomicBool>.allocate(capacity: 1)
  ptr.initialize(to: .init(value: .init(initialValue)))
  return ptr
}

public func swiftsyntax_atomic_bool_get(_ atomic: UnsafeMutablePointer<AtomicBool>) -> Bool {
  atomic.pointee.value
}

public func swiftsyntax_atomic_bool_set(_ atomic: UnsafeMutablePointer<AtomicBool>, _ newValue: Bool) {
  atomic.pointee.value = newValue
}

public func swiftsyntax_atomic_bool_destroy(_ atomic: UnsafeMutablePointer<AtomicBool>) {
  atomic.deallocate()
}

public struct AtomicPointer {
  public var value: UnsafeRawPointer?  // FIXME: This should be atomic.
}

public func swiftsyntax_atomic_pointer_get(_ atomic: UnsafePointer<AtomicPointer>) -> UnsafeRawPointer? {
  atomic.pointee.value
}

public func swiftsyntax_atomic_pointer_set(_ atomic: UnsafeMutablePointer<AtomicPointer>, _ newValue: UnsafeRawPointer?) {
  atomic.pointee.value = newValue
}
