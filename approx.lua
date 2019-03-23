local fmt = string.format
local expr_mt = {}

function expr(val, name)
	name = tostring(name or val)
	return setmetatable({
		val = val, name = name
	}, expr_mt)
end
local expr = expr

local function toexpr(val)
	if getmetatable(val) == expr_mt then
		return val
	else
		return expr(assert(tonumber(val)))
	end
end

function expr_mt.__tostring(x)
	return x.name
end
function expr_mt.__add(a, b)
	b = toexpr(b)
	return expr(a.val + b.val, fmt("(%s + %s)", a, b))
end
function expr_mt.__sub(a, b)
	b = toexpr(b)
	return expr(a.val - b.val, fmt("(%s - %s)", a, b))
end
function expr_mt.__mul(a, b)
	b = toexpr(b)
	return expr(a.val * b.val, fmt("%s * %s", a, b))
end
function expr_mt.__div(a, b)
	b = toexpr(b)
	return expr(a.val / b.val, fmt("%s / %s", a, b))
end
function expr_mt.__pow(a, b)
	b = toexpr(b)
	return expr(a.val ^ b.val, fmt("(%s) ^ (%s)", a, b))
end
function expr_mt.__eq(a, b)
	return a.val == b.val
end
local function esqrt(x)
	x = toexpr(x)
	return expr(x.val ^ 0.5, fmt("sqrt(%s)", x))
end

local value_mt = {}

function value(val, err)
	val = toexpr(val)
	err = toexpr(err or 0)
	return setmetatable({
		val = val, err = err
	}, value_mt)
end
local value = value

local function tovalue(val)
	if getmetatable(val) == value_mt then
		return val
	else
		return value(assert(tonumber(val)))
	end
end

function input(name, val, err)
	return value(expr(val, name), expr(err, "(Δ"..name..")"))
end

function value_mt.__tostring(x)
	return fmt("%s = %s ± %.2f = %s", x.val.val, x.val.name, x.err.val, x.err.name)
end
function value_mt.__add(a, b)
	b = tovalue(b)
	return value(a.val + b.val, a.err + b.err)
end
function value_mt.__sub(a, b)
	b = tovalue(b)
	return value(a.val - b.val, a.err + b.err)
end
function value_mt.__mul(a, b)
	b = tovalue(b)
	local ab = a.val * b.val
	return value(ab, ab * (a.err/a.val + b.err/b.val))
end
function value_mt.__div(a, b)
	b = tovalue(b)
	local ab = a.val / b.val
	return value(ab, ab * (a.err/a.val + b.err/b.val))
end
function value_mt.__pow(a, b)
	b = tovalue(b)
	assert(b.err.val == 0, "(a ^ b) is only allowed if Δb = 0; (Δb was " .. b.err.val .. ")")
	local pow = a.val ^ b.val
	return value(pow, pow * b.val * a.err / a.val)
end
function value_mt.__eq(a, b)
	return a.val == b.val and a.err == b.err
end
function vsqrt(x)
	x = tovalue(x)
	local root = esqrt(x.val)
	return value(root, root * 0.5 * x.err / x.val)
end

function rename(x, name)
	x = tovalue(x)
	return value(expr(x.val.val, name), expr(x.err.val, "(Δ"..name..")"))
end
