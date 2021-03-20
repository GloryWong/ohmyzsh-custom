### public alias

### specific alias

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

alias code="code-insiders"

alias ngxstart="nginx"
alias ngxreload="nginx -s reload"
alias ngxstop="nginx -s stop"
alias ngxtest="nginx -t"
alias ngxconfig="code -f '/usr/local/etc/nginx/servers/glorystudio.conf'"

opendemo() {
  local demoname;
  local dir;
  local alldemos=();

  # Get all the folder names of $demos directory,
  # Push into alldemos
  local oldPath=`pwd`;
  cd $demos;
  local count=1;
  for f in *
  do
    alldemos[$count]="$f";
    count=`expr $count + 1`;
  done
  cd $oldPath;

  listAndRead() {
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

    dir="$demos/$demoname";
    if test $demoname && ( test -d $dir )
    then
      dirExists=true;
    else
      dirExists=false;
    fi
  }
  
  # Input argument or not, which points to its demo folder name straightforward
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
    print -P "%F{red}$dir is not a demo directory. Try again.%f";
    listAndRead;
    check $demoname;
  done

  code -r $dir;
  print -P "%F{green}$dir successfully open.%f";
}
