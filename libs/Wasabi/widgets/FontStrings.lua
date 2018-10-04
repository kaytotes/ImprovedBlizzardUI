local Wasabi = LibStub and LibStub('Wasabi', true)
if(not Wasabi) then
	return
end

Wasabi:RegisterWidget('Title', 1, function(parent)
	return parent:CreateFontString('Title_' .. math.floor(GetTime() * 100), nil, 'GameFontNormalLarge')
end)

Wasabi:RegisterWidget('Description', 1, function(parent)
	return parent:CreateFontString('Description_' .. math.floor(GetTime() * 100), nil, 'GameFontHighlightSmallLeft')
end)
