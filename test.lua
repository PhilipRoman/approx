require 'approx'

io.output(io.open("index.html", "w"))

assert(input("x", 2, 1) == value(2, 1))

assert(input("x", 5, 1) + input("y", 8, 1) == value(13, 2))

local t = input("t", 60, 0.01)
local x = input("x0", 0, 0.1) + input("vx0", 5, 0.5)*t + input("a", 3, 0.5)*t^2/2
local y = input("y0", 10, 0.1) + input("vy0", 5, 0.5)*t + input("g", -9.8, 0.1)*t^2/2
local length = vsqrt(x^2 + y^2)
io.write [[
<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.4/latest.js?config=AM_CHTML"></script>
]]
local function show(e, name)
	io.write("`" .. name .. " = " .. e.val.name .. " = " .. e.val.val .. "`")	
	io.write "\n<br />\n"
	io.write("`Δ" .. name .. " = " .. e.err.name .. " = " .. e.err.val .. "`")	
	io.write "\n<br />\n"
end
show(length, "l")

show(x, "x")
show(y, "y")
x = rename(x, "x")
y = rename(y, "y")
length = vsqrt(x^2 + y^2)
show(length, "l")

io.flush()
