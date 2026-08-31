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

/// Finds the main declaration and qualified name of the nominal types
/// to which the the given type syntax refers.
@_spi(_QualifiedLookupTests)
public struct TypeResolver {
  init(symbolTable: SymbolTable, _verbose: Bool) {}

  mutating func resolve(
    typeSyntax: Attached<TypeSyntax>
  ) -> TypeResult {
    fatalError("TODO")
  }
}
