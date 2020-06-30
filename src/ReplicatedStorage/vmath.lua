local vmath = {}

function vmath.orthogonal(v1, v2, v3)
    local d1 = v2-v1;
    local d2 = v3-v2;
    return d1:Cross(d2);
end

-- vectors = {v1, v2, v3}
function vmath.normal(vectors)
    local normalV = Vector3.new(0, 0, 0);
    local twoFaces = {vectors[1], vectors[2]};
    for i, v3 in ipairs(vectors) do
      normalV = normalV + vmath.orthogonal(vectors[1], vectors[2], v3);
      twoFaces = {vectors[2], v3};
    end
    return normalV.unit;
end

return vmath;