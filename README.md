# polyhedron
Experimenting with Goldberg polyhedra and porting portions of Polyhedronism (Levskaya) to Rblx.Lua.

## Progression of development
### Starting out
I adapted a lot of code from Levskaya's polyHédronisme, including the creation of Polyhedron objects and Conway's polyhedron operations. This created the base for drawing the objects in Roblox.

Implementing preliminary vertex and face center drawing.

Green = vertex
Red = face center

![](https://i.imgur.com/o1FHQHp.png)

Originally, I wanted to use a single MeshPart for each polygonal face. This was my attempt.

![](https://i.imgur.com/o7YadTG.png)

It was definitely possible that perhaps my math was incorrect, but I decided that I would try out a triangle-based approach and compare the two. From this point on, I figured out the order of vertices that I needed to draw each triangle (3 per pentagon, 4 per hexagon, with 2 WedgeParts per triangle), and drew in each face.

![](https://i.imgur.com/04qf3gn.png)

This approach worked well, but there were still some unsightly seams between each edge. This happened because the triangles were positioned using their centers, and not their edges. I fixed this by positioning each triangle inward towards the center by half of their width.

![](https://i.imgur.com/khhbHDH.png)

At this point, triangle-based drawing seemed superior to single part-based drawing. Looking carefully, however, I noticed that the faces were not regular polygons. This is likely the reason part-based drawing did not work correctly, and is probably due to the malformation of the seed icosahedron. Regardless, even though the polygons may not be regular, they are still rather close.

The above example is a truncated icosahedron, but by using the dual and triakis operations, you can create even more complex shapes, like a T=9 Goldberg Polyhedron.

![](https://i.imgur.com/vSbeDGl.png)

## Resources & credits
Anselm Levskaya
polyHédronisme
https://github.com/levskaya/polyhedronisme

hkrish
StackOverflow
https://stackoverflow.com/a/47455940

Conway polyhedron notation
https://en.wikipedia.org/wiki/Conway_polyhedron_notation
