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

public let TYPE_NODES: [Node] = [
  Node(
    kind: .arrayType,
    base: .type,
    nameForDiagnostics: "array type",
    children: [
      Child(
        name: "leftSquare",
        kind: .token(choices: [.token(.leftSquare)])
      ),
      Child(
        name: "element",
        kind: .node(kind: .type)
      ),
      Child(
        name: "rightSquare",
        kind: .token(choices: [.token(.rightSquare)])
      ),
    ],
    childHistory: [
      [
        "leftSquare": .renamed(from: "leftSquareBracket"),
        "element": .renamed(from: "elementType"),
        "rightSquare": .renamed(from: "rightSquareBracket"),
      ]
    ]
  ),

  Node(
    kind: .attributedType,
    base: .type,
    nameForDiagnostics: "type",
    traits: [
      "WithAttributes"
    ],
    children: [
      Child(
        name: "specifiers",
        kind: .collection(kind: .typeSpecifierList, collectionElementName: "Specifier", defaultsToEmpty: true),
        documentation:
          "A list of specifiers that can be attached to the type, such as `inout`, `isolated`, or `consuming`."
      ),
      Child(
        name: "attributes",
        kind: .collection(kind: .attributeList, collectionElementName: "Attribute", defaultsToEmpty: true),
        documentation: "A list of attributes that can be attached to the type, such as `@escaping`."
      ),
      Child(
        name: "lateSpecifiers",
        kind: .collection(
          kind: .typeSpecifierList,
          collectionElementName: "Specifier",
          defaultsToEmpty: true,
          generateDeprecatedAddFunction: false
        ),
        documentation:
          "A list of specifiers that can be attached to the type after the attributes, such as 'nonisolated'."
      ),
      Child(
        name: "baseType",
        kind: .node(kind: .type),
        documentation: "The type to with the specifiers and attributes are applied."
      ),
    ]
  ),

  Node(
    kind: .classRestrictionType,
    base: .type,
    nameForDiagnostics: nil,
    children: [
      Child(
        name: "classKeyword",
        kind: .token(choices: [.keyword(.class)])
      )
    ]
  ),

  Node(
    kind: .compositionTypeElementList,
    base: .syntaxCollection,
    nameForDiagnostics: nil,
    elementChoices: [.compositionTypeElement]
  ),

  Node(
    kind: .compositionTypeElement,
    base: .syntax,
    nameForDiagnostics: nil,
    children: [
      Child(
        name: "type",
        kind: .node(kind: .type)
      ),
      Child(
        name: "ampersand",
        kind: .node(kind: .token),
        isOptional: true
      ),
    ]
  ),

  Node(
    kind: .compositionType,
    base: .type,
    nameForDiagnostics: "type composition",
    children: [
      Child(
        name: "elements",
        kind: .collection(kind: .compositionTypeElementList, collectionElementName: "Element")
      )
    ]
  ),

  Node(
    kind: .someOrAnyType,
    base: .type,
    nameForDiagnostics: "type",
    children: [
      Child(
        name: "someOrAnySpecifier",
        kind: .token(choices: [.keyword(.some), .keyword(.any)])
      ),
      Child(
        name: "constraint",
        kind: .node(kind: .type)
      ),
    ],
    childHistory: [
      [
        "constraint": .renamed(from: "baseType")
      ]
    ]
  ),

  Node(
    kind: .dictionaryType,
    base: .type,
    nameForDiagnostics: "dictionary type",
    children: [
      Child(
        name: "leftSquare",
        kind: .token(choices: [.token(.leftSquare)])
      ),
      Child(
        name: "key",
        kind: .node(kind: .type),
        nameForDiagnostics: "key type"
      ),
      Child(
        name: "colon",
        kind: .token(choices: [.token(.colon)])
      ),
      Child(
        name: "value",
        kind: .node(kind: .type),
        nameForDiagnostics: "value type"
      ),
      Child(
        name: "rightSquare",
        kind: .token(choices: [.token(.rightSquare)])
      ),
    ],
    childHistory: [
      [
        "leftSquare": .renamed(from: "leftSquareBracket"),
        "key": .renamed(from: "keyType"),
        "value": .renamed(from: "valueType"),
        "rightSquare": .renamed(from: "rightSquareBracket"),
      ]
    ]
  ),

  Node(
    kind: .functionType,
    base: .type,
    nameForDiagnostics: "function type",
    traits: [
      "Parenthesized"
    ],
    children: [
      Child(
        name: "leftParen",
        kind: .token(choices: [.token(.leftParen)])
      ),
      Child(
        name: "parameters",
        kind: .collection(
          kind: .tupleTypeElementList,
          collectionElementName: "Parameter",
          deprecatedCollectionElementName: "Argument"
        )
      ),
      Child(
        name: "rightParen",
        kind: .token(choices: [.token(.rightParen)])
      ),
      Child(
        name: "effectSpecifiers",
        kind: .node(kind: .typeEffectSpecifiers),
        isOptional: true
      ),
      Child(
        name: "returnClause",
        kind: .node(kind: .returnClause)
      ),
    ],
    childHistory: [
      [
        "parameters": .renamed(from: "arguments"),
        "returnClause": .renamed(from: "output"),
      ]
    ]
  ),

  Node(
    kind: .genericArgumentClause,
    base: .syntax,
    nameForDiagnostics: "generic argument clause",
    children: [
      Child(
        name: "leftAngle",
        kind: .token(choices: [.token(.leftAngle)])
      ),
      Child(
        name: "arguments",
        kind: .collection(kind: .genericArgumentList, collectionElementName: "Argument")
      ),
      Child(
        name: "rightAngle",
        kind: .token(choices: [.token(.rightAngle)])
      ),
    ],
    childHistory: [
      [
        "leftAngle": .renamed(from: "leftAngleBracket"),
        "rightAngle": .renamed(from: "rightAngleBracket"),
      ]
    ]
  ),

  Node(
    kind: .genericArgumentList,
    base: .syntaxCollection,
    nameForDiagnostics: nil,
    elementChoices: [.genericArgument]
  ),

  Node(
    kind: .genericArgument,
    base: .syntax,
    nameForDiagnostics: "generic argument",
    traits: [
      "WithTrailingComma"
    ],
    children: [
      Child(
        name: "argument",
        kind: .nodeChoices(choices: [
          Child(
            name: "type",
            kind: .node(kind: .type)
          ),
          Child(
            name: "expr",
            kind: .node(kind: .expr)
          ),
        ]),
        documentation:
          "The argument type for a generic argument. This can either be a regular type argument or an expression for value generics."
      ),
      Child(
        name: "trailingComma",
        kind: .token(choices: [.token(.comma)]),
        isOptional: true
      ),
    ],
    childHistory: [
      [
        "argument": .renamed(from: "argumentType")
      ]
    ]
  ),

  Node(
    kind: .implicitlyUnwrappedOptionalType,
    base: .type,
    nameForDiagnostics: "implicitly unwrapped optional type",
    children: [
      Child(
        name: "wrappedType",
        kind: .node(kind: .type)
      ),
      Child(
        name: "exclamationMark",
        kind: .token(choices: [.token(.exclamationMark)])
      ),
    ]
  ),

  Node(
    kind: .inlineArrayType,
    base: .type,
    experimentalFeature: .inlineArrayTypeSugar,
    nameForDiagnostics: "inline array type",
    documentation: "An inline array type `[3 of Int]`, sugar for `InlineArray<3, Int>`.",
    children: [
      Child(
        name: "leftSquare",
        kind: .token(choices: [.token(.leftSquare)])
      ),
      Child(
        name: "count",
        kind: .node(kind: .genericArgument),
        nameForDiagnostics: "count",
        documentation: """
          The `count` argument for the inline array type.

          - Note: In semantically valid Swift code, this is always an integer or a wildcard type, e.g `_` in `[_ of Int]`.
          """
      ),
      Child(
        name: "separator",
        kind: .token(choices: [.keyword(.of)])
      ),
      Child(
        name: "element",
        kind: .node(kind: .genericArgument),
        nameForDiagnostics: "element type",
        documentation: """
          The `element` argument for the inline array type.

          - Note: In semantically valid Swift code, this is always a type.
          """
      ),
      Child(
        name: "rightSquare",
        kind: .token(choices: [.token(.rightSquare)])
      ),
    ]
  ),

  Node(
    kind: .memberType,
    base: .type,
    nameForDiagnostics: "member type",
    children: [
      Child(
        name: "baseType",
        kind: .node(kind: .type),
        nameForDiagnostics: "base type"
      ),
      Child(
        name: "period",
        kind: .token(choices: [.token(.period)])
      ),
      Child(
        name: "name",
        kind: .token(choices: [.token(.identifier), .keyword(.self)]),
        nameForDiagnostics: "name"
      ),
      Child(
        name: "genericArgumentClause",
        kind: .node(kind: .genericArgumentClause),
        isOptional: true
      ),
    ]
  ),

  Node(
    kind: .metatypeType,
    base: .type,
    nameForDiagnostics: "metatype",
    children: [
      Child(
        name: "baseType",
        kind: .node(kind: .type),
        nameForDiagnostics: "base type"
      ),
      Child(
        name: "period",
        kind: .token(choices: [.token(.period)])
      ),
      Child(
        name: "metatypeSpecifier",
        kind: .token(choices: [.keyword(.Type), .keyword(.Protocol)])
      ),
    ],
    childHistory: [
      [
        "metatypeSpecifier": .renamed(from: "typeOrProtocol")
      ]
    ]
  ),

  Node(
    kind: .namedOpaqueReturnType,
    base: .type,
    nameForDiagnostics: "named opaque return type",
    children: [
      Child(
        name: "genericParameterClause",
        kind: .node(kind: .genericParameterClause),
        documentation: "The parameter clause that defines the generic parameters."
      ),
      Child(
        name: "type",
        kind: .node(kind: .type)
      ),
    ],
    childHistory: [
      [
        "genericParameterClause": .renamed(from: "genericParameters"),
        "type": .renamed(from: "baseType"),
      ]
    ]
  ),

  Node(
    kind: .optionalType,
    base: .type,
    nameForDiagnostics: "optional type",
    children: [
      Child(
        name: "wrappedType",
        kind: .node(kind: .type)
      ),
      Child(
        name: "questionMark",
        kind: .token(choices: [.token(.postfixQuestionMark)])
      ),
    ]
  ),

  Node(
    kind: .suppressedType,
    base: .type,
    nameForDiagnostics: "suppressed type conformance",
    children: [
      Child(
        name: "withoutTilde",
        kind: .token(choices: [.token(.prefixOperator)])
      ),
      Child(
        name: "type",
        kind: .node(kind: .type)
      ),
    ],
    childHistory: [
      [
        "type": .renamed(from: "patternType")
      ]
    ]
  ),

  Node(
    kind: .packExpansionType,
    base: .type,
    nameForDiagnostics: "variadic expansion",
    children: [
      Child(
        name: "repeatKeyword",
        kind: .token(choices: [.keyword(.repeat)])
      ),
      Child(
        name: "repetitionPattern",
        kind: .node(kind: .type)
      ),
    ],
    childHistory: [
      [
        "repetitionPattern": .renamed(from: "patternType")
      ]
    ]
  ),

  Node(
    kind: .packElementType,
    base: .type,
    nameForDiagnostics: "pack element",
    children: [
      Child(
        name: "eachKeyword",
        kind: .token(choices: [.keyword(.each)])
      ),
      Child(
        name: "pack",
        kind: .node(kind: .type)
      ),
    ],
    childHistory: [
      [
        "pack": .renamed(from: "packType")
      ]
    ]
  ),

  Node(
    kind: .identifierType,
    base: .type,
    nameForDiagnostics: "type",
    children: [
      Child(
        name: "name",
        kind: .token(choices: [
          .token(.identifier),
          .keyword(.Self),
          .keyword(.Any),
          .token(.wildcard),
        ])
      ),
      Child(
        name: "genericArgumentClause",
        kind: .node(kind: .genericArgumentClause),
        isOptional: true
      ),
    ]
  ),

  Node(
    kind: .tupleTypeElementList,
    base: .syntaxCollection,
    nameForDiagnostics: nil,
    elementChoices: [.tupleTypeElement]
  ),

  Node(
    kind: .tupleTypeElement,
    base: .syntax,
    nameForDiagnostics: nil,
    traits: [
      "WithTrailingComma"
    ],
    children: [
      Child(
        name: "inoutKeyword",
        kind: .token(choices: [.keyword(.inout)]),
        isOptional: true
      ),
      Child(
        name: "firstName",
        kind: .token(choices: [.token(.identifier), .token(.wildcard)]),
        nameForDiagnostics: "name",
        isOptional: true
      ),
      Child(
        name: "secondName",
        kind: .token(choices: [.token(.identifier), .token(.wildcard)]),
        nameForDiagnostics: "internal name",
        isOptional: true
      ),
      Child(
        name: "colon",
        kind: .token(choices: [.token(.colon)]),
        isOptional: true
      ),
      Child(
        name: "type",
        kind: .node(kind: .type)
      ),
      Child(
        name: "ellipsis",
        kind: .token(choices: [.token(.ellipsis)]),
        isOptional: true
      ),
      Child(
        name: "trailingComma",
        kind: .token(choices: [.token(.comma)]),
        isOptional: true
      ),
    ],
    childHistory: [
      [
        "inoutKeyword": .renamed(from: "inOut"),
        "firstName": .renamed(from: "name"),
      ]
    ]
  ),

  Node(
    kind: .tupleType,
    base: .type,
    nameForDiagnostics: "tuple type",
    traits: [
      "Parenthesized"
    ],
    children: [
      Child(
        name: "leftParen",
        kind: .token(choices: [.token(.leftParen)])
      ),
      Child(
        name: "elements",
        kind: .collection(kind: .tupleTypeElementList, collectionElementName: "Element")
      ),
      Child(
        name: "rightParen",
        kind: .token(choices: [.token(.rightParen)])
      ),
    ]
  ),

  Node(
    kind: .lifetimeSpecifierArgument,
    base: .syntax,
    experimentalFeature: .nonescapableTypes,
    nameForDiagnostics: nil,
    documentation: """
      A single argument that can be added to a lifetime specifier like `borrow`, `mutate`, `consume` or `copy`.

      ### Example
      `data` in `func foo(data: Array<Item>) -> borrow(data) ComplexReferenceType`
      """,
    traits: [
      "WithTrailingComma"
    ],
    children: [
      Child(
        name: "parameter",
        kind: .token(choices: [.token(.identifier), .keyword(.self), .token(.integerLiteral)]),
        nameForDiagnostics: "parameter reference",
        documentation: """
          The parameter on which the lifetime of this type depends. 

          This can be an identifier referring to an external parameter name, an integer literal to refer to an unnamed
          parameter or `self` if the type's lifetime depends on the object the method is called on.
          """
      ),
      Child(
        name: "trailingComma",
        kind: .token(choices: [.token(.comma)]),
        isOptional: true
      ),
    ]
  ),

  Node(
    kind: .lifetimeSpecifierArgumentList,
    base: .syntaxCollection,
    experimentalFeature: .nonescapableTypes,
    nameForDiagnostics: nil,
    elementChoices: [.lifetimeSpecifierArgument]
  ),

  Node(
    kind: .lifetimeTypeSpecifier,
    base: .syntax,
    experimentalFeature: .nonescapableTypes,
    nameForDiagnostics: "lifetime specifier",
    documentation: "A specifier that specifies function parameter on whose lifetime a type depends",
    children: [
      Child(
        name: "dependsOnKeyword",
        kind: .token(choices: [.keyword(.dependsOn)]),
        documentation: "lifetime dependence specifier on the return type"
      ),
      Child(
        name: "leftParen",
        kind: .token(choices: [.token(.leftParen)])
      ),
      Child(
        name: "scopedKeyword",
        kind: .token(choices: [.keyword(.scoped)]),
        documentation: "lifetime of return value is scoped to the lifetime of the original value",
        isOptional: true
      ),
      Child(
        name: "arguments",
        kind: .collection(kind: .lifetimeSpecifierArgumentList, collectionElementName: "Arguments")
      ),
      Child(
        name: "rightParen",
        kind: .token(choices: [.token(.rightParen)])
      ),
    ]
  ),

  Node(
    kind: .nonisolatedSpecifierArgument,
    base: .syntax,
    nameForDiagnostics: nil,
    documentation: """
      A single argument that can be added to a nonisolated specifier: 'nonsending'.

      ### Example
      `data` in `func foo(data: nonisolated(nonsending) () async -> Void) -> X`
      """,
    traits: [
      "Parenthesized"
    ],
    children: [
      Child(
        name: "leftParen",
        kind: .token(choices: [.token(.leftParen)])
      ),
      Child(
        name: "nonsendingKeyword",
        kind: .token(choices: [.keyword(.nonsending)])
      ),
      Child(
        name: "rightParen",
        kind: .token(choices: [.token(.rightParen)])
      ),
    ]
  ),

  Node(
    kind: .nonisolatedTypeSpecifier,
    base: .syntax,
    nameForDiagnostics: "'nonisolated' specifier",
    children: [
      Child(
        name: "nonisolatedKeyword",
        kind: .token(choices: [.keyword(.nonisolated)])
      ),
      Child(
        name: "argument",
        kind: .node(kind: .nonisolatedSpecifierArgument),
        isOptional: true
      ),
    ]
  ),

  Node(
    kind: .simpleTypeSpecifier,
    base: .syntax,
    nameForDiagnostics: "type specifier",
    documentation: "A specifier that can be attached to a type to eg. mark a parameter as `inout` or `consuming`",
    children: [
      Child(
        name: "specifier",
        kind: .token(choices: [
          .keyword(.inout),
          .keyword(.__shared),
          .keyword(.__owned),
          .keyword(.isolated),
          .keyword(._const),
          .keyword(.borrowing),
          .keyword(.consuming),
          .keyword(.sending),
        ]),
        documentation: "The specifier token that's attached to the type."
      )
    ]
  ),

  Node(
    kind: .typeSpecifierList,
    base: .syntaxCollection,
    nameForDiagnostics: nil,
    elementChoices: [.simpleTypeSpecifier, .lifetimeTypeSpecifier, .nonisolatedTypeSpecifier]
  ),
]
