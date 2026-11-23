#!/usr/bin/env python3
"""Aligne les graduations d'un export Inkscape PDF+LaTeX (.pdf_tex) issu de MATLAB.

Inkscape place chaque texte par son coin gauche, calculé avec la police de MATLAB.
Avec la police du document LaTeX (plus large), les graduations de l'axe des
ordonnées débordent à droite sur le graphe. Ce script :
  - aligne à droite les graduations de l'axe des ordonnées (bord droit fixe),
  - centre les graduations de l'axe des abscisses,
en recalculant ces positions à partir de la largeur du texte dans la police
d'origine (métriques Helvetica). Le résultat ne dépend plus de la police LaTeX.

Option : un 4e argument k (rapport largeur police LaTeX / police MATLAB, ex. 1.3) décale
les noms des axes des ordonnées vers la gauche, juste assez pour dégager les graduations.

Usage : python3 aligner_graduations.py figure.pdf_tex figure.svg sortie.pdf_tex [d]
"""
import re
import sys
import xml.etree.ElementTree as ET

LARGEURS = {c: 0.556 for c in '0123456789'}  # Helvetica, en em
LARGEURS.update({',': 0.278, '.': 0.278, '-': 0.584, '\u2212': 0.584})
NUM = re.compile(r'^\$?(\$-\$|-)?\$?[\d]+([,.][\d]+)?\$?$')


def largeur_em(texte):
    t = texte.replace('$-$', '-').replace('$', '')
    return sum(LARGEURS.get(c, 0.556) for c in t)


def tailles_svg(chemin):
    """Taille de police (unités SVG) de chaque texte, dans l'ordre du document."""
    ns = '{http://www.w3.org/2000/svg}'
    racine = ET.parse(chemin).getroot()
    vb = racine.get('viewBox')
    largeur = float(vb.split()[2]) if vb else float(re.sub('[a-z]', '', racine.get('width')))
    tailles = []
    for e in racine.iter(ns + 'text'):
        taille = None
        for sous in [e] + list(e):
            m = re.search(r'font-size:([\d.]+)px', sous.get('style', ''))
            if m:
                taille = float(m.group(1))
        tailles.append(taille or 10.0)
    return tailles, largeur


def main(pdftex, svg, sortie, decalage='0'):
    decalage = float(decalage)
    tailles, largeur_svg = tailles_svg(svg)
    lignes = open(pdftex, encoding='utf-8').read().split('\n')
    motif = re.compile(r'\\put\(([\d.]+),([\d.]+)\)(\{.*\\makebox\(0,0\)\[)lt(\]\{.*?\{l\}(.*?)\\end\{tabular\}.*)$')
    textes = []  # (indice de ligne, x, y, texte, rang du texte)
    rang = -1
    for i, l in enumerate(lignes):
        if '\\begin{tabular}' not in l:
            continue
        rang += 1
        m = motif.search(l)
        if m and 'rotatebox' not in l and NUM.match(m.group(5).strip()):
            textes.append((i, float(m.group(1)), float(m.group(2)), m.group(5).strip(), rang))
    # graduations de l'axe des abscisses : au moins 3 nombres sur la même hauteur
    hauteurs = {}
    for t in textes:
        hauteurs.setdefault(round(t[2], 4), []).append(t)
    # (dans chaque rangée, on coupe là où l'écart dépasse 0,08 : graduations de graphes voisins)
    abscisses = set()
    for groupe in hauteurs.values():
        groupe = sorted(groupe, key=lambda t: t[1])
        paquet = [groupe[0]]
        for t in groupe[1:] + [None]:
            if t is not None and t[1] - paquet[-1][1] < 0.08:
                paquet.append(t)
                continue
            if len(paquet) >= 3:
                abscisses.update(u[0] for u in paquet)
            if t is not None:
                paquet = [t]
    for i, x, y, texte, r in textes:
        taille = tailles[r] if r < len(tailles) else 7.8
        w = largeur_em(texte) * taille / largeur_svg
        if i in abscisses:
            ancre, nx = 't', x + w / 2
        else:
            ancre, nx = 'rt', x + w
        lignes[i] = re.sub(r'\\put\([\d.]+,', '\\\\put(%.8f,' % nx, lignes[i], count=1)
        lignes[i] = lignes[i].replace('\\makebox(0,0)[lt]', '\\makebox(0,0)[%s]' % ancre, 1)
        lignes[i] = lignes[i].replace('\\begin{tabular}[t]{l}', '\\begin{tabular}[t]{%s}' % ('c' if ancre == 't' else 'r'), 1)
    if decalage:
        # décalage sélectif : chaque nom d'axe vertical est décalé vers la gauche juste
        # assez pour dégager ses graduations, dont la largeur dans la police LaTeX est
        # estimée à decalage x largeur Helvetica (decalage = rapport des largeurs, ex. 1.3)
        graduations = []
        for i, x, y, texte, r in textes:
            if i in abscisses:
                continue
            taille = tailles[r] if r < len(tailles) else 7.8
            w = largeur_em(texte) * taille / largeur_svg
            graduations.append((x + w, y, w))  # bord droit, hauteur, largeur Helvetica
        for i, l in enumerate(lignes):
            if 'rotatebox{90}' not in l or '\\begin{tabular}' not in l:
                continue
            m = re.search(r'\\put\(([\d.]+),([\d.]+)\)', l)
            lx, ly = float(m.group(1)), float(m.group(2))
            voisines = [g for g in graduations if lx < g[0] < lx + 0.07 and ly - 0.02 < g[1] < ly + 0.2]
            if not voisines:
                continue
            gauche = min(g[0] - decalage * g[2] for g in voisines)
            nx = min(lx, gauche - 0.002)
            if nx < lx:
                lignes[i] = l.replace(m.group(0), '\\put(%.8f,%s)' % (nx, m.group(2)), 1)
    open(sortie, 'w', encoding='utf-8').write('\n'.join(lignes))
    print(f'{sortie} : {len(textes) - len(abscisses)} graduations alignées à droite, {len(abscisses)} centrées')


if __name__ == '__main__':
    main(*sys.argv[1:5])
