json = require "json"
file = io.open("users.json", "r")
data = file:read("*a")
users = json.decode(data)
count_of_users = table.getn(users)
counter = math.random(count_of_users) -- Each thread has separate start position

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function findLast(haystack, needle)
    local i=haystack:match(".*"..needle.."()")
    if i==nil then return nil else return i-1 end
end

request = function()
	local r = {}
	counter = counter + 1
	index = counter % count_of_users
	if index == 0 then
		index = 1
	end 
	item = users[index]
	path = "/databases/Library/queries" 
	local body = '{"Query": "from index \'Annotations\'  where startsWith(id(), $prefix) limit 10", "QueryParameters": { "prefix": "Annotations/' .. item.id .. '"}}"'

	r[1] = wrk.format("POST", path,  wrk.headers, body)

	return table.concat(r)
end