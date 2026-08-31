//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2026 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftIfConfig
import SwiftSyntax

@_spi(_QualifiedLookupTests)
public struct TypeGraph {}

extension TypeGraph {
  @_spi(_QualifiedLookupTests)
  public enum QualifiedTypeLookupFailure: Error {
    /// References non-registered base type
    case invalidBase
    case unregisteredFileRoot(SourceFileSyntax)
  }
}

/// An extension dependency stores cached information such as what declaration
/// group the given member was introduced. Normally, we don't store cached
/// information for types stored in the `TypeGraph` since we must
/// later update a lot of cached data when we bind/invalidate an extension.
/// However, extension dependencies are different because if the dependency
/// type changes, we necessarily have to invalidate and recompute the extensions.
/// Hence, extension dependencies should be created at extension binding and not
/// be modified (we simply invalidate the extension and destroy its state along
/// with any dependencies).
@_spi(_QualifiedLookupTests)
public struct ExtensionDependency: Sendable {}

/// The state of an admitted extension: what type it resolved to and the
/// dependencies for that resolution result.
///
/// Note: Extension state uses `GlobalTypeName` instead of `GlobalTypeRef`
/// since the type graph already stores information about types in a
/// different property.
@_spi(_QualifiedLookupTests)
public struct ExtensionState: Sendable {
  @_spi(_QualifiedLookupTests)
  public init(
    _uncheckedDependencies dependencies: [ExtensionDependency],
    extensionDecl: Attached<ExtensionDeclSyntax>,
    resolvedType: Result<TypeGraph.GlobalTypeName, TypeResolver.Failure>
  ) {}
}

@_spi(_QualifiedLookupTests)
extension ExtensionState: CustomDebugStringConvertible {
  public var debugDescription: String { "" }

  @_spi(_QualifiedLookupTests)
  public func _visitTypes(
    visitResolved: (TypeGraph.TypeRef) -> Void,
    visitName: (TypeGraph.GlobalTypeName) -> Void
  ) {
    fatalError("TODO")
  }
}
// MARK: Lookup

@_spi(_QualifiedLookupTests)
public struct DependencyTracker {}

extension TypeGraph {
  enum NominalRegistrationFailure: Error {
    /// We don't allow registering redeclarations. Redeclarations should be
    /// diagnosed as ambiguities.
    ///
    /// For instance:
    /// ```swift
    /// struct A {}
    /// typealias A = ()
    /// let _: A // <- 'A' is ambiguous
    ///
    /// extension A {
    ///   struct B {}
    ///   typealias B = ()
    /// }
    /// let _: A.B // 'A.B' is ambiguous
    /// ```
    /// It's possible that we discover ambiguities after binding extensions.
    /// So, to keep the graph consistent, extensions track their extensions:
    /// if member that an extension depends on becomes ambiguous, we invalidate
    /// the extension. Further, in both unqualified and qualified lookup, all
    /// possible declarations should be returned; if we can't disambiguate,
    /// we diagnose an ambiguity error before attempting to register a type
    /// in the graph.
    case cannotRegisterRedeclaration
  }
  enum NestedNominalRegistrationFailure: Error {
    case other(NominalRegistrationFailure)

    /// In order to register a nested type, its parent must be registered.
    case baseNotRegistered(parentTypeName: TypeGraph.GlobalTypeName)
    /// Decl group unexpectedly isn't registered to the given base type.
    case baseDeclGroupUnbound(Attached<DeclGroupSyntaxType>)
  }
  enum NominalTypeRefUpdateFailure: Error {
    /// This type is no longer in the symbol table
    case removed
  }
}
