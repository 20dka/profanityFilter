-- Word Buster Base of Operations --
-- modified by 20dka
-- based on https://github.com/Starfox64/word-buster
wordBuster = wordBuster or {}

function clog(text) clog(text, true) end
function clog(text, saveToDisk)
	if text == nil then
		return
	end

	if type(text) == "table" then
		text = tableToString(text)
	end

	print(os.date("[%d/%m/%Y %H:%M:%S]").." [profanityFilter] "..text)

	if saveToDisk then
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
				for line in f:lines() do
					table.insert(words, line)
				end

				for _, word in pairs(words) do
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

function printNameWithID(playerID) return GetPlayerName(playerID).."("..playerID..")" end

function wordBuster.checkText(text) --takes in string, returns count of censored words and censored text
	local total = 0
	local originalText = text
	for _, word in pairs(wordBuster.badWords) do
		local message, count = string.gsub(text, word, function( s )
			local censored = ""
			local l = 0
			if wordBuster.semiCensor then
				censored = s[1]
				while l < string.len(s) - 2 do
					censored = censored..wordBuster.censor
					l = l + 1
				end
				censored = censored..s[string.len(s)]
			else
				while l < string.len(s) do
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

		print(printNameWithID(playerID).." tried to say: "..originalText)
		SendChatMessage(-1, GetPlayerName(playerID).." wanted to say: "..text)
		return 1
	end
end

function onPlayerAuth(name, role, isGuest)
	if wordBuster.checkUsernames and wordBuster.checkText(name) > 0 then
		print(name..(isGuest and " (guest)" or "").." tried to join with a bad name, kicking")
		return "Your name contains a bad word, you must change it to join this server!"
	end
end

RegisterEvent("onChatMessage","onChatMessage")
RegisterEvent("onPlayerAuth","onPlayerAuth")

clog("(Word Buster) finished loading")