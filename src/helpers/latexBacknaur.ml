include MiniLatex

let print_header ts =
  documentclass
    "\\\\usepackage{backnaur}@;@;\
     \\\\let\\\\oldbnfprod\\\\bnfprod@;\
     \\\\renewcommand{\\\\bnfprod}[3][\\\\textwidth]{\\\\oldbnfprod{#2}{%%@;<0 2>\
     \\\\begin{minipage}[t]{#1}@;<0 4>\
     $#3$@;<0 2>\
     \\\\end{minipage}}}@;@;\
     \\\\newcommand{\\\\bnfbar}{\\\\hspace*{-2.5em}\\\\bnfor\\\\hspace*{1.2em}}@;@;";
  begin_document "bnf*" ts

let print_footer () = end_document "bnf*"

let def = "}{"
let prod_bar = "\\\\bnfbar "
let bar = "@ \\\\bnfbar@ "
let space = "\\\\bnfsp@ "
let break = "@;\\\\\\\\"
let eps = "\\\\bnfts{$\\\\epsilon$}"

let print_rule_name is_not_fun name =
  print_fmt "%s" (Str.global_replace (Str.regexp "_") "\\_" name)
let rule_begin () =
  print_string "@[<v 2>\\\\bnfprod{"
let rule_end () =
  print_string "}\\\\\\\\@]@;"

let production_begin _ =
  print_string "@[<hov 2>"
let production_end _ =
  print_string "@]"

let print_terminal is_term _ s =
  let s' = Str.global_replace (Str.regexp "_") "\\_" s in
  if is_term then print_fmt "\\bnfts{\\%s{}}" (command s)
  else print_fmt "\\bnfpn{%s}" s'

let enclose print op cl =
  print_string op; print (); print_string cl

let par e print =
  if e then enclose print "(" ")" else print ()