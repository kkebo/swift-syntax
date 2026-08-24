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

  // Top-scope (local or global)
  mutating func registerNominalType(
    topScopeMainDecl mainDecl: Attached<NominalTypeDeclSyntax>,
    declName: Identifier,
    declFileInfo: FileInfo,
    isGlobal: Bool,
    symbolTable: borrowing SymbolTable
  ) -> Result<NominalTypeRef, NominalRegistrationFailure> {
    // Local types don't have extensions, so we can just return a reference.
    guard isGlobal else {
      return .success(NominalTypeRef(localNominalType: mainDecl))
    }

    let globalName = GlobalTypeName(
      component: GlobalTypeName.Component(
        name: declName,
        file: mainDecl.fileRoot,
        module: declFileInfo.module,
        symbolTable: symbolTable
      )
    )

    return _admitNominalType(
      globalDecl: mainDecl,
      declFileConfiguredRegions: declFileInfo.configuredRegions,
      globalTypeName: globalName
    )
  }

  enum NestedNominalRegistrationFailure: Error {
    case other(NominalRegistrationFailure)

    /// In order to register a nested type, its parent must be registered.
    case baseNotRegistered(parentTypeName: GlobalTypeName)
    /// Decl group unexpectedly isn't registered to the given base type.
    case baseDeclGroupUnbound(Attached<DeclGroupSyntaxType>)
  }
  // Nested (local or global)
  mutating func registerNominalType(
    nestedMainDecl mainDecl: Attached<NominalTypeDeclSyntax>,
    declName: Identifier,
    declFileInfo: FileInfo,
    baseDeclGroup: Attached<DeclGroupSyntaxType>,
    baseType: NominalTypeRef,
    symbolTable: borrowing SymbolTable
  ) -> Result<NominalTypeRef, NestedNominalRegistrationFailure> {
    fatalError("TODO")
  }

  /// Admits the given (global) nominal-type into the graph or returns the
  /// existing reference.
  ///
  /// Important: Callers must validate the inputs
  fileprivate mutating func _admitNominalType(
    globalDecl mainDecl: Attached<NominalTypeDeclSyntax>,
    declFileConfiguredRegions: ConfiguredRegions?,
    globalTypeName: GlobalTypeName
  ) -> Result<NominalTypeRef, NominalRegistrationFailure> {
    fatalError("TODO")
  }

  enum NominalTypeRefUpdateFailure: Error {
    /// This type is no longer in the symbol table
    case removed
  }
  func updateNominalTypeReference(oldReference: NominalTypeRef) -> Result<NominalTypeRef, NominalTypeRefUpdateFailure> {
    fatalError("TODO")
  }
}

@_spi(_QualifiedLookupTests)
public struct QualifiedLookupDependency<TypeName: Sendable>: Sendable {
  let extendedTypeName: TypeName
  let member: Identifier
  let typeDecls: [(declGroupParent: Attached<DeclGroupSyntaxType>, typeDecl: Attached<TypeDeclSyntax>)]

  @_spi(_QualifiedLookupTests)
  public init(
    extendedTypeName: TypeName,
    member: Identifier,
    typeDecls: [(Attached<DeclGroupSyntaxType>, Attached<TypeDeclSyntax>)]
  ) {
    self.extendedTypeName = extendedTypeName
    self.member = member
    self.typeDecls = typeDecls
  }
}

@_spi(_QualifiedLookupTests) public struct GenericDependencyTracker<TypeName: Sendable> {
  /// Invariant: There's at most one dependency for the same type/member-name pair.
  private(set) var dependencies: [QualifiedLookupDependency<TypeName>]

  @_spi(_QualifiedLookupTests) public init(
    _uncheckedDependencies dependencies: [QualifiedLookupDependency<TypeName>] = []
  ) {
    self.dependencies = dependencies
  }

  /// Add the given dependency, maintainign unique dependencies
  fileprivate mutating func _addLookupDependency(
    baseTypeName: GlobalTypeName,
    memberTypeName: Identifier,
    performLookup: (GlobalTypeName, Identifier) -> QualifiedLookupDependency<TypeName>
  ) -> QualifiedLookupDependency<TypeName> where TypeName == GlobalTypeName {
    // Try to find existing request
    //
    // Note: Although this takes O(n) time where `n` is the number of dependencies,
    // we shouldn't have that many dependencies and small arrays are fast
    // at linear search.
    if let existingResult = dependencies.first(where: {
      $0.extendedTypeName == baseTypeName && $0.member == memberTypeName
    }) {
      return existingResult
    }

    // Otherwise, compute and add
    let result = performLookup(baseTypeName, memberTypeName)
    dependencies.append(result)
    return result
  }
}
@_spi(_QualifiedLookupTests) public typealias DependencyTracker = GenericDependencyTracker<GlobalTypeName>
