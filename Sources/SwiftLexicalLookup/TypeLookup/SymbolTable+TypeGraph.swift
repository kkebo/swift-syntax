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
  struct RequestedExtensions {
    fileprivate private(set) var current: Attached<ExtensionDeclSyntax>?
    private var requestedArray: [Attached<ExtensionDeclSyntax>]
    private var requestedSet: Set<Attached<ExtensionDeclSyntax>>

    init() {
      self.current = nil
      (self.requestedArray, self.requestedSet) = ([], [])
    }

    /// Appends the requested extensions
    ///
    /// Complexity: O(n) where `n` is the number of `elements`.
    mutating func append(contentsOf elements: [Attached<ExtensionDeclSyntax>]) {
      for element in elements {
        // Don't add the currently processing array
        guard current != element else { continue }
        // Add the extension if not already in the set.
        guard requestedSet.insert(element).inserted else { continue }
        requestedArray.append(element)
      }
    }

    /// Returns the last index and element of the requestedExtensions without
    /// popping; `nil` if empty.
    ///
    /// Precondition: No extensions are currently bound, i.e., the previous
    /// `current == nil`.
    ///
    /// Complexity: O(1) with respect to the number of requested extensions.
    mutating func beginPop() -> Attached<ExtensionDeclSyntax>? {
      // Both of the following calls are O(1)
      guard let extensionDecl = requestedArray.popLast() else { return nil }
      requestedSet.remove(extensionDecl)

      if let current {
        fatalError(
          "[SwiftLexicalLookup] Internal error: Unexpectedly popped extension `\(extensionDecl._memberlessDescription)` while binding other extension `\(current._memberlessDescription)`"
        )
      }
      current = extensionDecl
      return extensionDecl
    }
    /// Removes the requested extension at the given index if it exists, or
    /// returns `nil`.
    ///
    /// Precondition: The given extension is `current`.
    ///
    /// Complexity: O(1) with respect to the number of requested extensions.
    mutating func finalizePop(_ extensionDecl: Attached<ExtensionDeclSyntax>) {
      // Ensure we're finalizing the right extension
      precondition(
        extensionDecl == current,
        "[SwiftLexicalLookup] Internal error: Unexpectedly found different requested extension:  popped `\(extensionDecl._memberlessDescription)`; finalized `\(current?._memberlessDescription ?? "nil")`)"
      )
      // Reset the current
      current = nil
    }
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
