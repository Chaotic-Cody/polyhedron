
// Topology stored as set of faces.  Each face is list of n vertex indices
// corresponding to one oriented, n-sided face.  Vertices listed clockwise as seen from outside.
// this.faces = [ [vidx1, vidx2, vidx3] ]
const icosahedron = function() {
  const poly = new polyhedron();
  poly.name = "I";
  poly.faces = [ [0,1,2], [0,2,3], [0,3,4], [0,4,5],
    [0,5,1], [1,5,7], [1,7,6], [1,6,2],
    [2,6,8], [2,8,3], [3,8,9], [3,9,4],
    [4,9,10], [4,10,5], [5,10,7], [6,7,11],
    [6,11,8], [7,10,11], [8,11,9], [9,11,10] ];

  poly.vertices = [ [0,0,1.176], [1.051,0,0.526],
    [0.324,1.0,0.525], [-0.851,0.618,0.526],
    [-0.851,-0.618,0.526], [0.325,-1.0,0.526],
    [0.851,0.618,-0.526], [0.851,-0.618,-0.526],
    [-0.325,1.0,-0.526], [-1.051,0,-0.526],
    [-0.325,-1.0,-0.526], [0,0,-1.176] ];
  return poly;
};

--// Dual
--// ------------------------------------------------------------------------------------------------
--// The dual of a polyhedron is another mesh wherein:
--// - every face in the original becomes a vertex in the dual
--// - every vertex in the original becomes a face in the dual
--//
--// So N_faces, N_vertices = N_dualfaces, N_dualvertices
--//
--// The new vertex coordinates are convenient to set to the original face centroids.
--//
--const dual = function(poly) {
--  let f, i, v1, v2;
--  console.log(`Taking dual of ${poly.name}...`);
--
--  const flag = new polyflag();
--
--  const face = []; // make table of face as fn of edge
--  for (i = 0; i <= poly.vertices.length-1; i++) {
--    face[i] = {};
--  } // create empty associative table
--
--  for (i = 0; i < poly.faces.length; i++) {
--    f = poly.faces[i];
--    v1 = f[f.length-1]; //previous vertex
--    for (v2 of f) {
--      // THIS ASSUMES that no 2 faces that share an edge share it in the same orientation!
--      // which of course never happens for proper manifold meshes, so get your meshes right.
--      face[v1][`v${v2}`] = `${i}`;
--      v1=v2;
--    }
--  } // current becomes previous
--
--  const centers = poly.centers();
--  for (i = 0; i <= poly.faces.length-1; i++) {
--    flag.newV(`${i}`,centers[i]);
--  }
--
--  for (i = 0; i < poly.faces.length; i++) {
--    f = poly.faces[i];
--    v1 = f[f.length-1]; //previous vertex
--    for (v2 of f) {
--      flag.newFlag(v1, face[v2][`v${v1}`], `${i}`);
--      v1=v2;
--    }
--  } // current becomes previous
--
--  const dpoly = flag.topoly(); // build topological dual from flags
--
--  // match F index ordering to V index ordering on dual
--  const sortF = [];
--  for (f of dpoly.faces) {
--    const k = intersect(poly.faces[f[0]], poly.faces[f[1]], poly.faces[f[2]]);
--    sortF[k] = f;
--  }
--  dpoly.faces = sortF;
--
--  if (poly.name[0] !== "d") {
--    dpoly.name = `d${poly.name}`;
--  } else {
--    dpoly.name = poly.name.slice(1);
--  }
--
--  return dpoly;
--};
--
--// Kis(N)
--// ------------------------------------------------------------------------------------------
--// Kis (abbreviated from triakis) transforms an N-sided face into an N-pyramid rooted at the
--// same base vertices.
--// only kis n-sided faces, but n==0 means kis all.
--//
--const kisN = function(poly, n, apexdist){
--  let i;
--  if (!n) { n = 0; }
--  if (apexdist===undefined) { apexdist = 0.1; }
--  console.log(`Taking kis of ${n===0 ? "" : n}-sided faces of ${poly.name}...`);
--
--  const flag = new polyflag();
--  for (i = 0; i < poly.vertices.length; i++) {
--    // each old vertex is a new vertex
--    const p = poly.vertices[i];
--    flag.newV(`v${i}`, p);
--  }
--
--  const normals = poly.normals();
--  const centers = poly.centers();
--  let foundAny = false;
--  for (i = 0; i < poly.faces.length; i++) {
--    const f = poly.faces[i];
--    let v1 = `v${f[f.length-1]}`;
--    for (let v of f) {
--      const v2 = `v${v}`;
--      if ((f.length === n) || (n === 0)) {
--        foundAny = true;
--        const apex = `apex${i}`;
--        const fname = `${i}${v1}`;
--        // new vertices in centers of n-sided face
--        flag.newV(apex, add(centers[i], mult(apexdist, normals[i])));
--        flag.newFlag(fname,   v1,   v2); // the old edge of original face
--        flag.newFlag(fname,   v2, apex); // up to apex of pyramid
--        flag.newFlag(fname, apex,   v1); // and back down again
--      } else {
--        flag.newFlag(`${i}`, v1, v2);  // same old flag, if non-n
--      }
--      // current becomes previous
--      v1 = v2;
--    }
--  }
--
--  if (!foundAny) {
--    console.log(`No ${n}-fold components were found.`);
--  }
--
--  const newpoly = flag.topoly();
--  newpoly.name = `k${n === 0 ? "" : n}${poly.name}`;
--  return newpoly;
--};
