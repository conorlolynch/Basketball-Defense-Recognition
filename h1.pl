less-than([_,[Node1|_],Cost1],[_,[Node2|_],Cost2]) :- heuristic(Node1,Hvalue1),
                                                  heuristic(Node2,Hvalue2),
                                                  F1 is Cost1+Hvalue1,
                                                  F2 is Cost2+Hvalue2,
                                                  F1 =< F2.

heuristic(Node,H) :- length(Node,H).

arc([H|T],Node,Cost,KB) :- member([H|B],KB), append(B,T,Node),
                           length(B,L),Cost is 1+ L/(L+1).
goal([]).

astar(Node,Path,Cost,KB) :- search([[Node,[],0]],SecondPath,Cost,KB), reverse(Path, SecondPath).


search([[Node, Path, Cost]|_], [Node|Path], Cost, _) :- goal(Node).
search([[Node, CurrentPath, CurrentCost]|T], Path, Cost, KB) :-
                                                findall([X,[Node|CurrentPath],TotalPath],(arc(Node,X,ArcCost,KB),TotalPath is ArcCost + CurrentCost),Children),
                                                add2frontier(T,Children,New),insert(New, Sorted),search(Sorted,Path,Cost,KB).

add2frontier(Children,[],Children).
add2frontier(Children,[H|T],[H|More]) :- add2frontier(Children,T,More).

insert([],[]) :- !.
insert([A|B],N) :- insert(B,N1), insert(A,N1,N).
insert(A,[],[A]) :- !.
insert(A, [A1|B1], [A, A1|B1]):- less-than(A,A1), !.
insert(A, [A1|B1], [A1|B]):- insert(A, B1, B).
