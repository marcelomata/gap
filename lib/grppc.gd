#############################################################################
##
##  This file is part of GAP, a system for computational discrete algebra.
##  This file's authors include Frank Celler.
##
##  Copyright of GAP belongs to its developers, whose names are too numerous
##  to list here. Please refer to the COPYRIGHT file for details.
##
##  SPDX-License-Identifier: GPL-2.0-or-later
##
##  This file contains the operations for groups with a polycyclic collector.
##
##  IsPcgs
##    a polycyclic generating system, also behaves like a pc sequence
##
##  IsPcGroup
##    a poylcyclic group whose elements family is defined by a collector
##
##  CanEasilyComputePcgs
##    a group that knows how to compute a pcgs relatively fast
##
##  HasDefiningPcgs
##    a group whose elements family is generated by a pcgs
##
##  HasHomePcgs
##    a group that knows a pcgs of a super group
##


#############################################################################
##
#V  InfoPcGroup
##
##  <ManSection>
##  <InfoClass Name="InfoPcGroup"/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareInfoClass("InfoPcGroup");

#############################################################################
##
#M  CanEasilysortElements
##
InstallTrueMethod( CanEasilySortElements, IsPcGroup and IsFinite );


#############################################################################
##
#M  KnowsHowToDecompose( <G> )  . . . . . . . . . . always true for pc groups
##
InstallTrueMethod( KnowsHowToDecompose, IsPcGroup );


#############################################################################
##
#M  IsGeneratorsOfMagmaWithInverses( <G> )  always true for coll. of pc elts.
##
InstallTrueMethod( IsGeneratorsOfMagmaWithInverses,
    IsMultiplicativeElementWithInverseByPolycyclicCollectorCollection );


#############################################################################
##
#A  CanonicalPcgsWrtFamilyPcgs( <grp> )	. . . . . . .  with respect to family
##
##  <ManSection>
##  <Attr Name="CanonicalPcgsWrtFamilyPcgs" Arg='grp'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareAttribute( "CanonicalPcgsWrtFamilyPcgs", IsGroup );



#############################################################################
##
#A  CanonicalPcgsWrtHomePcgs( <grp> ) . . . . . . . . .  with respect to home
##
##  <ManSection>
##  <Attr Name="CanonicalPcgsWrtHomePcgs" Arg='grp'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareAttribute( "CanonicalPcgsWrtHomePcgs", IsGroup );



#############################################################################
##
#A  FamilyPcgs( <grp> ) . . . . . . . . . . . . . . . . .  pcgs of the family
##
##  <#GAPDoc Label="FamilyPcgs">
##  <ManSection>
##  <Attr Name="FamilyPcgs" Arg='grp'/>
##
##  <Description>
##  returns a <Q>natural</Q> pcgs of a pc group <A>grp</A> 
##  (with respect to which pcgs operations as described in 
##  Chapter&nbsp;<Ref Chap="Polycyclic Groups"/> are particularly 
##  efficient).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "FamilyPcgs", IsGroup );


InstallSubsetMaintenance( FamilyPcgs, IsGroup, IsGroup );


#############################################################################
##
#A  HomePcgs( <grp> ) . . . . . . . . . . . . . . . . . . .  pcgs of the home
##
##  <ManSection>
##  <Attr Name="HomePcgs" Arg='grp'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareAttribute( "HomePcgs", IsGroup );


InstallSubsetMaintenance( HomePcgs, IsGroup, IsGroup );


#############################################################################
##
#A  InducedPcgsWrtFamilyPcgs( <grp> ) . . . . . . . .  with respect to family
##
##  <#GAPDoc Label="InducedPcgsWrtFamilyPcgs">
##  <ManSection>
##  <Attr Name="InducedPcgsWrtFamilyPcgs" Arg='grp'/>
##
##  <Description>
##  returns the pcgs which induced with respect to a family pcgs
##  (see <Ref Prop="IsParentPcgsFamilyPcgs"/> for further details).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "InducedPcgsWrtFamilyPcgs", IsGroup );


#############################################################################
##
#O  InducedPcgs( <pcgs>, <grp> )
##
##  <#GAPDoc Label="InducedPcgs">
##  <ManSection>
##  <Oper Name="InducedPcgs" Arg='pcgs, grp'/>
##
##  <Description>
##  computes a pcgs for <A>grp</A> which is induced by <A>pcgs</A>.
##  If <A>pcgs</A> has a parent pcgs,
##  then the result is induced with respect to this parent pcgs.
##  <P/>
##  <Ref Oper="InducedPcgs"/> is a wrapper function only.
##  Therefore, methods for computing an induced pcgs
##  should be installed for the operation <C>InducedPcgsOp</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "InducedPcgs", [IsPcgs,IsGroup] );

#############################################################################
##
#O  InducedPcgsOp( <pcgs>, <grp> )
##
##  <ManSection>
##  <Oper Name="InducedPcgsOp" Arg='pcgs, grp'/>
##
##  <Description>
##  computes a pcgs for <A>grp</A> which is induced by <A>pcgs</A>. <A>pcgs</A> must not
##  be an induced pcgs. This operation should not be called directly. 
##  Instead, please use <C>InducedPcgs</C> which caches its results.
##  </Description>
##  </ManSection>
##
DeclareOperation( "InducedPcgsOp", [IsPcgs,IsGroup] );

#############################################################################
##
#F  SetInducedPcgs( <home>, <grp>, <pcgs> )
##
##  <ManSection>
##  <Func Name="SetInducedPcgs" Arg='home, grp, pcgs'/>
##
##  <Description>
##  This function sets <A>pcgs</A> to be a <A>home</A>-induced pcgs for
##  <A>grp</A> if the <Ref Func="HomePcgs"/> value of <A>grp</A> equals
##  <A>home</A> and the <Ref Func="ParentPcgs"/> value of <A>pcgs</A> equals
##  <A>home</A>.
##  (This means <A>pcgs</A> is induced by <A>home</A>.)
##  If <A>grp</A> has no <Ref Func="HomePcgs"/> value yet,
##  it is assigned to <A>home</A> before this.
##  This function should be used in algorithms if a pcgs for a new subgroup
##  is computed that by this calculation is known to be compatible with the
##  home pcgs of the calculation.
##  </Description>
##  </ManSection>
##
DeclareGlobalFunction( "SetInducedPcgs" );

#############################################################################
##
#A  ComputedInducedPcgses( <grp> )
##
##  <ManSection>
##  <Attr Name="ComputedInducedPcgses" Arg='grp'/>
##
##  <Description>
##  This attribute stores previously computed induced generating systems
##  of the group <A>grp</A>. It is a list of the form
##  <M>[ ppcgs_1, ipcgs_1, ppcgs_2, ipcgs_2, \ldots ]</M>,
##  where <M>ppcgs_n</M> is a parent pcgs and <M>igs_n</M> is the
##  corresponding induced generating system.
##  </Description>
##  </ManSection>
##
DeclareAttribute ("ComputedInducedPcgses", IsGroup, "mutable");

#############################################################################
##
#A  InducedPcgsWrtHomePcgs( <grp> ) . . . . . . . . . .  with respect to home
##
##  <ManSection>
##  <Attr Name="InducedPcgsWrtHomePcgs" Arg='grp'/>
##
##  <Description>
##  returns an induced pcgs for <A>grp</A> with respect to the home pcgs.
##  </Description>
##  </ManSection>
##
DeclareAttribute(
    "InducedPcgsWrtHomePcgs",
    IsGroup );



#############################################################################
##
#A  Pcgs( <G> ) . . . . . . . . . . . . . . . . . . . . . . pcgs of a group
##
##  <#GAPDoc Label="Pcgs">
##  <ManSection>
##  <Attr Name="Pcgs" Arg='G'/>
##
##  <Description>
##  returns a pcgs for the group <A>G</A>. 
##  If <A>grp</A> is not polycyclic it returns <K>fail</K> <E>and this result
##  is not  stored as attribute value</E>,
##  in particular in this case the filter <C>HasPcgs</C> is <E>not</E> set
##  for <A>G</A>!
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "Pcgs", IsGroup );

#############################################################################
##
#A  GeneralizedPcgs( <G> )  . . . . . . . . . . . . . . . . . pcgs of a group
##
##  <ManSection>
##  <Attr Name="GeneralizedPcgs" Arg='G'/>
##
##  <Description>
##  returns a generalized pcgs for the group <A>G</A>.
##  </Description>
##  </ManSection>
##
DeclareAttribute( "GeneralizedPcgs", IsGroup );

#############################################################################
##
#F  CanEasilyComputePcgs( <grp> ) . . . . .  group is willing to compute pcgs
##
##  <#GAPDoc Label="CanEasilyComputePcgs">
##  <ManSection>
##  <Filt Name="CanEasilyComputePcgs" Arg='grp'/>
##
##  <Description>
##  This filter indicates whether it is possible to compute a pcgs for
##  <A>grp</A> cheaply.
##  Clearly, <A>grp</A> must be polycyclic in this case.
##  However, not for every polycyclic group there is a method to compute a
##  pcgs at low costs.
##  This filter is used in the method selection mainly.
##  Note that this filter may change its value from <K>false</K> to
##  <K>true</K>. 
##
##  <Example><![CDATA[
##  gap> G := Group( (1,2,3,4),(1,2) );
##  Group([ (1,2,3,4), (1,2) ])
##  gap> CanEasilyComputePcgs(G);
##  false
##  gap> Pcgs(G);
##  Pcgs([ (3,4), (2,4,3), (1,4)(2,3), (1,3)(2,4) ])
##  gap> CanEasilyComputePcgs(G);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareFilter( "CanEasilyComputePcgs" );

# to satisfy method installation requirements
InstallTrueMethod(IsGroup,CanEasilyComputePcgs);


#############################################################################
##
#O  SubgroupByPcgs( <G>, <pcgs> )
##
##  <#GAPDoc Label="SubgroupByPcgs">
##  <ManSection>
##  <Oper Name="SubgroupByPcgs" Arg='G, pcgs'/>
##
##  <Description>
##  returns a subgroup of <A>G</A> generated by the elements of <A>pcgs</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "SubgroupByPcgs", [IsGroup, IsPcgs] );


#############################################################################
##
#O  AffineAction( <gens>, <basisvectors>, <linear>, <transl> )
##
##  <#GAPDoc Label="AffineAction">
##  <ManSection>
##  <Oper Name="AffineAction" Arg='gens, basisvectors, linear, transl'/>
##
##  <Description>
##  return a list of matrices, one for each element of <A>gens</A>, which
##  corresponds to the affine action of the elements in <A>gens</A> on the
##  basis <A>basisvectors</A> via <A>linear</A> with translation
##  <A>transl</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "AffineAction", 
    [ IsList, IsMatrix, IsFunction, IsFunction ] );


#############################################################################
##
#O  LinearAction( <gens>, <basisvectors>, <linear> )
#O  LinearOperation( <gens>, <basisvectors>, <linear> )
##
##  <#GAPDoc Label="LinearAction">
##  <ManSection>
##  <Oper Name="LinearAction" Arg='gens, basisvectors, linear'/>
##  <Oper Name="LinearOperation" Arg='gens, basisvectors, linear'/>
##
##  <Description>
##  returns a list of matrices, one for each element of <A>gens</A>, which
##  corresponds to the matrix action of the elements in <A>gens</A> on the
##  basis <A>basisvectors</A> via <A>linear</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "LinearAction", [ IsList, IsMatrix, IsFunction ] );
DeclareSynonym( "LinearOperation",LinearAction);


#############################################################################
##
#M  IsSolvableGroup
##
InstallTrueMethod(
    IsSolvableGroup,
    IsPcGroup );


#############################################################################
##
#F  AffineActionLayer( <G>, <gens>, <pcgs>, <transl> )
##
##  <#GAPDoc Label="AffineActionLayer">
##  <ManSection>
##  <Func Name="AffineActionLayer" Arg='G, gens, pcgs, transl'/>
##
##  <Description>
##  returns a list of matrices, one for each element of <A>gens</A>,
##  which corresponds to the affine action of <A>G</A> on the vector space
##  corresponding to the modulo pcgs <A>pcgs</A> with translation
##  <A>transl</A>.
##  <Example><![CDATA[
##  gap> G := SmallGroup( 96, 51 );
##  <pc group of size 96 with 6 generators>
##  gap> spec := SpecialPcgs( G );
##  Pcgs([ f1, f2, f3, f4, f5, f6 ])
##  gap> LGWeights( spec );
##  [ [ 1, 1, 2 ], [ 1, 1, 2 ], [ 1, 1, 3 ], [ 1, 2, 2 ], [ 1, 2, 2 ], 
##    [ 1, 3, 2 ] ]
##  gap> mpcgs := InducedPcgsByPcSequence( spec, spec{[4,5,6]} );
##  Pcgs([ f4, f5, f6 ])
##  gap> npcgs := InducedPcgsByPcSequence( spec, spec{[6]} );
##  Pcgs([ f6 ])
##  gap> modu := mpcgs mod npcgs;
##  [ f4, f5 ]
##  gap> mat:=LinearActionLayer( G, spec{[1,2,3]}, modu );
##  [ <an immutable 2x2 matrix over GF2>, 
##    <an immutable 2x2 matrix over GF2>, 
##    <an immutable 2x2 matrix over GF2> ]
##  gap> Print( mat, "\n" );
##  [ [ [ Z(2)^0, 0*Z(2) ], [ 0*Z(2), Z(2)^0 ] ], 
##    [ [ Z(2)^0, 0*Z(2) ], [ 0*Z(2), Z(2)^0 ] ], 
##    [ [ Z(2)^0, 0*Z(2) ], [ 0*Z(2), Z(2)^0 ] ] ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AffineActionLayer" );


#############################################################################
##
#F  GeneratorsCentrePGroup( <G> )
#F  GeneratorsCenterPGroup( <G> )
##
##  <ManSection>
##  <Func Name="GeneratorsCentrePGroup" Arg='G'/>
##  <Func Name="GeneratorsCenterPGroup" Arg='G'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareGlobalFunction( "GeneratorsCentrePGroup" );

DeclareSynonym( "GeneratorsCenterPGroup", GeneratorsCentrePGroup );


#############################################################################
##
#F  LinearActionLayer( <G>, <gens>, <pcgs> )
#F  LinearOperationLayer( <G>, <gens>, <pcgs> )
##
##  <#GAPDoc Label="LinearActionLayer">
##  <ManSection>
##  <Func Name="LinearActionLayer" Arg='G, gens, pcgs'/>
##  <Func Name="LinearOperationLayer" Arg='G, gens, pcgs'/>
##
##  <Description>
##  returns a list of matrices, one for each element of <A>gens</A>,
##  which corresponds to the matrix action of <A>G</A> on the vector space
##  corresponding to the modulo pcgs <A>pcgs</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "LinearActionLayer" );
DeclareSynonym( "LinearOperationLayer",LinearActionLayer );


#############################################################################
##
#F  VectorSpaceByPcgsOfElementaryAbelianGroup( <mpcgs>, <fld> )
##
##  <#GAPDoc Label="VectorSpaceByPcgsOfElementaryAbelianGroup">
##  <ManSection>
##  <Func Name="VectorSpaceByPcgsOfElementaryAbelianGroup" Arg='mpcgs, fld'/>
##
##  <Description>
##  returns the vector space over <A>fld</A> corresponding to the modulo pcgs
##  <A>mpcgs</A>.
##  Note that <A>mpcgs</A> has to define an elementary abelian <M>p</M>-group
##  where <M>p</M> is the characteristic of <A>fld</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction(
    "VectorSpaceByPcgsOfElementaryAbelianGroup" );

#############################################################################
##
#F  GapInputPcGroup( <grp>, <string> )
##
##  <#GAPDoc Label="GapInputPcGroup">
##  <ManSection>
##  <Func Name="GapInputPcGroup" Arg='grp, string'/>
##
##  <Description>
##  <Example><![CDATA[
##  gap> G := SmallGroup( 24, 12 );
##  <pc group of size 24 with 4 generators>
##  gap> PrintTo( "save", GapInputPcGroup( G, "H" ) );
##  gap> Read( "save" );
##  #I A group of order 24 has been defined.
##  #I It is called H
##  gap> H = G;
##  false
##  gap> IdSmallGroup( H ) = IdSmallGroup( G );
##  true
##  gap> RemoveFile( "save" );;
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "GapInputPcGroup" );

#############################################################################
##
#F  PrintPcPresentation( <grp>, <commBool> )
##
DeclareGlobalFunction( "PrintPcPresentation" );

#############################################################################
##
#O  CanonicalSubgroupRepresentativePcGroup( <G>, <U> )
##
##  <ManSection>
##  <Oper Name="CanonicalSubgroupRepresentativePcGroup" Arg='G, U'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareGlobalFunction( "CanonicalSubgroupRepresentativePcGroup" );

#############################################################################
##
#F  CentrePcGroup( <grp> )
##
##  <ManSection>
##  <Func Name="CentrePcGroup" Arg='grp'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareGlobalFunction( "CentrePcGroup" );

#############################################################################
##
#A  OmegaSeries( G )
##
##  <ManSection>
##  <Attr Name="OmegaSeries" Arg='G'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareAttribute( "OmegaSeries", IsGroup );
