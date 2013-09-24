#******************************************************************************/
# .zshrc (config file for zsh)                                      monotone-RK/
#                                                       Last updated 2013.06.09/
#******************************************************************************/

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
# rootユーザ時(太字にし、アンダーバーをつける)
case ${UID} in
    0)
	   tmp_prompt="%B%U${tmp_prompt}%u%b"
	   tmp_prompt2="%B%U${tmp_prompt2}%u%b"
	   tmp_sprompt="%B%U${tmp_sprompt}%u%b"
	   tmp_rprompt="%B%U${tmp_rprompt}%u%b"
        ;;
esac
PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト
RPROMPT=$tmp_rprompt  # 右側のプロンプト

###############################################
## source zsh-syntax-highlighting             #
###############################################
case ${OSTYPE} in
    darwin*)
	   if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
		  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	   fi
        ;;
    linux*)
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
    linux*)
	   fpath=(${HOME}/.zsh/zsh-completions $fpath)
        ;;
esac
autoload -U compinit
compinit
setopt auto_cd             # ディレクトリ名を入力するだけでカレントディレクトリを変更
setopt auto_pushd          # 移動したディレクトリを記録
setopt correct             # 入力したコマンド名が間違っている場合には修正
setopt auto_menu           # タブキー連打で補完候補を順に表示
setopt list_packed         # 補完候補を詰めて表示
setopt list_types          # 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
setopt print_eight_bit     # 補完候補リストの日本語を正しく表示
setopt nolistbeep          # ベルを鳴らさない。
setopt noautoremoveslash   # パスの最後に付くスラッシュ(/)を自動的に削除させない
setopt pushd_ignore_dups   # auto_pushdで重複するディレクトリは記録しないようにする
setopt magic_equal_subst   # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt extended_glob       # グロブ機能を拡張する
unsetopt caseglob          # ファイルグロブで大文字小文字を区別しない
setopt auto_param_slash    # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs           # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt no_beep             # ビープ音を鳴らさないようにする
setopt transient_rprompt   # 現在の行のみにRPROMPTを表示させる
bindkey "^I" menu-complete # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)

###############################################
## zstyle                                     #
###############################################
zstyle ":completion:*" list-colors "di=34" "ln=35" "so=32" "ex=31" "bd=46;34" "cd=43;34"
zstyle ":completion:*:default" menu select=1                        # 補完候補をカーソルで選択できる
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"                 # 補完時に大文字小文字を区別しない
zstyle ":completion:*:*files" ignored-patterns "*?.o"               # オブジェクトファイルとか中間ファイルとかはfileとして補完させない
zstyle ":completion:*" list-separator "-->"                         # セパレータを設定する
zstyle ":completion:*:*:-subscript-:*" tag-order indexes parameters # 変数の添字を補完する
# 補完関数の表示を過剰にする
zstyle ":completion:*" verbose yes 
zstyle ":completion:*" completer _expand _complete _match _prefix _approximate _list _history 
zstyle ":completion:*:messages" format $YELLOW"%d"$DEFAULT
zstyle ":completion:*:warnings" format $RED"No matches for:"$YELLOW" %d"$DEFAULT
zstyle ":completion:*:descriptions" format $YELLOW"completing %B%d%b"$DEFAULT
zstyle ":completion:*:corrections" format $YELLOW"%B%d "$RED"(errors: %e)%b"$DEFAULT
zstyle ":completion:*:options" description "yes"
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ":completion:*" group-name "" 
zstyle ":completion:*" use-cache true # apt-getとかdpkgコマンドをキャッシュを使って速くする

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
export EDITOR="emacs"
export LANG=ja_JP.UTF-8
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30" 
case ${OSTYPE} in
    darwin*)
	   export PATH=${HOME}/bin:/usr/local/bin:/usr/texbin:/opt/ImageMagick/bin:$PATH
        ;;
    linux*)
	   export PATH=/home/share/cad/mipsel4/usr/bin:/usr/local/bin:${HOME}/bin:/usr/local/cuda/bin:$PATH
	   export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/lib:${HOME}/pin2.11/intel64/runtime:${HOME}/snappy/lib:$LD_LIBRARY_PATH
        ;;
esac

###############################################
## alias                                      #
###############################################
alias emacs="emacs -nw"
alias gls="gls --color"
alias jitac="java -jar ~/bin/jitac-0.2.0.jar"
alias ll="ls -ltr"
alias sshx="ssh -Y"
alias sc="screen -D -RR"
case ${OSTYPE} in
    darwin*)
	   if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
	     export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
		export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
		alias ls='ls --color=auto'
	   else
		export LSCOLORS=gxfxcxdxbxegedabagacad
		alias ls='ls -G'
	   fi
	   alias Emacs="open -a '/Applications/Emacs.app/Contents/MacOS/Emacs'"
	   alias excel="open -a Microsoft\ Excel"
	   alias pwp="open -a Microsoft\ PowerPoint"
	   alias word="open -a Microsoft\ Word"
	   alias adobe="open -a Adobe\ Reader"
	   alias preview="open -a preview"
	   alias pycat="/usr/local/share/python/pygmentize"
        ;;
    linux*)
	   alias ls="ls --color"
	   alias pycat="pygmentize"
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
#[ ${STY} ] || screen -rx || screen -D -RR

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
            if [ ${SSH_AGENT_PID} = ${id} ]
            then 
                ssh_agent_exist=1
            fi
        done
        if [ $ssh_agent_exist = 0 ]
        then
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
## google search (Japanese is available)      #
###############################################
function google() {
  local str opt
  if [ $# != 0 ]; then # 引数が存在すれば
    for i in $*; do
      str="$str+$i"
    done
    str=`echo $str | sed 's/^\+//'` # 先頭の「+」を削除
    opt="search?num=50&hl=ja&ie=euc-jp&oe=euc-jp&lr=lang_ja"
    opt="${opt}&q=${str}"
  fi
  w3m http://www.google.co.jp/$opt # 引数がなければ $opt は空
}

###############################################
## display "username@host:current directory"  #
## on title of the terminal                   #
###############################################
# case "${TERM}" in
# kterm*|xterm)
#     precmd() {
#         echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#     }
#     ;;
# esac

