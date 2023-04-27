#!/bin/bash
git_uname=$1
git_email=$2
ssh_dir=$3
ssh_dir_default=$HOME/.ssh
confirm="r"
warning=""
while [ "$confirm" == "r" ] || [ "$confirm" == "retry" ]; do
    clear -x
    echo "


     -------------------------------------------------------
    |    ENTER CREDENTIAL INFO                              |
     -------------------------------------------------------"
    while [ -z $git_uname ]; do
        read -r -p "
        github username: 
            " git_uname
    done
    git_uname=$git_uname@github.com
    while [ -z $git_email ]; do
        read -r -p "
        email address: 
            " git_email
    done
    if [ -z $ssh_dir ]; then
        read -r -p "
        press ENTER to use default save location (${ssh_dir:-$ssh_dir_default})
        OR enter a custom save directory:
            " ssh_dir
        ssh_dir=${ssh_dir:-$ssh_dir_default}
    fi

    test_dir="$ssh_dir/testing_permissions_123"
    #test permissions with mkdir
    echo "
    helloworld
    testing write access in $ssh_dir ...
    attempting to create new directory in $ssh_dir ...
        "
    if ! mkdir -pv $test_dir; then
        warning+="

        WARNING: 
        insufficient write privileges for $ssh_dir
    
    "
    fi 
    if [ -r $ssh_dir/id_ed25519 ] || [ -r $ssh_dir/id_ed25519 ]; then
            warning+="

            !!!!!!!!!!!!!! WARNING !!!!!!!!!!!!!!!!

                keys EXIST and may be LOST
            
            !!!!!!!!!!!!!! WARNING !!!!!!!!!!!!!!!!

    an attempt will be made to rename the directory to $ssh_dir.old
"
    fi
    # cleanup test_dir
    rmdir -v $test_dir

    max_padding=48
    git_uname_len=${#git_uname}
    uname_padding_ws_count=$((max_padding - git_uname_len))
    uname_padding=""
    if [ $uname_padding_ws_count -lt 0 ]; then 
        uname_padding_ws_count=0
        uname_padding=""
    else
        for ((i=0;i<$uname_padding_ws_count;i++))
        do
            uname_padding+=" "
        done
        uname_padding+="|"
    fi

    # echo uname_padding_ws_count=$uname_padding_ws_count

    git_email_len=${#git_email}
    email_padding_ws_count=$((max_padding - git_email_len))
    email_padding=""
    if [ $email_padding_ws_count -lt 0 ]; then 
        email_padding_ws_count=0
        email_padding=""
    else
        for ((i=0;i<$email_padding_ws_count;i++))
        do
            email_padding+=" "
        done
        email_padding+="|"
    fi

    # echo email_padding_ws_count=$email_padding_ws_count
  
    ssh_dir_len=${#ssh_dir}
    ssh_dir_padding_ws_count=$((max_padding - ssh_dir_len))  
    ssh_dir_padding=""
    if [ $ssh_dir_padding_ws_count -lt 0 ]; then
        ssh_dir_padding_ws_count=0
        ssh_dir_padding=""
    else
        for ((i=0;i<$ssh_dir_padding_ws_count;i++))
        do
            ssh_dir_padding+=" "
        done
        ssh_dir_padding+="|"
    fi

    # echo ssh_dir_padding_ws_count=$ssh_dir_padding_ws_count

    clear -x
    read -r -p "


     -------------------------------------------------------
    |    CONFIRM CREDENTIAL INFO                            |
     -------------------------------------------------------
    |                                                       |
    |   github username:                                    |
    |       $git_uname$uname_padding
    |                                                       |
    |   email address:                                      |
    |       $git_email$email_padding
    |                                                       |
    |   save location:                                      |
    |       $ssh_dir$ssh_dir_padding
    |                                                       |
    |_______________________________________________________|
        $warning

    press ENTER to confirm and generate credentials

    [r]etry / e[x]it / (continue) " confirm
    if [ "$confirm" == "exit" ] || [ "$confirm" == "x" ]; then exit; fi
    if [ ! -z "$confirm" ] && ( [ "$confirm" != "r" ] && [ "$confirm" != "retry" ] ); then exit; fi
    if [ "$confirm" == "r" ] || [ "$confirm" == "retry" ]; then 
        echo "
        retrying ... ";
        unset ssh_dir git_uname git_email warning;
    fi
done

echo "
    -- use CTRL + C to cancel --
    "
sleep 3

if [ -r $ssh_dir/id_ed25519 ] || [ -r $ssh_dir/id_ed25519 ]; then
    mv -bv $ssh_dir $ssh_dir.old
fi
echo "  now running apt-get update and apt-get upgrade"
sleep 3

sudo apt-get update && sudo apt-get upgrade

echo "generating keys and saving to $ssh_dir"
# if [ -d $ssh_dir ]; then echo "----- $ssh_dir directory already exists - remove the directory ( rm -rf $ssh_dir ) and try again -----"; fi;
# rm -f $ssh_dir/id_ed25519 $ssh_dir/id_ed25519.pub 
git config --global user.email $git_email;
git config --global user.name $git_uname;
rm -fv $ssh_dir/id_ed25519 $ssh_dir/id_ed25519.pub;
ssh-keygen -C $git_uname -f $ssh_dir/id_ed25519 -N "" -t ed25519;
eval "$(ssh-agent -s)";
ssh-add $ssh_dir/id_ed25519;

# quietly verify host signature before using ssh-key
host_fingerprint_expected_rsa='github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==';
host_fingerprint_actually_rsa="$(ssh-keyscan -t rsa github.com)";
# quietly verify host signature before using ssh-key
host_fingerprint_expected_ed25519='github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl';
host_fingerprint_actually_ed25519="$(ssh-keyscan -t ed25519 github.com)";
# quietly verify host signature before using ssh-key
host_fingerprint_expected_ecdsa='github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=';
host_fingerprint_actually_ecdsa="$(ssh-keyscan -t ecdsa github.com)";
# if verified save - otherwise output error and stop

matching_prints_rsa=false;
matching_prints_ed25519=false;
matching_prints_ecdsa=false;


if [ "$host_fingerprint_actually_ecdsa" = "$host_fingerprint_expected_ecdsa" ]; then matching_prints_rsa=true; fi;
if [ "$host_fingerprint_actually_ed25519" = "$host_fingerprint_expected_ed25519" ]; then matching_prints_ed25519=true; fi;
if [ "$host_fingerprint_actually_ecdsa" = "$host_fingerprint_expected_ecdsa" ]; then matching_prints_ecdsa=true; fi;
if  [ $matching_prints_rsa ] && [ $matching_prints_ed25519 ] && [ $matching_prints_ecdsa ]; then
    echo "
    github host confirmed and verified
    "
    if [ -f "$ssh_dir/known_hosts" ]; then ssh-keyscan github.com >> $ssh_dir/known_hosts; else ssh-keyscan github.com > $ssh_dir/known_hosts; fi;
else
	echo '

    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    
    ';

    if ! [ $matching_prints_rsa ]; then echo '\nexpected RSA:\t$host_fingerprint_expected_rsa\nactual RSA:\t$host_fingerprint_actually_rsa';   fi;
    if ! [ $matching_prints_ed25519 ]; then  echo '\nexpected ED25519:\t$host_fingerprint_expected_ed25519\nactual ED25519:\t$host_fingerprint_actually_ed25519';  fi;
    if ! [ $matching_prints_ecdsa ]; then  echo '\nexpected ECDSA:\t$host_fingerprint_expected_ecdsa\nactual ECDSA:\t$host_fingerprint_actually_ecdsa';  fi;

	echo '

    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    !!!!!!!!! WARNING !!!!!!!!! 
    GH SSH KEYS *NOT* AUTHENTIC 
    !!!!!!!!! WARNING !!!!!!!!! 
    
    
    ';
fi

echo "converting virtual network to bridged"

$remoteport = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( $found ){
  $remoteport = $matches[0];
} else{
  echo "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

#[Ports]

#All the ports you want to forward separated by coma
$ports=@(80,443,10000,3000,5000);


#[Static ip]
#You can change the addr to your ip config to listen to a specific address
$addr='0.0.0.0';
$ports_a = $ports -join ",";


#Remove Firewall Exception Rules
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

#adding Exception Rules for inbound and outbound Rules
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteport";
}



echo "operation complete ..."


