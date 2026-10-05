\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{style/presentation}[2026/10/02 Classe perso pour ma soutenance de thèse]

% Charger la classe de base
\LoadClass[11pt, aspectratio=169, french]{beamer}

% Packages nécessaires pour la présentation
\RequirePackage[T1]{fontenc}
\RequirePackage{libertine}
\RequirePackage{etoolbox}

% thème
\usetheme{PaloAlto}

% Titre de diapo par défaut = titre de la section courante
\makeatletter
\pretocmd\beamer@checkframetitle{%
  \frametitle{\insertsection}%
  \ifx\insertsubsection\@empty\else
    \ifx\insertsubsubsection\@empty
      \framesubtitle{\insertsubsection}%
    \else
      \framesubtitle{\insertsubsection\ -- \insertsubsubsection}%
    \fi
  \fi
}{}{}
\makeatother