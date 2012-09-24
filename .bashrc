# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

export LANG="en_US.UTF-8"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set up TERM variables.
# vt100 and xterm have no color in vim (at least on unixs), but if we call them xterm-color, they will.
# (vt100 for F-Secure SSH.)
# This may well be the case for some other terms, so I'm putting them here.
# Also set up a variable to indicate whether to set up the title functions.
# TODO gnome-terminal, or however it reports itself
case $TERM in

  screen)
    TERM_IS_COLOR=true
    TERM_NOT_RECOGNIZED_AS_COLOR_BY_VIM=false
    TERM_NOT_RECOGNIZED_BY_SUN_UTILS=false
    TERM_CAN_TITLE=true
  ;;

  xterm-color|color_xterm|rxvt|Eterm|screen*) # screen.linux|screen-w
    TERM_IS_COLOR=true
    TERM_NOT_RECOGNIZED_AS_COLOR_BY_VIM=false
    TERM_NOT_RECOGNIZED_BY_SUN_UTILS=true
    TERM_CAN_TITLE=true
  ;;

  linux)
    TERM_IS_COLOR=true
    TERM_NOT_RECOGNIZED_AS_COLOR_BY_VIM=false
    TERM_NOT_RECOGNIZED_BY_SUN_UTILS=true
    TERM_CAN_TITLE=false
  ;;

  xterm|vt100)
    TERM_IS_COLOR=true
    TERM_NOT_RECOGNIZED_AS_COLOR_BY_VIM=true
    TERM_NOT_RECOGNIZED_BY_SUN_UTILS=false
    TERM_CAN_TITLE=true
  ;;

  *xterm*|eterm|rxvt*)
    TERM_IS_COLOR=true
    TERM_NOT_RECOGNIZED_AS_COLOR_BY_VIM=true
    TERM_NOT_RECOGNIZED_BY_SUN_UTILS=true
    TERM_CAN_TITLE=true
  ;;

  *)
    TERM_IS_COLOR=false
    TERM_NOT_RECOGNIZED_AS_COLOR_BY_VIM=false
    TERM_NOT_RECOGNIZED_BY_SUN_UTILS=false
    TERM_CAN_TITLE=false
  ;;

esac

# dircolors... make sure that we have a color terminal, dircolors exists, and ls supports it.
if $TERM_IS_COLOR && ( dircolors --help && ls --color ) &> /dev/null; then
  # For some reason, the unixs machines need me to use $HOME instead of ~
  # List files from highest priority to lowest.  As soon as the loop finds one that works, it will exit.
  for POSSIBLE_DIR_COLORS in "$HOME/.dir_colors" "/etc/DIR_COLORS"; do
    [[ -f "$POSSIBLE_DIR_COLORS" ]] && [[ -r "$POSSIBLE_DIR_COLORS" ]] && eval `dircolors -b "$POSSIBLE_DIR_COLORS"` && break
  done

  alias ls="ls --color=auto"
  alias ll="ls --color=auto -l"
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
else
  # No color, so put a slash at the end of directory names, etc. to differentiate.
  alias ls="ls -F"
  alias ll="ls -lF"
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# Set $TERM for libvte terminals that set $TERM wrong (like gnome-terminal)
{
  [ "_$TERM" = "_xterm" ] && type ldd && type grep && type tput && [ -L "/proc/$PPID/exe" ] && {
    if ldd /proc/$PPID/exe | grep libvte; then
      if [ "`tput -Txterm-256color colors`" = "256" ]; then
        TERM=xterm-256color
      elif [ "`tput -Txterm-256color colors`" = "256" ]; then
        TERM=xterm-256color
      elif tput -T xterm; then
        TERM=xterm
      fi
    fi
  }
} >/dev/null 2>/dev/null


##################################################
# This bashrc's current prompt		 	 #
##################################################

PS1='\[\033]0;\w\007\]\[\e[35;1m\]\u\[\e[0m\]\[\e[32m\]@\h\[\e[34m\]\w $(__git_ps1 " (%s)")\[\e[33m\]\$ \[\e[0m\]'	# purple, green, blue prompt w/default black & dir title



##################################################
# More command prompt choices (CHOOSE ONE, either#
# one of single lines below, or one of the	 #
# fancier ones farther below - just uncomment	 #
# one want and comment mine above)		 #
##################################################

# PS1='\[\033[01;31m\]\u\[\033[01;36m\]@\[\033[01;32m\]\h\[\033[01;33m\]:\[\033[01;33m\]\w\n\[\033[01;31m\]\$ \[\033[00;32m\]'	# red, cyan, green, yellow with green output
# PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "					# green and blue prompt with pc name & default black output
# PS1="\[\033[0;31m\][\u] [ \w ] \[\033[0m\] \n # "						# red with default black output (2-tier)
# PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"	# yellow and green with default black output
# PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"	# yellow, green, w/black output w/color change upon bad command
# PS1="\[\033[0;34m\][\u] \[\033[0;0m\]\w \[\033[0m\]$ "					# blue username and default black output
# PS1="\[\033[0;34m\][\u] \[\033[0;31m\][ \w ] \[\033[0m\] \n >> "				# blue and red with default black output (2-tier)
# PS1="\[\033[0;34m\][\u] \[\033[0;33m\][ \t ] \[\033[0;31m\][ \w ] \[\033[0m\] \n >> "		# blue, yellow, red with default black output (2-tier)
# PS1='\[\033[1;30m\][\[\033[0;37m\]${PIPESTATUS}\[\033[1;30m\]:\[\033[0;37m\]${SHLVL}\[\033[1;30m\]:\[\033[0;37m\]\j\[\033[1;30m\]][\[\033[1;34m\]\u\[\033[0;34m\]@\[\033[1;34m\]\h\[\033[1;30m\]:\[\033[0;37m\]`tty | sed s/\\\\\/dev\\\\\/\//g`\[\033[1;30m\]]\[\033[0;37m\][\[\033[1;37m\]\W\[\033[0;37m\]]\[\033[1;30m\] \$\[\033[00m\] '									# grey and blue with default black output
# PS1="[\[\033[1;34m\]\u\[\033[0m\]@\h \W]\\$ "							# blue username with default colors (black)
# PS1="[\!] \033[1;36m[ \u@\h ]\033[1;32m\] [ \t ] [ \d ]\n\033[1;33m\[[ \w ] \033[00m\\n\[\e[30;1m\](\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\]) \[\e[0m\] $: "	# black, cyan, green, yellow, default black output (2-tier)
# PS1="[\[\033[32m\]\w]\[\033[0m\]\n\[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\]"		# black, green, cyan, yellow, w/black output w/full path (2-tier)
# PS1="\[\033[34m\]   \u@\h `tty | sed 's/\/dev\///'` \t \d \[\033[35m\]\w/ \n\[\033[34m\] $\[\033[0m\] "	# cyan with green output
# PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "	# purple, cyan, black, green, yellow, default black
# PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "	# purple, cyan, black, green, yellow, w/black output
# PS1="\[\033[36m\]   \u@\h `tty | sed 's/\/dev\///'` \t \d \[\033[32m\]\w/ \n\[\033[36m\] $\[\033[0m\] "	# blue with purple output
# PS1=">\[\033[s\]\[\033[1;\$((COLUMNS-4))f\]\$(date +%H:%M)\[\033[u\]"				# trimmed up prompt with clock using default colors (black)
# PS1='C:${PWD//\//\\\}>'									# change prompt to MS-DOS one (joke)
# PS1='${debian_chroot:+($debian_chroot)}\[[ \033[01;31m\]\w\[\033[00m\]] '			# basic red with default black output
# PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\]'	# red and blue prompt with green output
# PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'	# green and blue prompt with light grey output
# PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\]'			# green and blue prompt with default black output
# PS1='\e[1;31;47m\u \e[1;32;47mon \h \e[1;35;47m\d \@\e[0;0m\n\e[1;31m[dir.= \w] \# > \e[0;0m'	# red, green, purple, red with default black output
# PS1='\[\e[1;31m\][\[\e[0;37m\]\u\[\e[1;31m\]@\[\e[0;37m\]\h \W\[\e[1;31m\]]\$\[\e[0m\] '	# red and grey with default black output
# PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '							# red color with default black output
# PS1='\[\e[1;32m\]\u@\H:\[\e[m\] \[\e[1;37m\]\w\[\e[m\]\n\[\e[1;33m\]hist:\! \[\e[0;33m\] \[\e[1;31m\]jobs:\j \$\[\e[m\] '	# green, yellow, red, grey and default black output (2-tier)
# PS1='\[\e[1;32m\]\u@\H:\[\e[m\] \[\e[1;37m\]\w\[\e[m\]\n\[\e[1;33m\]hist:\! \[\e[0;33m\] \[\e[1;31m\]jobs:\j \$\[\e[m\] '	# green, yellow, red, w/black output (2-tier) w/background job count
# PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '							# green color with default black output
# PS1='\e[1;33;47m\u \e[1;32;47mon \h \e[1;35;47m\d \@\e[0;0m\n\e[1;34m[dir.= \w] \# > \e[0;0m'	# yellow, green, purple, cyan with default black output
# PS1="\[\e[1;33m\] > \[\033[0m\]"								# basic yellow with default black output & nothing else
# PS1='\[\e[1m\]\h:\w\$\[\e[0m\] '								# black-bold with default colors (black)
# PS1="\[\e]2;\u@\H \w\a\e[30;1m\]>\[\e[0m\] "							# trimmed up prompt w/black arrow & title is current dir.
# PS1="\[\e[30;1m\]\w> \[\e[0m\]"								# trimmed up prompt with just black arrow and default colors
# PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\H> \[\e[0m\]"						# cyan and green prompt with default black output
# PS1="\[\e[37;1m\]-{\[\e[34;1m\]\u@\h\[\e[37;1m\]}-\n\[\e[37;1m\](\[\e[34;1m\]\w: \$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[37;1m\])\n--> \[\e[0m\]"		# grey and cyan w/black output (2-tier) w/dir size
# PS1='\[\e[41m\]\[\e[1;37m\] \u \[\e[47m\]\[\e[1;30m\] \W \[\e[0m\]\[\e[1;37m\]\[\e[42m\] # \[\033[0m\] '	# red, grey, green boxed with default black
# PS1='\[\e[45m\]\[\e[1;37m\] \u@\h \[\e[47m\]\[\e[1;30m\] \W \[\e[0m\]\[\e[1;37m\]\[\e[42m\] > \[\033[0m\] '	# purple, grey, green boxed with default black
# PS1='\[\e[m\n\e[0;33m\][$$:$PPID \j:\!\[\e[0;33m\]]\[\e[0;36m\] \T \d \[\e[1;34m\][\[\e[1;34m\]\u@\H\[\e[1;31m\]:\[\e[0;37m\]${SSH_TTY} \[\e[0;32m\]+${SHLVL}\[\e[1;30m\]] \[\e[1;31m\]\w\[\e[0;30m\] \n($SHLVL:\!)\$ '				# yellow, cyan, red, blue, white, green, black, red w/ default black output
# PS1="\`if [ \$? = 0 ]; then echo \[\e[33m\]^_^\[\e[0m\]; else echo \[\e[31m\]O_O\[\e[0m\]; fi\`[\u@\h:\w]\\$ "	# all black with happy face (yellow/red) upon successful completion
# PS1="\`if [ \$? = 0 ]; then echo \[\e[33m\]^_^\[\e[0m\]; else echo \[\e[31m\]O_O\[\e[0m\]; fi\`[\u@\h:\w]\\$ "	# basic prompt but with yellow smiley
# PS1="\n\[\033[32;1m\]It's \t\[\033[33;1m\] Currently browsing \[\033[1;36m\]\w \[\033[33;1m\]directory\n\[\033[34;1m\]\`if [ \$? = 0 ]; then echo \[\e[37m\]Last Command Was Successfully Executed \[\e[32m\]^_^\[\e[0m\]; else echo \[\e[37m\]Smeggin Hell !!! Last Command Was Unknown \[\e[32m\]O_O\[\e[0m\]; fi\` \n\[\033[31m\]What is thy bidding, my master? \n\n\[\033[34;1m\]"				# green, yellow, grey, green, red, w/cyan output (3-tier) Star Wars version
# PS1="\n\[\033[35m\]\$(/bin/date)\n\[\033[32m\]\w\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"	- purple, green, blue, cyan, yellow, with default black output (3-tier)
# PS1="\n\[\033[35m\]\$(/bin/date)\n\[\033[32m\]\w\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"												# purple, red, blue, cyan, yellow, w/white output (3-tier)
# PS1="\n\[$bldgrn\][\[$txtrst\]\w\[$bldgrn\]]\[$bldwht\]\n\[$bldwht\][\[$txtrst\]\t\[$bldwht\]]\[$bldylw\]$ \[$txtrst\]"	# green, black, grey, yellow with default black output (3-tier)
# PS1="\n#--[\[\e[1;36m\]\u@\h\[\e[m\]]-[\[\e[1;34m\]\w\[\e[m\]]-[\$(date +%k:%M)]-->\n"	# black, cyan, blue, black, w/black output (2-tier)
# PS1="\n\[\e[30;1m\]\[\016\]l\[\017\](\[\e[34;1m\]\u@\h\[\e[30;1m\])-(\[\e[34;1m\]\j\[\e[30;1m\])-(\[\e[34;1m\]\@ \d\[\e[30;1m\])->\[\e[30;1m\]\n\[\016\]m\[\017\]-(\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])--> \[\e[0m\]"				# grey, cyan, green, w/black output (2-tier) w/ dir. info
# PS1="\n\[\e[30;1m\]?(\[\e[34;1m\]\u@\h\[\e[30;1m\])-(\[\e[34;1m\]\j\[\e[30;1m\])-(\[\e[34;1m\]\@ \d\[\e[30;1m\])->\[\e[30;1m\]\n??(\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, $(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])--> \[\e[0m\]"	# black, cyan, green w/black output (2-tier)
# PS1="\n\[\e[32;1m\](\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"	# grey and green with default black output (3-tier)
# PS1="\n\[\e[m\][\[\033[01;32m\]\w\[\e[m\]] [\t] \n\[\033[01;33m\]$ \[\033[00m\]"		# green, black, yellow, with default black output (3-tier)
# PS1="\t \u@\h\$ "										# simple prompt with time (black)
# PS1="\t \u@\h `tty | sed 's/\/dev\///'` \w \$ "						# longer prompt with time (black)
# PS1="\u@\h\$ "										# simple default prompt (black)
# PS1="\u@\h `tty | sed 's/\/dev\///'` \w \$ "							# longer prompt with brief info (black)
# PS1='[\u@\h \W]\$ '										# default colors (black)
# PS1="\u@\h [\w] \$ "										# simple prompt with directory (black)
# PS1="\u `tty | sed 's/\/dev\///'` [\W] \$ "							# prompt with brief info (black)


# Cappucinno PATH
export PATH="/usr/local/narwhal/bin:$PATH"
export CAPP_BUILD="/home/raymond/Downloads/capp/Starter/Build"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


#YAY Git Completion
source ~/.git-completion.sh
