# 2012/11/01 (SL)
gap> m := IdentityMat(10,GF(7));;
gap> m[3][3] := 0*Z(7,6);;
gap> Display(m);
 1 . . . . . . . . .
 . 1 . . . . . . . .
 . . . . . . . . . .
 . . . 1 . . . . . .
 . . . . 1 . . . . .
 . . . . . 1 . . . .
 . . . . . . 1 . . .
 . . . . . . . 1 . .
 . . . . . . . . 1 .
 . . . . . . . . . 1
