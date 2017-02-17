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

function django() {
    source ../../bin/activate;
    export PYTHONPATH=$PWD:$VIRTUAL_ENV:~/Sites/libraries/server-scripts;
    export SITE_NAME=${PWD##*/};
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
    cd $1;
    ../../bin/pip install -r server/requirements/local.txt;
    npm install;
}
