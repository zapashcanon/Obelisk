%token FOO BAR

%left zorro

%start <unit> main

%%

main:
  FOO {}

