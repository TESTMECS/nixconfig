--[[
-- Copyright (c) TESTMEE 2025
-- My My lua and tyto
--]]
---@class tyto
---@field arrow table
---@field fn table
---@field cmp table
TYTO = {}
TYTO.__index = TYTO
---=== === === === === Types === === === ===  ===
function TYTO:is_num(x)
	return type(x) == "number"
end
function TYTO:is_int(x)
	return type(x) == "number" and math.floor(x) == x
end
function TYTO:is_str(x)
	return type(x) == "string"
end
function TYTO:is_tbl(x)
	return type(x) == "table"
end
function TYTO:is_fn(f)
	return type(f) == "function"
end
---=== === === === === puts === === === ===  ===
---@vararg any
function TYTO:puts(...)
	io.write((...))
end
---@vararg any
function TYTO:putsln(...)
	io.write((...) .. "\n")
end
---@vararg any
function TYTO:putsf(fmt, ...)
	io.write(string.format(fmt, ...))
end
---@vararg any
function TYTO:putsfln(fmt, ...)
	io.write(string.format(fmt, ...) .. "\n")
end
---@description: prints a table with each element on a new line
---@param t table
function TYTO:putstbl(t)
	io.write(string.format("\n{i}|{j}\n{--|--}\n"))
	for i, v in ipairs(t) do
		io.write(string.format("{%s}|{%s}\n", i, v))
	end
end
function TYTO:newline()
	io.write("\n")
end
---=== === === === === map === === === ===  ===
---@description: map f over t or extract a column from a list of records.
---@param t table
---@param f string|fun(k: any, v: any, ...: any): any
---@vararg any
---@return table
function TYTO:map(t, f, ...)
	local dt = {}
	if type(f) == "function" then
		for k, v in pairs(t) do
			dt[k] = f(k, v, ...)
		end
	else
		for k, v in pairs(t) do
			local sel = v[f]
			if type(sel) == "function" then --method to apply
				dt[k] = sel(v, ...)
			else --field to pluck
				dt[k] = sel
			end
		end
	end
	return dt
end
---@description: map f over t or extract a column from a list of records.
---@param t table
---@param f string|fun(k: any, v: any, ...: any): any
---@vararg any
---@return table
function TYTO:imap(t, f, ...)
	local dt = { n = t.n }
	local n = t.n or #t
	if type(f) == "function" then
		for i = 1, n do
			dt[i] = f(t[i], ...)
		end
	else
		for i = 1, n do
			local v = t[i]
			local sel = v[f]
			if type(sel) == "function" then --method to apply
				dt[i] = sel(v, ...)
			else --field to pluck
				dt[i] = sel
			end
		end
	end
	return dt
end
--- === === === === === Misc === === === === ===
---@description: generate a uuid
---@return string
function TYTO:uuid()
	return ("%08x-%04x-%04x-%04x-%08x%04x"):format(
		math.random(0xffffffff),
		math.random(0xffff),
		0x4000 + math.random(0x0fff), --4xxx
		0x8000 + math.random(0x3fff), --10bb-bbbb-bbbb-bbbb
		math.random(0xffffffff),
		math.random(0xffff)
	)
end
---@description: sign of a number
function TYTO:sign(x)
	return x > 0 and 1 or x == 0 and 0 or -1
end
------@description: readonly table
---@return table
function TYTO:readonlyT(t)
	return setmetatable(t, {
		__newindex = function()
			error("trying to set a field in tyto.Tbl")
		end, --read-only
		__metatable = false,
	})
end
---@description: table.unpack but with default j of n or #t
---@param t table
---@param i? number
---@param j? number
function TYTO:unpack(t, i, j)
	return table.unpack(t, i or 1, j or t.n or #t)
end
---@description: flip a table
---@param t table
---@return table: with the keys as values and the values as keys
function TYTO:flipt(t)
	local dt = {}
	for k, v in pairs(t) do
		dt[v] = k
	end
	return dt
end
---@description: append non-nil arguments to a list.
---@param dt table
---@vararg any
function TYTO:append(dt, ...)
	local j = #dt
	for i = 1, select("#", ...) do
		dt[j + i] = select(i, ...)
	end
	return dt
end
---@description: update a table with the contents of other table(s).
---@param dt table
---@vararg table
function TYTO:update(dt, ...)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				dt[k] = v
			end
		end
	end
	return dt
end
---@description: scan list for value.
---@param v any: value to search for
---@param t table: list to search
---@param eq fun(a: any, b: any): boolean
---@param i? number: start index
---@param j? number: end index
function TYTO:indexof(v, t, eq, i, j)
	i = i or 1
	j = j or #t
	if eq then
		for i = i, j do
			if eq(t[i], v) then
				return i
			end
		end
	else
		for i = i, j do
			if t[i] == v then
				return i
			end
		end
	end
end
local cmps = {}
cmps["<"] = function(t, i, v)
	return t[i] < v
end
cmps[">"] = function(t, i, v)
	return t[i] > v
end
cmps["<="] = function(t, i, v)
	return t[i] <= v
end
cmps[">="] = function(t, i, v)
	return t[i] >= v
end
TYTO.cmp = cmps
---@instance
TYTO = setmetatable({}, TYTO)
return TYTO
