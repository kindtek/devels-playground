#!/bin/bash
git_user_email=$GH_REPO_OWNER_EMAIL;
git_user_name=kindtek@github.com;
ssh_dir=/home/${1:-$LOGNAME}/.ssh;
if ! [ -d $ssh_dir ]; then $ssh_dir=~/.ssh; fi;
if [ -d $ssh_dir ]; then echo "----- $ssh_dir directory already exists - remove the directory ( rm -rf $ssh_dir ) and try again -----"; fi;
# rm -f $ssh_dir/id_ed25519 $ssh_dir/id_ed25519.pub 
# git config --global user.email $git_user_email;
# git config --global user.name $git_user_name;
rm -f $ssh_dir/id_ed25519 $ssh_dir/id_ed25519.pub;
ssh-keygen -C $git_user_name -f $ssh_dir/id_ed25519 -N "" -t ed25519;
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
    echo '\n verfied host confirmed \n'
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

