\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{style/presentation}[2026/10/02 Classe perso pour ma soutenance de thèse]

% Polices Computer Modern (maths) redimensionnables à toute taille
% (évite les « Font shape ... not available » avec \fontsize{4pt})
\RequirePackage{fix-cm}

% Charger la classe de base
\LoadClass[8pt, aspectratio=169, french]{beamer}

% Packages nécessaires pour la présentation
\RequirePackage[T1]{fontenc}
\RequirePackage{libertine}
% Sans-serif CM (opérateurs maths de beamer) à toute taille : fix-cm ne la couvre pas
\DeclareFontFamily{OT1}{cmss}{\hyphenchar\font45 }
\DeclareFontShape{OT1}{cmss}{m}{n}{<-9>cmss8<9-10>cmss9<10-12>cmss10<12-17>cmss12<17->cmss17}{}
\RequirePackage{etoolbox}
\RequirePackage{subcaption}
\RequirePackage{tikz}
\RequirePackage{import}
\RequirePackage{mathtools}
\RequirePackage{tabularx}
\RequirePackage{multirow} 
\RequirePackage{colortbl}
\RequirePackage{siunitx}
\RequirePackage{appendixnumberbeamer}

% ---------------------------------------------------------------------------
% Thème : épuré, sans barre latérale (l'ancien réglage PaloAlto est conservé
% dans style/presentation_paloalto.cls)
% ---------------------------------------------------------------------------
\usetheme{default}

% Palette
\definecolor{jvbleu}{HTML}{17325C}   % bleu nuit : titres, messages
\definecolor{jvteal}{HTML}{0F8B8D}   % sarcelle : accents, puces, progression
\definecolor{jvcorail}{HTML}{D1495B} % corail : mise en évidence (\alert)
\definecolor{jvtexte}{HTML}{23272F}  % texte courant
\definecolor{jvgris}{HTML}{6B7280}   % texte secondaire

\setbeamercolor{normal text}{fg=jvtexte, bg=white}
\setbeamercolor{structure}{fg=jvbleu}
\setbeamercolor{alerted text}{fg=jvcorail}
\setbeamercolor{frametitle}{fg=jvteal, bg=}
\setbeamercolor{framesubtitle}{fg=jvgris}
\setbeamercolor{item}{fg=jvteal}
\setbeamercolor{subitem}{fg=jvgris}
\setbeamercolor{caption}{fg=jvgris}
\setbeamercolor{caption name}{fg=jvgris}
\setbeamercolor{section in toc}{fg=jvbleu}
\setbeamercolor{subsection in toc}{fg=jvgris}
\setbeamercolor{section number projected}{fg=jvteal, bg=}
\setbeamercolor{block title}{fg=jvbleu, bg=jvteal!12}
\setbeamercolor{block body}{fg=jvtexte, bg=jvteal!4}
\setbeamercolor{block title alerted}{fg=jvcorail!80!black, bg=jvcorail!12}
\setbeamercolor{block body alerted}{fg=jvtexte, bg=jvcorail!4}
\setbeamercolor{block title example}{fg=jvbleu, bg=jvbleu!10}
\setbeamercolor{block body example}{fg=jvtexte, bg=jvbleu!4}

% Marges : même largeur utile que l'ancienne mise en page (130 mm)
\setbeamersize{text margin left=15mm, text margin right=15mm}

% En-tête : fil d'Ariane discret « SECTION › sous-section » + filet
\setbeamerfont{frametitle}{size=\scriptsize, series=\bfseries}
\setbeamerfont{framesubtitle}{size=\scriptsize, series=\mdseries}
\setbeamertemplate{frametitle}{%
    \vspace*{3.2mm}%
    \begin{beamercolorbox}[wd=\textwidth, left]{frametitle}%
        \usebeamerfont{frametitle}\MakeUppercase{\insertframetitle}%
        \ifx\insertframesubtitle\@empty\else
            {\usebeamercolor[fg]{framesubtitle}\usebeamerfont{framesubtitle}%
             \hspace{0.5em}\textperiodcentered\hspace{0.5em}\insertframesubtitle}%
        \fi
    \end{beamercolorbox}%
    \vspace{0.6mm}%
    {\color{black!12}\rule{\textwidth}{0.4pt}}%
    \vspace{0.8mm}%
}

% Puces et numéros : plats, couleur d'accent
\setbeamertemplate{itemize item}{\raisebox{0.18ex}{\scalebox{0.75}{$\bullet$}}}
\setbeamertemplate{itemize subitem}{\raisebox{0.1ex}{\textendash}}
\setbeamertemplate{itemize subsubitem}{\raisebox{0.1ex}{\textperiodcentered}}
\setbeamertemplate{enumerate item}{\usebeamercolor[fg]{item}\bfseries\insertenumlabel.}
\setbeamertemplate{enumerate subitem}{\usebeamercolor[fg]{item}\insertenumlabel.\insertsubenumlabel}

% Blocs : plats, sans ombre
\setbeamertemplate{blocks}[rounded][shadow=false]

% Légendes : sans « Figure: », petites et grises (gérées par le paquet caption,
% chargé par subcaption) ; les sous-figures gardent leur « (a) »
\DeclareCaptionFont{jvgris}{\color{jvgris}}
\captionsetup{font={scriptsize,jvgris}, labelfont={scriptsize,jvgris}, skip=3pt}
\captionsetup[figure]{labelformat=empty, labelsep=none}
\captionsetup[table]{labelformat=empty, labelsep=none}
\captionsetup[sub]{labelformat=parens, labelsep=space, font={scriptsize,jvgris}}

% Plan : numéros de section en couleur d'accent, sans boules 3D
\setbeamertemplate{section in toc}{%
    \leavevmode\hangindent=1.6em\hangafter=1
    \makebox[1.6em][l]{\usebeamercolor[fg]{section number projected}\bfseries\inserttocsectionnumber}%
    \inserttocsection\par}
\setbeamertemplate{subsection in toc}{%
    \leavevmode\hangindent=2.6em\hangafter=1\hspace{1.6em}%
    {\small\inserttocsubsection}\par}
\setbeamertemplate{section in toc shaded}[default][35]
\setbeamertemplate{subsection in toc shaded}[default][35]

% Titre de diapo par défaut = titre de la section courante
\makeatletter
% Option de diapo [sanssoustitre] : pas de sous-titre automatique
\newif\ifjv@sanssoustitre
\newif\ifjv@sanstitre
\BeforeBeginEnvironment{frame}{\global\jv@sanssoustitrefalse\global\jv@sanstitrefalse}
\define@key{beamerframe}{sanstitre}[true]{\global\jv@sanstitretrue}
\define@key{beamerframe}{sanssoustitre}[true]{\global\jv@sanssoustitretrue}
\pretocmd\beamer@checkframetitle{%
    \ifjv@sanstitre\else
    \frametitle{\insertsection}%
    \ifjv@sanssoustitre\else
    \ifx\insertsubsection\@empty\else
        \ifx\insertsubsubsection\@empty
            \framesubtitle{\insertsubsection}%
        \else
            \framesubtitle{\insertsubsection\ -- \insertsubsubsection}%
        \fi
    \fi
    \fi
    \fi
}{}{}
\makeatother

% Intercalaire en début de section : grand numéro, titre, sous-parties,
% et rappel du plan complet à droite
\makeatletter
\AtBeginSection[]{
    \begin{frame}[plain, noframenumbering, sanstitre]
        \begin{tikzpicture}[remember picture, overlay]
            \fill[jvbleu] (current page.south west) rectangle ([xshift=0.47\paperwidth]current page.north west);
            \node[anchor=south west, inner sep=0pt, text width=0.47\paperwidth-30mm, align=left]
                at ([xshift=15mm, yshift=0.5\paperheight-12mm]current page.south west) {%
                {\fontsize{40}{40}\selectfont\bfseries\color{jvteal!70!white}%
                 \ifbeamer@inappendix A\else\two@digits{\insertsectionnumber}\fi}\par\vspace{3mm}
                {\Large\bfseries\color{white}\insertsectionhead}%
            };
            \node[anchor=west, inner sep=0pt, text width=0.53\paperwidth-28mm, align=left]
                at ([xshift=0.47\paperwidth+14mm]current page.west) {%
                \tableofcontents[currentsection, subsectionstyle=show/show/hide]%
            };
        \end{tikzpicture}
    \end{frame}
}
\makeatother

% \appendix de beamer écrit \translate{...} dans les signets PDF
\pdfstringdefDisableCommands{\def\translate#1{#1}}

% désafficher la barre de navigation des slides
\setbeamertemplate{navigation symbols}{}

% Listes : puce collée à la marge gauche (retrait = largeur de la puce + \labelsep)
\AtBeginDocument{%
    \settowidth{\leftmargini}{\usebeamertemplate{itemize item}}%
    \addtolength{\leftmargini}{\labelsep}%
    \settowidth{\leftmarginii}{\usebeamertemplate{itemize subitem}}%
    \addtolength{\leftmarginii}{\labelsep}%
}

% Pied de page : auteur · titre court à gauche, « 12 / 38 » à droite,
% fine barre de progression en bas de page (masqués sur la page de titre)
\makeatletter
\setbeamertemplate{footline}{%
    \ifnum\c@framenumber>1
        \leavevmode
        \hbox to \paperwidth{%
            \hspace*{15mm}%
            {\usebeamerfont{page number in head/foot}\color{black!38}%
             \insertshortauthor\hspace{0.5em}\textperiodcentered\hspace{0.5em}\insertshorttitle}%
            \hfill
            {\usebeamerfont{page number in head/foot}%
             {\color{jvbleu}\bfseries\insertframenumber}%
             {\color{black!38}\,/\,\inserttotalframenumber}}%
            \hspace*{15mm}}%
        \par\vspace*{2mm}%
        \jv@progression
    \fi
}
\newcommand{\jv@progression}{%
    \begingroup
    \ifnum\inserttotalframenumber>0
        \dimen0=\paperwidth
        \divide\dimen0 by \inserttotalframenumber
        \multiply\dimen0 by \c@framenumber
        \ifdim\dimen0>\paperwidth \dimen0=\paperwidth \fi
    \else \dimen0=0pt \fi
    \hbox to \paperwidth{%
        {\color{jvteal}\rule{\dimen0}{0.7mm}}%
        {\color{black!7}\rule{\dimexpr\paperwidth-\dimen0\relax}{0.7mm}}}%
    \endgroup
}
\makeatother
\setbeamerfont{page number in head/foot}{size=\scriptsize}

% ---------------------------------------------------------------------------
% Outils de rédaction de la soutenance
% ---------------------------------------------------------------------------

% \assertion{...} : le message de la diapo, en une phrase affirmative.
% (Le titre/sous-titre étant déjà pris par section/sous-section,
%  le message est affiché en tête du corps de la diapo.)
\newcommand{\assertion}[1]{%
    {\usebeamercolor[fg]{structure}\large\bfseries #1\par}%
    \vspace{1.2ex}%
}

% \figafaire[hauteur]{description} : emplacement réservé d'une figure
% encore à produire (cadre gris visible dans le PDF pour les répétitions).
% À remplacer par \includegraphics une fois la figure prête.
\newcommand{\figafaire}[2][0.55\textheight]{%
    \begin{center}%
        \fcolorbox{gray}{gray!8}{%
            \begin{minipage}[c][#1][c]{0.9\linewidth}%
                \centering\color{gray}\small #2%
            \end{minipage}}%
    \end{center}%
}

% Réglages siunitx : virgule décimale + affichage du signe +
\sisetup{
  output-decimal-marker = {,},
  retain-explicit-plus  = true,
  per-mode = symbol
}

% --- Ajout du type de colonne centré comme X ---
\newcolumntype{Y}{>{\centering\arraybackslash}X}

% --- Définition d'une unité de mesure personnalisée ---
\DeclareSIUnit{\sample}{S}
\DeclareSIUnit{\tour}{tr}
\DeclareSIUnit{\dent}{dent}
\DeclareSIUnit{\octet}{o}
% ---------------------------------------------------------------------------
% Page de garde personnalisée
%   Dans presentation.tex (préambule) :
%     \photogarde{images/MOCN.png}            photo à droite (optionnel)
%     \surtitre{...}                          ligne au-dessus du titre
%     \jury{\membre{Nom}{Titre, établissement}{Rôle} ...}  (optionnel)
%     \logosgarde{\logogarde{fichier.png}{Nom} ...}
%   Puis : \begin{frame}[plain]\titlepage\end{frame}
%   (compiler deux fois : placement TikZ absolu)
% ---------------------------------------------------------------------------
\usetikzlibrary{fadings}
\tikzfading[name=jvfondu, left color=transparent!0, right color=transparent!100]
\makeatletter
\def\jv@photo{}\newcommand{\photogarde}[1]{\def\jv@photo{#1}}
\def\jv@surtitre{}\newcommand{\surtitre}[1]{\def\jv@surtitre{#1}}
\def\jv@jury{}\newcommand{\jury}[1]{\def\jv@jury{#1}}
\def\jv@logos{}\newcommand{\logosgarde}[1]{\def\jv@logos{#1}}

% \logogarde{fichier avec extension}{nom affiché tant que le fichier manque}
\newcommand{\logogarde}[2]{%
    \IfFileExists{#1}%
        {\includegraphics[height=6.5mm, keepaspectratio]{#1}}%
        {\fcolorbox{gray!45}{white}{\parbox[c][5.5mm][c]{15mm}{\centering\color{gray}\tiny #2}}}%
    \hspace{3mm}%
}

% \membre{Nom}{Titre, établissement}{Rôle}
\newcommand{\membre}[3]{%
    \parbox[t]{0.49\linewidth}{%
        {\color{black!85}\bfseries #1}\,{\color{structure.fg}\textperiodcentered\ #3}\\[-0.2ex]
        {\color{gray}\tiny #2}\vspace{0.6ex}}%
    \hfill\allowbreak\ignorespaces}

\defbeamertemplate*{title page}{jv}{%
    \usebeamercolor{structure}%
    \begin{tikzpicture}[remember picture, overlay]
        % --- fond blanc (masque l'en-tête du thème) ---
        \fill[white] (current page.south west) rectangle (current page.north east);
        % --- photo à droite, fondu vers la gauche ---
        \ifx\jv@photo\@empty\else
            \begin{scope}
                \clip ([xshift=-0.36\paperwidth]current page.south east) rectangle (current page.north east);
                \node at ([xshift=-0.18\paperwidth]current page.east)
                    {\includegraphics[height=\paperheight]{\jv@photo}};
            \end{scope}
            \fill[white, path fading=jvfondu]
                ([xshift=-0.361\paperwidth]current page.south east)
                rectangle ([xshift=-0.27\paperwidth]current page.north east);
        \fi
        % --- liseré vertical à gauche ---
        \fill[structure.fg] (current page.south west) rectangle ([xshift=2.2mm]current page.north west);
        % --- bloc titre ---
        \node[anchor=north west, inner sep=0pt, text width=0.55\paperwidth, align=left]
            (bloc) at ([xshift=11mm, yshift=-8mm]current page.north west) {%
            {\scriptsize\color{gray}\MakeUppercase{\jv@surtitre}}\par\vspace{3.5mm}
            {\fontsize{17}{20}\selectfont\bfseries\color{structure.fg}\inserttitle\par}\vspace{3mm}
            {\color{structure.fg}\rule{22mm}{0.8pt}}\par\vspace{2.5mm}
            {\large\insertauthor}\par\vspace{0.8mm}
            {\small\color{gray}\insertdate}%
        };
        % --- jury ---
        \ifx\jv@jury\@empty\else
            \node[anchor=north west, inner sep=0pt, text width=0.56\paperwidth, align=left, font=\scriptsize]
                at ([yshift=-4.5mm]bloc.south west) {%
                {\color{gray}\scriptsize\MakeUppercase{Jury}}\par\vspace{1.2mm}
                \jv@jury};
        \fi
        % --- bandeau de logos ---
        \node[anchor=south west, inner sep=0pt] at ([xshift=11mm, yshift=5mm]current page.south west)
            {\jv@logos};
    \end{tikzpicture}%
}
\makeatother
