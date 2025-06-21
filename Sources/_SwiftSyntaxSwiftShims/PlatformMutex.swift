#if canImport(Darwin)
import Darwin

public struct PlatformMutex {
  public var opaque: UnsafeMutableRawPointer?

  public init(opaque: UnsafeMutableRawPointer?) {
    self.opaque = opaque
  }

  public static func create() -> Self {
    let ptr = UnsafeMutablePointer<os_unfair_lock_s>.allocate(capacity: 1)
    ptr.initialize(to: os_unfair_lock())
    return .init(opaque: ptr)
  }

  public func lock() {
    guard let ptr = self.opaque?.assumingMemoryBound(to: os_unfair_lock_s.self) else { return }
    os_unfair_lock_lock(ptr)
  }

  public func unlock() {
    guard let ptr = self.opaque?.assumingMemoryBound(to: os_unfair_lock_s.self) else { return }
    os_unfair_lock_unlock(ptr)
  }

  public func destroy() {
    self.opaque?.deallocate()
  }
}
#elseif canImport(Glibc)
import Glibc

public struct PlatformMutex {
  public var opaque: UnsafeMutableRawPointer?

  public init(opaque: UnsafeMutableRawPointer?) {
    self.opaque = opaque
  }

  public static func create() -> Self {
    let ptr = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
    pthread_mutex_init(ptr, nil)
    return .init(opaque: ptr)
  }

  public func lock() {
    guard let ptr = self.opaque?.assumingMemoryBound(to: pthread_mutex_t.self) else { return }
    pthread_mutex_lock(ptr)
  }

  public func unlock() {
    guard let ptr = self.opaque?.assumingMemoryBound(to: pthread_mutex_t.self) else { return }
    pthread_mutex_unlock(ptr)
  }

  public func destroy() {
    guard let ptr = self.opaque?.assumingMemoryBound(to: pthread_mutex_t.self) else { return }
    pthread_mutex_destroy(ptr)
    ptr.deallocate()
  }
}
#endif
