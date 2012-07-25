.XCompose
=========

As explained in <http://canonical.org/~kragen/setting-up-keyboard.html>,
your Compose key in X11 is controlled by (among other things) the file
`.XCompose` in your home directory.  This project gives you a large set
of bindings for Unicode characters that range from useful to fun.

Instant Install
---------------

    git clone https://github.com/kragen/xcompose.git && cd xcompose && make full

Fetching
--------

If installing as a standalone:

    git clone https://github.com/kragen/xcompose.git

If installing as part of a config repo, try:

    cd $MY_CONFIG_WORKING_DIR
    git submodule add https://github.com/kragen/xcompose.git

Setup
-----

After that, enter the `xcompose/` dir, and do:

    make install

The `Makefile` should help you if you have any troubles. If it doesn't, or if
anything else goes wrong, please [let me
know](mailto:rkingxcompose@sharpsaw.org) so we can improve it for others.

There used to be a more complicated ./configure step, that accepted
enable/disable args. Now I think the easiest thing is to just edit the
.XCompose file to however you want (for example, you can delete some of the
input files' lines so they don't have an effect, or you can reorder them so a
certain one overrides another in the case of conflicts).

Behavior
--------

This works for anything that uses XIM (X Input Method... don't forget to look
at the [spec](http://www.x.org/releases/X11R7.6/doc/libX11/specs/XIM/xim.html)
for some zany diagrams.).

Any given program will only take notice of `~/.XCompose` changes on its start.

This means using a multiplexer like `tmux` (or `screen`) is yet again useful,
because it allows you to make changes to your mappings and apply their effects
to the terminal without having to restart the programs inside it (e.g. IRC).

Helping
-------

More contributions are welcome; there's a Git repository at
<http://github.org/kragen/xcompose>.  We're trying to come up with a
broadly acceptable set of keybindings that won't interfere with the
traditional Compose bindings, aren't too hard to type, and cover a
wide set of characters that are useful to use occasionally, making
them available without the need for specialized input methods.
