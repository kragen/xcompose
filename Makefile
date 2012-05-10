default: deps check-mapping ensure-config
	@echo -e "OK! ...now for: \e[35mmake install\e[0m"

install: deps check-mapping ensure-config pave-the-way install-link

full: deps xmodmap config-all install

refill: git-pull full

deps:
	@type fmt >/dev/null || (echo -e "\e[31mOh snap.\e[0m rking thought 'fmt' was universal, but apparently not. Try installing a 'coreutils' OS package, and please also tell rking he's totally wrong → \e[35mxcompose@sharpsaw.org\e[0m"; false)

config-all:
	./configure --all

git-pull:
	git pull

# Note. I'm unsure about this part... a noob, myself. Perhaps this will flag a
# false-negative?
check-mapping:
	@if ! xmodmap -p | grep Multi_key > /dev/null; then \
	    echo -e "Well, it looks like you don't have any key mapped to Multi_key, a.k.a. AltGr, a.k.a. Compose Character. This means our whole ~/.XCompose system won't really work for you.\n\n" \
	    "To fix this, run '\e[35mmake xmodmap\e[0m'" | fmt; \
	fi

SUPER_SPECIAL_CODE = keysym Alt_R = Multi_key
xmodmap:
	grep "$(SUPER_SPECIAL_CODE)" ~/.Xmodmap >/dev/null || \
	    echo $(SUPER_SPECIAL_CODE) >> ~/.Xmodmap
	echo $(SUPER_SPECIAL_CODE) | xmodmap - || true
	@echo -e "\n\e[34mDone setting Right-Alt to Multi_key.\e[0m\n\n\
You should at this point already be able to type: Right-Alt (then let go of it), then \" then o, and ö should appear. This is a system default.\n\n\
Now, you will have to ensure that \e[35mxmodmap ~/.Xmodmap\e[0m gets run at some point during the next X session. Some systems are already set up this way, and others you'll have to help out (e.g., adding it to your existing ~/.xsession or ~/.xinitrc)." | fmt

ensure-config:
	@if [ ! -f .XCompose ]; then \
	    echo -e "Please run \e[35m./configure\e[0m to select the mappings you want."; \
	    exit 1; \
	fi

pave-the-way:
# Symlinks don't survive. This presumes the most common case of the
# user moving their xcompose working directory and wanting to reseat
# the link. If they did something funky, like had their own symlink... 
# it will be removed, but they are apparently an advanced user and
# should be able to figure it out.
	@[ -L ~/.XCompose ] && rm ~/.XCompose || true
	@if [ -f ~/.XCompose ]; then \
	    if [ -e ~/.localXCompose ]; then \
		echo -e "\e[31mUh-oh\e[0m. ~/.XCompose is a regular file. Normally we would move this to ~/.localXCompose, which would get included by the new ~/.XCompose… but that file exists, too. You might know what to do at this point better than we would." | fmt; \
		exit 2; \
	    fi; \
	    mv ~/.XCompose ~/.localXCompose; \
	fi

install-link:
	ln -s "`pwd`/.XCompose" ~/.XCompose
