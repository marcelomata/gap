#############################################################################
##
#W  magma.gi                    GAP library                     Thomas Breuer
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  This file contains generic methods for magmas.
##
Revision.magma_gi :=
    "@(#)$Id$";


#############################################################################
##

#M  PrintObj( <M> ) . . . . . . . . . . . . . . . . . . . . . . print a magma
##
InstallMethod( PrintObj,
    "method for a magma",
    true,
    [ IsMagma ], 0,
    function( M )
    Print( "Magma( ... )" );
    end );

InstallMethod( PrintObj,
    "method for a magma with generators",
    true,
    [ IsMagma and HasGeneratorsOfMagma ], 0,
    function( M )
    Print( "Magma( ", GeneratorsOfMagma( M ), " )" );
    end );

InstallMethod( PrintObj,
    "method for a magma-with-one with generators",
    true,
    [ IsMagmaWithOne and HasGeneratorsOfMagmaWithOne ], 0,
    function( M )
    Print( "MagmaWithOne( ", GeneratorsOfMagmaWithOne( M ), " )" );
    end );

InstallMethod( PrintObj,
    "method for a magma-with-inverses with generators",
    true,
    [ IsMagmaWithInverses and HasGeneratorsOfMagmaWithInverses ], 0,
    function( M )
    Print( "MagmaWithInverses( ", GeneratorsOfMagmaWithInverses( M ), " )" );
    end );


#############################################################################
##
#M  IsTrivial( <M> )  . . . . . . . . . . . . test whether a magma is trivial
##
InstallImmediateMethod( IsTrivial,
    IsMagmaWithOne and HasGeneratorsOfMagmaWithOne, 0,
    function( M )
    if IsEmpty( GeneratorsOfMagmaWithOne( M ) ) then
      return true;
    else
      TryNextMethod();
    fi;
    end );

InstallImmediateMethod( IsTrivial,
    IsMagmaWithInverses and HasGeneratorsOfMagmaWithInverses, 0,
    function( M )
    if IsEmpty( GeneratorsOfMagmaWithInverses( M ) ) then
      return true;
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  IsAssociative( <M> )  . . . . . . . . test whether a magma is associative
##
InstallMethod( IsAssociative,
    "method for a magma",
    true,
    [ IsMagma ], 0,
    function( M )

    local elms,      # list of elements
          i, j, k;   # loop variables

    # Test associativity for all triples of elements.
    elms:= Enumerator( M );
    for i in elms do
      for j in elms do
        for k in elms do
          if ( i * j ) * k <> i * ( j * k ) then
            return false;
          fi;
        od;
      od;
    od;

    # No associativity test failed.
    return true;
    end );


#############################################################################
##
#M  IsCommutative( <M> )  . . . . . . . . test whether a magma is commutative
##
InstallImmediateMethod( IsCommutative,
    IsMagma and IsAssociative and HasGeneratorsOfMagma, 0,
    function( M )
    if Length( GeneratorsOfMagma( M ) ) = 1 then
      return true;
    else
      TryNextMethod();
    fi;
    end );

InstallImmediateMethod( IsCommutative,
    IsMagmaWithOne and IsAssociative and HasGeneratorsOfMagmaWithOne, 0,
    function( M )
    if Length( GeneratorsOfMagmaWithOne( M ) ) = 1 then
      return true;
    else
      TryNextMethod();
    fi;
    end );

InstallImmediateMethod( IsCommutative,
    IsMagmaWithInverses and IsAssociative
                        and HasGeneratorsOfMagmaWithInverses, 0,
    function( M )
    if Length( GeneratorsOfMagmaWithInverses( M ) ) = 1 then
      return true;
    else
      TryNextMethod();
    fi;
    end );

InstallMethod( IsCommutative,
    "method for a magma",
    true,
    [ IsMagma ], 0,
    IsCommutativeFromGenerators( GeneratorsOfDomain ) );

InstallMethod( IsCommutative,
    "method for an associative magma",
    true,
    [ IsMagma and IsAssociative ], 0,
    IsCommutativeFromGenerators( GeneratorsOfMagma ) );

InstallMethod( IsCommutative,
    "method for an associative magma with one",
    true,
    [ IsMagmaWithOne and IsAssociative ], 0,
    IsCommutativeFromGenerators( GeneratorsOfMagmaWithOne ) );

InstallMethod( IsCommutative,
    "method for an associative magma with inverses",
    true,
    [ IsMagmaWithInverses and IsAssociative ], 0,
    IsCommutativeFromGenerators( GeneratorsOfMagmaWithInverses ) );


#############################################################################
##
#M  CentralizerInParent( <M> )
##
InstallMethod( CentralizerInParent,
    "method for a magma with parent",
    true,
    [ IsMagma and HasParent ], 0,
    M -> Centralizer( Parent( M ), M ) );


#############################################################################
##
#M  Centralizer( <M>, <elm> ) . . . . .  centralizer of an element in a magma
#M  Centralizer( <M>, <N> ) . . . . . . . . centralizer of a magma in a magma
##
InstallMethod( Centralizer,
    "method for a magma, and a mult. element",
    IsCollsElms,
    [ IsMagma, IsMultiplicativeElement ], 0,
    function( M, obj )
    return Filtered( AsList( M ), x -> x * obj = obj * x );
    end );

InstallMethod( Centralizer,
    "method for a commutative magma, and a mult. element",
    IsCollsElms,
    [ IsMagma and IsCommutative, IsMultiplicativeElement ], SUM_FLAGS,
    function( M, obj )
    if obj in M then
      return M;
    else
      TryNextMethod();
    fi;
    end );

InstallMethod( Centralizer,
    "method for two magmas",
    IsIdentical,
    [ IsMagma, IsMagma ], 0,
    function( M, N )
    return Filtered( M, x -> ForAll( N, y -> x * y = y * x ) );
    end );

InstallMethod( Centralizer,
    "method for two magmas, the first being commutative",
    IsIdentical,
    [ IsMagma and IsCommutative, IsMagma ], SUM_FLAGS,
    function( M, N )
    if IsSubset( M, N ) then
      return M;
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  Centre( <M> ) . . . . . . . . . . . . . . . . . . . . . centre of a magma
##
InstallMethod( Centre,
    "method for a magma",
    true,
    [ IsMagma ], 0,
    M -> Centralizer( M, M ) );

InstallMethod( Centre,
    "method for a commutative magma",
    true,
    [ IsMagma and IsCommutative ], SUM_FLAGS,
    IdFunc );


#############################################################################
##
#F  Magma( <gens> )
#F  Magma( <Fam>, <gens> )
##
Magma := function( arg )

    # list of generators
    if Length( arg ) = 1 and IsList( arg[1] ) and 0 < Length( arg[1] ) then
      return MagmaByGenerators( arg[1] );

    # family plus list of generators
    elif Length( arg ) = 2 and IsFamily( arg[1] ) and IsList( arg[1] ) then
      return MagmaByGenerators( arg[1], arg[2] );

    # generators
    elif 0 < Length( arg ) then
      return MagmaByGenerators( arg );
    fi;

    # no argument given, error
    Error("usage: Magma(<gens>), Magma(<Fam>,<gens>)");
end;


#############################################################################
##
#F  Submagma( <M>, <gens> ) . . . . . . . submagma of <M> generated by <gens>
##
Submagma := function( M, gens )
    local S;

    if not IsMagma( M ) then
        Error( "<M> must be a magma" );
    elif IsEmpty( gens ) then
        return SubmagmaNC( M, gens );
    elif not IsHomogeneousList(gens)  then
        Error( "<gens> must be a homogeneous list of elements" );
    elif not IsIdentical( FamilyObj(M), FamilyObj(gens) )  then
        Error( "families of <gens> and <M> are different" );
    fi;
    if not ForAll( gens, x -> x in M ) then
        Error( "<gens> must be elements in <M>" );
    fi;
    return SubmagmaNC( M, gens );
end;


#############################################################################
##
#F  SubmagmaNC( <M>, <gens> )
##
##  Note that 'SubmagmaNC' is allowed to call 'Objectify'
##  in the case that <gens> is empty.
##
SubmagmaNC := function( M, gens )
    local K, S;

    if IsEmpty( gens ) then
      K:= NewType( FamilyObj(M),
                       IsMagma
                   and IsTrivial
                   and IsAttributeStoringRep );
      S:= Objectify( K, rec() );
      SetGeneratorsOfMagma( S, [] );
    else
      S:= MagmaByGenerators(gens);
    fi;
    SetParent( S, M );
    return S;
end;


#############################################################################
##
#F  MagmaWithOne( <gens> )
#F  MagmaWithOne( <Fam>, <gens> )
##
MagmaWithOne := function( arg )

    # list of generators
    if Length( arg ) = 1 and IsList( arg[1] ) and 0 < Length( arg[1] ) then
      return MagmaWithOneByGenerators( arg[1] );

    # family plus list of generators
    elif Length( arg ) = 2 and IsFamily( arg[1] ) and IsList( arg[1] ) then
      return MagmaWithOneByGenerators( arg[1], arg[2] );

    # generators
    elif 0 < Length( arg ) then
      return MagmaWithOneByGenerators( arg );
    fi;

    # no argument given, error
    Error("usage: MagmaWithOne(<gens>), MagmaWithOne(<Fam>,<gens>)");
end;


#############################################################################
##
#F  SubmagmaWithOne( <M>, <gens> )  . submagma-with-one of <M> gen. by <gens>
##
SubmagmaWithOne := function( M, gens )
    local S;

    if not IsMagmaWithOne( M ) then
        Error( "<M> must be a magma-with-one" );
    elif IsEmpty( gens ) then
        return SubmagmaWithOneNC( M, gens );
    elif not IsHomogeneousList(gens)  then
        Error( "<gens> must be a homogeneous list of elements" );
    elif not IsIdentical( FamilyObj(M), FamilyObj(gens) )  then
        Error( "families of <gens> and <M> are different" );
    fi;
    if not ForAll( gens, x -> x in M ) then
        Error( "<gens> must be elements in <M>" );
    fi;
    return SubmagmaWithOneNC( M, gens );
end;


#############################################################################
##
#F  SubmagmaWithOneNC( <M>, <gens> )
##
##  Note that 'SubmagmaWithOneNC' is allowed to call 'Objectify'
##  in the case that <gens> is empty.
##
##  Furthermore note that a trivial submagma-with-one is automatically
##  a group.
##
SubmagmaWithOneNC := function( M, gens )
    local K, S;

    if IsEmpty( gens ) then
      K:= NewType( FamilyObj(M),
                       IsMagmaWithInverses
                   and IsTrivial
                   and IsAttributeStoringRep );
      S:= Objectify( K, rec() );
      SetGeneratorsOfMagmaWithInverses( S, [] );
    else
      S:= MagmaWithOneByGenerators(gens);
    fi;
    SetParent( S, M );
    return S;
end;


#############################################################################
##
#F  MagmaWithInverses( <gens> )
#F  MagmaWithInverses( <Fam>, <gens> )
##
MagmaWithInverses := function( arg )

    # list of generators
    if Length( arg ) = 1 and IsList( arg[1] ) and 0 < Length( arg[1] ) then
      return MagmaWithInversesByGenerators( arg[1] );

    # family plus list of generators
    elif Length( arg ) = 2 and IsFamily( arg[1] ) and IsList( arg[1] ) then
      return MagmaWithInversesByGenerators( arg[1], arg[2] );

    # generators
    elif 0 < Length( arg ) then
      return MagmaWithInversesByGenerators( arg );
    fi;

    # no argument given, error
    Error("usage: MagmaWithInverses(<gens>), ",
          "MagmaWithInverses(<Fam>,<gens>)");
end;


#############################################################################
##
#F  SubmagmaWithInverses( <M>, <gens> )
#F                    . . . . . . .  submagma-with-inv. of <M> gen. by <gens>
##
SubmagmaWithInverses := function( M, gens )
    local S;

    if not IsMagmaWithInverses( M ) then
        Error( "<M> must be a magma-with-inverses" );
    elif IsEmpty( gens ) then
        return SubmagmaWithInversesNC( M, gens );
    elif not IsHomogeneousList(gens)  then
        Error( "<gens> must be a homogeneous list of elements" );
    elif not IsIdentical( FamilyObj(M), FamilyObj(gens) )  then
        Error( "families of <gens> and <M> are different" );
    fi;
    if not ForAll( gens, x -> x in M ) then
        Error( "<gens> must be elements in <M>" );
    fi;
    return SubmagmaWithInversesNC( M, gens );
end;


#############################################################################
##
#F  SubmagmaWithInversesNC( <M>, <gens> )
##
##  Note that 'SubmagmaWithInversesNC' is allowed to call 'Objectify'
##  in the case that <gens> is empty.
##
SubmagmaWithInversesNC := function( M, gens )
    local K, S;

    if IsEmpty( gens ) then
      K:= NewType( FamilyObj(M),
                       IsMagmaWithInverses
                   and IsTrivial
                   and IsAttributeStoringRep );
      S:= Objectify( K, rec() );
      SetGeneratorsOfMagmaWithInverses( S, [] );
    else
      S:= MagmaWithInversesByGenerators(gens);
    fi;
    SetParent( S, M );
    return S;
end;


#############################################################################
##
#M  MagmaByGenerators( <gens> ) . . . . . . . . . . . . . .  for a collection
##
InstallMethod( MagmaByGenerators,
    "method for collection",
    true,
    [ IsCollection ] , 0,
    function( gens )
    local M;
    M:= Objectify( NewType( FamilyObj( gens ),
                            IsMagma and IsAttributeStoringRep ),
                   rec() );
    SetGeneratorsOfMagma( M, AsList( gens ) );
    return M;
    end );


#############################################################################
##
#M  MagmaByGenerators( <Fam>, <gens> )  . . . . . . . . . for family and list
##
InstallOtherMethod( MagmaByGenerators,
    "method for family and list",
    true,
    [ IsFamily, IsList ], 0,
    function( family, gens )
    local M;
    if not ( IsEmpty(gens) or IsIdentical( FamilyObj(gens), family ) ) then
      Error( "<family> and family of <gens> do not match" );
    fi;
    M:= Objectify( NewType( family,
                            IsMagma and IsAttributeStoringRep ),
                   rec() );
    SetGeneratorsOfMagma( M, AsList( gens ) );
    return M;
    end );


#############################################################################
##
#M  MagmaWithOneByGenerators( <gens> )  . . . . . . . . . .  for a collection
##
InstallMethod( MagmaWithOneByGenerators,
    "method for collection",
    true,
    [ IsCollection ] , 0,
    function( gens )
    local M;
    M:= Objectify( NewType( FamilyObj( gens ),
                            IsMagmaWithOne and IsAttributeStoringRep ),
                   rec() );
    SetGeneratorsOfMagmaWithOne( M, AsList( gens ) );
    return M;
    end );


#############################################################################
##
#M  MagmaWithOneByGenerators( <Fam>, <gens> ) . . . . . . for family and list
##
InstallOtherMethod( MagmaWithOneByGenerators,
    "method for family and list",
    true,
    [ IsFamily, IsList ], 0,
    function( family, gens )
    local M;
    if not ( IsEmpty(gens) or IsIdentical( FamilyObj(gens), family ) ) then
      Error( "<family> and family of <gens> do not match" );
    fi;
    M:= Objectify( NewType( family,
                            IsMagmaWithOne and IsAttributeStoringRep ),
                   rec() );
    SetGeneratorsOfMagmaWithOne( M, AsList( gens ) );
    return M;
    end );


#############################################################################
##
#M  MagmaWithInversesByGenerators( <gens> ) . . . . . . . .  for a collection
##
InstallMethod( MagmaWithInversesByGenerators,
    "method for collection",
    true,
    [ IsCollection ] , 0,
    function( gens )
    local M;
    M:= Objectify( NewType( FamilyObj( gens ),
                            IsMagmaWithInverses and IsAttributeStoringRep ),
                   rec() );
    SetGeneratorsOfMagmaWithInverses( M, AsList( gens ) );
    return M;
    end );


#############################################################################
##
#M  MagmaWithInversesByGenerators( <Fam>, <gens> )  . . . for family and list
##
InstallOtherMethod( MagmaWithInversesByGenerators,
    "method for family and list",
    true,
    [ IsFamily, IsList ], 0,
    function( family, gens )
    local M;
    if not ( IsEmpty(gens) or IsIdentical( FamilyObj(gens), family ) ) then
      Error( "<family> and family of <gens> do not match" );
    fi;
    M:= Objectify( NewType( family,
                            IsMagmaWithInverses and IsAttributeStoringRep ),
                   rec() );
    SetGeneratorsOfMagmaWithInverses( M, AsList( gens ) );
    return M;
    end );


#############################################################################
##
#M  TrivialSubmagmaWithOne( <M> ) . . . . . . . . . . .  for a magma-with-one
##
InstallMethod( TrivialSubmagmaWithOne,
    "method for magma-with-one",
    true,
    [ IsMagmaWithOne ], 0,
    M -> SubmagmaWithOneNC( M, [] ) );


#############################################################################
##
#M  GeneratorsOfMagma( <M> )
#M  GeneratorsOfMagmaWithOne( <M> )
#M  GeneratorsOfMagmaWithInverses( <M> )
##
##  If nothing special is known about the magma <M> we have no chance to
##  get the required generators.
##
##  If we know 'GeneratorsOfMagma',
##  they are also 'GeneratorsOfMagmaWithOne'.
##  If we know 'GeneratorsOfMagmaWithOne',
##  they are also 'GeneratorsOfMagmaWithInverses'.
##
InstallImmediateMethod( GeneratorsOfMagma,
    IsMagma and HasGeneratorsOfDomain, 0,
    GeneratorsOfDomain );

InstallImmediateMethod( GeneratorsOfMagmaWithOne,
    IsMagmaWithOne and HasGeneratorsOfMagma, 0,
    GeneratorsOfMagma );

InstallImmediateMethod( GeneratorsOfMagmaWithInverses,
    IsMagmaWithInverses and HasGeneratorsOfMagmaWithOne, 0,
    GeneratorsOfMagmaWithOne );


InstallMethod( GeneratorsOfMagma,
    "method for a magma",
    true,
    [ IsMagma ], 0,
    GeneratorsOfDomain );

InstallMethod( GeneratorsOfMagma,
    "method for a magma-with-one with generators",
    true,
    [ IsMagmaWithOne and HasGeneratorsOfMagmaWithOne ], 0,
    M -> Set( Concatenation( GeneratorsOfMagmaWithOne( M ), [ One(M) ] ) ) );

InstallMethod( GeneratorsOfMagma,
    "method for a magma-with-inverses with generators",
    true,
    [ IsMagmaWithInverses and HasGeneratorsOfMagmaWithInverses ], 0,
    M -> Set( Concatenation( GeneratorsOfMagmaWithInverses( M ),
                [ One( M ) ],
                List( GeneratorsOfMagmaWithInverses( M ), Inverse ) ) ) );

InstallMethod( GeneratorsOfMagmaWithOne,
    "method for a magma-with-inverses with generators",
    true,
    [ IsMagmaWithInverses and HasGeneratorsOfMagmaWithInverses ], 0,
    M -> Set( Concatenation( GeneratorsOfMagmaWithInverses( M ),
                List( GeneratorsOfMagmaWithInverses( M ), x -> x^-1 ) ) ) );


InstallMethod( GeneratorsOfMagma,
    "method for a magma-with-one with generators, all elms. of finite order",
    true,
    [ IsMagmaWithOne and HasGeneratorsOfMagmaWithOne
      and IsFiniteOrderElementCollection ], 0,
    function( M )
    local gens;
    gens:= GeneratorsOfMagmaWithOne( M );
    if IsEmpty( gens ) then
      return [ One( M ) ];
    else
      return gens;
    fi;
    end );

InstallMethod( GeneratorsOfMagma,
    "method for a magma-with-inv. with gens., all elms. of finite order",
    true,
    [ IsMagmaWithInverses and HasGeneratorsOfMagmaWithInverses
      and IsFiniteOrderElementCollection ], 0,
    function( M )
    local gens;
    gens:= GeneratorsOfMagmaWithInverses( M );
    if IsEmpty( gens ) then
      return [ One( M ) ];
    else
      return gens;
    fi;
    end );

InstallMethod( GeneratorsOfMagmaWithOne,
    "method for a magma-with-inv. with gens., all elms. of finite order",
    true,
    [ IsMagmaWithInverses and HasGeneratorsOfMagmaWithInverses
      and IsFiniteOrderElementCollection ], 0,
    GeneratorsOfMagmaWithInverses );


#############################################################################
##
#M  Representative( <M> ) . . . . . . . . . . . . . .  one element of a magma
##
InstallMethod( Representative,
    "method for magma with generators",
    true,
    [ IsMagma and HasGeneratorsOfMagma ], 0,
    RepresentativeFromGenerators( GeneratorsOfMagma ) );

InstallMethod( Representative,
    "method for magma-with-one with generators",
    true,
    [ IsMagmaWithOne and HasGeneratorsOfMagmaWithOne ], 0,
    RepresentativeFromGenerators( GeneratorsOfMagmaWithOne ) );

InstallMethod( Representative,
    "method for magma-with-inverses with generators",
    true,
    [ IsMagmaWithInverses and HasGeneratorsOfMagmaWithInverses ], 0,
    RepresentativeFromGenerators( GeneratorsOfMagmaWithInverses ) );

InstallMethod( Representative,
    "method for magma-with-one with known one",
    true,
    [ IsMagmaWithOne and HasOne ], SUM_FLAGS,
    One );


#############################################################################
##
#M  MultiplicativeNeutralElement( <M> ) . . . . . . . . . identity of a magma
##
InstallMethod( MultiplicativeNeutralElement,
    "method for a magma",
    true,
    [ IsMagma ], 0,
    function( M )
    local m;
    if IsFinite( M ) then
      for m in M do
        if ForAll( M, n -> n * m = n and m * n = n ) then
          return m;
        fi;
      od;
      return fail;
    else
      TryNextMethod();
    fi;
    end );


#############################################################################
##
#M  One( <M> )  . . . . . . . . . . . . . . . . . . . . . identity of a magma
##
InstallOtherMethod( One,
    "method for a magma",
    true,
    [ IsMagma ], 0,
    function( M )
    local one;
    one:= One( Representative( M ) );
    if one <> fail and one in M then
      return one;
    else
      return fail;
    fi;
    end );

InstallOtherMethod( One,
    "partial method for a magma-with-one (ask family)",
    true,
    [ IsMagmaWithOne ], 100,
#T high priority?
    function( M )
    M:= ElementsFamily( FamilyObj( M ) );
    if HasOne( M ) then
      return One( M );
    else
      TryNextMethod();
    fi;
    end );

InstallOtherMethod( One,
    "method for a magma-with-one that has a parent",
    true,
    [ IsMagmaWithOne and HasParent ], SUM_FLAGS,
    M -> One( Parent( M ) ) );

InstallOtherMethod( One,
    "method for a magma-with-one",
    true,
    [ IsMagmaWithOne ], 0,
    M -> One( Representative( M ) ) );


#############################################################################
##
#M  Enumerator( <M> ) . . . . . . . . .  enumerator of trivial magma with one
#M  EnumeratorSorted( <M> ) . . . . . .  enumerator of trivial magma with one
##
EnumeratorOfTrivialMagmaWithOne := M -> Immutable( [ One( M ) ] );

InstallMethod( Enumerator,
    "method for trivial magma-with-one",
    true,
    [ IsMagmaWithOne and IsTrivial ], 0,
    EnumeratorOfTrivialMagmaWithOne );

InstallMethod( EnumeratorSorted,
    "method for trivial magma-with-one",
    true,
    [ IsMagmaWithOne and IsTrivial ], 0,
    EnumeratorOfTrivialMagmaWithOne );


#############################################################################
##
#M  IsCentral( <M>, <N> ) . . . . . . . . . . . . . . . . . .  for two magmas
##
InstallMethod( IsCentral,
    "method for two magmas",
    IsIdentical,
    [ IsMagma, IsMagma ], 0,
    IsCentralFromGenerators( GeneratorsOfMagma, GeneratorsOfMagma ) );


#############################################################################
##
#M  IsCentral( <M>, <N> ) . . . . . . . . . . . . . . for two magmas with one
##
InstallMethod( IsCentral,
    "method for two magmas-with-one",
    IsIdentical,
    [ IsMagmaWithOne, IsMagmaWithOne ], 0,
    IsCentralFromGenerators( GeneratorsOfMagmaWithOne,
                             GeneratorsOfMagmaWithOne ) );


#############################################################################
##
#M  IsCentral( <M>, <N> ) . . . . . . . . . . .  for two magmas with inverses
##
InstallMethod( IsCentral,
    "method for two magmas-with-inverses",
    IsIdentical,
    [ IsMagmaWithInverses, IsMagmaWithInverses ], 0,
    IsCentralFromGenerators( GeneratorsOfMagmaWithInverses,
                             GeneratorsOfMagmaWithInverses ) );


#############################################################################
##
#M  IsSubset( <M>, <N> )  . . . . . . . . . . . . . . . . . .  for two magmas
##
InstallMethod( IsSubset,
    "method for two magmas",
    IsIdentical,
    [ IsMagma, IsMagma ], 0,
    function( M, N )
    return IsSubset( M, GeneratorsOfMagma( N ) );
    end );


#############################################################################
##
#M  IsSubset( <M>, <N> )  . . . . . . . . . . . . . . for two magmas with one
##
InstallMethod( IsSubset,
    "method for two magmas with one",
    IsIdentical,
    [ IsMagmaWithOne, IsMagmaWithOne ], 0,
    function( M, N )
    return IsSubset( M, GeneratorsOfMagmaWithOne( N ) );
    end );


#############################################################################
##
#M  IsSubset( <M>, <N> )  . . . . . . . . . . .  for two magmas with inverses
##
InstallMethod( IsSubset,
    "method for two magmas with inverses",
    IsIdentical,
    [ IsMagmaWithInverses, IsMagmaWithInverses ], 0,
    function( M, N )
    return IsSubset( M, GeneratorsOfMagmaWithInverses( N ) );
    end );

InstallInParentMethod( CentralizerInParent, IsMagma, Centralizer );

#############################################################################
##
#E  magma.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here



