# Set colours for file types
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000                 # entries in memory
SAVEHIST=10000                 # entries written to disk
setopt HIST_IGNORE_ALL_DUPS    # remove all previous duplicates of a command
setopt HIST_IGNORE_DUPS        # ignore duplicate consecutive commands
setopt HIST_IGNORE_SPACE       # ignore commands that start with a space
setopt HIST_EXPIRE_DUPS_FIRST  # Expire a duplicate event first when trimming history.
setopt INC_APPEND_HISTORY      # append each command to history immediately
setopt SHARE_HISTORY           # share history across multiple sessions
setopt EXTENDED_HISTORY        # saves time in seconds along with command

# Load starship
eval "$(starship init zsh)"