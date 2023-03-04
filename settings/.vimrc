"语法高亮
syntax on

"在底部显示, 当前处于命令模式还是插入模式
set showmode

"命令模式下, 在底部显示, 当前键入的指令
set showcmd

"显示行号
set nu

"设置光标行高亮显示, 背景是红色,文字时白色
"ctermbg:当前行的背景色, ctermfg:当前行的前景色(文字颜色)
set cursorline
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white


"显示括号匹配
set showmatch

"设置缩进
"设置Tab长度为4空格'
set tabstop=4
"设置自动缩进长度为4空格'
set shiftwidth=4

"自动对齐, 继承前一行的缩进方式, 适用于多行注释'
set autoindent

"智能缩进
set smartindent

"c文件自动缩进
set cindent

"搜索时, 每输入一个字符, 就自动跳到第一个匹配的结果
set incsearch

"设置粘贴模式
"set paste

"启用鼠标
"set mouse=a  " always use mouse

"绑定复制/粘贴快捷键, 复制到系统粘贴板
let mapleader=";"  "设置前置键
vmap <leader>c "+y "可视化模式使用 ;c 复制
nmap <leader>v "+p "正常模式使用 ;v 粘贴
imap <leader>v <esc>"+p "插入模式使用 ;v 粘贴


"设置tags, 首先在当前目录寻找tags文件, 没找到的话再去上层目录寻找
set tags=tags;
set autochdir

"让taglist中函数刷新变快
set updatetime=100

set history=9999
"set visuallbell
set autoread
"set noerrorbell
set noundofile
"set laststatus=2
set encoding=utf-8
set t_Co=256
filetype indent on
set scrolloff=5


"PATHOGEN配置
"execute pathogen#infect()
filetype plugin on "允许插件
filetype plugin indent on "启动智能补全


"nerdtree配置
"快捷键:使用F2打开关闭
"map <F2> :NERDTreeMirror <CR>
"map <F2> :NERDTreeToggle <CR>   "开关NERDTree
map <F2> :NERDTreeTabsToggle <CR>   "开关NERDTree tab版, 需要安装vim-nerdtree-tabs插件
"NERDTree配置
let NERDChristmasTree=1 "显示增强
let NERDTreeAutoCenter=1 "自动调整焦点
let NERDTreeShowFiles=1 "显示文件
let NERDTreeShowLineNumbers=1 "显示行号
let NERDTreeHightCursorline=1 "高亮当前文件
let NERDTreeShowHidden=0 "显示隐藏文件
let NERDTreeMinimalUI=0 "不显示'Bookmarks' label 'Press ? for help'
let NERDTreeWinPos='left' "窗口位置在左边
let NERDTreeWinSize=31 "窗口宽度
"当NERDTree为剩下的唯一窗口时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"打开vim时自动打开NERDTreetab
let g:nerdtree_tabs_open_on_console_startup=0

"taglist配置信息
"打开关闭快捷键
map <silent> <F3> :TlistToggle<CR>
let Tlist_Auto_Open=0 " Let the tag list open automatically
let Tlist_Auto_Update=0 " Update the tag list automatically
let Tlist_Compact_Format=1 " Hide help menu
let Tlist_Ctags_Cmd='ctags' " Location of ctags
let Tlist_Enable_Fold_Column=0 "do show folding tree
let Tlist_Process_File_Always=1 " Always process the source file
let Tlist_Show_One_File=1 " Only show the tag list of current file
let Tlist_Exit_OnlyWindow=1 " If you are the last, kill yourself
let Tlist_File_Fold_Auto_Close=0 " Fold closed other trees
let Tlist_Sort_Type="name" " Order by name
let Tlist_WinWidth=30 " Set the window 40 cols wide.
let Tlist_Close_On_Select=0 " Close the list when a item is selected
let Tlist_Use_SingleClick=1 "Go To Target By SingleClick
let Tlist_Use_Right_Window=1 "在右侧显示

"EasyComplete配置
"imap <Tab>   <Plug>EasyCompTabTrigger
"imap <S-Tab> <Plug>EasyCompShiftTabTrigger
"let g:pmenu_scheme = 'dark'
