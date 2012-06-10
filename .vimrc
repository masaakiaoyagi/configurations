set nocompatible	" vi との互換性OFF
filetype off		" ファイル検出無効

"------------------------------------------------------------------------------
" プラグイン
"------------------------------------------------------------------------------
set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimfiler'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'
Bundle 'rails.vim'
Bundle 'mattn/zencoding-vim'
Bundle 'tpope/vim-fugitive'

source $VIMRUNTIME/mswin.vim

"------------------------------------------------------------------------------
" 基本設定
"------------------------------------------------------------------------------
set encoding=utf-8										" 内部エンコーディング
set fileencodings=utf-8,cp932,euc-jisx0213,iso-2022-jp	" 読込自動判定エンコーディング
set number												" 行番号表示
set cursorline											" カーソル行強調
set showmatch											" 閉じ括弧強調
set showmode											" モード表示
set noswapfile											" swap を生成しない
" インデント
au BufNewFile,BufRead * set tabstop=4
"au BufNewFile,BufRead *.erb,*.rb,*.yml set tabstop=2 expandtab
set autoindent											" 自動インデント
vmap <Tab> :s/^/\t/<CR>gv								" 選択行の TAB インデント
vmap <S-Tab> :s/^\t//<CR>gv								" 選択行の shift + TAB アンインデント
set list												" 不可視文字の表示
set listchars=tab:>.,eol:$,trail:_,extends:\			" 不可視文字の表示形式
" 検索
set ignorecase											" 大文字・小文字を区別しない
set smartcase											" ただし、混在している場合は区別する
set hlsearch											" 検索語を強調
" 折り畳み
set foldmethod=syntax									" 折り畳み方法
set foldmarker={{{,}}}									" 折り畳む最初と最後の文字
set foldlevel=1											" 初期折り畳みレベル
set foldtext=MyFoldText()								" 折り畳まれた際の表示テキスト
function MyFoldText()
	let line = getline(v:foldstart)
	let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
	let fold_cnt = v:foldend - v:foldstart + 1
	return '+' . v:folddashes . sub . '   (' . fold_cnt . ' 行)'
endfunction
" 行頭の左矢印で折り畳む(ちょっと怪しいかも)
nnoremap <expr> <LEFT> foldlevel(getpos('.')[1])>0 &&
	\(getpos('.')[2]==1 \|\|
	\getline('.')[: getpos('.')[2]-2] =~ "^[\<TAB> ]*$" )?"zch":"h"
" gvim用
if has("gui_running")
	set showtabline=2									" タブ表示
	set guioptions-=T									" ツールバー非表示
	set columns=130										" ウインドウの幅
	set lines=105										" ウインドウの高さ
endif

"------------------------------------------------------------------------------
" プラグイン設定
"------------------------------------------------------------------------------
" VimFiler
nnoremap <F2> :VimFiler -buffer-name=explorer -split -winwidth=50 -toggle -no-quit<Cr>
autocmd! FileType vimfiler call g:my_vimfiler_settings()
function! g:my_vimfiler_settings()
	nmap		<buffer><expr><Cr>	vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
	nnoremap	<buffer>s			:call vimfiler#mappings#do_action('my_split')<Cr>
	nnoremap	<buffer>v			:call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

let my_action = { 'is_selectable' : 1 }
function! my_action.func(candidates)
	wincmd p
	exec 'split '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_split', my_action)

let my_action = { 'is_selectable' : 1 }
function! my_action.func(candidates)
	wincmd p
	exec 'vsplit '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_vsplit', my_action)
" git のルートディレクトリを開く
function! s:git_root_dir()
	if(system('git rev-parse --is-inside-work-tree') == "true\n")
		return ':VimFiler ' . system('git rev-parse --show-cdup') . '\<CR>'
	else
		echoerr '!!!current directory is outside git working tree!!!'
	endif
endfunction
nnoremap <expr><Leader>fg <SID>git_root_dir()

filetype plugin indent on

"------------------------------------------------------------------------------
" 色
"------------------------------------------------------------------------------
colorscheme desert
" ハイライト
au BufRead,BufNew * match JpSpace /　/
highlight JpSpace cterm=underline ctermfg=Red guibg=Red			" 全角スペース
function! HighlightRuby()
"	highlight rubySymbol ctermfg=DarkYellow guifg=DarkYellow	" シンボル
	syntax match rubyLocalVariable /\<_\w\+\>/
	highlight rubyLocalVariable ctermfg=Green guifg=Green		" ローカル変数
	syntax match rubyExit /\<\(raise\|return\|beak\|next\|redo\|retry\)\>/
	highlight rubyExit ctermfg=Red guifg=Red					" 脱出
endfunc
au BufRead,BufNew *.rb,*.erb,*.yml call HighlightRuby()

