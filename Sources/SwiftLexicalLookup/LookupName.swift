//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax

/// An entity that is implicitly declared based on the syntactic structure of the program.
@_spi(Experimental) public enum ImplicitDecl {
  /// `self` keyword representing object instance.
  /// Could be associated with type declaration, extension,
  /// or closure captures.
  case `self`(DeclSyntaxProtocol)
  /// `Self` keyword representing object type.
  /// Could be associated with type declaration or extension.
  case `Self`(DeclSyntaxProtocol)
  /// `error` value caught by a `catch`
  /// block that does not specify a catch pattern.
  case error(CatchClauseSyntax)
  /// `newValue` available by default inside `set` and `willSet`.
  case newValue(AccessorDeclSyntax)
  /// `oldValue` available by default inside `didSet`.
  case oldValue(AccessorDeclSyntax)

  /// Syntax associated with this name.
  @_spi(Experimental) public var syntax: SyntaxProtocol {
    switch self {
    case .self(let syntax):
      return syntax
    case .Self(let syntax):
      return syntax
    case .error(let syntax):
      return syntax
    case .newValue(let syntax):
      return syntax
    case .oldValue(let syntax):
      return syntax
    }
  }

  /// The name of the implicit declaration.
  private var name: String {
    switch self {
    case .self:
      return "self"
    case .Self:
      return "Self"
    case .error:
      return "error"
    case .newValue:
      return "newValue"
    case .oldValue:
      return "oldValue"
    }
  }

  /// Identifier used for name comparison.
  ///
  /// Note that `self` and `Self` are treated as identifiers for name lookup purposes
  /// and that a variable named `self` can shadow the `self` keyword. For example.
  /// ```swift
  /// class Foo {
  ///     func test() {
  ///     let `Self` = "abc"
  ///     print(Self.self)
  ///
  ///     let `self` = "def"
  ///     print(self)
  ///   }
  /// }
  ///
  /// Foo().test()
  /// ```
  /// prints:
  /// ```
  /// abc
  /// def
  /// ```
  /// `self` and `Self` identifers override implicit `self` and `Self` introduced by
  /// the `Foo` class declaration.
  var identifier: Identifier {
    switch self {
    case .self:
      return Identifier("self")
    case .Self:
      return Identifier("Self")
    case .error:
      return Identifier("error")
    case .newValue:
      return Identifier("newValue")
    case .oldValue:
      return Identifier("oldValue")
    }
  }
}

@_spi(Experimental) public enum LookupName {
  /// Identifier associated with the name.
  /// Could be an identifier of a variable, function or closure parameter and more.
  case identifier(IdentifiableSyntax, accessibleAfter: AbsolutePosition?)
  /// Declaration associated with the name.
  /// Could be class, struct, actor, protocol, function and more.
  case declaration(NamedDeclSyntax)
  /// Name introduced implicitly by certain syntax nodes.
  case implicit(ImplicitDecl)

  /// Syntax associated with this name.
  @_spi(Experimental) public var syntax: SyntaxProtocol {
    switch self {
    case .identifier(let syntax, _):
      return syntax
    case .declaration(let syntax):
      return syntax
    case .implicit(let implicitName):
      return implicitName.syntax
    }
  }

  /// Identifier used for name comparison.
  @_spi(Experimental) public var identifier: Identifier? {
    switch self {
    case .identifier(let syntax, _):
      return Identifier(syntax.identifier)
    case .declaration(let syntax):
      return Identifier(syntax.name)
    case .implicit(let kind):
      return kind.identifier
    }
  }

  /// Point, after which the name is available in scope.
  /// If set to `nil`, the name is available at any point in scope.
  var accessibleAfter: AbsolutePosition? {
    switch self {
    case .identifier(_, let absolutePosition):
      return absolutePosition
    default:
      return nil
    }
  }

  /// Checks if this name was introduced before the syntax used for lookup.
  func isAccessible(at lookUpPosition: AbsolutePosition) -> Bool {
    guard let accessibleAfter else { return true }
    return accessibleAfter <= lookUpPosition
  }

  /// Extracts names introduced by the given `syntax` structure.
  ///
  /// When e.g. looking up a variable declaration like `let a = a`,
  /// we expect `a` to be visible after the whole declaration.
  /// That's why we can't just use `syntax.endPosition` for the `a` identifier pattern,
  /// as the name would already be visible at the `a` reference withing the declaration.
  /// That’s why code block and file scopes have to set
  /// `accessibleAfter` to be the end position of the entire declaration syntax node.
  static func getNames(
    from syntax: SyntaxProtocol,
    accessibleAfter: AbsolutePosition? = nil
  ) -> [LookupName] {
    switch Syntax(syntax).as(SyntaxEnum.self) {
    case .variableDecl(let variableDecl):
      return variableDecl.bindings.flatMap { binding in
        getNames(
          from: binding.pattern,
          accessibleAfter: accessibleAfter != nil ? binding.endPositionBeforeTrailingTrivia : nil
        )
      }
    case .tuplePattern(let tuplePattern):
      return tuplePattern.elements.flatMap { tupleElement in
        getNames(from: tupleElement.pattern, accessibleAfter: accessibleAfter)
      }
    case .valueBindingPattern(let valueBindingPattern):
      return getNames(from: valueBindingPattern.pattern, accessibleAfter: accessibleAfter)
    case .expressionPattern(let expressionPattern):
      return getNames(from: expressionPattern.expression, accessibleAfter: accessibleAfter)
    case .sequenceExpr(let sequenceExpr):
      return sequenceExpr.elements.flatMap { expression in
        getNames(from: expression, accessibleAfter: accessibleAfter)
      }
    case .patternExpr(let patternExpr):
      return getNames(from: patternExpr.pattern, accessibleAfter: accessibleAfter)
    case .optionalBindingCondition(let optionalBinding):
      return getNames(from: optionalBinding.pattern, accessibleAfter: accessibleAfter)
    case .matchingPatternCondition(let matchingPatternCondition):
      return getNames(from: matchingPatternCondition.pattern, accessibleAfter: accessibleAfter)
    case .functionCallExpr(let functionCallExpr):
      return functionCallExpr.arguments.flatMap { argument in
        getNames(from: argument.expression, accessibleAfter: accessibleAfter)
      }
    default:
      if let namedDecl = Syntax(syntax).asProtocol(SyntaxProtocol.self) as? NamedDeclSyntax {
        return handle(namedDecl: namedDecl, accessibleAfter: accessibleAfter)
      } else if let identifiable = Syntax(syntax).asProtocol(SyntaxProtocol.self) as? IdentifiableSyntax {
        return handle(identifiable: identifiable, accessibleAfter: accessibleAfter)
      } else {
        return []
      }
    }
  }

  /// Extracts name introduced by `IdentifiableSyntax` node.
  private static func handle(
    identifiable: IdentifiableSyntax,
    accessibleAfter: AbsolutePosition? = nil
  ) -> [LookupName] {
    switch identifiable.identifier.tokenKind {
    case .wildcard:
      return []
    default:
      return [.identifier(identifiable, accessibleAfter: accessibleAfter)]
    }
  }

  /// Extracts name introduced by `NamedDeclSyntax` node.
  private static func handle(
    namedDecl: NamedDeclSyntax,
    accessibleAfter: AbsolutePosition? = nil
  ) -> [LookupName] {
    [.declaration(namedDecl)]
  }
}
