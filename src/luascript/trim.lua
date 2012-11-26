--trim
function trim(words)
if type(words)~="string" then return end
local out_words=string.match(words,"^%s*(.-)%s*$")
return out_words
end
