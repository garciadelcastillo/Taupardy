# Taupardy!
![Taupardy!](http://fathom.info/uploads/2014/06/IMG_4103.jpg "Taupardy!")
![Fathom Tau Day 2015](http://fathom.info/uploads/2015/06/Fathom_TauDay_06_Taupardy.jpg "Fathom Tau Day 2015")
![Fathom Tau Day 2014](http://fathom.info/uploads/2014/06/IMG_20140620_172340.jpg "Fathom Tau Day 2014")

**Taupardy!** is a [Jeopardy!](https://en.wikipedia.org/wiki/Jeopardy!) inspired Tau quiz game for [Processing](http://www.processing.org)! 

It is particularly appropriate for [Tau Day celebrations](http://tauday.com/). Bundled with this code are the two panels we used for our own [2014](http://fathom.info/latest/7850) & [2015](http://fathom.info/latest/11298) celebrations, feel free to create your own ones and submit a pull request ;)

**Taupardy!** was created by [Fathom Information Design](http://fathom.info/) and [Jose Luis García del Castillo](http://www.garciadelcastillo.es). 

If you like this project and had fun with it, share the love! [@fathominfo](https://twitter.com/fathominfo)

# Setup
1. Download and install [Processing](http://www.processing.org).
2. Taupardy! depends on [Benedikt Groß's great Ani library](http://www.looksgood.de/libraries/Ani/). Make sure it is available in your system's `Procesing/libraries`.
3. Download/clone the repo.
4. Open `taupardy.pde` with the Processing IDE.
5. Hit run. Enjoy!

# Usage
Taupardy! is a collaborative game intended to be played as a group. Therefore, so far only one global player/score is supported. 

You can click/tap on the questions on screen to give them focus. When a question is highlighted, use: 

* `a` key to display the answer
* `y` to indicate the question was correctly answered, and add the score
* `n` to indicate the opposite
* `x` any time for game over and final screen

You can create and customize your own question panels by following the template `.xls` files in the `/data` folder, and then exporting it to utf-8 CSV. Then pointing to the appropriate `.csv` file via the `panelFileName` variable.

Enjoy!

[![The Fathom Team](http://fathom.info/wp-content/uploads/2015/06/Fathom_TauDay_2015-1024x682.jpg)](http://fathom.info/latest/11298)


# License
See [license](https://github.com/garciadelcastillo/taupardy/tree/master/LICENSE).









