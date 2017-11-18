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
validRotation(anti-clockwise).
validRotation(clockwise).
validQuadrant(top-left).
validQuadrant(top-right).
validQuadrant(bottom-left).
validQuadrant(bottom-right).

/*threatening(Board,CurrentPlayer,ThreatsCount) :-
	Board = board(BlackL, RedL),
	(CurrentPlayer == black -> 
		aggregate_all(count,scenarioCheck(RedL,BlackL,Scenario),ThreatsCount);
		aggregate_all(count,scenarioCheck(BlackL,RedL,Scenario),ThreatsCount)).*/

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
	blank(Board,MovePlace),
	append([MovePlace],BlackL,NewBlackL),
	win(Scenario),
	countMatches(NewBlackL,Scenario,MatchCount),
	MatchCount is 5,
	BestMove = move(MovePlace,Rotation,Quadrant);
	Board = board(BlackL,RedL).

pentago_ai(Board,red,BestMove,NextBoard) :-
	Board = board(BlackL,RedL),
	validRotation(Rotation),
	validQuadrant(Quadrant),
	blank(Board,MovePlace),
	append([MovePlace],RedL,NewRedL),
	win(Scenario),
	countMatches(NewRedL,Scenario,MatchCount),
	MatchCount is 5,
	BestMove = move(MovePlace,Rotation,Quadrant);
	Board = board(BlackL,RedL).


blank(board(BlackL,RedL),X) :-
    union(BlackL,RedL,Z),
    subtract([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36],Z,Y),
    member(X,Y).

/*WinScenarios =
	[[1,7,13,19,25],[5,11,17,23,29],[8,9,10,11,12],[13,14,15,16,17],
	[1,2,3,4,5],[5,10,15,20,25],[8,15,22,29,36],[14,15,16,17,18],
	[1,8,15,22,29],[6,12,18,24,30],[9,15,21,27,33],[19,20,21,22,23],
	[2,8,14,20,26],[6,11,16,21,26],[10,16,22,28,34],[20,21,22,23,24],
	[2,3,4,5,6],[7,13,19,25,31],[11,17,23,29,35],[25,26,27,28,29],
	[2,9,16,23,30],[7,8,9,10,11],[11,16,21,26,31],[26,27,28,29,30],
	[3,9,15,21,27],[7,14,21,28,35],[12,18,24,30,36],[31,32,33,34,35],
	[4,10,16,22,28],[8,14,20,26,32],[12,17,22,27,32],[32,33,34,35,36]],*/