# Allow Ctrl-s etc on vim
# See: http://apple.stackexchange.com/questions/24310/emacs-ctrl-x-ctrl-s-command-not-working-in-terminal-app
stty -ixon -ixoff

shopt -s expand_aliases
export PATH=~/Sites/libraries/scripts/scripts:$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH
PS1="\[\033[00m\]\u\[\033[0;33m\]@\[\033[00m\]\h\[\033[0;33m\] \w\[\033[00m\]: "
export EDITOR=vim
export PIP_DEFAULT_TIMEOUT=60
export PIP_REQUIRE_VIRTUALENV=true
export WERKZEUG_DEBUG_PIN=off

source /usr/local/etc/bash_completion.d/*

function rename_to_typescript() {
    # Rename all *.js to *.ts
    for f in *.js; do
    git mv -- "$f" "${f%.js}.ts"
    done
}
