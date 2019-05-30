all: emoji.compose modletters.compose tags.compose maths.compose

%.compose: %-base emojitrans2.pl
	./emojitrans2.pl < $< > $@
