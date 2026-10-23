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
