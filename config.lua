-- Word Buster Configuration --
if not wordBuster then return end
-- Censor: Which character should be used to replace bad words?
wordBuster.censor = "*"

-- Semi Censor: Show the first and last character of bad words?
wordBuster.semiCensor = true

-- Languages: Which languages should be loaded?
wordBuster.languages = {
	["cs"] = false,
	["da"] = false,
	["de"] = false,
	["en"] = true,
	["eo"] = false,
	["es"] = false,
	["fr"] = false,
	["hu"] = false,
	["it"] = false,
	["ja"] = false,
	["ko"] = false,
	["nl"] = false,
	["no"] = false,
	["pl"] = false,
	["pt"] = false,
	["ru"] = false,
	["sv"] = false,
	["th"] = false,
	["tlh"] = false,
	["tr"] = false,
	["zh"] = false
}

-- Notify: Notify the user that one of his words was censored.
wordBuster.notify = true

-- Notify Text: Text to notify the user with.
wordBuster.notifyText = "Watch your language young person!"

-- Patterns: Advanced users only, patterns used to block variations of bad words.
wordBuster.patterns = {
	["a"] = "[aA@]",
	["b"] = "[bB]",
	["c"] = "[cCkK]",
	["d"] = "[dD]",
	["e"] = "[eE3]",
	["f"] = "[fF]",
	["g"] = "[gG6]",
	["h"] = "[hH]",
	["i"] = "[iIl!1]",
	["j"] = "[jJ]",
	["k"] = "[cCkK]",
	["l"] = "[lL1!i]",
	["m"] = "[mM]",
	["n"] = "[nN]",
	["o"] = "[oO0]",
	["p"] = "[pP]",
	["q"] = "[qQ9]",
	["r"] = "[rR]",
	["s"] = "[sS$5]",
	["t"] = "[tT7]",
	["u"] = "[uUvV]",
	["v"] = "[vVuU]",
	["w"] = "[wW]",
	["x"] = "[xX]",
	["y"] = "[yY]",
	["z"] = "[zZ2]",
	["&"] = "[&]"
}

-- Check Usernames: Whether usernames should be checked upon joining or not
wordBuster.checkUsernames = true

return true