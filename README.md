Profanity filter
===========

Profanity filter is a BeamMP plugin based on [Word Buster][1], a filter for Garry's Mod, it censors "bad words" with the character of your choice.
It uses the [**List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words**][2] *([License][3])* which contains more than 350 english words and then converts them into patterns so that it can catch most variants of the banned words.

Installation
------------
Click **Download zip**, put the ```profanityFilter-master``` folder in your ```Resources/Server``` folder, and rename it to ```profanityFilter```. You can customize ```config.lua``` to your needs, by default it is set up to block english words only. To add or remove words simply edit the language files in the ```data``` folder but remember that the censor character cannot be present in any of the loaded language files.

Open Source
-----------

Hey! It's open source feel free to upgrade it and add words to the list. *coughcough Pull Requests coughcough*

[1]:https://github.com/Starfox64/word-buster
[2]:https://github.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words
[3]:https://github.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/blob/master/LICENSE
