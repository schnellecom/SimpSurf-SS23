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
	edge, j, edgeT;

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

	for i in [1..Length(umbrellaDescriptor)] do
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

	Print("v: ",vertices, " e: ",edges," f: ",faces,"\n");

	surface := SimplicialSurfaceByDownwardIncidence(vertices, edges, faces, verticesOfEdges, edgesOfFaces);
	return surface;
end;