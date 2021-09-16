\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rsreport}[2021/9/16 Wingnes TomBaugh <tangbo@stu.ecnu.edu.cn>]


\DeclareOption{colorprint}{\@mcm@bwprintfalse}
\DeclareOption{bwprint}{\@mcm@bwprinttrue}
\DeclareOption{withoutpreface}{\@mcm@prefacefalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%% Executing of Options
% \ExecuteOptions{colorprint}
\ProcessOptions\relax
%% Loading Class
\LoadClass[a4paper,12pt]{ctexart}
%% Loading Package
\RequirePackage{ifxetex}
\RequireXeTeX
\ifxetex\else
\ClassError{mcmthesis}{You must use the `xelatex' driver \MessageBreak Please choose `xelatex'}{%
Just choose `xelatex', no `pdflatex' or `latex' and so on.}
\fi

% \RequirePackage[backend=biber,style=gb7714-2015]{biblatex}
\RequirePackage{etoolbox}
\BeforeBeginEnvironment{tabular}{\begin{center}\zihao{-5}}
\AfterEndEnvironment{tabular}{\end{center}}
\RequirePackage{
    % 支持中文的 ctex 宏包
    % ctex,   
    zhnumber,
    % 页面布局
    geometry,
    titlesec,
    titletoc,
    % 数学宏包
    amsmath,
    amsfonts,
    amssymb,
    bm,
    amsthm,
    % 设置颜色
    xcolor,
    % 插入图片
    graphicx,
    float,
    % 表格
    array,
    booktabs,
    longtable,
    tabularx,
    multirow,
    bigstrut,
    diagbox,
    bigdelim,
    % 保护脆落命令
    cprotect,
    % 设置代码环境
    listings,
    % 插入链接
    url,
    % 伪代码
    algorithm,
    algpseudocode,
    algorithmicx,
    % 调整列举环境
    enumitem,
    % 避免浮动
    placeins,
    % 缩进
    indentfirst,
    % 使用系统字体
    xeCJK,
    % 自定义页眉页脚
    fancyhdr,
    % 下划线
    ulem,
    % 超链接
    hyperref,
    % cite,
    caption,
    tocloft,
    fontspec,
    xunicode,
    enumitem,
    xpatch,
    % subcaption
}
%避免浮动
% \RequirePackage[section]{placeins} 
% \RequirePackage[titles]{tocloft}

\defaultfontfeatures{Mapping=tex-text} %如果没有它，会有一些 tex 特殊字符无法正常使用，比如连字符。

% 利用宏包 geometry设置上、下、左、右的页边距以及标题和正文之间的间距
\geometry
  {
    paper     = a4paper,
    top       = 2.54 cm, 
    bottom    = 2.54 cm, 
    left      = 2.5  cm, 
    right     = 2.5  cm
  }
%\r% 将行间距调整为1.25倍行距
\renewcommand*{\baselinestretch}{1.25}

% ### 设置封面内容###
\newcommand*\@head@input{}
\newcommand*\@name@input{姓名}
\newcommand*\@studentID@input{学号}
\newcommand*\@major@input{专业}

\newcommand\name[1]{
    \renewcommand{\@name@input}{#1}}
\newcommand\studentID[1]{
    \renewcommand{\@studentID@input}{#1}}
\newcommand\major[1]{
    \renewcommand{\@major@input}{#1}}
\newcommand\head[1]{
      \renewcommand{\@head@input}{《遥感软件二次开发》上机实习 #1}}
% \captionsetup{font={\zihao{5}}}

\renewcommand{\maketitle}{\par
	\begingroup
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \endgroup
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
% 定义封面页
\def\@maketitle{
    \newpage
    \thispagestyle{empty}
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\zihao{2}\hei \@head@input \par}%
    \vskip 2cm
    {\zihao{4}
    \renewcommand\arraystretch{2.5}
      \begin{tabular}[b]{
        |p{0.1\textwidth}
        |p{0.3\textwidth}
        |p{0.1\textwidth}
        |p{0.3\textwidth}
        |}
        \hline
        \zihao{4}姓名 & \zihao{4}{\@name@input} & 
        \zihao{4}学号 & \zihao{4}{\@studentID@input} \\
        \hline
        \zihao{4}专业 & \zihao{4}{\@major@input} & 
        \zihao{4}日期 & \zihao{4}{\@date} \\
        \hline
      \end{tabular}\par}
    \vskip 1em
  \end{center}
  \par
  \vskip 1.5em
}
% 超链接设置颜色
\hypersetup{
colorlinks=true,
filecolor=black,      
urlcolor=black,
citecolor=black,
linkcolor=black
}
%设置页码
\pagestyle{fancy}
\lhead{}
\chead{}
\rhead{}
\cfoot{}
\lfoot{}
\rfoot{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
% 设置目录和章节题
% \setlength{\cftsecindent}{0pt}
% \setlength{\cftsubsecindent}{0pt}
% \setlength{\cftsubsubsecindent}{0pt}

% \titleformat{\section}[block]{\zihao{4}\bfseries\centering}{第\zhnum{section}节}{1em}{}
% \renewcommand*\contentsname{}
% \renewcommand*\thesection{第\zhnum{section}节}
% \renewcommand\thesubsection{\arabic{section}.\arabic{subsection}}

\titlecontents{section}[4.5em]{\zihao{4}\bfseries \vspace{10pt}}
{\contentslabel{4em}}{\hspace*{-4em}}
              {\titlerule*[0.5pc]{$\cdot$}\contentspage}%

\titlecontents{subsection}[4.5em]{\zihao{5}}
{\contentslabel{4em}}{\hspace*{-4em}}
                {\titlerule*[0.5pc]{$\cdot$}\contentspage}%
\titlecontents{subsubsection}[4.5em]{\zihao{5}}
{\contentslabel{4em}}{\hspace*{-4em}}
                {\titlerule*[0.5pc]{$\cdot$}\contentspage}%

\setlist[enumerate]{leftmargin=*}
% 每行缩进两个汉字
\setlength{\parindent}{2em}
% 设置字体
\let\songti\relax
\let\heiti\relax
\let\fangsong\relax
\let\kaishu\relax

% \newCJKfontfamily\sonti{思源宋体}[BoldFont=SourceHanSerifSC-Bold]
\setCJKmainfont{SourceHanSerifSC}[
  Extension      = .otf,
  UprightFont    = SourceHanSerifSC-Regular,
  BoldFont       = SourceHanSerifSC-Bold,
  ]

\setmainfont{Times New Roman}
\setCJKfamilyfont{hei}[AutoFakeBold]{SourceHanSans-Regular}
\newcommand*{\hei}{\CJKfamily{hei}}
% 浮动环境设置
% 默认情况下, \LaTeX{} 要求每页的文字至少占据 20%,否则该页就只单独放置一个浮动环境,
% 而这通常不是我们想要的, 我们将这个要求降低到 5%.
\renewcommand*{\textfraction}{0.05}
% 有时如果多个浮动环境连续放在一起, \LaTeX{}
% 会将它们分在几个不同页，即使它们可在同一页放
% 得下. 我们可以通过修改 |\topfraction| 和 |\bottomfraction| 分别设置顶端和底端的浮
% 动环境的最大比例.
 \renewcommand*{\topfraction}{0.9}
 \renewcommand*{\bottomfraction}{0.8}
% 有时\LaTeX{}会把一个浮动环境单独放在一页,
% 我们要求这个环境至少要占据 85% 才能单独放在一页.
% 注意:  |\floatpagefraction| 的数值必须小于 |\topfraction|.
 \renewcommand*{\floatpagefraction}{0.85}
% 关于图片 graphicx
 % 如果图片没有指定后缀, 依次按下列顺序搜索
\DeclareGraphicsExtensions{.pdf,.eps,.jpg,.png}
 % 设置图表搜索路径, 可以给图表文件夹取如下名字
\graphicspath{{figures/}{figure/}{pictures/}%
  {picture/}{pic/}{pics/}{image/}{images/}}
% 图表标题
\DeclareCaptionFont{song}{\songti}
\DeclareCaptionFont{five}{\zihao{5}}
\DeclareCaptionFont{smallfive}{\zihao{-5}}
\captionsetup[figure]{%
	format=hang,   % 标题从第二行开始都有缩进, 应该和 justification=raggedright 的效果一样.
	labelsep=quad, % 分隔符是一个空格
	font={song,five,bf}, % 图的字体, 宋体小四
	position=bottom % position=bottom, 不代表标题放在下面, 标题仍放在你放\caption的位置.
}
\captionsetup[table]{%
	format=hang,   % 标题从第二行开始都有缩进, 应该和 justification=raggedright 的效果一样.
	labelsep=quad, % 分隔符是一个空格
	font={song,five,bf}, % 表的字体, 宋体小四
	position=top % position=bottom, 不代表标题放在下面, 标题仍放在你放\caption的位置.
}
\definecolor{blue}{rgb}{0,0,1}
\definecolor{red}{rgb}{1,0,0}
\definecolor{green}{rgb}{0,1,0}
% 引用颜色库
\definecolor{bluekeywords}{rgb}{0,0,1}
\definecolor{greencomments}{rgb}{0,0.5,0}
\definecolor{redstrings}{rgb}{0.64,0.08,0.08}
\definecolor{xmlcomments}{rgb}{0.5,0.5,0.5}
\definecolor{types}{rgb}{0.17,0.57,0.68}

% url过长自动换行
\def\UrlBreaks{\do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J
\do\K\do\L\do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V
\do\W\do\X\do\Y\do\Z\do\[\do\\\do\]\do\^\do\_\do\`\do\a\do\b
\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l\do\m\do\n
\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z
\do\.\do\@\do\\\do\/\do\!\do\_\do\|\do\;\do\>\do\]\do\)\do\,
\do\?\do\'\do+\do\=\do\#}

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}
