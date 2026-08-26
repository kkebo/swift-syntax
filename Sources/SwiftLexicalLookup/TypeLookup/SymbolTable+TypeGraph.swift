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

// MARK: Requested Extensions

extension SymbolTable {
  /// Getter
  var requestedExtensions: [Attached<ExtensionDeclSyntax>] { _requestedExtensions }
  /// Appends a requested extensions
  func appendRequestedExtensions(_ elements: [Attached<ExtensionDeclSyntax>]) {
    for element in elements {
      // Add the extension if not already in the set.
      if _requestedExtensionsSet.contains(element) { continue }
      _requestedExtensions.append(element)
    }
  }
  /// Removes the first requested extension if it exists, or returns `nil`.
  func removeFirstRequestedExtension() -> Attached<ExtensionDeclSyntax>? {
    guard !requestedExtensions.isEmpty else { return nil }
    let first = _requestedExtensions.removeFirst()
    _requestedExtensionsSet.remove(first)
    return first
  }
}

// MARK: Registering Nominal

extension SymbolTable {
  /// Registers nominal type by forwarding to `TypeGraph/registerNominalType`
  func registerNominalType(
    topScopeMainDecl: Attached<NominalTypeDeclSyntax>,
    declName: Identifier,
    declFileInfo: FileInfo,
    isGlobal: Bool,
    originatingSyntax: Attached<TypeLikeSyntax>
  ) -> Result<TypeResolver.ResolvedTypeSyntax, TypeGraph.NominalRegistrationFailure> {
    fatalError("TODO")
  }
  /// Registers nominal type by forwarding to `TypeGraph/registerNominalType`
  func registerNominalType(
    nestedMainDecl: Attached<NominalTypeDeclSyntax>,
    declName: Identifier,
    declFileInfo: FileInfo,
    baseDeclGroup: Attached<DeclGroupSyntaxType>,
    baseType: TypeResolver.ResolvedTypeSyntax,
    originatingSyntax: Attached<TypeLikeSyntax>
  ) -> Result<TypeResolver.ResolvedTypeSyntax, TypeGraph.NestedNominalRegistrationFailure> {
    fatalError("TODO")
  }
}

// MARK: Qualified Type Lookup

extension SymbolTable {
  func findMemberType(
    baseType: TypeGraph.TypeRef,
    memberTypeName: Identifier,
    introducingTypeSyntax: Attached<TypeLikeSyntax>,
    introducingModule: ModuleName,
    dependencyTracker: inout DependencyTracker
  ) -> Result<
    [(declGroupParent: Attached<DeclGroupSyntaxType>, typeDecl: Attached<TypeDeclSyntax>)],
    TypeGraph.QualifiedTypeLookupFailure
  > {
    fatalError("TODO")
  }
}
