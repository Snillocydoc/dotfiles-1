# 
# Bash setup inspired by: https://github.com/mathiasbynens/dotfiles
#
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`
# * ~/.extra can be used for other setttings you don't want to commit
for file in ~/.{path,prompt_bash,exports,aliases,functions,extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

shopt -s histappend

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# if possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion
