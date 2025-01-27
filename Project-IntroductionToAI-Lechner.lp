%First we specify the grid, I took the one from the ASP chef
cell(1,1,"c").
cell(1,2,"e").
cell(1,3,"b").
cell(1,4,"b").
cell(1,5,"c").
cell(2,1,"b").
cell(2,2,"e").
cell(2,3,"a").
cell(2,4,"d").
cell(2,5,"e").
cell(3,1,"a").
cell(3,2,"d").
cell(3,3,"a").
cell(3,4,"c").
cell(3,5,"e").
cell(4,1,"c").
cell(4,2,"a").
cell(4,3,"b").
cell(4,4,"e").
cell(4,5,"c").
cell(5,1,"e").
cell(5,2,"b").
cell(5,3,"a").
cell(5,4,"a").
cell(5,5,"a").

%Then we caclulate the number of occurencies per symbol per row or column
rowCount(RowIndex, Symbol, C) :- cell(RowIndex, _, Symbol), C = #count{ColumnIndex : cell(RowIndex, ColumnIndex, Symbol)}.
columnCount(ColumnIndex, Symbol, C) :- cell(_,ColumnIndex,Symbol), C = #count{RowIndex : cell(RowIndex, ColumnIndex, Symbol)}.

%For all critical rows or colums we cross symbols
{crossedout(RowIndex, ColumnIndex, Symbol)} :- cell(RowIndex, ColumnIndex, Symbol), rowCount(RowIndex, Symbol, C), C >= 2.
{crossedout(RowIndex, ColumnIndex, Symbol)} :- cell(RowIndex, ColumnIndex, Symbol), columnCount(ColumnIndex, Symbol, C), C >= 2.

%Assert that no symbol is duplicate in row or column
:- rowCount(RowIndex, Symbol, _), #count{ColumnIndex : cell(RowIndex, ColumnIndex, Symbol), not crossedout(RowIndex, ColumnIndex, Symbol)} > 1.
:- columnCount(ColumnIndex, Symbol, _), #count{RowIndex : cell(RowIndex, ColumnIndex, Symbol), not crossedout(RowIndex, ColumnIndex, Symbol)} > 1.

%Assert that no crossout happens next to each other
:- crossedout(RowIndex1, ColumnIndex, _), crossedout(RowIndex2, ColumnIndex, _), RowIndex1 = RowIndex2+1.
:- crossedout(RowIndex1, ColumnIndex, _), crossedout(RowIndex2, ColumnIndex, _), RowIndex1 = RowIndex2-1.
:- crossedout(RowIndex, ColumnIndex1, _), crossedout(RowIndex, ColumnIndex2, _), ColumnIndex1 = ColumnIndex2+1.
:- crossedout(RowIndex, ColumnIndex1, _), crossedout(RowIndex, ColumnIndex2, _), ColumnIndex1 = ColumnIndex2-1.

%Assure that everything is connected on a single path
%To do so we first specify which fields are not crossed out
notCrossedOut(RowIndex, ColumnIndex) :- cell(RowIndex, ColumnIndex,_),  not crossedout(RowIndex, ColumnIndex,_).

%Then we calculate all paths which are neigbhours 
path(I, J, I2, J2) :- notCrossedOut(I, J), notCrossedOut(I2, J2), I=I2, J=J2+1.
path(I, J, I2, J2) :- notCrossedOut(I, J), notCrossedOut(I2, J2), I=I2, J=J2-1.
path(I, J, I2, J2) :- notCrossedOut(I, J), notCrossedOut(I2, J2), I=I2+1, J=J2.
path(I, J, I2, J2) :- notCrossedOut(I, J), notCrossedOut(I2, J2), I=I2-1, J=J2.

%Here we calculate the transitive paths to get all connections
path(I,J, I3,J3) :- path(I, J, I2, J2), notCrossedOut(I3, J3), I2=I3, J2=J3+1.
path(I,J, I3,J3) :- path(I, J, I2, J2), notCrossedOut(I3, J3), I2=I3, J2=J3-1.
path(I,J, I3,J3) :- path(I, J, I2, J2), notCrossedOut(I3, J3), I2=I3+1, J2=J3.
path(I,J, I3,J3) :- path(I, J, I2, J2), notCrossedOut(I3, J3), I2=I3-1, J2=J3.

%This eliminates all answeres where two fields should be connected as they are not crossed, but no path exist
:- notCrossedOut(I, J), notCrossedOut(I2, J2),  not path(I, J, I2, J2).

#show crossedout/3.