const polyhedron {
    // constructor of initially null polyhedron
    constructor(verts, faces, name) {
      // array of faces.  faces.length = # faces
      this.faces = faces || new Array();
      // array of vertex coords.  vertices.length = # of vertices
      this.vertices  = verts || new Array();
      this.name = name  || "null polyhedron";
    }
        
    // get array of face centers
  -- go through Faces
  -- go through specific face (get to indices for vertices)
  -- vidx = index of vertex (which is a vector3)
  -- add all vector3s of face to fcenter
  -- 
    centers() {
      const centersArray = [];
      for (let face of this.faces) {
        let fcenter = [0, 0, 0];
        // average vertex coords
        for (let vidx of face) {
          fcenter = add(fcenter, this.vertices[vidx]);
        }
        centersArray.push(mult(1.0 / face.length, fcenter));
      }
      // return face-ordered array of centroids
      return centersArray;
    }
  
    // get array of face normals
    normals() {
      const normalsArray = [];
      for (let face of this.faces) {
        normalsArray.push(normal(face.map(vidx => this.vertices[vidx])));
      }
      return normalsArray;
    }
  
    // informative string
    data() {
      const nEdges = (this.faces.length + this.vertices.length) - 2; // E = V + F - 2
      return `${this.faces.length} faces, ${nEdges} edges, ${this.vertices.length} vertices`;
    }
  
    moreData() {
      return `min edge length ${this.minEdgeLength().toPrecision(2)}<br>` +
             `min face radius ${this.minFaceRadius().toPrecision(2)}`;
    }
  // return a non-redundant list of the polyhedron's edges
    edges() {
      let e, a, b;
      const uniqEdges = {};
      const faceEdges = this.faces.map(faceToEdges);
      for (let edgeSet of faceEdges) {
        for (e of edgeSet) {
          if (e[0] < e[1]) {
            [a, b] = e;
          } else {
            [b, a] = e;
          }
          uniqEdges[`${a}~${b}`] = e;
        }
      }
      return _.values(uniqEdges);
    }
  };
  
  // Topology stored as set of faces.  Each face is list of n vertex indices
  // corresponding to one oriented, n-sided face.  Vertices listed clockwise as seen from outside.
  
  // Generate an array of edges [v1,v2] for the face.
  const faceToEdges = function(face) {
    const edges = [];
    let [v1] = face.slice(-1);
    for (let v2 of face) {
      edges.push([v1, v2]);
      v1 = v2;
    }
    return edges;
  };
  
  // calculate average normal vector for array of vertices
  const normal = function(vertices) {
    // running sum of normal vectors
    let normalV = [0,0,0]; 
    let [v1, v2] = vertices.slice(-2);
    for (let v3 of vertices) {
      normalV = add(normalV, orthogonal(v1, v2, v3));
      [v1, v2] = [v2, v3];
    } // shift over one
    return unit(normalV);
  };