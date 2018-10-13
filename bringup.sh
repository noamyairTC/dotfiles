add_line() {
    # Usage: add_line filename "string"

    local filename=$1
    local string=$2

    if [ -z "$(sudo grep -Fx "## Added by bringup script" "$filename")" ]; then
        sudo printf "## Added by bringup script\n$string\n## Added by bringup script - end\n"  | sudo tee -a "$1" > /dev/null
    else
        if [ -z "$(sudo grep -Fx "$string" "$filename")" ]; then
            sudo sed -i "/## Added by bringup script - end/i$string" $filename
        fi
    fi
}

change_line() {
    # Usage: change_line filename "line to replace regex" "string"

    local filename=$1
    local line_regex=$2
    local string=$3

    if [ ! -z "$(sudo grep "^$string\$" "$filename")" ]; then
        :
    else
        if [ -z "$(sudo grep "$line_regex" "$filename")" ]; then
            echo "Error: could not find line to change \"$line_regex\" in \"$filename\"" 1>&2
            exit 1
        fi
        sudo sed -i "s/$line_regex/$string/g" $filename
    fi
}

echo "-> Setting passwordless sudo"
add_line /etc/sudoers "$USER ALL=(ALL:ALL) NOPASSWD: ALL"

echo "-> Update aptitude"
sudo apt-get update -y || true
sudo apt-get upgrade -y

echo "-> Install basic packages"
## Basic
sudo apt-get install -y \
    software-properties-common \
    build-essential \
    cmake \
    python3 \
    python3-dev \
    python3-pip \
    python \
    python-dev \
    python-pip
## Utilities
sudo apt-get install -y -qq \
    sshfs \
    curl \
    vim \
    git \
    tig \
    tmux \
    unzip \
    htop \
    tree \
    silversearcher-ag

## Install Z-shell
echo "-> Installing Z-shell"
sudo apt-get install -y zsh
sudo chsh -s $(which zsh) $USER

## Install Oh my Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "-> Installing Oh My Zsh"
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

echo "-> linking dot files"
dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sudo chown -R $USER:$USER $dotfiles_dir
for i in .tmux.conf .zshrc; do
    ln -sfT $dotfiles_dir/$i $HOME/$i
done

## Set oh my Zsh theme
ln -sfT $dotfiles_dir/mytheme.zsh-theme $HOME/.oh-my-zsh/themes/mytheme.zsh-theme

# echo "-> Install docker"
# if [ "$(lsb_release -r | awk '{print $2}')" == "14.04" ]; then
#     sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual  # allow Docker to use the aufs storage
# fi
# sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common  # allow apt to use a repository over HTTPS
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  # Add Docker’s official GPG key
# ## Verify that the key fingerprint is 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88: sudo apt-key fingerprint 0EBFCD88
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-get update || true
# sudo apt-get install -y docker-ce
# ## Test docker installation: sudo docker run hello-world
# 
# sudo groupadd docker || true
# sudo usermod -aG docker $USER
# 
# ## ==========================
# echo "-> Install docker compose"
# curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose >  /dev/null
# sudo chmod +x /usr/local/bin/docker-compose
# sudo curl -L https://raw.githubusercontent.com/docker/compose/1.17.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
# 
# ## ==========================
# echo "-> Install nvidia-docker"
# # If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
# sudo docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
# sudo apt-get purge -y nvidia-docker || true
# 
# # Add the package repositories
# curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
# sudo apt-get update
# 
# # Install nvidia-docker2 and reload the Docker daemon configuration
# sudo apt-get install -y nvidia-docker2
# sudo pkill -SIGHUP dockerd
# 
# # # Test nvidia-smi with the latest official CUDA image
# # sudo docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
# 
# ## ==========================
# if [ -z "$(sudo docker network ls | grep docknet)" ]; then
#     echo "-> Create docker network"
#     sudo docker network create --driver bridge --subnet 172.18.0.0/16 docknet
# fi
