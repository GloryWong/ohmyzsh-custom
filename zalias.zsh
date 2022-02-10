### public alias

### specific alias

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

alias nginxstart="nginx"
alias nginxreload="nginx -s reload"
alias nginxstop="nginx -s stop"
alias nginxtest="nginx -t"
alias nginxconfig="code -r '/usr/local/etc/nginx/servers/glorystudio.conf'"

alias hosts="code -r '/etc/hosts'"

alias zshrcconfig="code -r ~/.zshrc"
alias zshaliasconfig="code -r $ZSH_CUSTOM/zalias.zsh"
alias zshsource="source ~/.zshrc"

alias mongostart="brew services start mongodb-community"
alias mongorestart="brew services restart mongodb-community"
alias mongostop="brew services stop mongodb-community"

alias pm2start="pm2 start ~/Public/pm2/ecosystem.config.js"
alias pm2stop="pm2 stop ~/Public/pm2/ecosystem.config.js"

alias rm="trash"

opendemo() {
  local demosdir=$demos; # variable 'demos' is a global shortcut refered to demos directory
  local demoname; # name of selected or created demo
  local demodir; # directory of selected or created demo
  local alldemos=(); # array type, all demos in 'demos' directory

  # Create a demo directory
  createDemoDir() {
    mkdir -p $demosdir/$1;
    print -P "%F{green}Directory $demosdir/$1 was successfully created.%f";
    if read -qs -t 30 "?>> Do you want to open '$1'? [Y/n]"$'\n'; then
      code -r "$demosdir/$1";
    fi
  }

  if ( test -n $1 ) && ( test "$1" = "-m" ) && ( test -n $2 ); then
    createDemoDir $2;
    return;
  fi

  # delete a demo directory
  deleteDemoDir() {
    if ( test -d $demosdir/$1 ) then
      if read -qs -t 30 "?>> Are you sure to delete demo '$1'? [Y/n]"$'\n'; then
        rm -rf $demosdir/$1;
        print -P "%F{green}Directory $demosdir/$1 was successfully deleted.%f";
      fi
    else
      print -P "%F{red} demo '$1' does not exist";
    fi
  }
  if ( test -n $1 ) && ( test "$1" = "-r" ) && ( test -n $2 ); then
    deleteDemoDir $2;
    return;
  fi

  # Get all the demo names in $demosdir,
  # Push into alldemos
  updateAllDemos() {
    local currentDir=`pwd`;
    cd $demosdir;
    local count=1;
    for f in *
    do
      alldemos[$count]="$f";
      count=`expr $count + 1`;
    done
    # changed back to current working directory
    cd $currentDir;
  }

  listAndRead() {
    updateAllDemos;
    local count=0;
    print "================================";
    for f in ${alldemos[@]}
    do
      print -P "[%F{cyan}$count%f]$f";
      count=`expr $count + 1`;
    done
    print "================================";
    read "demoname?>> Input demo code or name: ";
  }

  local dirExists;
  check() {
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      demoname=$alldemos[`expr $1 + 1`];
    else
      demoname=$1;
    fi

    demodir="$demosdir/$demoname";
    if test $demoname && ( test -d $demodir )
    then
      dirExists=true;
    else
      dirExists=false;
    fi
  }
  
  # Input argument or not, which refer to its demo folder name straightforward
  if [ -z $1 ]
  then
    listAndRead;
  else
    demoname=$1;
  fi

  # Check and urge input available folder name or related code, in a loop
  check $demoname;
  while [ "$dirExists" = false ]
  do
    print -P "%F{red}$demodir is not a demo directory.%f";
    if read -qs -t 30 "?>> Do you want to create demo '$demoname'? [Y/n]"$'\n'; then
      if [ -n $demoname ]; then
        createDemoDir $demoname;
        return;
      else
        print -P "%F{red}Invalid directory name%f";
      fi
    fi
    listAndRead;
    check $demoname;
  done

  code -r $demodir;
  print -P "%F{green}$demodir successfully open.%f";
}

transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}
