local Util = {}

function Util.WriteFileKey(fileName, key, newValue)
	local file = assert(io.open(fileName, "r"))
	local newContent = file:read('*a')
	file:close()

	newContent = newContent:gsub(key .. ':%S+', key .. ':' .. newValue)
	
	local fileW = assert(io.open(fileName, 'w'))
	fileW:write(newContent)
	fileW:close()
end

function Util.InsertFileContent(fileName, key, newValue)
	local file = assert(io.open(fileName, "r"))
	local newContent = file:read('*a')
	file:close()

	local pattern = key .. ':%S+'
	
	local currentData = key .. ':{'
	for c in newContent:match(pattern):gmatch'%w+' do
		if c ~= key then
			currentData = currentData .. c .. ','
		end
	end
	currentData = currentData .. newValue .. '}'
	
	newContent = newContent:gsub(pattern, currentData)
	
	local file = assert(io.open(fileName, 'w'))
	file:write(newContent)
	file:close()
end

function Util.GetKeyValue(fileName, key)
	local file = assert(io.open(fileName, "r"))
	local fileContent = file:read('*a')
	file:close()

	return fileContent:match(key .. ':([^\n\r]+)')
end

function Util.GetArticleWithNoun(str, uppercase)
	local endString = (str:match('^[aeiouy]') and 'an' or 'a') .. ' ' .. str
	return endString:gsub('^.', uppercase and string.upper or string.lower)
end

return Util