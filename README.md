.XCompose
=========

As explained in <http://canonical.org/~kragen/setting-up-keyboard.html>,
your Compose key in X11 is controlled by (among other things) the file
`.XCompose` in your home directory.  This file gives you a large set
of bindings for Unicode characters that are useful occasionally.

More contributions are welcome; there's a Git repository at
<https://github.com/kragen/xcompose>.  We're trying to come up with a
broadly acceptable set of keybindings that won't interfere with the
traditional Compose bindings, aren't too hard to type, and cover a
wide set of characters that are useful to use occasionally, making
them available without the need for specialized input methods.

After installing `.XCompose` you will need to restart any applications
to see its effect for that application. Not all applications support
XCompose, and it depends on which input method you are using.

Some "extensions" have been added to this repository, and installing them
may take a few more commands.  Use `make` to generate the extension files
(for emoji, modifier letters, etc.)  You can include them by using the
`include` directive in your `.XCompose` file.  So you might actually not
want to use our `install` script, but rather create your own `.XCompose`
(perhaps with your own personal entries) along these lines:

     include "/path/to/dotXCompose"
	 include "/path/to/frakturcompose"
	 include "/path/to/emoji.compose"
	 include "/path/to/modletters.compose"
	 include "/path/to/parens.compose"

	 # I complain a lot, oy...
	 <Multi_key> <O> <Y>	: "ѹ" U0479	# CYRILLIC SMALL LETTER UK
	 # My very original smileyface!
	 <Multi_key> <parenleft> <t> <u> <parenright> : "㋡" U32E1 # CIRCLED KATAKANA TU
	 # ...
