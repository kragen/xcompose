all: emoji.compose

emoji.compose: emoji-base emojitrans2.pl
	./emojitrans2.pl < emoji-base > emoji.compose
