

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{cs-techrep}[2025/01/16 TechReps in CS and SWE v0.6]


\newcounter{cstechrep@subfigtracker}
\newcounter{cstechrep@subcaptiontracker}
\newcounter{cstechrep@pbalancetracker}
\newcounter{cstechrep@flushendtracker}


\DeclareOption{subfig}{
  \setcounter{cstechrep@subfigtracker}{1}
  \typeout{cs-techrep class: subfig option is set (use subfloat command).}
}
\DeclareOption{subcaption}{
  \setcounter{cstechrep@subcaptiontracker}{1}
  \typeout{cs-techrep class: subcaption option is set (use subfigure command).}
}

\DeclareOption{onecolumn}{\OptionNotUsed}

\DeclareOption{pbalance}{
  \setcounter{cstechrep@pbalancetracker}{1}
  \typeout{cs-techrep class: pbalance option is set.}
}
\DeclareOption{flushend}{
  \setcounter{cstechrep@flushendtracker}{1}
  \typeout{cs-techrep class: flushend option is set.}
}

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{IEEEtran}
}

\ProcessOptions\relax

\LoadClass{IEEEtran}



\makeatletter
\newcommand*\DefcstechrepVar[1]{%
\@namedef{cstechrep#1}##1{\global\@namedef{cstechrep#1}{##1}}}
\makeatother

\DefcstechrepVar{AuthorListTex}
\DefcstechrepVar{AuthorListBib} % Use *and* as author separator!
\DefcstechrepVar{TitleTex}
\DefcstechrepVar{TitleBib}
\DefcstechrepVar{Department}  % e.g., Department of Computer Science
\DefcstechrepVar{Institution} % e.g., OTH Amberg-Weiden
\DefcstechrepVar{Address}     % e.g., Amberg, Germany
\DefcstechrepVar{Type}        % e.g., Technical Report
\DefcstechrepVar{Year}        % e.g., 2024
\DefcstechrepVar{Title}
\DefcstechrepVar{Month}       % e.g., 10 (for October)
\DefcstechrepVar{Number}      % e.g., CL-2024-42
\DefcstechrepVar{Lang}        % e.g., english = en-US (or: ngerman = DE)

\RequirePackage{upquote}

\RequirePackage[ngerman,main=english]{babel}
\addto\extrasenglish{\languageshorthands{ngerman}\useshorthands{"}}

\RequirePackage{lmodern}
\RequirePackage{times}

\RequirePackage[hyphens]{url}


\makeatletter
\g@addto@macro{\UrlBreaks}{\UrlOrds}
\makeatother


\RequirePackage[zerostyle=b,scaled=.75]{newtxtt}

\RequirePackage[utf8]{inputenc}

\RequirePackage[T1]{fontenc}

\RequirePackage[
  babel=true, % Enable language-specific kerning
  expansion=alltext,
  protrusion=alltext-nott, % Ensure no changes at the edge of the listing.
  nopatch=eqnum, % fix unable to apply patch eqnum
  final % Always enable microtype, even if in draft mode.
        % This helps finding bad boxes quickly. In the standard
        % configuration, this template is always in the final mode, so
        % this option only makes a difference if "pros" use the draft mode.
]{microtype}

\DisableLigatures{encoding = T1, family = tt* }

\RequirePackage{graphicx}

\RequirePackage{ccicons}

\RequirePackage{diagbox}

\RequirePackage[cmyk, table]{xcolor}

\RequirePackage{relsize} % allows for \textsmaller{..}

\RequirePackage[nolist,smaller]{acronym}

\RequirePackage{listings}

\definecolor{eclipseStrings}{RGB}{42,0.0,255}
\definecolor{eclipseKeywords}{RGB}{127,0,85}
\colorlet{numb}{magenta!60!black}


\lstdefinelanguage{json}{
  basicstyle=\normalfont\ttfamily,
  commentstyle=\color{eclipseStrings}, % style of comment
  stringstyle=\color{eclipseKeywords}, % style of strings
  numbers=left,
  numberstyle=\scriptsize,
  stepnumber=1,
  numbersep=8pt,
  showstringspaces=false,
  breaklines=true,
  frame=lines,
  % backgroundcolor=\color{gray}, %only if you like
  string=[s]{"}{"},
  comment=[l]{:\ "},
  morecomment=[l]{:"},
  literate=
      *{0}{{{\color{numb}0}}}{1}
       {1}{{{\color{numb}1}}}{1}
       {2}{{{\color{numb}2}}}{1}
       {3}{{{\color{numb}3}}}{1}
       {4}{{{\color{numb}4}}}{1}
       {5}{{{\color{numb}5}}}{1}
       {6}{{{\color{numb}6}}}{1}
       {7}{{{\color{numb}7}}}{1}
       {8}{{{\color{numb}8}}}{1}
       {9}{{{\color{numb}9}}}{1}
}

\lstset{
  % everything between (* *) is a latex command
  escapeinside={(*}{*)},
  %
  language=json,
  %
  showstringspaces=false,
  %
  extendedchars=true,
  %
  basicstyle=\footnotesize\ttfamily,
  %
  commentstyle=\slshape,
  %
  % default: \rmfamily
  stringstyle=\ttfamily,
  %
  breaklines=true,
  %
  breakatwhitespace=true,
  %
  % alternative: fixed
  columns=flexible,
  %
  numbers=left,
  %
  numberstyle=\tiny,
  %
  basewidth=.5em,
  %
  xleftmargin=.5cm,
  %
  % aboveskip=0mm,
  %
  % belowskip=0mm,
  %
  captionpos=b
}

\lstset{literate=
  {^^c3^^a1}{{\'a}}1 {^^c3^^a9}{{\'e}}1 {^^c3^^ad}{{\'i}}1 {^^c3^^b3}{{\'o}}1 {^^c3^^ba}{{\'u}}1
  {^^c3^^81}{{\'A}}1 {^^c3^^89}{{\'E}}1 {^^c3^^8d}{{\'I}}1 {^^c3^^93}{{\'O}}1 {^^c3^^9a}{{\'U}}1
  {^^c3^^a0}{{\`a}}1 {^^c3^^a8}{{\`e}}1 {^^c3^^ac}{{\`i}}1 {^^c3^^b2}{{\`o}}1 {^^c3^^b9}{{\`u}}1
  {^^c3^^80}{{\`A}}1 {^^c3^^88}{{\'E}}1 {^^c3^^8c}{{\`I}}1 {^^c3^^92}{{\`O}}1 {^^c3^^99}{{\`U}}1
  {^^c3^^a4}{^^c3^^a4}1 {^^c3^^ab}{{\"e}}1 {^^c3^^af}{{\"i}}1 {^^c3^^b6}{^^c3^^b6}1 {^^c3^^bc}{{\"u}}1
  {^^c3^^84}{^^c3^^a4}1 {^^c3^^8b}{{\"E}}1 {^^c3^^8f}{{\"I}}1 {^^c3^^96}{^^c3^^b6}1 {^^c3^^9c}{{\"U}}1
  {^^c3^^a2}{{\^a}}1 {^^c3^^aa}{{\^e}}1 {^^c3^^ae}{{\^i}}1 {^^c3^^b4}{{\^o}}1 {^^c3^^bb}{{\^u}}1
  {^^c3^^82}{{\^A}}1 {^^c3^^8a}{{\^E}}1 {^^c3^^8e}{{\^I}}1 {^^c3^^94}{{\^O}}1 {^^c3^^9b}{{\^U}}1
  {^^c3^^83}{{\~A}}1 {^^c3^^a3}{{\~a}}1 {^^c3^^95}{{\~O}}1 {^^c3^^b5}{{\~o}}1
  {^^c5^^93}{{\oe}}1 {^^c5^^92}{{\OE}}1 {^^c3^^a6}{{\ae}}1 {^^c3^^86}{{\AE}}1 {^^c3^^9f}{{\ss}}1
  {^^c5^^b1}{{\H{u}}}1 {^^c5^^b0}{{\H{U}}}1 {^^c5^^91}{{\H{o}}}1 {^^c5^^90}{{\H{O}}}1
  {^^c3^^a7}{{\c c}}1 {^^c3^^87}{{\c C}}1 {^^c3^^b8}{{\o}}1 {^^c3^^a5}{{\r a}}1 {^^c3^^85}{{\r A}}1
}

\RequirePackage{booktabs}

\RequirePackage[alwaysadjust]{paralist}


\RequirePackage[
    defernumbers=true,  % required due to self-cite
    %style=ieee,        % english only
    sorting=none,       % nty, nyt, nyvt, anyt, anyvt, ynt, ydnt, none, debug
    sortcites=false,
    citestyle=numeric-comp,
    bibstyle=numeric,
    backend=biber,
    bibencoding=utf8,   % = auto, utf8, ascii
    hyperref=true,      % activate hyperref support
    backref=false,      % activate backrefs
    isbn=true,
    url=true,
    doi=true,
    urldate=terse,      % = iso, year, short, long, terse
    maxnames=5,         % max number of names in text ??
    minnames=1,         % min number of names in text ??
    maxbibnames=99,     % max number of names in bibliography
    minbibnames=1,      % number of names in bibliography (bevor et al)
    maxcitenames=99,    % max number of names in text ??
    mincitenames=1,     % max number of names in text ??
    giveninits=false,   % abbreviate first names
    uniquename=init,    % otherwise option conflict with firstinits=true
    autolang=other
]{biblatex}

\makeatletter
\let\blx@rerun@biber\relax
\makeatother

\addbibresource{selfref.bib}
\DeclareBibliographyCategory{selfref}
\addtocategory{selfref}{selfref}

\renewcommand{\bibfont}{\normalfont\small}

\RequirePackage{etoolbox}
\makeatletter
\patchcmd{\NAT@test}{\else \NAT@nm}{\else \NAT@hyper@{\NAT@nm}}{}{}
\makeatother

\makeatletter
\DeclareCiteCommand{\citemonth}
  {\usebibmacro{prenote}}
  {%
    \let\oldabx@bibmonth\abx@bibmonth%
    \setkeys{blx@opt@pre}{dateabbrev=false}% nowork
    \mkbibmonth{\thefield{month}}%
    \let\abx@bibmonth\oldabx@bibmonth% restore
  }
  {\multicitedelim}
  {\usebibmacro{postnote}}
\makeatother

%% Enable nice TODO comments
\RequirePackage[colorinlistoftodos,prependcaption,textsize=tiny]{todonotes}
\newcommand{\TODO}[1]{\todo[%
linecolor=red,backgroundcolor=red!25,bordercolor=red]{#1}}

\RequirePackage{stfloats}
\fnbelowfloat

\RequirePackage[group-minimum-digits=4,per-mode=fraction]{siunitx}
\addto\extrasgerman{\sisetup{locale = DE}}

\RequirePackage{hyperref}

\hypersetup{
  hidelinks,
  colorlinks=true,
  allcolors=black,
  pdfstartview=Fit,
  breaklinks=true
}

\RequirePackage[all]{hypcap}

\RequirePackage{orcidlink}

\RequirePackage[autostyle=true]{csquotes}

\defineshorthand{"`}{\openautoquote}
\defineshorthand{"'}{\closeautoquote}

\usepackage{amsmath,amssymb,amsfonts}

\RequirePackage[capitalise,nameinlink,noabbrev]{cleveref}

\crefname{listing}{Listing}{Listings}
\Crefname{listing}{Listing}{Listings}
\crefname{lstlisting}{Listing}{Listings}
\Crefname{lstlisting}{Listing}{Listings}

\RequirePackage{lipsum}

\RequirePackage{tcolorbox}
\tcbuselibrary{listings}

\DeclareFontFamily{U}{MnSymbolC}{}
\DeclareSymbolFont{MnSyC}{U}{MnSymbolC}{m}{n}
\DeclareFontShape{U}{MnSymbolC}{m}{n}{
  <-6>    MnSymbolC5
  <6-7>   MnSymbolC6
  <7-8>   MnSymbolC7
  <8-9>   MnSymbolC8
  <9-10>  MnSymbolC9
  <10-12> MnSymbolC10
  <12->   MnSymbolC12%
}{}
\DeclareMathSymbol{\powerset}{\mathord}{MnSyC}{180}

\RequirePackage{xspace}
\newcommand{\eg}{e.\,g.,\ }
\newcommand{\ie}{i.\,e.,\ }

\makeatletter
\newcommand{\hydash}{\penalty\@M-\hskip\z@skip}
\makeatother

\input glyphtounicode
\pdfgentounicode=1

\RequirePackage{lscape}
\RequirePackage{pdflscape}
\RequirePackage{afterpage}

\RequirePackage[hyperxmp=false,lang=English]{doclicense}

\makeatletter
\def\ps@IEEEtitlepagestyle{
  \def\@oddfoot{\mycopyrightnotice}
  \def\@evenfoot{}
}
\def\mycopyrightnotice{
  {\footnotesize
    \begin{minipage}{0.8\textwidth}
  \centering
    % License based on doclicense package:
    \href{\doclicenseURL}{\doclicenseIcon{}
    This work is licensed under a \doclicenseLongNameRef{}
    (\doclicenseNameRef{}) license.}
    % Citation advice:
    \\Please cite as: \fullcite{selfref}.
  \end{minipage}
  }
}
\makeatother

\makeatletter
\def\filecontentsForceExpansion#1#2#3{
  \global\let\ltxspecials\dospecials
  \gdef\dospecials{\ltxspecials
    \catcode`#1=0
    \catcode`#2=1
    \catcode`#3=2
    \global\let\dospecials\ltxspecials
  }
}
\makeatother

\title{\cstechrepTitleTex}

\author{
\IEEEauthorblockN{\cstechrepAuthorListTex}
\IEEEauthorblockA{%
\cstechrepDepartment\\
\cstechrepInstitution\\
\cstechrepAddress
}}

\IEEEspecialpapernotice{\cstechrepType: \cstechrepNumber,
\citemonth{selfref} \cstechrepYear}

\ifnum\value{cstechrep@subfigtracker}=1
  \typeout{cs-techrep class: load subfig package (use subfloat command).}
  \RequirePackage[caption=false,font=footnotesize]{subfig}
\fi
\ifnum\value{cstechrep@subcaptiontracker}=1
  \typeout{cs-techrep class: load subcaption package (use subfigure command).}
  \RequirePackage{subcaption}
  \captionsetup[subfigure]{labelformat=parens,font=footnotesize}
\fi

\ifnum\value{cstechrep@pbalancetracker}=1
  \typeout{cs-techrep class: load pbalance package.}
  \RequirePackage{pbalance}
\fi
\ifnum\value{cstechrep@flushendtracker}=1
  \typeout{cs-techrep class: load flushend package.}
  \RequirePackage{flushend}
\fi


\RequirePackage[shortcuts]{extdash}

\endinput
%%
%% End of file `cs-techrep.cls'.
