#------------------------------------------------------------------------------
# プロンプト
#------------------------------------------------------------------------------
autoload -Uz colors
colors
#local DEFAULT=$'%{\e[1;m%}'
#local BLUE=$'%{\e[1;34m%}'
#local GRAY=$'%{\e[1;30m%}'
#local LGRAY=$'%{\e[0;37m%}'
#local WHITE=$'%{\e[1;37m%}'
#local PURPLE=$'%{\e[1;35m%}'
local DEFAULT=$'%{\e[0;0m%}'
local RESET="%{${reset_color}%}"
local GREEN="%{${fg[green]}%}"
local LGREEN=$'%{\e[1;32m%}'
local BGREEN="%{${fg_bold[green]}%}"
local BLUE="%{${fg[blue]}%}"
local LBLUE=$'%{\e[1;36m%}'
local BBLUE="%{${fg_bold[blue]}%}"
local RED="%{${fg[red]}%}"
local BRED="%{${fg_bold[red]}%}"
local CYAN="%{${fg[cyan]}%}"
local BCYAN="%{${fg_bold[cyan]}%}"
local YELLOW="%{${fg[yellow]}%}"
local LYELLOW=$'%{\e[1;33m%}'
local BYELLOW="%{${fg_bold[yellow]}%}"
local MAGENTA="%{${fg[magenta]}%}"
local BMAGENTA="%{${fg_bold[magenta]}%}"
local WHITE="%{${fg[white]}%}"
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
PROMPT='[%D{%H:%M:%S} ${LBLUE}${USER}${RESET}@${LYELLOW}${HOST%%.*}${RESET}:${LGREEN}%~${RESET}] %(!.#.$) '
RPROMPT="%1(v|%F${LGREEN}%1v%f|)"
setopt PROMPT_SUBST

#------------------------------------------------------------------------------
# キーバインド
#------------------------------------------------------------------------------
#bindkey -v						# Vi風

#------------------------------------------------------------------------------
# 履歴
#------------------------------------------------------------------------------
# ディレクトリ移動
setopt auto_cd					# ディレクトリ名だけで､ディレクトリの移動をする
setopt auto_pushd				# cdのタイミングで自動的にpushd
alias gd='dirs -v; echo -n "select number: "; read newdir; cd -"$newdir"'

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history			# 履歴ファイルに時刻を記録
#setopt hist_ignore_dups		# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_all_dups		# 重複したヒストリは追加しない
#setopt append_history			# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
#setopt share_history			# シェルのプロセスごとに履歴を共有
setopt hist_verify				# ヒストリを呼び出してから実行する間に一旦編集できる状態になる

# コマンド履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#------------------------------------------------------------------------------
# 補完
#------------------------------------------------------------------------------
autoload -U compinit
compinit
setopt magic_equal_subst		# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
#setopt auto_list				# 補完候補が複数ある時に、一覧表示
setopt list_packed				# 補完候補を詰めて表示
#setopt list_types				# 補完候補にファイルの種類も表示する
#setopt auto_menu				# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
#setopt auto_param_keys			# カッコの対応などを自動的に補完
#setopt auto_param_slash		# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
# sudo でも補完の対象
#zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# ファイルリスト補完でもlsと同様に色をつける｡
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
bindkey "\e[Z" reverse-menu-complete	# 逆向き補完（SHIFT + TAB）

# 先方予測
#autoload predict-on
#predict-on

#------------------------------------------------------------------------------
# 色
#------------------------------------------------------------------------------
# ls
alias ls='ls --color=auto'

