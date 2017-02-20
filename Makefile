all: emoji.compose modletters.compose

emoji.compose: emoji-base emojitrans2.pl
	./emojitrans2.pl < $< > $@

modletters.compose: modletters-base emojitrans2.pl
	./emojitrans2.pl < $< > $@
