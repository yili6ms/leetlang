Definitions.

Rules.

/\*([^*]|\*+[^*/])*\*+/ : skip_token.

//([^\n])* : skip_token.

\== : {token, {eq, TokenLine }}.
\!= : {token, {ne, TokenLine }}.
\= : {token, {assign, TokenLine }}.

\>= : {token, {ge, TokenLine }}.
\<= : {token, {le, TokenLine }}.

\> : {token, {gt, TokenLine }}.
\< : {token, {lt, TokenLine }}.

\{ : {token, {'{', TokenLine}}.
\} : {token, {'}', TokenLine}}.

\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.

\. : {token, {dot_call, TokenLine }}.

\&& : {token, {and_sym, TokenLine }}.
\|\| : {token, {or_sym, TokenLine }}.
\! : {token, {not_sym, TokenLine }}.
\+ : {token, {plus_sym, TokenLine }}.
\- : {token, {minus_sym, TokenLine }}.
\* : {token, {mult_sym, TokenLine }}.
\/ : {token, {div_sym, TokenLine }}.
\-> : {token, {arrow_sym, TokenLine }}.

if : {token, {if_sym, TokenLine}}.
else : {token, {else_sym, TokenLine}}.
while : {token, {while_sym, TokenLine}}.
let : {token , {let_sym, TokenLine}}.
program : {token , {program_sym, TokenLine}}.
let_fn : {token , {let_fn_sym, TokenLine}}.
void : {token , {void_sym, TokenLine}}.
return : {token , {return_sym, TokenLine}}.
int : {token , {int_sym, TokenLine}}.
bool : {token , {bool_sym, TokenLine}}.
true : {token , {true_sym, TokenLine}}.
false : {token , {false_sym, TokenLine}}.


/:[a-zA-Z_]+ : {token, {atom, TokenLine, TokenChars}}.
[0-9]+ : {token, {digital, TokenLine, list_to_integer(TokenChars)}}.
[a-zA-Z0-9_]+ : {token, {chars, TokenLine, TokenChars}}.

[\s\n\r\t]+ : skip_token.

Erlang code.