git_user_email=$GH_REPO_OWNER_EMAIL;
git_user_name=kindtek@github.com;
ssh_dir=/home/${1:-dvl}/.ssh;
if ! [ -d $ssh_dir ]; then $ssh_dir=/home/dvl/.ssh; fi;
# rm -f $ssh_dir/id_ed25519 $ssh_dir/id_ed25519.pub 
# git config --global user.email $git_user_email;
# git config --global user.name $git_user_name;
rm -f $ssh_dir/id_ed25519 $ssh_dir/id_ed25519.pub;
ssh-keygen -C $git_user_name -f $ssh_dir/id_ed25519 -N "" -t ed25519;
eval "$(ssh-agent -s)";
ssh-add $ssh_dir/id_ed25519;
