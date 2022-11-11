#******************************************************************************/
# .zshrc (config file for zsh)                                      monotone-RK/
#                                                       Last updated 2020.01.01/
#******************************************************************************/

# Enable Ctrl+A to move to the beginning in the VSCode terminal
bindkey -e

###############################################
## iTerm2's tab title                         #
###############################################
function precmd() {
  local usrname=`whoami`
  local hstname=`hostname | cut -f 1 -d "."`
  local dirname=`pwd | sed -e "s|$HOME|~|"`
  echo -ne "\033]2;$usrname@$hstname:$dirname\007"
  echo -ne "\033]1;$usrname@$hstname:$dirname\007"
}

###############################################
## colors                                     #
###############################################
local GRAY=$'%{\e[1;30m%}'
local LIGHT_GRAY=$'%{\e[0;37m%}'
local WHITE=$'%{\e[1;37m%}'
local LIGHT_BLUE=$'%{\e[1;36m%}'
local YELLOW=$'%{\e[1;33m%}'
local PURPLE=$'%{\e[1;35m%}'
local GREEN=$'%{\e[1;32m%}'
local BLUE=$'%{\e[1;34m%}'
local RED=$'%{\e[1;31m%}'
local DEFAULT=$'%{\e[[%}'

###############################################
## enable to display prompt with color        #
###############################################
autoload -U colors
colors
tmp_prompt="%{${fg[cyan]}%}[%n@%m] %(!.#.$) %{${reset_color}%}"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_sprompt="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
tmp_rprompt="%{${fg[cyan]}%}[%~]%{${reset_color}%}"
# root mode
case ${UID} in
    0)
	tmp_prompt="%B%U${tmp_prompt}%u%b"
	tmp_prompt2="%B%U${tmp_prompt2}%u%b"
	tmp_sprompt="%B%U${tmp_sprompt}%u%b"
	tmp_rprompt="%B%U${tmp_rprompt}%u%b"
        ;;
esac
PROMPT=$tmp_prompt    # normal prompt
PROMPT2=$tmp_prompt2  # secondary prompt
SPROMPT=$tmp_sprompt  # a prompt for spell correction
RPROMPT=$tmp_rprompt  # right-side prompt

###############################################
## source zsh-syntax-highlighting             #
###############################################
case ${OSTYPE} in
    darwin*)
	if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
	if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
        ;;
    *)
	if [ -f ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	    source ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
        ;;
esac

###############################################
## completion                                 #
###############################################
case ${OSTYPE} in
    darwin*)
	fpath=(/usr/local/share/zsh-completions $fpath)
        ;;
    *)
	fpath=(${HOME}/.zsh/zsh-completions $fpath)
        ;;
esac
autoload -U compinit
compinit
setopt auto_cd
setopt auto_pushd
setopt correct
setopt auto_menu
setopt list_packed
setopt list_types
setopt print_eight_bit
setopt nolistbeep
setopt noautoremoveslash
setopt pushd_ignore_dups
setopt magic_equal_subst
setopt extended_glob
unsetopt caseglob
setopt auto_param_slash
setopt mark_dirs
setopt no_beep
setopt transient_rprompt
bindkey "^I" menu-complete

###############################################
## zstyle                                     #
###############################################
zstyle ":completion:*" list-colors "di=34" "ln=35" "so=32" "ex=31" "bd=46;34" "cd=43;34"
zstyle ":completion:*:default" menu select=1
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"
zstyle ":completion:*:*files" ignored-patterns "*?.o"
zstyle ":completion:*" list-separator "-->"
zstyle ":completion:*:*:-subscript-:*" tag-order indexes parameters
# Show completion excessively
zstyle ":completion:*" verbose yes
zstyle ":completion:*" completer _expand _complete _match _prefix _approximate _list _history
zstyle ":completion:*:messages" format $YELLOW"%d"$DEFAULT
zstyle ":completion:*:warnings" format $RED"No matches for:"$YELLOW" %d"$DEFAULT
zstyle ":completion:*:descriptions" format $YELLOW"completing %B%d%b"$DEFAULT
zstyle ":completion:*:corrections" format $YELLOW"%B%d "$RED"(errors: %e)%b"$DEFAULT
zstyle ":completion:*:options" description "yes"
zstyle ":completion:*" group-name ""
zstyle ":completion:*" use-cache true

###############################################
## command's history function                 #
###############################################
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
autoload history-search-end # history search
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

###############################################
## export                                     #
###############################################
export LANG=en_US.UTF-8
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30"

typeset -U PATH

export PATH=${HOME}/bin:/usr/local/bin:$PATH
case ${OSTYPE} in
    darwin*)
	export PATH=/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/sbin:/usr/texbin:/opt/ImageMagick/bin:$PATH
	export EDITOR="vim"
        ;;
    linux*)
	export PATH=${HOME}/local/bin:/opt/bin:/opt/local/bin:$PATH
	if [[ -z $TMUX ]]; then
	    export MODULEPATH=$HOME/modules:$MODULEPATH
	fi
        ;;
esac

if [ -x "`which go`" ]; then
    export GOROOT=`go env GOROOT`
    export GOPATH=~/.go
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
fi

###############################################
## alias                                      #
###############################################
if [[ -x `which colordiff` ]]; then
    alias diff="colordiff"
fi
if [[ ! -x `which tree` ]]; then
    alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"
fi
alias less="less -R"
alias gls="gls --color"
alias jitac="java -jar ~/bin/jitac-0.2.0.jar"
alias ll="ls -ltr"
alias sshx="ssh -Y"
alias sc="screen -D -RR"
alias pycat="pygmentize"
alias grep="grep --color=always"
alias egrep="egrep --color=always"
alias fgrep="fgrep --color=always"
alias zgrep="zgrep --color=always"
alias pdfgrep="pdfgrep --color=always"
case ${OSTYPE} in
    darwin*)
	if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
	    export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
	    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
	    alias ls="ls --color"
	elif [ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]; then
	    export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
	    export MANPATH=/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH
	    alias ls="ls --color"
	else
	    export LSCOLORS=gxfxcxdxbxegedabagacad
	    alias ls="ls -G"
	fi
	if [ -d /usr/local/opt/gnu-sed/libexec/gnubin ]; then
	    export PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH
	    export MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH
	elif [ -d /opt/homebrew/opt/gnu-sed/libexec/gnubin ]; then
	    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
	    export MANPATH=/opt/homebrew/opt/gnu-sed/libexec/gnuman:$MANPATH
	fi
	if [ -d /usr/local/opt/gnu-tar/libexec/gnubin ]; then
	    export PATH=/usr/local/opt/gnu-tar/libexec/gnubin:$PATH
	    export MANPATH=/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH
	elif [ -d /opt/homebrew/opt/gnu-tar/libexec/gnubin ]; then
	    export PATH=/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH
	    export MANPATH=/opt/homebrew/opt/gnu-tar/libexec/gnuman:$MANPATH
	fi
	function excel() { open -a Microsoft\ Excel $1 }
	function pwp() { open -a Microsoft\ PowerPoint $1 }
	function word() { open -a Microsoft\ Word $1 }
	alias adobe="open -a Adobe\ Acrobat\ Reader"
	alias preview="open -a preview"
	alias arduino="open -a Arduino"
        ;;
    linux*)
	alias ls="ls --color"
        ;;
esac

###############################################
## screen                                     #
###############################################
if [ ${TERM} = xterm-color ]; then # status bar
    preexec () {
	[ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
    }
    precmd() {
	[ ${STY} ] && echo -ne "\ek$shelltitle\e\\"
    }
fi

###############################################
## ssh-keygen                                 #
###############################################
case ${OSTYPE} in
    linux*) # linux only
	HOST=`hostname`
	HOST_NAME=`echo ${HOST} | sed 's/\..*//'`
	if [ "$PS1" ]; then # only Interactive mode
	    # ssh-agent
	    SSH_AGENT_FILE="${HOME}/.ssh/.ssh-agent.`hostname`"
	    if [ -f ${SSH_AGENT_FILE} ]; then
		eval `cat ${SSH_AGENT_FILE}`
		ssh_agent_exist=0
		for id in `ps ax|grep 'ssh-agent'|sed -e 's/\([0-9]\+\).*/\1/'`
		do
		    if [ ${SSH_AGENT_PID} = ${id} ]; then
			ssh_agent_exist=1
		    fi
		done
		if [ $ssh_agent_exist = 0 ]; then
		    rm -f ${SSH_AGENT_FILE}
		    ssh-agent > ${SSH_AGENT_FILE}
		    chmod 600 ${SSH_AGENT_FILE}
		    eval `cat ${SSH_AGENT_FILE}`
		    ssh-add
		fi
	    else
		ssh-agent > ${SSH_AGENT_FILE}
		chmod 600 ${SSH_AGENT_FILE}
		eval `cat ${SSH_AGENT_FILE}`
		ssh-add
	    fi
	fi
	;;
esac

###############################################
## VCS                                        #
###############################################
if [ -f /eda/cad.bashrc ]; then
    source /eda/cad.bashrc
fi

###############################################
## VNC Viewer                                 #
###############################################
FPGA=localhost:5901
PPX=localhost:5902

alias vfpga="vncviewer ${FPGA} &"
alias vppx="vncviewer ${PPX} &"

###############################################
## Utility                                    #
###############################################
function add_path() {
    if [[ -e "$1" ]]; then
        export PATH="$(readlink -f "$1"):$PATH"
    fi
}

function add_ldpath() {
    if [[ -e "$1" ]]; then
        export LD_LIBRARY_PATH="$(readlink -f "$1"):$LD_LIBRARY_PATH"
    fi
}
