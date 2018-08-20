# Allow Ctrl-s etc on vim
# See: http://apple.stackexchange.com/questions/24310/emacs-ctrl-x-ctrl-s-command-not-working-in-terminal-app
stty -ixon -ixoff

shopt -s expand_aliases
export PATH=~/Sites/libraries/scripts/scripts:$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH
# PS1="\[\033[00m\]\u\[\033[0;33m\]@\[\033[00m\]\h\[\033[0;33m\] \w\[\033[00m\]: "

alias forcepush='mv .git/hooks/pre-push .git/hooks/disabled-pre-push && git push && mv .git/hooks/disabled-pre-push .git/hooks/pre-push'

export VIRTUAL_ENV_DISABLE_PROMPT=1
function super_cwd() {
    cwd_with_tilde=`dirs -0`
    # Turn something like ~/Sites/foo.example.com/src/foo.example.com/a/b/c into: foo.example.com/a/b/c
    pattern=\~\/Sites\/*\/src\/

    without_prefix=${cwd_with_tilde/$pattern/};

    # If no virtual env is activated, behave as normal.
    if [ -z ${VIRTUAL_ENV+x} ]; then
        echo $cwd_with_tilde;
    else
        # Get just the name of the virtual env, ie, foo.example.com
        site_name=`basename $VIRTUAL_ENV`;

        # Get the full path, ie, ~/Sites/foo.example.com/src/foo.example.com
        site_path="$VIRTUAL_ENV/src/$site_name";

        # If we are inside this path, trim it off and show just the virtualenv in parentheses.
        if [ "${PWD##$site_path}" != "$PWD" ]; then
            echo "($site_name)${PWD/$site_path/}";
        else
            # Else show the normal behavior but also highlight the virtualenv.
            echo "($site_name) $cwd_with_tilde";
        fi
    fi
}

PS1="\[\033[00m\]\u\[\033[0;33m\]@\[\033[00m\]\h\[\033[0;33m\] \$(super_cwd)\[\033[00m\]: "
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

function django() {
    source ../../bin/activate;
    # export PYTHONPATH=$PWD:$VIRTUAL_ENV:~/Sites/libraries/server-scripts;
    # Presumably django admin works below.
    export MYPYPATH="$PWD/server/stubs"
    export PYTHONPATH="$PWD:$HOME/Sites/libraries/server-scripts"
    export DJANGO_SETTINGS_MODULE="server.settings"
    export SITE_NAME=${PWD##*/};
}

function runserver_plus() {
    while True; do
        django-admin.py runserver_plus
        sleep 3s
    done
}

ds () {
    if [ -z "$1" ]; then
        settings="env";
    else
        settings="$1.env";
    fi;
    export WERKZEUG_DEBUG_PIN="off";
    DEBUG_PORT=`echo "from settings.$settings import DEBUG_PORT; print(DEBUG_PORT);" | python`;
    PYTHONPATH="$PWD" DJANGO_SETTINGS_MODULE=settings.$settings django-admin.py runserver_plus "0.0.0.0:$DEBUG_PORT"
}

reset_migrations() {
    rm -rf apps/$1/migrations;
    mkdir -p apps/$1/migrations;
    touch apps/$1/migrations/__init__.py;
}

reset_all_migrations() {
    for dir in apps/*
    do
        test -d "$dir" || continue
        rm -rf $dir/migrations;
        mkdir -p $dir/migrations;
        touch $dir/migrations/__init__.py;
    done
}

resetdb() {
  psql postgres -c 'SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid()';
  psql postgres -c "DROP DATABASE IF EXISTS \"$1\"";
  psql postgres -c "CREATE DATABASE \"$1\"";
}

savedb() {
    pg_dump $1 > ~/backup.sql;
}

restoredb() {
    psql $1 < ~/backup.sql;
}

setup_environment() {
    mkdir -p ~/Sites/$1;
    virtualenv -p python3.5 --clear ~/Sites/$1;
    mkdir -p ~/Sites/$1/backups;
    mkdir -p ~/Sites/$1/src;
    cd ~/Sites/$1/src;
    git clone $2 $1;
    cd $1;
    ../../bin/pip install -r server/requirements/local.txt;
    npm install;
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
