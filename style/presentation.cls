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

% thème
\usetheme[width=2cm, hideothersubsections]{PaloAlto}

% Titre de diapo par défaut = titre de la section courante
\makeatletter
% Option de diapo [sanssoustitre] : pas de sous-titre automatique
\newif\ifjv@sanssoustitre
\BeforeBeginEnvironment{frame}{\global\jv@sanssoustitrefalse}
\define@key{beamerframe}{sanssoustitre}[true]{\global\jv@sanssoustitretrue}
\pretocmd\beamer@checkframetitle{%
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
}{}{}
\makeatother

% Plan en début de section
\AtBeginSection[]{
    \begin{frame}[sanssoustitre]{Plan}
        \tableofcontents[currentsection, hideothersubsections]
    \end{frame}
}


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

% Numéro de diapo : « 12 / 38 » discret en bas à droite
% (numéro courant en couleur de structure, total en gris ; masqué sur la page de titre)
\makeatletter
\setbeamertemplate{footline}{%
    \ifnum\c@framenumber>1
        \hfill
        \usebeamerfont{page number in head/foot}%
        {\usebeamercolor[fg]{structure}\bfseries\insertframenumber}%
        {\color{gray!70}\,/\,\inserttotalframenumber}%
        \hspace*{1.2em}%
    \fi
    \vspace*{1.2ex}%
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
