-- Word Buster Base of Operations --
-- modified by 20dka
-- based on https://github.com/Starfox64/word-buster
wordBuster = wordBuster or {}

function clog(text)
	if text == nil then
		return
	end

	if type(text) == "table" then
		text = tableToString(text)
	end

	print(os.date("[%d/%m/%Y %H:%M:%S]").." [profanityFilter] "..text)

	if not (wordBuster.logToFile~=nil and not wordBuster.logToFile) then --default to writing
		file = io.open("log.txt", "a")
		file:write(os.date("[%d/%m/%Y %H:%M:%S] ")..text.."\n")
		file:close()
	end
end

clog("(Word Buster) loading...")
local conf = require("Resources\\Server\\profanityFilter\\config")

if conf then
	clog("Config loaded")
else
	clog("Config failed to load, stopping plugin")
	return
end

wordBuster.badWords = {}



function wordBuster.Load()
	clog("Loading languages...")
	for lang, load in pairs(wordBuster.languages) do
		if load then
			local path = "Resources\\Server\\profanityFilter\\data\\"..lang..".txt"
			local f = io.open(path, "r")
			if f ~= nil then
				local words = {}
				for word in f:lines() do
					local formattedWord = ""
					local letters = {}
					word:gsub(".",function(c) table.insert(letters,c) end)
					for _, char in pairs(letters) do
						if wordBuster.patterns[char] then
							formattedWord = formattedWord..wordBuster.patterns[char]
						else
							formattedWord = formattedWord.."." -- Wildcard if the character isn't a letter
						end
					end
					table.insert(wordBuster.badWords, formattedWord)
				end
				for k, v in pairs(wordBuster.badWords) do
					if v == "" or v == " " then
						table.remove(wordBuster.badWords, k) -- Removes empty filters
					end
				end
			else
				clog("[Word Buster] Couldn't load language '"..lang.."', language not found!")
			end
		end
	end
	clog(#wordBuster.badWords.." words loaded!")
end

wordBuster.Load()

function printNameWithID(playerID) return (GetPlayerName(playerID) or "Unknown").."("..playerID..")" end

function wordBuster.checkText(text) --takes in string, returns count of censored words and censored text
	local total = 0
	local originalText = text
	for _, word in pairs(wordBuster.badWords) do
		local message, count = string.gsub(text, word, function( word )
			local censored = ""
			local l = 0
			local letters = {}
			word:gsub(".",function(c) table.insert(letters,c) end)
			if wordBuster.semiCensor then
				censored = letters[1]
				while l < string.len(word) - 2 do
					censored = censored..wordBuster.censor
					l = l + 1
				end
				censored = censored..letters[string.len(word)]
			else
				while l < string.len(word) do
					censored = censored..wordBuster.censor
					l = l + 1
				end
			end
			return censored
		end)
		total = total + count
		text = message
	end
	
	return total, text
end


function onChatMessage(playerID, name, originalMsg)
	local total, filteredMsg = wordBuster.checkText(originalMsg)
	if total > 0 then
		if wordBuster.notify then
			SendChatMessage(playerID, wordBuster.notifyText)
		end

		clog(printNameWithID(playerID).." tried to say: "..originalMsg..", corrected to: "..filteredMsg)
		SendChatMessage(-1, name.." wanted to say: "..filteredMsg)
		return 1
	end
end

function onPlayerAuth(name, role, isGuest)
	local total, filteredName = wordBuster.checkText(name)
	if wordBuster.checkUsernames and total > 0 then
		clog(filteredName..(isGuest and " (guest)" or "").." tried to join with the name "..name..", kicking")
		return "Your name contains a bad word, you must change it to join this server!"
	end
end

RegisterEvent("onChatMessage","onChatMessage")
RegisterEvent("onPlayerAuth","onPlayerAuth")

clog("(Word Buster) finished loading")


--return wordBuster
