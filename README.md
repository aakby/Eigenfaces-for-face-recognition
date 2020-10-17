# Eigenfaces-for-face-recognition

Ce projet s’inspire d’un article intitulé Eigenfaces for recognition, écrit par Turk et Pentland et publié
dans le Journal of Cognitive Neuroscience en 1991.

# Description des données

On dispose de n images de visages d’un ensemble d’individus. Chaque individu est photographié sous
le même nombre de postures faciales (gauche, face, trois quart face, etc.). Chacune de ces n images
en niveaux de gris est stockée dans une matrice bidimensionnelle. Ces n images
constituent les images d’apprentissage. (Voir donnees.m)

# Projection des images sur les eigenfaces

On calcule les axes principaux et les composantes principales des images d’apprentissage à partir des vecteurs
propres associés aux n − 1 valeurs propres non nulles de la matrice de variance/covariance Σ des données.
Ces axes principaux sont appelés eigenfaces par Turk et Pentland, par contraction des mots anglais
eigenvectors et faces.

# La reconnaissance de visages

Le script clusters.m calcule les composantes principales des n images d’apprentissage, puis affiche sous
la forme d’un nuage de n points de R² leurs deux premières composantes principales. Chaque couleur
correspond à un même individu de la base d’apprentissage. Ce nuage fait apparaître des groupes de
points (ou clusters) de couleur uniforme, ce qui montre que chaque cluster correspond aux différentes
postures d’un même individu. Il semble donc possible d’utiliser les eigenfaces pour la reconnaissance
de visages, en calculant les deux premières composantes principales d’une image, dite image de test,
n’appartenant pas forcément à la base d’apprentissage, et en cherchant de quelle image d’apprentissage
cette image est la plus proche, donc à quel individu elle correspond.
Le script exercice_3.m tire aléatoirement une image de test parmi les 37 personnes et les six postures
faciales disponibles dans la base de données.
