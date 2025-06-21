Fun is a new programming language. The specifications of the language are as follows, which is quite similar to OCaml.

• Reserved words: fun, in, let, while, do, if, then, else, ref, not

• Identifiers
– An identifier is a sequence of letters, digits, and underscores, starting with a letter. – Upper-case letters are distinguished from lower-case letters.

• Numbers
– Each number is a sequence of digits.
– May be preceded by a minus sign, but the minus sign should be lexed as a separate token.

• Other tokens:

ARROW ->

BANG ! 

ASSIGN := 

OR || 

AND & 

EQ =

LPAREN ( 

RPAREN ) 

GT > 

LT < 

TIMES * 

MINUS - 

PLUS + 

SEMICOLON ; 

COMMA ,

COLON : 

PROJ #i

Note that in #i of PROJ, i indicates a non-negative integer without leading 0’s.

• Comments: Comments start with /* and end with */ and may be nested.

• Whitespaces: Newlines (\n), carriage-returns (\r), tabs (\t), spaces may appear between any two tokens.
