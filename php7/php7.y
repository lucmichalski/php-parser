%{
package php7

import (
    "strings"
    "strconv"

    "github.com/z7zmey/php-parser/meta"
    "github.com/z7zmey/php-parser/scanner"
    "github.com/z7zmey/php-parser/node"
    "github.com/z7zmey/php-parser/node/scalar"
    "github.com/z7zmey/php-parser/node/name"
    "github.com/z7zmey/php-parser/node/stmt"
    "github.com/z7zmey/php-parser/node/expr"
    "github.com/z7zmey/php-parser/node/expr/assign"
    "github.com/z7zmey/php-parser/node/expr/binary"
    "github.com/z7zmey/php-parser/node/expr/cast"
)

%}

%union{
    node             node.Node
    token            *scanner.Token
    list             []node.Node
    str              string

    ClassExtends     *stmt.ClassExtends
    ClassImplements  *stmt.ClassImplements
    InterfaceExtends *stmt.InterfaceExtends
    ClosureUse       *expr.ClosureUse
}

%type <token> $unk
%token <token> T_INCLUDE
%token <token> T_INCLUDE_ONCE
%token <token> T_EXIT
%token <token> T_IF
%token <token> T_LNUMBER
%token <token> T_DNUMBER
%token <token> T_STRING
%token <token> T_STRING_VARNAME
%token <token> T_VARIABLE
%token <token> T_NUM_STRING
%token <token> T_INLINE_HTML
%token <token> T_CHARACTER
%token <token> T_BAD_CHARACTER
%token <token> T_ENCAPSED_AND_WHITESPACE
%token <token> T_CONSTANT_ENCAPSED_STRING
%token <token> T_ECHO
%token <token> T_DO
%token <token> T_WHILE
%token <token> T_ENDWHILE
%token <token> T_FOR
%token <token> T_ENDFOR
%token <token> T_FOREACH
%token <token> T_ENDFOREACH
%token <token> T_DECLARE
%token <token> T_ENDDECLARE
%token <token> T_AS
%token <token> T_SWITCH
%token <token> T_ENDSWITCH
%token <token> T_CASE
%token <token> T_DEFAULT
%token <token> T_BREAK
%token <token> T_CONTINUE
%token <token> T_GOTO
%token <token> T_FUNCTION
%token <token> T_CONST
%token <token> T_RETURN
%token <token> T_TRY
%token <token> T_CATCH
%token <token> T_FINALLY
%token <token> T_THROW
%token <token> T_USE
%token <token> T_INSTEADOF
%token <token> T_GLOBAL
%token <token> T_VAR
%token <token> T_UNSET
%token <token> T_ISSET
%token <token> T_EMPTY
%token <token> T_HALT_COMPILER
%token <token> T_CLASS
%token <token> T_TRAIT
%token <token> T_INTERFACE
%token <token> T_EXTENDS
%token <token> T_IMPLEMENTS
%token <token> T_OBJECT_OPERATOR
%token <token> T_DOUBLE_ARROW
%token <token> T_LIST
%token <token> T_ARRAY
%token <token> T_CALLABLE
%token <token> T_CLASS_C
%token <token> T_TRAIT_C
%token <token> T_METHOD_C
%token <token> T_FUNC_C
%token <token> T_LINE
%token <token> T_FILE
%token <token> T_COMMENT
%token <token> T_DOC_COMMENT
%token <token> T_OPEN_TAG
%token <token> T_OPEN_TAG_WITH_ECHO
%token <token> T_CLOSE_TAG
%token <token> T_WHITESPACE
%token <token> T_START_HEREDOC
%token <token> T_END_HEREDOC
%token <token> T_DOLLAR_OPEN_CURLY_BRACES
%token <token> T_CURLY_OPEN
%token <token> T_PAAMAYIM_NEKUDOTAYIM
%token <token> T_NAMESPACE
%token <token> T_NS_C
%token <token> T_DIR
%token <token> T_NS_SEPARATOR
%token <token> T_ELLIPSIS
%token <token> T_EVAL
%token <token> T_REQUIRE
%token <token> T_REQUIRE_ONCE
%token <token> T_LOGICAL_OR
%token <token> T_LOGICAL_XOR
%token <token> T_LOGICAL_AND
%token <token> T_INSTANCEOF
%token <token> T_NEW
%token <token> T_CLONE
%token <token> T_ELSEIF
%token <token> T_ELSE
%token <token> T_ENDIF
%token <token> T_PRINT
%token <token> T_YIELD
%token <token> T_STATIC
%token <token> T_ABSTRACT
%token <token> T_FINAL
%token <token> T_PRIVATE
%token <token> T_PROTECTED
%token <token> T_PUBLIC
%token <token> T_INC
%token <token> T_DEC
%token <token> T_YIELD_FROM
%token <token> T_INT_CAST
%token <token> T_DOUBLE_CAST
%token <token> T_STRING_CAST
%token <token> T_ARRAY_CAST
%token <token> T_OBJECT_CAST
%token <token> T_BOOL_CAST
%token <token> T_UNSET_CAST
%token <token> T_COALESCE
%token <token> T_SPACESHIP
%token <token> T_NOELSE
%token <token> T_PLUS_EQUAL
%token <token> T_MINUS_EQUAL
%token <token> T_MUL_EQUAL
%token <token> T_POW_EQUAL
%token <token> T_DIV_EQUAL
%token <token> T_CONCAT_EQUAL
%token <token> T_MOD_EQUAL
%token <token> T_AND_EQUAL
%token <token> T_OR_EQUAL
%token <token> T_XOR_EQUAL
%token <token> T_SL_EQUAL
%token <token> T_SR_EQUAL
%token <token> T_BOOLEAN_OR
%token <token> T_BOOLEAN_AND
%token <token> T_POW
%token <token> T_SL
%token <token> T_SR
%token <token> T_IS_IDENTICAL
%token <token> T_IS_NOT_IDENTICAL
%token <token> T_IS_EQUAL
%token <token> T_IS_NOT_EQUAL
%token <token> T_IS_SMALLER_OR_EQUAL
%token <token> T_IS_GREATER_OR_EQUAL
%token <token> '"'
%token <token> '`'
%token <token> '{'
%token <token> '}'
%token <token> ';'
%token <token> ':'
%token <token> '('
%token <token> ')'
%token <token> '['
%token <token> ']'
%token <token> '?'
%token <token> '&'
%token <token> '-'
%token <token> '+'
%token <token> '!'
%token <token> '~'
%token <token> '@'
%token <token> '$'
%token <token> ','
%token <token> '|'
%token <token> '='
%token <token> '^'
%token <token> '*'
%token <token> '/'
%token <token> '%'
%token <token> '<'
%token <token> '>'
%token <token> '.'

%left T_INCLUDE T_INCLUDE_ONCE T_EVAL T_REQUIRE T_REQUIRE_ONCE
%left ','
%left T_LOGICAL_OR
%left T_LOGICAL_XOR
%left T_LOGICAL_AND
%right T_PRINT
%right T_YIELD
%right T_DOUBLE_ARROW
%right T_YIELD_FROM
%left '=' T_PLUS_EQUAL T_MINUS_EQUAL T_MUL_EQUAL T_DIV_EQUAL T_CONCAT_EQUAL T_MOD_EQUAL T_AND_EQUAL T_OR_EQUAL T_XOR_EQUAL T_SL_EQUAL T_SR_EQUAL T_POW_EQUAL
%left '?' ':'
%right T_COALESCE
%left T_BOOLEAN_OR
%left T_BOOLEAN_AND
%left '|'
%left '^'
%left '&'
%nonassoc T_IS_EQUAL T_IS_NOT_EQUAL T_IS_IDENTICAL T_IS_NOT_IDENTICAL T_SPACESHIP
%nonassoc '<' T_IS_SMALLER_OR_EQUAL '>' T_IS_GREATER_OR_EQUAL
%left T_SL T_SR
%left '+' '-' '.'
%left '*' '/' '%'
%right '!'
%nonassoc T_INSTANCEOF
%right '~' T_INC T_DEC T_INT_CAST T_DOUBLE_CAST T_STRING_CAST T_ARRAY_CAST T_OBJECT_CAST T_BOOL_CAST T_UNSET_CAST '@'
%right T_POW
%right '['
%nonassoc T_NEW T_CLONE
%left T_NOELSE
%left T_ELSEIF
%left T_ELSE
%left T_ENDIF
%right T_STATIC T_ABSTRACT T_FINAL T_PRIVATE T_PROTECTED T_PUBLIC

%type <token> is_reference is_variadic returns_ref

%type <token> reserved_non_modifiers
%type <token> semi_reserved
%type <token> identifier
%type <token> possible_comma
%type <token> case_separator

%type <node> top_statement name statement function_declaration_statement
%type <node> class_declaration_statement trait_declaration_statement
%type <node> interface_declaration_statement
%type <node> group_use_declaration inline_use_declaration
%type <node> mixed_group_use_declaration use_declaration unprefixed_use_declaration
%type <node> const_decl inner_statement
%type <node> expr optional_expr
%type <node> declare_statement finally_statement unset_variable variable
%type <node> parameter optional_type argument expr_without_variable global_var
%type <node> static_var class_statement trait_adaptation trait_precedence trait_alias
%type <node> absolute_trait_method_reference trait_method_reference property echo_expr
%type <node> new_expr anonymous_class class_name class_name_reference simple_variable
%type <node> internal_functions_in_yacc
%type <node> exit_expr scalar lexical_var function_call member_name property_name
%type <node> variable_class_name dereferencable_scalar constant dereferencable
%type <node> callable_expr callable_variable static_member new_variable
%type <node> encaps_var encaps_var_offset
%type <node> if_stmt
%type <node> alt_if_stmt
%type <node> if_stmt_without_else
%type <node> class_const_decl
%type <node> alt_if_stmt_without_else
%type <node> array_pair possible_array_pair
%type <node> isset_variable type return_type type_expr
%type <node> class_modifier
%type <node> argument_list ctor_arguments
%type <node> trait_adaptations
%type <node> switch_case_list
%type <node> method_body
%type <node> foreach_statement for_statement while_statement
%type <ClassExtends> extends_from
%type <ClassImplements> implements_list
%type <InterfaceExtends> interface_extends_list
%type <ClosureUse> lexical_vars

%type <node> member_modifier
%type <node> use_type
%type <node> foreach_variable


%type <list> encaps_list backticks_expr namespace_name catch_name_list catch_list class_const_list
%type <list> const_list echo_expr_list for_exprs non_empty_for_exprs global_var_list
%type <list> unprefixed_use_declarations inline_use_declarations property_list static_var_list
%type <list> case_list trait_adaptation_list unset_variables
%type <list> use_declarations lexical_var_list isset_variables non_empty_array_pair_list
%type <list> array_pair_list non_empty_argument_list top_statement_list
%type <list> inner_statement_list parameter_list non_empty_parameter_list class_statement_list
%type <list> method_modifiers variable_modifiers
%type <list> non_empty_member_modifiers name_list class_modifiers

%type <str> backup_doc_comment

%%

/////////////////////////////////////////////////////////////////////////

start:
        top_statement_list
            {
                yylex.(*Parser).rootNode = node.NewRoot($1)

                // save position
                yylex.(*Parser).rootNode.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
                
                if yylex.(*Parser).currentToken.Value == "\xff" {
                    yylex.(*Parser).currentToken.Meta.SetTokenName(meta.NodeEnd).AppendTo(yylex.(*Parser).rootNode.GetMeta())
                }
            }
;

reserved_non_modifiers:
      T_INCLUDE {$$=$1} | T_INCLUDE_ONCE {$$=$1} | T_EVAL {$$=$1} | T_REQUIRE {$$=$1} | T_REQUIRE_ONCE {$$=$1} | T_LOGICAL_OR {$$=$1} | T_LOGICAL_XOR {$$=$1} | T_LOGICAL_AND {$$=$1} 
    | T_INSTANCEOF {$$=$1} | T_NEW {$$=$1} | T_CLONE {$$=$1} | T_EXIT {$$=$1} | T_IF {$$=$1} | T_ELSEIF {$$=$1} | T_ELSE {$$=$1} | T_ENDIF {$$=$1} | T_ECHO {$$=$1} | T_DO {$$=$1} | T_WHILE {$$=$1} | T_ENDWHILE {$$=$1} 
    | T_FOR {$$=$1} | T_ENDFOR {$$=$1} | T_FOREACH {$$=$1} | T_ENDFOREACH {$$=$1} | T_DECLARE {$$=$1} | T_ENDDECLARE {$$=$1} | T_AS {$$=$1} | T_TRY {$$=$1} | T_CATCH {$$=$1} | T_FINALLY {$$=$1} 
    | T_THROW {$$=$1} | T_USE {$$=$1} | T_INSTEADOF {$$=$1} | T_GLOBAL {$$=$1} | T_VAR {$$=$1} | T_UNSET {$$=$1} | T_ISSET {$$=$1} | T_EMPTY {$$=$1} | T_CONTINUE {$$=$1} | T_GOTO {$$=$1} 
    | T_FUNCTION {$$=$1} | T_CONST {$$=$1} | T_RETURN {$$=$1} | T_PRINT {$$=$1} | T_YIELD {$$=$1} | T_LIST {$$=$1} | T_SWITCH {$$=$1} | T_ENDSWITCH {$$=$1} | T_CASE {$$=$1} | T_DEFAULT {$$=$1} | T_BREAK {$$=$1} 
    | T_ARRAY {$$=$1} | T_CALLABLE {$$=$1} | T_EXTENDS {$$=$1} | T_IMPLEMENTS {$$=$1} | T_NAMESPACE {$$=$1} | T_TRAIT {$$=$1} | T_INTERFACE {$$=$1} | T_CLASS {$$=$1} 
    | T_CLASS_C {$$=$1} | T_TRAIT_C {$$=$1} | T_FUNC_C {$$=$1} | T_METHOD_C {$$=$1} | T_LINE {$$=$1} | T_FILE {$$=$1} | T_DIR {$$=$1} | T_NS_C {$$=$1} 
;

semi_reserved:
        reserved_non_modifiers
            {
                $$ = $1
            }
    |   T_STATIC {$$=$1} | T_ABSTRACT {$$=$1} | T_FINAL {$$=$1} | T_PRIVATE {$$=$1} | T_PROTECTED {$$=$1} | T_PUBLIC {$$=$1}
;

identifier:
        T_STRING
            {
                $$ = $1
            }
    |   semi_reserved
            {
                $$ = $1
            }
;

top_statement_list:
        top_statement_list top_statement
            {
                if $2 != nil {
                    $$ = append($1, $2)
                }

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   /* empty */
            {
                $$ = []node.Node{}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

namespace_name:
        T_STRING
            {
                namePart := name.NewNamePart($1.Value)
                $$ = []node.Node{namePart}

                // save position
                namePart.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(namePart.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   namespace_name T_NS_SEPARATOR T_STRING
            {
                namePart := name.NewNamePart($3.Value)
                $$ = append($1, namePart)

                // save position
                namePart.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(namePart.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

name:
        namespace_name
            {
                $$ = name.NewName($1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($1))

                // save comments
                $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    | T_NAMESPACE T_NS_SEPARATOR namespace_name
            {
                $$ = name.NewRelative($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.NsSeparatorToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    | T_NS_SEPARATOR namespace_name
            {
                $$ = name.NewFullyQualified($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

top_statement:
        error
            {
                // error
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   function_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   class_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   trait_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   interface_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_HALT_COMPILER '(' ')' ';'
            {
                $$ = stmt.NewHaltCompiler()

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)

                yylex.(*Parser).Begin(scanner.HALT_COMPILER)
            }
    |   T_NAMESPACE namespace_name ';'
            {
                name := name.NewName($2)
                $$ = stmt.NewNamespace(name, nil)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NAMESPACE namespace_name '{' top_statement_list '}'
            {
                name := name.NewName($2)
                $$ = stmt.NewNamespace(name, $4)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $5.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NAMESPACE '{' top_statement_list '}'
            {
                $$ = stmt.NewNamespace(nil, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_USE mixed_group_use_declaration ';'
            {
                $$ = $2

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_USE use_type group_use_declaration ';'
            {
                $$ = $3.(*stmt.GroupUse).SetUseType($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_USE use_declarations ';'
            {
                $$ = stmt.NewUseList(nil, $2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_USE use_type use_declarations ';'
            {
                $$ = stmt.NewUseList($2, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CONST const_list ';'
            {
                $$ = stmt.NewConstList($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

use_type:
        T_FUNCTION
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CONST
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

group_use_declaration:
        namespace_name T_NS_SEPARATOR '{' unprefixed_use_declarations possible_comma '}'
            {
                name := name.NewName($1)
                $$ = stmt.NewGroupUse(nil, name, $4)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListTokenPosition($1, $6))

                // save comments
                $2.Meta.SetTokenName(meta.NsSeparatorToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                if $5 != nil {
                    $5.Meta.SetTokenName(meta.CommaToken).AppendTo($$.GetMeta())
                    yylex.(*Parser).appendMetaToken($$, $5, meta.CommaToken)
                }
                $6.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo(name.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NS_SEPARATOR namespace_name T_NS_SEPARATOR '{' unprefixed_use_declarations possible_comma '}'
            {
                name := name.NewName($2)
                $$ = stmt.NewGroupUse(nil, name, $5)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $7))

                // save comments
                $1.Meta.SetTokenName(meta.UseLeadingNsSeparatorToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.UseLeadingNsSeparatorToken)
                $3.Meta.SetTokenName(meta.NsSeparatorToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                if $6 != nil {
                    $6.Meta.SetTokenName(meta.CommaToken).AppendTo($$.GetMeta())
                    yylex.(*Parser).appendMetaToken($$, $6, meta.CommaToken)
                }
                $7.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                $2[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo(name.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

mixed_group_use_declaration:
        namespace_name T_NS_SEPARATOR '{' inline_use_declarations possible_comma '}'
            {
                name := name.NewName($1)
                $$ = stmt.NewGroupUse(nil, name, $4)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListTokenPosition($1, $6))

                // save comments
                $2.Meta.SetTokenName(meta.NsSeparatorToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                if $5 != nil {
                    $5.Meta.SetTokenName(meta.CommaToken).AppendTo($$.GetMeta())
                    yylex.(*Parser).appendMetaToken($$, $5, meta.CommaToken)
                }
                $6.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo(name.GetMeta())
                
                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NS_SEPARATOR namespace_name T_NS_SEPARATOR '{' inline_use_declarations possible_comma '}'
            {
                name := name.NewName($2)
                $$ = stmt.NewGroupUse(nil, name, $5)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $7))

                // save comments
                $1.Meta.SetTokenName(meta.UseLeadingNsSeparatorToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.UseLeadingNsSeparatorToken)
                $3.Meta.SetTokenName(meta.NsSeparatorToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                if $6 != nil {
                    $6.Meta.SetTokenName(meta.CommaToken).AppendTo($$.GetMeta())
                    yylex.(*Parser).appendMetaToken($$, $6, meta.CommaToken)
                }
                $7.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                $2[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo(name.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

possible_comma:
        /* empty */
            {
                $$ = nil
            }
    |   ','
            {
                $$ = $1
            }
;

inline_use_declarations:
        inline_use_declarations ',' inline_use_declaration
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   inline_use_declaration
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

unprefixed_use_declarations:
        unprefixed_use_declarations ',' unprefixed_use_declaration
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   unprefixed_use_declaration
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

use_declarations:
        use_declarations ',' use_declaration
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   use_declaration
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

inline_use_declaration:
        unprefixed_use_declaration
            {
                $$ = $1

                $1.(*stmt.Use).Use.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   use_type unprefixed_use_declaration
            {
                $$ = $2.(*stmt.Use).SetUseType($1)

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

unprefixed_use_declaration:
        namespace_name
            {
                name := name.NewName($1)
                $$ = stmt.NewUse(nil, name, nil)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($1))

                $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo(name.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   namespace_name T_AS T_STRING
            {
                name := name.NewName($1)
                alias := node.NewIdentifier($3.Value)
                $$ = stmt.NewUse(nil, name, alias)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($1))
                alias.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListTokenPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.AsToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(alias.GetMeta())

                $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo(name.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

use_declaration:
        unprefixed_use_declaration
            {
                $$ = $1

                $1.(*stmt.Use).Use.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NS_SEPARATOR unprefixed_use_declaration
            {
                $$ = $2;

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

const_list:
        const_list ',' const_decl
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   const_decl
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

inner_statement_list:
        inner_statement_list inner_statement
            {
                if $2 != nil {
                    $$ = append($1, $2)
                }

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   /* empty */
            {
                $$ = []node.Node{}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

inner_statement:
        error
            {
                // error
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   function_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   class_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   trait_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   interface_declaration_statement
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_HALT_COMPILER '(' ')' ';'
            {
                $$ = stmt.NewHaltCompiler()

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }

statement:
        '{' inner_statement_list '}'
            {
                $$ = stmt.NewStmtList($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   if_stmt
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   alt_if_stmt
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_WHILE '(' expr ')' while_statement
            {
                switch n := $5.(type) {
                case *stmt.While :
                    n.Cond = $3
                case *stmt.AltWhile :
                    n.Cond = $3
                }

                $$ = $5

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DO statement T_WHILE '(' expr ')' ';'
            {
                $$ = stmt.NewDo($2, $5)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $7))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.WhileToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $7.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $7, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FOR '(' for_exprs ';' for_exprs ';' for_exprs ')' for_statement
            {
                switch n := $9.(type) {
                case *stmt.For :
                    n.Init = $3
                    n.Cond = $5
                    n.Loop = $7
                case *stmt.AltFor :
                    n.Init = $3
                    n.Cond = $5
                    n.Loop = $7
                }

                $$ = $9

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $9))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.ForInitSemicolonToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.ForCondSemicolonToken).AppendTo($$.GetMeta())
                $8.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_SWITCH '(' expr ')' switch_case_list
            {
                switch n := $5.(type) {
                case *stmt.Switch:
                    n.Cond = $3
                case *stmt.AltSwitch:
                    n.Cond = $3
                default:
                    panic("unexpected node type")
                }

                $$ = $5

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_BREAK optional_expr ';'
            {
                $$ = stmt.NewBreak($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CONTINUE optional_expr ';'
            {
                $$ = stmt.NewContinue($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_RETURN optional_expr ';'
            {
                $$ = stmt.NewReturn($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_GLOBAL global_var_list ';'
            {
                $$ = stmt.NewGlobal($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_STATIC static_var_list ';'
            {
                $$ = stmt.NewStatic($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_ECHO echo_expr_list ';'
            {
                $$ = stmt.NewEcho($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_INLINE_HTML
            {
                $$ = stmt.NewInlineHtml($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr ';'
            {
                $$ = stmt.NewExpression($1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $2))

                // save comments
                $2.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.SemiColonToken)

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_UNSET '(' unset_variables possible_comma ')' ';' 
            {
                $$ = stmt.NewUnset($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $6))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                if $4 != nil {
                    $4.Meta.SetTokenName(meta.CommaToken).AppendTo($$.GetMeta())
                    yylex.(*Parser).appendMetaToken($$, $4, meta.CommaToken)
                }
                $5.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $6, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FOREACH '(' expr T_AS foreach_variable ')' foreach_statement
            {
                switch n := $7.(type) {
                case *stmt.Foreach :
                    n.Expr = $3
                    n.Variable = $5
                case *stmt.AltForeach :
                    n.Expr = $3
                    n.Variable = $5
                }

                $$ = $7

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $7))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.AsToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FOREACH '(' expr T_AS variable T_DOUBLE_ARROW foreach_variable ')' foreach_statement
            {
                switch n := $9.(type) {
                case *stmt.Foreach :
                    n.Expr = $3
                    n.Key = $5
                    n.Variable = $7
                case *stmt.AltForeach :
                    n.Expr = $3
                    n.Key = $5
                    n.Variable = $7
                }

                $$ = $9

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $9))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.AsToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.DoubleArrowToken).AppendTo($$.GetMeta())
                $8.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DECLARE '(' const_list ')' declare_statement
            {
                $$ = $5
                $$.(*stmt.Declare).Consts = $3

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ';'
            {
                $$ = stmt.NewNop()

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_TRY '{' inner_statement_list '}' catch_list finally_statement
            {
                if $6 == nil {
                    $$ = stmt.NewTry($3, $5, $6)
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($1, $5))
                } else {
                    $$ = stmt.NewTry($3, $5, $6)
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $6))
                }

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_THROW expr ';'
            {
                $$ = stmt.NewThrow($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_GOTO T_STRING ';'
            {
                label := node.NewIdentifier($2.Value)
                $$ = stmt.NewGoto(label)

                // save position
                label.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(label.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_STRING ':'
            {
                label := node.NewIdentifier($1.Value)
                $$ = stmt.NewLabel(label)

                // save position
                label.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }

catch_list:
        /* empty */
            {
                $$ = []node.Node{}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   catch_list T_CATCH '(' catch_name_list T_VARIABLE ')' '{' inner_statement_list '}'
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($5.Value, isDollar))
                variable := expr.NewVariable(identifier)
                catch := stmt.NewCatch($4, variable, $8)
                $$ = append($1, catch)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($5))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($5))
                catch.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($2, $9))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(catch.GetMeta())
                $3.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo(catch.GetMeta())
                $5.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)
                $6.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo(catch.GetMeta())
                $7.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo(catch.GetMeta())
                $9.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo(catch.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;
catch_name_list:
        name
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   catch_name_list '|' name
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

finally_statement:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FINALLY '{' inner_statement_list '}'
            {
                $$ = stmt.NewFinally($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

unset_variables:
        unset_variable
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   unset_variables ',' unset_variable
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

unset_variable:
        variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

function_declaration_statement:
        T_FUNCTION returns_ref T_STRING backup_doc_comment '(' parameter_list ')' return_type '{' inner_statement_list '}'
            {
                name := node.NewIdentifier($3.Value)
                $$ = stmt.NewFunction(name, $2 != nil, $6, $8, $10, $4)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $11))


                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                if $2 != nil {
                    $2.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())
                }
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $5.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $7.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $9.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $11.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

is_reference:
        /* empty */
            {
                $$ = nil
            }
    |   '&'
            {
                $$ = $1
            }
;

is_variadic:
        /* empty */
            {
                $$ = nil
            }
    |   T_ELLIPSIS
            {
                $$ = $1
            }
;

class_declaration_statement:
    class_modifiers T_CLASS T_STRING extends_from implements_list backup_doc_comment '{' class_statement_list '}'
            {
                name := node.NewIdentifier($3.Value)
                $$ = stmt.NewClass(name, $1, nil, $4, $5, $8, $6)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewOptionalListTokensPosition($1, $2, $9))

                // save comments
                $2.Meta.SetTokenName(meta.ClassToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $7.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $9.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CLASS T_STRING extends_from implements_list backup_doc_comment '{' class_statement_list '}'
            {
                name := node.NewIdentifier($2.Value)
                $$ = stmt.NewClass(name, nil, nil, $3, $4, $7, $5)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $8))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $6.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $8.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_modifiers:
        class_modifier
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   class_modifiers class_modifier
            {
                $$ = append($1, $2)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_modifier:
        T_ABSTRACT
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FINAL
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

trait_declaration_statement:
        T_TRAIT T_STRING backup_doc_comment '{' class_statement_list '}'
            {
                name := node.NewIdentifier($2.Value)
                $$ = stmt.NewTrait(name, $5, $3)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $6))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $4.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

interface_declaration_statement:
        T_INTERFACE T_STRING interface_extends_list backup_doc_comment '{' class_statement_list '}'
            {
                name := node.NewIdentifier($2.Value)
                $$ = stmt.NewInterface(name, $3, $6, $4)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $7))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $5.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $7.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

extends_from:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_EXTENDS name
            {
                $$ = stmt.NewClassExtends($2);

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.ExtendsToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

interface_extends_list:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_EXTENDS name_list
            {
                $$ = stmt.NewInterfaceExtends($2);

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.ExtendsToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

implements_list:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_IMPLEMENTS name_list
            {
                $$ = stmt.NewClassImplements($2);

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.ImplementsToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

foreach_variable:
        variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '&' variable
            {
                $$ = expr.NewReference($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_LIST '(' array_pair_list ')'
            {
                $$ = expr.NewList($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '[' array_pair_list ']'
            {
                $$ = expr.NewShortList($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

for_statement:
        statement
            {
                $$ = stmt.NewFor(nil, nil, nil, $1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodePosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ':' inner_statement_list T_ENDFOR ';'
            {
                stmtList := stmt.NewStmtList($2)
                $$ = stmt.NewAltFor(nil, nil, nil, stmtList)

                // save position
                stmtList.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.EndforToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

foreach_statement:
        statement
            {
                $$ = stmt.NewForeach(nil, nil, nil, $1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodePosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ':' inner_statement_list T_ENDFOREACH ';'
            {
                stmtList := stmt.NewStmtList($2)
                $$ = stmt.NewAltForeach(nil, nil, nil, stmtList)

                // save position
                stmtList.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.EndforeachToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

declare_statement:
        statement
            {
                $$ = stmt.NewDeclare(nil, $1, false)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodePosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ':' inner_statement_list T_ENDDECLARE ';'
            {
                stmtList := stmt.NewStmtList($2)
                $$ = stmt.NewDeclare(nil, stmtList, true)

                // save position
                stmtList.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.EnddeclareToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

switch_case_list:
        '{' case_list '}'
            {
                caseList := stmt.NewCaseList($2)
                $$ = stmt.NewSwitch(nil, caseList)

                // save position
                caseList.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo(caseList.GetMeta())
                $3.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo(caseList.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '{' ';' case_list '}'
            {
                caseList := stmt.NewCaseList($3)
                $$ = stmt.NewSwitch(nil, caseList)

                // save position
                caseList.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo(caseList.GetMeta())
                $2.Meta.SetTokenName(meta.CaseSeparatorToken).AppendTo(caseList.GetMeta())
                yylex.(*Parser).appendMetaToken(caseList, $2, meta.CaseSeparatorToken)
                $4.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo(caseList.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ':' case_list T_ENDSWITCH ';'
            {
                caseList := stmt.NewCaseList($2)
                $$ = stmt.NewAltSwitch(nil, caseList)

                // save position
                caseList.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.EndswitchToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ':' ';' case_list T_ENDSWITCH ';'
            {

                caseList := stmt.NewCaseList($3)
                $$ = stmt.NewAltSwitch(nil, caseList)

                // save position
                caseList.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.CaseSeparatorToken).AppendTo(caseList.GetMeta())
                yylex.(*Parser).appendMetaToken(caseList, $2, meta.CaseSeparatorToken)
                $4.Meta.SetTokenName(meta.EndswitchToken).AppendTo($$.GetMeta())
                $5.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $5, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

case_list:
        /* empty */
            {
                $$ = []node.Node{}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   case_list T_CASE expr case_separator inner_statement_list
            {
                _case := stmt.NewCase($3, $5)
                $$ = append($1, _case)

                // save position
                _case.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($2, $5))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(_case.GetMeta())
                $4.Meta.SetTokenName(meta.CaseSeparatorToken).AppendTo(_case.GetMeta())
                yylex.(*Parser).appendMetaToken(_case, $4, meta.CaseSeparatorToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   case_list T_DEFAULT case_separator inner_statement_list
            {
                _default := stmt.NewDefault($4)
                $$ = append($1, _default)

                // save position
                _default.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($2, $4))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(_default.GetMeta())
                $3.Meta.SetTokenName(meta.CaseSeparatorToken).AppendTo(_default.GetMeta())
                yylex.(*Parser).appendMetaToken(_default, $3, meta.CaseSeparatorToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

case_separator:
        ':'
            {
                $$ = $1
            }
    |   ';'
            {
                $$ = $1
            }
;

while_statement:
        statement
            {
                $$ = stmt.NewWhile(nil, $1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodePosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ':' inner_statement_list T_ENDWHILE ';'
            {
                stmtList := stmt.NewStmtList($2)
                $$ = stmt.NewAltWhile(nil, stmtList)

                // save position
                stmtList.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.EndwhileToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

if_stmt_without_else:
        T_IF '(' expr ')' statement
            {
                $$ = stmt.NewIf($3, $5, nil, nil)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   if_stmt_without_else T_ELSEIF '(' expr ')' statement
            {
                _elseIf := stmt.NewElseIf($4, $6)
                $$ = $1.(*stmt.If).AddElseIf(_elseIf)

                // save position
                _elseIf.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($2, $6))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $6))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(_elseIf.GetMeta())
                $3.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo(_elseIf.GetMeta())
                $5.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo(_elseIf.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

if_stmt:
        if_stmt_without_else %prec T_NOELSE
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   if_stmt_without_else T_ELSE statement
            {
                _else := stmt.NewElse($3)
                $$ = $1.(*stmt.If).SetElse(_else)

                // save position
                _else.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($2, $3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(_else.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

alt_if_stmt_without_else:
        T_IF '(' expr ')' ':' inner_statement_list
            {
                stmts := stmt.NewStmtList($6)
                $$ = stmt.NewAltIf($3, stmts, nil, nil)

                // save position
                stmts.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($6))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($1, $6))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $5.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   alt_if_stmt_without_else T_ELSEIF '(' expr ')' ':' inner_statement_list
            {
                stmts := stmt.NewStmtList($7)
                _elseIf := stmt.NewAltElseIf($4, stmts)
                $$ = $1.(*stmt.AltIf).AddElseIf(_elseIf)

                // save position
                stmts.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($7))
                _elseIf.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($2, $7))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(_elseIf.GetMeta())
                $3.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo(_elseIf.GetMeta())
                $5.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo(_elseIf.GetMeta())
                $6.Meta.SetTokenName(meta.ColonToken).AppendTo(_elseIf.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

alt_if_stmt:
        alt_if_stmt_without_else T_ENDIF ';'
            {
                $$ = $1

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.EndifToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   alt_if_stmt_without_else T_ELSE ':' inner_statement_list T_ENDIF ';'
            {
                stmts := stmt.NewStmtList($4)
                _else := stmt.NewAltElse(stmts)
                $$ = $1.(*stmt.AltIf).SetElse(_else)

                // save position
                stmts.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListPosition($4))
                _else.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodeListPosition($2, $4))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $6))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(_else.GetMeta())
                $3.Meta.SetTokenName(meta.ColonToken).AppendTo(_else.GetMeta())
                $5.Meta.SetTokenName(meta.EndifToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $6, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

parameter_list:
        non_empty_parameter_list
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

non_empty_parameter_list:
        parameter
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   non_empty_parameter_list ',' parameter
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

parameter:
        optional_type is_reference is_variadic T_VARIABLE
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($4.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = node.NewParameter($1, variable, nil, $2 != nil, $3 != nil)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($4))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($4))
                if $1 != nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $4))
                } else if $2 != nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($2, $4))
                } else if $3 != nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($3, $4))
                } else {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($4))
                }

                // save comments
                if $1 != nil {
                    $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())
                }
                if $2 != nil {
                    $2.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())
                }
                if $3 != nil {
                    $3.Meta.SetTokenName(meta.EllipsisToken).AppendTo($$.GetMeta())
                }
                if $1 == nil && $2 == nil && $3 == nil {
                    $4.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                } else {
                    $4.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                }
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   optional_type is_reference is_variadic T_VARIABLE '=' expr
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($4.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = node.NewParameter($1, variable, $6, $2 != nil, $3 != nil)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($4))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($4))
                if $1 != nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $6))
                } else if $2 != nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($2, $6))
                } else if $3 != nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($3, $6))
                } else {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($4, $6))
                }

                // save comments
                if $1 != nil {
                    $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())
                }
                if $2 != nil {
                    $2.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())
                }
                if $3 != nil {
                    $3.Meta.SetTokenName(meta.EllipsisToken).AppendTo($$.GetMeta())
                }
                if $1 == nil && $2 == nil && $3 == nil {
                    $4.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                } else {
                    $4.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                }
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)
                $5.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

optional_type:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   type_expr
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

type_expr:
        type
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '?' type
            {
                $$ = node.NewNullable($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

type:
        T_ARRAY
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CALLABLE
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   name
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

return_type:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   ':' type_expr
            {
                $$ = $2;

                // save comments
                $1.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

argument_list:
        '(' ')'
            {
                $$ = node.NewArgumentList(nil)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '(' non_empty_argument_list possible_comma ')'
            {
                $$ = node.NewArgumentList($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                if $3 != nil {
                    $3.Meta.SetTokenName(meta.CommaToken).AppendTo($$.GetMeta())
                    yylex.(*Parser).appendMetaToken($$, $3, meta.CommaToken)
                }
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

non_empty_argument_list:
        argument
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   non_empty_argument_list ',' argument
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

argument:
        expr
            {
                $$ = node.NewArgument($1, false, false)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodePosition($1))

                // save comments
                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_ELLIPSIS expr
            {
                $$ = node.NewArgument($2, true, false)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

global_var_list:
        global_var_list ',' global_var
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   global_var
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

global_var:
        simple_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

static_var_list:
        static_var_list ',' static_var
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   static_var
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

static_var:
        T_VARIABLE
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = stmt.NewStaticVar(variable, nil)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_VARIABLE '=' expr
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = stmt.NewStaticVar(variable, $3)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)
                $2.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_statement_list:
        class_statement_list class_statement
            {
                $$ = append($1, $2)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   /* empty */
            {
                $$ = []node.Node{}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_statement:
        variable_modifiers property_list ';'
            {
                $$ = stmt.NewPropertyList($1, $2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListTokenPosition($1, $3))

                // save comments
                $3.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.SemiColonToken)

                $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   method_modifiers T_CONST class_const_list ';'
            {
                $$ = stmt.NewClassConstList($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewOptionalListTokensPosition($1, $2, $4))

                // save comments
                $2.Meta.SetTokenName(meta.ConstToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.SemiColonToken)

                

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_USE name_list trait_adaptations
            {
                $$ = stmt.NewTraitUse($2, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   method_modifiers T_FUNCTION returns_ref identifier backup_doc_comment '(' parameter_list ')' return_type method_body
            {
                name := node.NewIdentifier($4.Value)
                $$ = stmt.NewClassMethod(name, $1, $3 != nil, $7, $9, $10, $5)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($4))
                if $1 == nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($2, $10))
                } else {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeListNodePosition($1, $10))
                }

                // save comments
                $2.Meta.SetTokenName(meta.FunctionToken).AppendTo($$.GetMeta())
                if $3 != nil {
                    $3.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())
                }
                $4.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $6.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $8.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                if len($1) > 0 {
                    $1[0].GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())
                }

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

name_list:
        name
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   name_list ',' name
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

trait_adaptations:
        ';'
            {
                $$ = stmt.NewNop()

                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)


                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '{' '}'
            {
                $$ = stmt.NewTraitAdaptationList(nil)

                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '{' trait_adaptation_list '}'
            {
                $$ = stmt.NewTraitAdaptationList($2)

                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

trait_adaptation_list:
        trait_adaptation
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   trait_adaptation_list trait_adaptation
            {
                $$ = append($1, $2)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

trait_adaptation:
        trait_precedence ';'
            {
                $$ = $1;

                // save comments
                $2.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   trait_alias ';'
            {
                $$ = $1;

                // save comments
                $2.Meta.SetTokenName(meta.SemiColonToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.SemiColonToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

trait_precedence:
        absolute_trait_method_reference T_INSTEADOF name_list
            {
                $$ = stmt.NewTraitUsePrecedence($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeNodeListPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.InsteadofToken).AppendTo($$.GetMeta())

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

trait_alias:
        trait_method_reference T_AS T_STRING
            {
                alias := node.NewIdentifier($3.Value)
                $$ = stmt.NewTraitUseAlias($1, nil, alias)

                // save position
                alias.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.AsToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(alias.GetMeta())

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   trait_method_reference T_AS reserved_non_modifiers
            {
                alias := node.NewIdentifier($3.Value)
                $$ = stmt.NewTraitUseAlias($1, nil, alias)

                // save position
                alias.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.AsToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(alias.GetMeta())

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   trait_method_reference T_AS member_modifier identifier
            {
                alias := node.NewIdentifier($4.Value)
                $$ = stmt.NewTraitUseAlias($1, $3, alias)

                // save position
                alias.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($4))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.AsToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.NodeStart).AppendTo(alias.GetMeta())

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   trait_method_reference T_AS member_modifier
            {
                $$ = stmt.NewTraitUseAlias($1, $3, nil)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.AsToken).AppendTo($$.GetMeta())

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

trait_method_reference:
        identifier
            {
                name := node.NewIdentifier($1.Value)
                $$ = stmt.NewTraitMethodRef(nil, name)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   absolute_trait_method_reference
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

absolute_trait_method_reference:
        name T_PAAMAYIM_NEKUDOTAYIM identifier
            {
                target := node.NewIdentifier($3.Value)
                $$ = stmt.NewTraitMethodRef($1, target)

                // save position
                target.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(target.GetMeta())

                $1.GetMeta().Cut(newInheritMetaFilter()).PrependTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

method_body:
        ';' /* abstract method */ 
            {
                $$ = stmt.NewNop()

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '{' inner_statement_list '}'
            {
                $$ = stmt.NewStmtList($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

variable_modifiers:
        non_empty_member_modifiers
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_VAR
            {
                modifier := node.NewIdentifier($1.Value)
                $$ = []node.Node{modifier}

                // save position
                modifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(modifier.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

method_modifiers:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   non_empty_member_modifiers
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

non_empty_member_modifiers:
        member_modifier
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   non_empty_member_modifiers member_modifier
            {
                $$ = append($1, $2)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

member_modifier:
        T_PUBLIC
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_PROTECTED
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_PRIVATE
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_STATIC
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_ABSTRACT
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FINAL
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

property_list:
        property_list ',' property
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   property
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

property:
        T_VARIABLE backup_doc_comment
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = stmt.NewProperty(variable, nil, $2)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_VARIABLE '=' expr backup_doc_comment
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = stmt.NewProperty(variable, $3, $4)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)
                $2.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_const_list:
        class_const_list ',' class_const_decl
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   class_const_decl
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_const_decl:
        identifier '=' expr backup_doc_comment
            {
                name := node.NewIdentifier($1.Value)
                $$ = stmt.NewConstant(name, $3, $4)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $2.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

const_decl:
        T_STRING '=' expr backup_doc_comment
            {
                name := node.NewIdentifier($1.Value)
                $$ = stmt.NewConstant(name, $3, $4)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $2.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

echo_expr_list:
        echo_expr_list ',' echo_expr
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   echo_expr
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

echo_expr:
        expr
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

for_exprs:
        /* empty */
            {
                $$ = nil;

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   non_empty_for_exprs
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

non_empty_for_exprs:
        non_empty_for_exprs ',' expr
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

anonymous_class:
        T_CLASS ctor_arguments extends_from implements_list backup_doc_comment '{' class_statement_list '}'
            {
                if $2 != nil {
                    $$ = stmt.NewClass(nil, nil, $2.(*node.ArgumentList), $3, $4, $7, $5)
                } else {
                    $$ = stmt.NewClass(nil, nil, nil, $3, $4, $7, $5)
                }

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $8))

                // save comments
                $1.Meta.SetTokenName(meta.ClassToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $8.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

new_expr:
        T_NEW class_name_reference ctor_arguments
            {
                if $3 != nil {
                    $$ = expr.NewNew($2, $3.(*node.ArgumentList))
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $3))
                } else {
                    $$ = expr.NewNew($2, nil)
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))
                }

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NEW anonymous_class
            {
                $$ = expr.NewNew($2, nil)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

expr_without_variable:
        T_LIST '(' array_pair_list ')' '=' expr
            {
                list := expr.NewList($3)
                $$ = assign.NewAssign(list, $6)

                // save position
                list.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $6))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(list.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo(list.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo(list.GetMeta())
                $5.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '[' array_pair_list ']' '=' expr
            {
                shortList := expr.NewShortList($2)
                $$ = assign.NewAssign(shortList, $5)

                // save position
                shortList.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(shortList.GetMeta())
                $3.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo(shortList.GetMeta())
                $4.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable '=' expr
            {
                $$ = assign.NewAssign($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable '=' '&' expr
            {
                $$ = assign.NewReference($1, $4)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.EqualToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CLONE expr
            {
                $$ = expr.NewClone($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_PLUS_EQUAL expr
            {
                $$ = assign.NewPlus($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PlusEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_MINUS_EQUAL expr
            {
                $$ = assign.NewMinus($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.MinusEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_MUL_EQUAL expr
            {
                $$ = assign.NewMul($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.MulEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_POW_EQUAL expr
            {
                $$ = assign.NewPow($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PowEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_DIV_EQUAL expr
            {
                $$ = assign.NewDiv($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.DivEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_CONCAT_EQUAL expr
            {
                $$ = assign.NewConcat($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.ConcatEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_MOD_EQUAL expr
            {
                $$ = assign.NewMod($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.ModEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_AND_EQUAL expr
            {
                $$ = assign.NewBitwiseAnd($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.AndEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_OR_EQUAL expr
            {
                $$ = assign.NewBitwiseOr($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.OrEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_XOR_EQUAL expr
            {
                $$ = assign.NewBitwiseXor($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.XorEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_SL_EQUAL expr
            {
                $$ = assign.NewShiftLeft($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.SlEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_SR_EQUAL expr
            {
                $$ = assign.NewShiftRight($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.SrEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_INC
            {
                $$ = expr.NewPostInc($1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $2))

                // save comments
                $2.Meta.SetTokenName(meta.IncToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_INC variable
            {
                $$ = expr.NewPreInc($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable T_DEC
            {
                $$ = expr.NewPostDec($1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $2))

                // save comments
                $2.Meta.SetTokenName(meta.DecToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DEC variable
            {
                $$ = expr.NewPreDec($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_BOOLEAN_OR expr
            {
                $$ = binary.NewBooleanOr($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.BooleanOrToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_BOOLEAN_AND expr
            {
                $$ = binary.NewBooleanAnd($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.BooleanAndToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_LOGICAL_OR expr
            {
                $$ = binary.NewLogicalOr($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.LogicalOrToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_LOGICAL_AND expr
            {
                $$ = binary.NewLogicalAnd($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.LogicalAndToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_LOGICAL_XOR expr
            {
                $$ = binary.NewLogicalXor($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.LogicalXorToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '|' expr
            {
                $$ = binary.NewBitwiseOr($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.VerticalBarToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '&' expr
            {
                $$ = binary.NewBitwiseAnd($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '^' expr
            {
                $$ = binary.NewBitwiseXor($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.CaretToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '.' expr
            {
                $$ = binary.NewConcat($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.DotToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '+' expr
            {
                $$ = binary.NewPlus($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PlusToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '-' expr
            {
                $$ = binary.NewMinus($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.MinusToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '*' expr
            {
                $$ = binary.NewMul($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.AsteriskToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_POW expr
            {
                $$ = binary.NewPow($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PowToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '/' expr
            {
                $$ = binary.NewDiv($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.SlashToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '%' expr
            {
                $$ = binary.NewMod($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PercentToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_SL expr
            {
                $$ = binary.NewShiftLeft($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.SlToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_SR expr
            {
                $$ = binary.NewShiftRight($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.SrToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '+' expr %prec T_INC
            {
                $$ = expr.NewUnaryPlus($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '-' expr %prec T_INC
            {
                $$ = expr.NewUnaryMinus($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '!' expr
            {
                $$ = expr.NewBooleanNot($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '~' expr
            {
                $$ = expr.NewBitwiseNot($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_IS_IDENTICAL expr
            {
                $$ = binary.NewIdentical($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.IsIdenticalToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_IS_NOT_IDENTICAL expr
            {
                $$ = binary.NewNotIdentical($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.IsNotIdenticalToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_IS_EQUAL expr
            {
                $$ = binary.NewEqual($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.IsEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_IS_NOT_EQUAL expr
            {
                $$ = binary.NewNotEqual($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.IsNotEqualToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.IsNotEqualToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '<' expr
            {
                $$ = binary.NewSmaller($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.LessToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_IS_SMALLER_OR_EQUAL expr
            {
                $$ = binary.NewSmallerOrEqual($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.IsSmallerOrEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '>' expr
            {
                $$ = binary.NewGreater($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.GreaterToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_IS_GREATER_OR_EQUAL expr
            {
                $$ = binary.NewGreaterOrEqual($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.IsGreaterOrEqualToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_SPACESHIP expr
            {
                $$ = binary.NewSpaceship($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.SpaceshipToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_INSTANCEOF class_name_reference
            {
                $$ = expr.NewInstanceOf($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.InstanceofToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '(' expr ')'
            {
                $$ = $2;

                // save comments
                yylex.(*Parser).prependMetaToken($$, $1, meta.NodeStart)
                $1.Meta.SetTokenName(meta.NodeStart).PrependTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   new_expr
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '?' expr ':' expr
            {
                $$ = expr.NewTernary($1, $3, $5)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $5))

                // save comments
                $2.Meta.SetTokenName(meta.QuestionMarkToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr '?' ':' expr
            {
                $$ = expr.NewTernary($1, nil, $4)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.QuestionMarkToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.ColonToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_COALESCE expr
            {
                $$ = binary.NewCoalesce($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.CoalesceToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   internal_functions_in_yacc
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_INT_CAST expr
            {
                $$ = cast.NewInt($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DOUBLE_CAST expr
            {
                $$ = cast.NewDouble($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_STRING_CAST expr
            {
                $$ = cast.NewString($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_ARRAY_CAST expr
            {
                $$ = cast.NewArray($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_OBJECT_CAST expr
            {
                $$ = cast.NewObject($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_BOOL_CAST expr
            {
                $$ = cast.NewBool($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_UNSET_CAST expr
            {
                $$ = cast.NewUnset($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_EXIT exit_expr
            {
                var e *expr.Exit;
                if $2 != nil {
                    e = $2.(*expr.Exit)
                } else {
                    e = expr.NewExit(nil)
                }

                $$ = e

                if (strings.EqualFold($1.Value, "die")) {
                    e.Die = true
                }

                // save position
                if $2 == nil {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                } else {
                    $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))
                }

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '@' expr
            {
                $$ = expr.NewErrorSuppress($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   scalar
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '`' backticks_expr '`'
            {
                $$ = expr.NewShellExec($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_PRINT expr
            {
                $$ = expr.NewPrint($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_YIELD
            {
                $$ = expr.NewYield(nil, nil)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_YIELD expr
            {
                $$ = expr.NewYield(nil, $2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_YIELD expr T_DOUBLE_ARROW expr
            {
                $$ = expr.NewYield($2, $4)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.DoubleArrowToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_YIELD_FROM expr
            {
                $$ = expr.NewYieldFrom($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FUNCTION returns_ref backup_doc_comment '(' parameter_list ')' lexical_vars return_type '{' inner_statement_list '}'
            {
                $$ = expr.NewClosure($5, $7, $8, $10, false, $2 != nil, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $11))
                
                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                if $2 != nil {
                    $2.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())
                }
                $4.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $6.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $9.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $11.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_STATIC T_FUNCTION returns_ref backup_doc_comment '(' parameter_list ')' lexical_vars return_type '{' inner_statement_list '}'
            {
                $$ = expr.NewClosure($6, $8, $9, $11, true, $3 != nil, $4)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $12))
                
                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.FunctionToken).AppendTo($$.GetMeta())
                if $3 != nil {
                    $3.Meta.SetTokenName(meta.AmpersandToken).AppendTo($$.GetMeta())
                }
                $5.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $7.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                $10.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                $12.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

backup_doc_comment:
        /* empty */
            {
                $$ = yylex.(*Parser).PhpDocComment
                yylex.(*Parser).PhpDocComment = ""

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

returns_ref:
        /* empty */
            {
                $$ = nil
            }
    |   '&'
            {
                $$ = $1
            }
;

lexical_vars:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_USE '(' lexical_var_list ')'
            {
                $$ = expr.NewClosureUse($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

lexical_var_list:
        lexical_var_list ',' lexical_var
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   lexical_var
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

lexical_var:
    T_VARIABLE
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                $$ = expr.NewVariable(identifier)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMeta($$, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '&' T_VARIABLE
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($2.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = expr.NewReference(variable)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

function_call:
        name argument_list
            {
                $$ = expr.NewFunctionCall($1, $2.(*node.ArgumentList))

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $2))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   class_name T_PAAMAYIM_NEKUDOTAYIM member_name argument_list
            {
                $$ = expr.NewStaticCall($1, $3, $4.(*node.ArgumentList))

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable_class_name T_PAAMAYIM_NEKUDOTAYIM member_name argument_list
            {
                $$ = expr.NewStaticCall($1, $3, $4.(*node.ArgumentList))

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   callable_expr argument_list
            {
                $$ = expr.NewFunctionCall($1, $2.(*node.ArgumentList))

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $2))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_name:
        T_STATIC
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   name
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

class_name_reference:
        class_name
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   new_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

exit_expr:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '(' optional_expr ')'
            {
                $$ = expr.NewExit($2);

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.OpenParenthesisToken)
                $3.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.CloseParenthesisToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

backticks_expr:
        /* empty */
            {
                $$ = []node.Node{}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_ENCAPSED_AND_WHITESPACE
            {
                $$ = []node.Node{scalar.NewEncapsedStringPart($1.Value)}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   encaps_list
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

ctor_arguments:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   argument_list
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

dereferencable_scalar:
    T_ARRAY '(' array_pair_list ')'
            {
                $$ = expr.NewArray($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '[' array_pair_list ']'
            {
                $$ = expr.NewShortArray($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CONSTANT_ENCAPSED_STRING
            {
                $$ = scalar.NewString($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

scalar:
        T_LNUMBER
            {
                $$ = scalar.NewLnumber($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DNUMBER
            {
                $$ = scalar.NewDnumber($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_LINE
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FILE
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DIR
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_TRAIT_C
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_METHOD_C
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_FUNC_C
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NS_C
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CLASS_C
            {
                $$ = scalar.NewMagicConstant($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_START_HEREDOC T_ENCAPSED_AND_WHITESPACE T_END_HEREDOC 
            {
                encapsed := scalar.NewEncapsedStringPart($2.Value)
                $$ = scalar.NewHeredoc($1.Value, []node.Node{encapsed})

                // save position
                encapsed.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_START_HEREDOC T_END_HEREDOC
            {
                $$ = scalar.NewHeredoc($1.Value, nil)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '"' encaps_list '"'
            {
                $$ = scalar.NewEncapsed($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_START_HEREDOC encaps_list T_END_HEREDOC
            {
                $$ = scalar.NewHeredoc($1.Value, $2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   dereferencable_scalar
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   constant
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

constant:
        name
            {
                $$ = expr.NewConstFetch($1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodePosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   class_name T_PAAMAYIM_NEKUDOTAYIM identifier
            {
                target := node.NewIdentifier($3.Value)
                $$ = expr.NewClassConstFetch($1, target)

                // save position
                target.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(target.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable_class_name T_PAAMAYIM_NEKUDOTAYIM identifier
            {
                target := node.NewIdentifier($3.Value)
                $$ = expr.NewClassConstFetch($1, target)

                // save position
                target.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(target.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

expr:
        variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr_without_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

optional_expr:
        /* empty */
            {
                $$ = nil

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

variable_class_name:
        dereferencable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

dereferencable:
        variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '(' expr ')'
            {
                $$ = $2;

                // save comments
                yylex.(*Parser).prependMetaToken($$, $1, meta.NodeStart)
                $1.Meta.SetTokenName(meta.NodeStart).PrependTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   dereferencable_scalar
            {
                $$ = $1;

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

callable_expr:
        callable_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '(' expr ')'
            {
                $$ = $2;

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   dereferencable_scalar
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

callable_variable:
        simple_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   dereferencable '[' optional_expr ']'
            {
                $$ = expr.NewArrayDimFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.OpenSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.OpenSquareBracket)
                $4.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.CloseSquareBracket)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   constant '[' optional_expr ']'
            {
                $$ = expr.NewArrayDimFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.OpenSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.OpenSquareBracket)
                $4.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.CloseSquareBracket)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   dereferencable '{' expr '}'
            {
                $$ = expr.NewArrayDimFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.OpenCurlyBracesToken)
                $4.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.CloseCurlyBracesToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   dereferencable T_OBJECT_OPERATOR property_name argument_list
            {
                $$ = expr.NewMethodCall($1, $3, $4.(*node.ArgumentList))

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.ObjectOperatorToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   function_call
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

variable:
        callable_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   static_member
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   dereferencable T_OBJECT_OPERATOR property_name
            {
                $$ = expr.NewPropertyFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.ObjectOperatorToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

simple_variable:
        T_VARIABLE
            {
                name := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                $$ = expr.NewVariable(name)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMeta($$, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '$' '{' expr '}'
            {
                $$ = expr.NewVariable($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.NodeStart)
                $4.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '$' simple_variable
            {
                $$ = expr.NewVariable($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

static_member:
        class_name T_PAAMAYIM_NEKUDOTAYIM simple_variable
            {
                $$ = expr.NewStaticPropertyFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   variable_class_name T_PAAMAYIM_NEKUDOTAYIM simple_variable
            {
                $$ = expr.NewStaticPropertyFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

new_variable:
        simple_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   new_variable '[' optional_expr ']'
            {
                $$ = expr.NewArrayDimFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.OpenSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.OpenSquareBracket)
                $4.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.CloseSquareBracket)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   new_variable '{' expr '}'
            {
                $$ = expr.NewArrayDimFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $4))

                // save comments
                $2.Meta.SetTokenName(meta.OpenCurlyBracesToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.OpenCurlyBracesToken)
                $4.Meta.SetTokenName(meta.CloseCurlyBracesToken).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.CloseCurlyBracesToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   new_variable T_OBJECT_OPERATOR property_name
            {
                $$ = expr.NewPropertyFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.ObjectOperatorToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   class_name T_PAAMAYIM_NEKUDOTAYIM simple_variable
            {
                $$ = expr.NewStaticPropertyFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   new_variable T_PAAMAYIM_NEKUDOTAYIM simple_variable
            {
                $$ = expr.NewStaticPropertyFetch($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.PaamayimNekudotayimToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

member_name:
        identifier
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '{' expr '}'
            {
                $$ = $2;

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   simple_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

property_name:
        T_STRING
            {
                $$ = node.NewIdentifier($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '{' expr '}'
            {
                $$ = $2;
                
                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   simple_variable
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

array_pair_list:
        non_empty_array_pair_list
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

possible_array_pair:
        /* empty */
            {
                $$ = expr.NewArrayItem(nil, nil)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   array_pair
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

non_empty_array_pair_list:
        non_empty_array_pair_list ',' possible_array_pair
            {
                if len($1) == 0 {
                    $1 = []node.Node{expr.NewArrayItem(nil, nil)}
                }

                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   possible_array_pair
            {
                if $1.(*expr.ArrayItem).Key == nil && $1.(*expr.ArrayItem).Val == nil {
                    $$ = []node.Node{}
                } else {
                    $$ = []node.Node{$1}
                }

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

array_pair:
        expr T_DOUBLE_ARROW expr
            {
                $$ = expr.NewArrayItem($1, $3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $3))

                // save comments
                $2.Meta.SetTokenName(meta.DoubleArrowToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr
            {
                $$ = expr.NewArrayItem(nil, $1)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodePosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_DOUBLE_ARROW '&' variable
            {
                reference := expr.NewReference($4)
                $$ = expr.NewArrayItem($1, reference)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodesPosition($1, $4))
                reference.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($3, $4))

                // save comments
                $2.Meta.SetTokenName(meta.DoubleArrowToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(reference.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '&' variable
            {
                reference := expr.NewReference($2)
                $$ = expr.NewArrayItem(nil, reference)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))
                reference.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(reference.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   expr T_DOUBLE_ARROW T_LIST '(' array_pair_list ')'
            {
                // TODO: Cannot use list() as standalone expression
                list := expr.NewList($5)
                $$ = expr.NewArrayItem($1, list)

                // save position
                list.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($3, $6))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewNodeTokenPosition($1, $6))

                // save comments
                $2.Meta.SetTokenName(meta.DoubleArrowToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(list.GetMeta())
                $4.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo(list.GetMeta())
                $6.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo(list.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_LIST '(' array_pair_list ')'
            {
                // TODO: Cannot use list() as standalone expression
                list := expr.NewList($3)
                $$ = expr.NewArrayItem(nil, list)

                // save position
                list.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))
                
                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(list.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo(list.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo(list.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

encaps_list:
        encaps_list encaps_var
            {
                $$ = append($1, $2)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   encaps_list T_ENCAPSED_AND_WHITESPACE
            {
                encapsed := scalar.NewEncapsedStringPart($2.Value)
                $$ = append($1, encapsed)

                // save position
                encapsed.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))

                // save comments
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(encapsed.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   encaps_var
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_ENCAPSED_AND_WHITESPACE encaps_var
            {
                encapsed := scalar.NewEncapsedStringPart($1.Value)
                $$ = []node.Node{encapsed, $2}

                // save position
                encapsed.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(encapsed.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

encaps_var:
        T_VARIABLE
            {
                name := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                $$ = expr.NewVariable(name)

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMeta($$, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_VARIABLE '[' encaps_var_offset ']'
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                variable := expr.NewVariable(identifier)
                $$ = expr.NewArrayDimFetch(variable, $3)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)
                $2.Meta.SetTokenName(meta.OpenSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $2, meta.OpenCurlyBracesToken)
                $4.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $4, meta.CloseCurlyBracesToken)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_VARIABLE T_OBJECT_OPERATOR T_STRING
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                variable := expr.NewVariable(identifier)
                fetch := node.NewIdentifier($3.Value)
                $$ = expr.NewPropertyFetch(variable, fetch)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                fetch.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($3))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo(variable.GetMeta())
                yylex.(*Parser).appendMeta(variable, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)
                $2.Meta.SetTokenName(meta.ObjectOperatorToken).AppendTo($$.GetMeta())
                $3.Meta.SetTokenName(meta.NodeStart).AppendTo(fetch.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DOLLAR_OPEN_CURLY_BRACES expr '}'
            {
                variable := expr.NewVariable($2)

                $$ = variable

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DOLLAR_OPEN_CURLY_BRACES T_STRING_VARNAME '}'
            {
                name := node.NewIdentifier($2.Value)
                variable := expr.NewVariable(name)

                $$ = variable

                // save position
                name.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $3))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $2.Meta.SetTokenName(meta.NodeStart).AppendTo(name.GetMeta())
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_DOLLAR_OPEN_CURLY_BRACES T_STRING_VARNAME '[' expr ']' '}'
            {
                identifier := node.NewIdentifier($2.Value)
                variable := expr.NewVariable(identifier)
                $$ = expr.NewArrayDimFetch(variable, $4)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                variable.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($2))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $6))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $1, meta.NodeStart)
                $3.Meta.SetTokenName(meta.OpenSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.OpenSquareBracket)
                $5.Meta.SetTokenName(meta.CloseSquareBracket).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $5, meta.CloseSquareBracket)
                $6.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $6, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_CURLY_OPEN variable '}'
            {
                $$ = $2;

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).PrependTo($$.GetMeta())
                yylex.(*Parser).prependMetaToken($$, $1, meta.NodeStart)
                $3.Meta.SetTokenName(meta.NodeEnd).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMetaToken($$, $3, meta.NodeEnd)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

encaps_var_offset:
        T_STRING
            {
                $$ = scalar.NewString($1.Value)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_NUM_STRING
            {
                // TODO: add option to handle 64 bit integer
                if _, err := strconv.Atoi($1.Value); err == nil {
                    $$ = scalar.NewLnumber($1.Value)
                } else {
                    $$ = scalar.NewString($1.Value)
                }

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   '-' T_NUM_STRING
            {
                var lnumber *scalar.Lnumber
                // TODO: add option to handle 64 bit integer
                _, err := strconv.Atoi($2.Value);
                isInt := err == nil

                if isInt {
                    lnumber = scalar.NewLnumber($2.Value)
                    $$ = expr.NewUnaryMinus(lnumber)
                } else {
                    $2.Value = "-"+$2.Value
                    $$ = scalar.NewString($2.Value)
                }

                // save position
                if isInt {
                    lnumber.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $2))
                }
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_VARIABLE
            {
                identifier := node.NewIdentifier(strings.TrimLeftFunc($1.Value, isDollar))
                $$ = expr.NewVariable(identifier)

                // save position
                identifier.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenPosition($1))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                yylex.(*Parser).appendMeta($$, &meta.Data{"$", meta.TokenType, nil, meta.NodeStart}, meta.NodeStart)

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

internal_functions_in_yacc:
        T_ISSET '(' isset_variables possible_comma ')'
            {
                $$ = expr.NewIsset($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $5))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                if $4 != nil {
                    $4.Meta.SetTokenName(meta.CommaToken).AppendTo($$.GetMeta())
                    yylex.(*Parser).appendMetaToken($$, $4, meta.CommaToken)
                }
                $5.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_EMPTY '(' expr ')'
            {
                $$ = expr.NewEmpty($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_INCLUDE expr
            {
                $$ = expr.NewInclude($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_INCLUDE_ONCE expr
            {
                $$ = expr.NewIncludeOnce($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_EVAL '(' expr ')'
            {
                $$ = expr.NewEval($3)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokensPosition($1, $4))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())
                $2.Meta.SetTokenName(meta.OpenParenthesisToken).AppendTo($$.GetMeta())
                $4.Meta.SetTokenName(meta.CloseParenthesisToken).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_REQUIRE expr
            {
                $$ = expr.NewRequire($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   T_REQUIRE_ONCE expr
            {
                $$ = expr.NewRequireOnce($2)

                // save position
                $$.SetPosition(yylex.(*Parser).positionBuilder.NewTokenNodePosition($1, $2))

                // save comments
                $1.Meta.SetTokenName(meta.NodeStart).AppendTo($$.GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

isset_variables:
        isset_variable
            {
                $$ = []node.Node{$1}

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
    |   isset_variables ',' isset_variable
            {
                $$ = append($1, $3)

                // save comments
                $2.Meta.SetTokenName(meta.NodeEnd).AppendTo(lastNode($1).GetMeta())

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

isset_variable:
        expr
            {
                $$ = $1

                yylex.(*Parser).returnTokenToPool(yyDollar, &yyVAL)
            }
;

/////////////////////////////////////////////////////////////////////////

%%
