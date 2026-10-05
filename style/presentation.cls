\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{style/presentation}[2026/10/02 Classe perso pour ma soutenance de thèse]

% Charger la classe de base
\LoadClass[8pt, aspectratio=169, french]{beamer}

% Packages nécessaires pour la présentation
\RequirePackage[T1]{fontenc}
\RequirePackage{libertine}
\RequirePackage{etoolbox}

% thème
\usetheme{PaloAlto}

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