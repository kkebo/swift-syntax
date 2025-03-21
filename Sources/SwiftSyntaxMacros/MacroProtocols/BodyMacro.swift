//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#if compiler(>=6)
public import SwiftSyntax
#else
import SwiftSyntax
#endif

/// Describes a macro that can create the body for a function that does not
/// have one.
public protocol BodyMacro: AttachedMacro {
  /// Expand a macro described by the given custom attribute and
  /// attached to the given declaration and evaluated within a
  /// particular expansion context.
  ///
  /// The macro expansion can introduce a body for the given function.
  static func expansion(
    of node: AttributeSyntax,
    providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
    in context: some MacroExpansionContext
  ) throws -> [CodeBlockItemSyntax]

  /// Expand a macro described by the given custom attribute and
  /// attached to the given closure and evaluated within a
  /// particular expansion context.
  ///
  /// The macro expansion can replace the body of the given closure.
  static func expansion(
    of node: AttributeSyntax,
    providingBodyFor closure: ClosureExprSyntax,
    in context: some MacroExpansionContext
  ) throws -> [CodeBlockItemSyntax]
}

private struct ClosureNotSupported: Error, CustomStringConvertible {
  var description: String {
    "Function body macro cannot be applied to closure"
  }
}

extension BodyMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingBodyFor closure: ClosureExprSyntax,
    in context: some MacroExpansionContext
  ) throws -> [CodeBlockItemSyntax] {
    throw ClosureNotSupported()
  }
}
