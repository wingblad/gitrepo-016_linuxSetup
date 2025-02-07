# Function to print red echo text
echo_red() {
    echo "\e[31m$1\e[0m"
}

# Update and Upgrade the System
echo_red "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install Essential Packages
echo_red "Installing essential packages..."
sudo apt install build-essential curl git vim net-tools zsh micro qalc gpg openssh-server cifs-utils nginx default-libmysqlclient-dev pkg-config smbclient -y

# Enable SSH server
echo_red "Enabling SSH server..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

# Install Python and pip
echo_red "Installing Python and pip..."
sudo apt install -y python3 python3-pip -y
sudo apt install python3-venv -y
sudo apt install python3-dev -y
sudo apt install python-is-python3 -y

# Install Docker
echo_red "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Prompt user for Git information
echo_red "Please enter your Git configuration information."

# Get Git user.name
read -p "Enter your Git username (e.g., Emil Wingblad): " git_username
git config --global user.name "$git_username"

# Get Git user.email
read -p "Enter your Git email (e.g., name@email.com): " git_email
git config --global user.email "$git_email"

# Set taskbar settings
echo_red "Set taskbar settings..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false

# Install Oh My Zsh
echo_red "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
echo_red "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install required plugins (zsh-autosuggestions, zsh-syntax-highlighting, fast-syntax-highlighting, zsh-autocomplete)
echo_red "Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Cleanup and Finish
echo_red "Cleaning up..."
sudo apt autoremove -y

echo_red "Setup is complete! Replace .zshrc file and then reboot your machine."

# Set Zsh as the default shell (without interrupting the rest of the script)
chsh -s $(which zsh)