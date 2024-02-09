math.findDistanceBetweenPoints = function(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

math.lerp = function(a, b, t)
	return a + (b - a) * t
end

math.clamp = function(val, min, max)
	if val < min then
		return min
	elseif val > max then
		return max
	else
		return val
	end
end

math.scale = function(num)
	return num * scale
end

math.inverseScale = function(num)
	return num / scale
end

math.checkIfPointInRect = function(x, y, x1, x2, y1, y2)
	if x > x1 and x < x2 and y > y1 and y < y2 then
		return true
	else
		return false
	end
end

math.checkIfPointInCircle = function(x, y, cx, cy, r)
	if math.findDistanceBetweenPoints(x, y, cx, cy) < r then
		return true
	else
		return false
	end
end

math.round = function(val, decimal)
	local mult = 10^(decimal or 0)
	return math.floor(val * mult + 0.5) / mult
end

math.findAngleBetweenPoints = function(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

math.findAngleBetweenVectors = function(x1, y1, x2, y2)
	return math.atan2(y2, x2) - math.atan2(y1, x1)
end

math.findVectorFromAngle = function(angle, magnitude)
	return math.cos(angle) * magnitude, math.sin(angle) * magnitude
end

math.findAngleFromVector = function(x, y)
	return math.atan2(y, x)
end

math.G = 6.67408 * 10^-11

math.findGravitationalForce = function(mass1, mass2, distance)
	return (math.G * mass1 * mass2) / (distance^2)
end

math.findHyptenuse = function(a, b)
	return math.sqrt(a^2 + b^2)
end

math.findLeg = function(a, c)
	return math.sqrt(c^2 - a^2)
end

math.findAreaOfCircle = function(radius)
	return math.pi * radius^2
end

math.findAreaOfTriangle = function(base, height)
	return (base * height) / 2
end

math.findAreaOfRectangle = function(width, height)
	return width * height
end

math.findAreaOfSquare = function(side)
	return side^2
end

math.findAreaOfTrapezoid = function(base1, base2, height)
	return ((base1 + base2) / 2) * height
end

math.findAreaOfEllipse = function(a, b)
	return math.pi * a * b
end

math.findPerimeterOfCircle = function(radius)
	return 2 * math.pi * radius
end

math.findPerimeterOfTriangle = function(side1, side2, side3)
	return side1 + side2 + side3
end

math.findPerimeterOfRectangle = function(width, height)
	return 2 * (width + height)
end

math.findPerimeterOfSquare = function(side)
	return 4 * side
end

math.findPerimeterOfTrapezoid = function(base1, base2, side1, side2)
	return base1 + base2 + side1 + side2
end

math.findPerimeterOfEllipse = function(a, b)
	return 2 * math.pi * math.sqrt((a^2 + b^2) / 2)
end

math.findVolumeOfSphere = function(radius)
	return (4/3) * math.pi * radius^3
end

math.findVolumeOfCylinder = function(radius, height)
	return math.pi * radius^2 * height
end

math.findVolumeOfCone = function(radius, height)
	return (1/3) * math.pi * radius^2 * height
end

math.findVolumeOfCube = function(side)
	return side^3
end

math.findVolumeOfRectangularPrism = function(width, height, length)
	return width * height * length
end

math.findVolumeOfTriangularPrism = function(base, height, length)
	return (1/2) * base * height * length
end

math.findVolumeOfPyramid = function(base, height)
	return (1/3) * base * height
end

math.findVolumeOfEllipsoid = function(a, b, c)
	return (4/3) * math.pi * a * b * c
end


math.findSurfaceAreaOfSphere = function(radius)
	return 4 * math.pi * radius^2
end

math.findSurfaceAreaOfCylinder = function(radius, height)
	return (2 * math.pi * radius * height) + (2 * math.pi * radius^2)
end

math.findSurfaceAreaOfCone = function(radius, height)
	return math.pi * radius * (radius + math.sqrt(height^2 + radius^2))
end	

math.findSurfaceAreaOfCube = function(side)
	return 6 * side^2
end

math.findSurfaceAreaOfRectangularPrism = function(width, height, length)
	return 2 * (width * height + height * length + width * length)
end

math.findSurfaceAreaOfTriangularPrism = function(base, height, length)
	return base * height + 2 * (base + length) * math.sqrt((base - length / 2)^2 + height^2)
end

math.findSurfaceAreaOfPyramid = function(base, height)
	return base^2 + 2 * base * math.sqrt((base / 2)^2 + height^2)
end

math.findSurfaceAreaOfEllipsoid = function(a, b, c)
	local p = 1.6075
	local A = 4 * math.pi * ((a^p * b^p + a^p * c^p + b^p * c^p) / 3)^(1 / p)
	return A
end

math.findSlope = function(x1, y1, x2, y2)
	return (y2 - y1) / (x2 - x1)
end

math.findYIntercept = function(x1, y1, x2, y2)
	local m = findSlope(x1, y1, x2, y2)
	return y1 - m * x1
end

math.findXIntercept = function(x1, y1, x2, y2)
	local m = findSlope(x1, y1, x2, y2)
	local b = findYIntercept(x1, y1, x2, y2)
	return -b / m
end

