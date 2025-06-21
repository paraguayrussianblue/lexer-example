(* CSE322 Compiler Assignment 1 *)
{
exception Eof

(* create a tuple of the start and end positions *)
let make_pos buf = (Lexing.lexeme_start buf, Lexing.lexeme_end buf)
}

let alpha = ['A'-'Z''a'-'z']
let digit = ['0'-'9']
let alphanum = alpha | digit | '_'

rule initial = parse
  (* 예약어 *)
  | "fun"    { Tokens.tok_fun(make_pos lexbuf) }
  | "in"     { Tokens.tok_in(make_pos lexbuf) }
  | "let"    { Tokens.tok_let(make_pos lexbuf) }
  | "while"  { Tokens.tok_while(make_pos lexbuf) }
  | "do"     { Tokens.tok_do(make_pos lexbuf) }
  | "if"     { Tokens.tok_if(make_pos lexbuf) }
  | "then"   { Tokens.tok_then(make_pos lexbuf) }
  | "else"   { Tokens.tok_else(make_pos lexbuf) }
  | "ref"    { Tokens.tok_ref(make_pos lexbuf) }
  | "not"    { Tokens.tok_not(make_pos lexbuf) }

  (* 연산자 및 특수 기호 *)
  | "->"     { Tokens.tok_arrow(make_pos lexbuf) }
  | ":="     { Tokens.tok_assign(make_pos lexbuf) }
  | "||"     { Tokens.tok_or(make_pos lexbuf) }
  | "&"      { Tokens.tok_and(make_pos lexbuf) }
  | "!"      { Tokens.tok_bang(make_pos lexbuf) }
  | "="      { Tokens.tok_eq(make_pos lexbuf) }
  | "("      { Tokens.tok_lparen(make_pos lexbuf) }
  | ")"      { Tokens.tok_rparen(make_pos lexbuf) }
  | ">"      { Tokens.tok_gt(make_pos lexbuf) }
  | "<"      { Tokens.tok_lt(make_pos lexbuf) }
  | "*"      { Tokens.tok_times(make_pos lexbuf) }
  | "-"      { Tokens.tok_minus(make_pos lexbuf) }
  | "+"      { Tokens.tok_plus(make_pos lexbuf) }
  | ";"      { Tokens.tok_semicolon(make_pos lexbuf) }
  | ","      { Tokens.tok_comma(make_pos lexbuf) }
  | ":"      { Tokens.tok_colon(make_pos lexbuf) }

  | "#0"      
       { Tokens.tok_proj(make_pos lexbuf, 0) }
  | "#" "0" digit+  
       { let msg = "Invalid projection index: " ^ Lexing.lexeme lexbuf in
         Errormsg.error (make_pos lexbuf, msg);
         Errormsg.impossible msg
       }
  | "#" [ '1'-'9' ] digit*  
       { let lexeme = Lexing.lexeme lexbuf in
         let len = String.length lexeme in
         let num_str = String.sub lexeme 1 (len - 1) in
         let index = int_of_string num_str in
         Tokens.tok_proj(make_pos lexbuf, index)
       }

  | (alpha)(alphanum)* as id  
       { Tokens.tok_id(make_pos lexbuf, id) }

  | (digit)+ as num         
       { Tokens.tok_num(make_pos lexbuf, int_of_string num) }

  | "/*"    { comment 1 lexbuf }

  | [' ' '\t' '\r']  
       { initial lexbuf }
  | "\n"             
       { Errormsg.new_line(make_pos lexbuf); initial lexbuf }

  | eof      
       { raise Eof }

  | _ as c   
       { let msg = "Illegal character: " ^ String.make 1 c in
         Errormsg.error (make_pos lexbuf, msg);
         Errormsg.impossible msg
       }

and comment depth = parse
  | "/*"   
       { comment (depth + 1) lexbuf }
  | "*/"   
       { if depth = 1 then initial lexbuf else comment (depth - 1) lexbuf }
  | "\n"   
       { Errormsg.new_line(make_pos lexbuf); comment depth lexbuf }
  | _      
       { comment depth lexbuf }
  | eof    
       { let msg = "Unterminated comment" in
         Errormsg.error (make_pos lexbuf, msg);
         Errormsg.impossible msg
       }
