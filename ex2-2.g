LoadPackage("SimplicialSurface");;

ListFromCycle:=function(c)
	local i, s, res;
	res := [];
	s := SmallestMovedPoint(c);
	i := OnPoints(s, c);
	Add(res, s);
	Add(res, i);
	while not s = OnPoints(i, c) do
		i := OnPoints(i, c);
		Add(res, i);
	od;

	return res;
end;

SurfaceFromUmbrella:=function(umbrellaDescriptor)
	local i, vertices, edges, faces, verticesOfEdges, edgesOfFaces, surface, umbrella, edgeQueue,
	edge, j, edgeT, testSurface;

	edgeQueue := [];
	verticesOfEdges := [];
	edgesOfFaces := [];

	vertices := Length(umbrellaDescriptor);
	faces := [];

	for j in [1..Length(umbrellaDescriptor)] do
		umbrella := umbrellaDescriptor[j];
		for i in [1..LargestMovedPoint(umbrella)] do
			if not i = OnPoints(i, umbrella) then
				Add(edgeQueue, [j, (i, OnPoints(i, umbrella))]);
			fi;
		od;
		
		Append(faces, ListFromCycle(umbrella));
	od;

	faces := DuplicateFreeList(faces);
	faces := Length(faces);
	edges := (3/2)*faces;

	for i in [1..faces] do
		Add(edgesOfFaces, []);
	od;

	for edge in edgeQueue do
		for edgeT in edgeQueue do
			if edge[2] = edgeT[2] and not edge[1] = edgeT[1] and Position(verticesOfEdges, (edge[1], edgeT[1])) = fail then
				Add(verticesOfEdges, (edge[1], edgeT[1]) );

				Add(edgesOfFaces[ ListFromCycle(edge[2])[1] ], Position(verticesOfEdges, (edge[1], edgeT[1]) ));
				Add(edgesOfFaces[ ListFromCycle(edge[2])[2] ], Position(verticesOfEdges, (edge[1], edgeT[1]) ) );
			fi;
		od;
	od;

	Apply(verticesOfEdges, v -> ListFromCycle(v));
	Apply(edgesOfFaces, l -> DuplicateFreeList(l));

	surface := SimplicialSurfaceByDownwardIncidence(vertices, edges, faces, verticesOfEdges, edgesOfFaces);

	for testSurface in AllSimplicialSurfaces(NumberOfVertices, vertices, NumberOfEdges, edges, NumberOfFaces, faces) do
		if(IsIsomorphic(surface, testSurface)) then
			Print("Is iso to a surface in the library \n");
		fi;
	od;

	return surface;
end;

ex :=  [(1, 5, 4, 3, 2),(1, 6, 11, 7, 2),(1, 6, 15, 10, 5),(2, 7, 12, 8, 3),(3, 8, 13, 9, 4),(4, 9, 14, 10, 5),(6, 15, 20, 16, 11),(7, 12, 17, 16, 11),(8, 13, 18, 17, 12),(9, 14, 19, 18, 13),(10, 14, 19, 20, 15),(16, 17, 18, 19, 20)];

surfaceFromEx := SurfaceFromUmbrella(ex);