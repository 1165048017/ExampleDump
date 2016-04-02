-- check readme for link to explanation

local extra = 2;

local img = Instance.new("ImageLabel");
img.BackgroundTransparency = 1;
img.BorderSizePixel = 0;

function dotv2(a, b)
	return a.x * b.x + a.y * b.y;
end;

function rotateV2(vec, angle)
	local x = vec.x * math.cos(angle) + vec.y * math.sin(angle);
	local y = -vec.x * math.sin(angle) + vec.y * math.cos(angle);
	return Vector2.new(x, y);
end;

function drawTriangle(a, b, c, parent)
	local edges = {
		{longest = (c - b), other = (a - b), position = b};
		{longest = (a - c), other = (b - c), position = c};
		{longest = (b - a), other = (c - a), position = a};
	};
	
	table.sort(edges, function(a, b) return a.longest.magnitude > b.longest.magnitude end);
	
	local edge = edges[1];
	edge.angle = math.acos(dotv2(edge.longest.unit, edge.other.unit));
	edge.x = edge.other.magnitude * math.cos(edge.angle);
	edge.y = edge.other.magnitude * math.sin(edge.angle);
	
	local r = edge.longest.unit * edge.x - edge.other;
	local rotation = math.atan2(r.y, r.x) - math.pi/2;
	
	local tp = -edge.other;
	local tx = (edge.longest.unit * edge.x) - edge.other;
	local nz = tp.x * tx.y - tp.y * tx.x;
	
	local tlc1 = edge.position + edge.other;
	local tlc2 = nz > 0 and edge.position + edge.longest - tx or edge.position - tx;
	
	local tasize = Vector2.new((tlc1 - tlc2).magnitude, edge.y);
	local tbsize = Vector2.new(edge.longest.magnitude - tasize.x, edge.y);
	
	local center1 = nz <= 0 and edge.position + ((edge.longest + edge.other)/2) or (edge.position + edge.other/2);
	local center2 = nz > 0 and edge.position + ((edge.longest + edge.other)/2) or (edge.position + edge.other/2);
	
	tlc1 = center1 + rotateV2(tlc1 - center1, rotation);
	tlc2 = center2 + rotateV2(tlc2 - center2, rotation);
	
	local ta = img:Clone();
	local tb = img:Clone();
	ta.Image = "rbxassetid://319692171";
	tb.Image = "rbxassetid://319692151";
	ta.Position = UDim2.new(0, tlc1.x, 0, tlc1.y);
	tb.Position = UDim2.new(0, tlc2.x, 0, tlc2.y);
	ta.Size = UDim2.new(0, tbsize.x + extra, 0, tbsize.y + extra);
	tb.Size = UDim2.new(0, tasize.x + extra, 0, tasize.y + extra);
	ta.Rotation = math.deg(rotation);
	tb.Rotation = ta.Rotation;
	ta.Parent = parent;
	tb.Parent = parent;
end;