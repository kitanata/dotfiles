if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin:/usr/texbin"
export PATH=$PATH:/usr/local/share/npm/bin

alias ctags='/usr/local/bin/ctags'

source /Users/raymond/.rvm/scripts/rvm

export JAVA_HOME=`/usr/libexec/java_home -v 1.7`

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

echo 'Your path is: '$PATH
export PATH="$HOME/.rbenv/bin:$PATH"
