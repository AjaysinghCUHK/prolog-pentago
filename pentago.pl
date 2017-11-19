:- use_module(library(clpfd)).

win([1,7,13,19,25]).
win([5,11,17,23,29]).
win([8,9,10,11,12]).
win([13,14,15,16,17]).
win([1,2,3,4,5]).
win([5,10,15,20,25]).
win([8,15,22,29,36]).
win([14,15,16,17,18]).
win([1,8,15,22,29]).
win([6,12,18,24,30]).
win([9,15,21,27,33]).
win([19,20,21,22,23]).
win([2,8,14,20,26]).
win([6,11,16,21,26]).
win([10,16,22,28,34]).
win([20,21,22,23,24]).
win([2,3,4,5,6]).
win([7,13,19,25,31]).
win([11,17,23,29,35]).
win([25,26,27,28,29]).
win([2,9,16,23,30]).
win([7,8,9,10,11]).
win([11,16,21,26,31]).
win([26,27,28,29,30]).
win([3,9,15,21,27]).
win([7,14,21,28,35]).
win([12,18,24,30,36]).
win([31,32,33,34,35]).
win([4,10,16,22,28]).
win([8,14,20,26,32]).
win([12,17,22,27,32]).
win([32,33,34,35,36]).
validRotation(clockwise).
validRotation(anti-clockwise).
validQuadrant(top-left).
validQuadrant(top-right).
validQuadrant(bottom-left).
validQuadrant(bottom-right).

threatening(Board,black,ThreatsCount) :-
	Board = board(BlackL, RedL),
	aggregate_all(count,scenarioCheck(RedL,BlackL,_),ThreatsCount),
	!.

threatening(Board,red,ThreatsCount) :-
	Board = board(BlackL, RedL),
	aggregate_all(count,scenarioCheck(BlackL,RedL,_),ThreatsCount),
	!.

scenarioCheck(Board,OtherBoard,Scenario) :-
	win(Scenario),
	countMatches(Board,Scenario,Count),
	Count is 4,
	union(Board,OtherBoard,UniBoard),
	countMatches(Scenario,UniBoard,Count1),
	not(Count1 == 5).

countMatches(_, [], 0).
countMatches(X, [H|T], Count) :-
    (member(H, X) -> Count #= Count1 + 1;
    Count1 = Count),
    countMatches(X, T, Count1),
    !.

pentago_ai(Board,black,BestMove,NextBoard) :-
	Board = board(BlackL,RedL),
	validRotation(Rotation),
	validQuadrant(Quadrant),
	blankSpaces(Board,MovePlace),
	append([MovePlace],BlackL,NewBlackL),
	win(Scenario),
	countMatches(NewBlackL,Scenario,MatchCount),
	MatchCount is 5,
	BestMove = move(MovePlace,Rotation,Quadrant),
	sort(NewBlackL,SortedBlack),
	NextBoard = board(SortedBlack,RedL),
	!.

pentago_ai(Board,black,BestMove,NextBoard) :-
	Board = board(BlackL,RedL),
	validRotation(Rotation),
	validQuadrant(Quadrant),
	blankSpaces(Board,MovePlace),
	append([MovePlace],BlackL,NewBlackL),
	rotate(Quadrant,Rotation,NewBlackL,RedL,RotatedBlack,RotatedRed),
	win(Scenario),
	countMatches(RotatedBlack,Scenario,MatchCount),
	MatchCount is 5,
	BestMove = move(MovePlace,Rotation,Quadrant),
	sort(RotatedBlack,SortedBlack),
	sort(RotatedRed,SortedRed),
	NextBoard = board(SortedBlack,SortedRed),
	!.

pentago_ai(Board,black,BestMove,NextBoard) :-
	Board = board(BlackL,RedL),
	validRotation(Rotation),
	validQuadrant(Quadrant),
	blankSpaces(Board,MovePlace),
	append([MovePlace],BlackL,NewBlackL),
	rotate(Quadrant,Rotation,NewBlackL,RedL,RotatedBlack,RotatedRed),
	BestMove = move(MovePlace,Rotation,Quadrant),
	sort(RotatedBlack,SortedBlack),
	sort(RotatedRed,SortedRed),
	NextBoard = board(SortedBlack,SortedRed),
	!.

pentago_ai(Board,red,BestMove,NextBoard) :-
	Board = board(BlackL,RedL),
	validRotation(Rotation),
	validQuadrant(Quadrant),
	blankSpaces(Board,MovePlace),
	append([MovePlace],RedL,NewRedL),
	win(Scenario),
	countMatches(NewRedL,Scenario,MatchCount),
	MatchCount is 5,
	BestMove = move(MovePlace,Rotation,Quadrant),
	sort(NewRedL,SortedRed),
	NextBoard = board(BlackL,SortedRed),
	!.

pentago_ai(Board,red,BestMove,NextBoard) :-
	Board = board(BlackL,RedL),
	validRotation(Rotation),
	validQuadrant(Quadrant),
	blankSpaces(Board,MovePlace),
	append([MovePlace],RedL,NewRedL),
	rotate(Quadrant,Rotation,BlackL,NewRedL,RotatedBlack,RotatedRed),
	win(Scenario),
	countMatches(RotatedRed,Scenario,MatchCount),
	MatchCount is 5,
	BestMove = move(MovePlace,Rotation,Quadrant),
	sort(RotatedBlack,SortedBlack),
	sort(RotatedRed,SortedRed),
	NextBoard = board(SortedBlack,SortedRed),
	!.

pentago_ai(Board,red,BestMove,NextBoard) :-
	Board = board(BlackL,RedL),
	validRotation(Rotation),
	validQuadrant(Quadrant),
	blankSpaces(Board,MovePlace),
	append([MovePlace],RedL,NewRedL),
	rotate(Quadrant,Rotation,BlackL,NewRedL,RotatedBlack,RotatedRed),
	BestMove = move(MovePlace,Rotation,Quadrant),
	sort(RotatedBlack,SortedBlack),
	sort(RotatedRed,SortedRed),
	NextBoard = board(SortedBlack,SortedRed),
	!.

blankSpaces(board(BlackL,RedL),X) :-
	union(BlackL,RedL,Z),
	subtract([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36],Z,Y),
	member(X,Y).

rotate(Quadrant,Direction,BlackL,RedL,NewBlackL,NewRedL):-
  Direction == clockwise,
  rotateClockwise(Quadrant,BlackL,RedL,NewBlackL,NewRedL),
  !;
  Direction == anti-clockwise,
  rotateAntiClockwise(Quadrant,BlackL,RedL,NewBlackL,NewRedL),
  !.

rotateClockwise(Quadrant,BlackL,RedL,NewBlackL,NewRedL):-
  rotateClockwiseSpecific(Quadrant,BlackL,NewBlackL),
  rotateClockwiseSpecific(Quadrant,RedL,NewRedL).

rotateClockwiseSpecific(_,[],[]).
rotateClockwiseSpecific(top-left,[1|T],[3|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[2|T],[9|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[3|T],[15|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[7|T],[2|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[9|T],[14|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[13|T],[1|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[14|T],[7|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[15|T],[13|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-left,[H|T],[H|NewT]):-rotateClockwiseSpecific(top-left,T,NewT),!.
rotateClockwiseSpecific(top-right,[4|T],[6|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[5|T],[12|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[6|T],[18|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[10|T],[5|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[12|T],[17|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[16|T],[4|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[17|T],[10|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[18|T],[16|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(top-right,[H|T],[H|NewT]):-rotateClockwiseSpecific(top-right,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[19|T],[21|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[20|T],[27|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[21|T],[33|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[25|T],[20|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[27|T],[32|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[31|T],[19|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[32|T],[25|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[33|T],[31|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-left,[H|T],[H|NewT]):-rotateClockwiseSpecific(bottom-left,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[22|T],[24|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[23|T],[30|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[24|T],[36|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[28|T],[23|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[30|T],[35|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[34|T],[22|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[35|T],[28|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[36|T],[34|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT),!.
rotateClockwiseSpecific(bottom-right,[H|T],[H|NewT]):-rotateClockwiseSpecific(bottom-right,T,NewT).

rotateAntiClockwise(Quadrant,BlackL,RedL,NewBlackL,NewRedL):-
  rotateAntiClockwiseSpecific(Quadrant,BlackL,NewBlackL),
  rotateAntiClockwiseSpecific(Quadrant,RedL,NewRedL).

rotateAntiClockwiseSpecific(_,[],[]).
rotateAntiClockwiseSpecific(top-left,[1|T],[13|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[2|T],[7|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[3|T],[1|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[7|T],[14|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[9|T],[2|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[13|T],[15|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[14|T],[9|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[15|T],[3|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-left,[H|T],[H|NewT]):-rotateAntiClockwiseSpecific(top-left,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[4|T],[16|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[5|T],[10|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[6|T],[4|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[10|T],[17|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[12|T],[5|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[16|T],[18|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[17|T],[12|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[18|T],[6|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(top-right,[H|T],[H|NewT]):-rotateAntiClockwiseSpecific(top-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[19|T],[31|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[20|T],[25|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[21|T],[19|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[25|T],[32|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[27|T],[20|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[31|T],[33|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[32|T],[27|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[33|T],[21|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-left,[H|T],[H|NewT]):-rotateAntiClockwiseSpecific(bottom-left,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[22|T],[34|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[23|T],[28|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[24|T],[22|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[28|T],[35|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[30|T],[23|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[34|T],[36|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[35|T],[30|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[36|T],[24|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT),!.
rotateAntiClockwiseSpecific(bottom-right,[H|T],[H|NewT]):-rotateAntiClockwiseSpecific(bottom-right,T,NewT).