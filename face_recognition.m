clear;
close all;
load donnees;
load exercice_1;
figure('Name','Image tiree aleatoirement','Position',[0.2*L,0.2*H,0.6*L,0.5*H]);

% Seuil de reconnaissance:
s = 30;

% Pourcentage d'information: 
per = 0.95;

% Tirage aleatoire d'une image de test:
%individu = randi(37);
posture = randi(6);
individu = numeros_individus(randi(length(numeros_individus)));
chemin = './Images_Projet_2020';
fichier = [chemin '/' num2str(individu+3) '-' num2str(posture) '.jpg'];
Im=importdata(fichier);
I=rgb2gray(Im);
I=im2double(I);
image_test=I(:)';
 

% Affichage de l'image de test:
colormap gray;
imagesc(I);
axis image;
axis off;

% Nombre de composantes principales:
N = 15;

% N premieres composantes principales des images d'apprentissage:
C_apprentissage = X_c*W(:,1:N);

% N premieres composantes principales de l'image de test:
C_test = (image_test - individu_moyen)*W(:, 1:N);

% Determination de l'image d'apprentissage la plus proche:

    % Distances entre l'image de test et les images d'apprentissage:
    distances = sqrt(sum((C_apprentissage - C_test).^2,2));

    % K voisins les plus proches:
    K = 3;
    [~,ind] = sort(distances);
    voisins = ind(1:K);

    % Label d'apprentissage:
    labelA = kron(numeros_individus,ones(1,length(numeros_postures)));

    % Nombre des voisins appartenant à chaque classe:
    classes_voisins = labelA(voisins);

    % Regrouper pour chaque classe le nombre des voisins appartenant à
    % cette même classe (La matrice A contient le nombres de voisins
    % qui correspondent à chaque classe).
    A =hist(classes_voisins,numeros_individus);

    % Trier le vecteur v dans un ordre decroissant:
    [~,Ind] = sort(A,'descend');
    classe_test = numeros_individus(Ind(1));

    % Distance minimal:
    distance_minimale = distances(voisins(1));

% Affichage du resultat :
if distance_minimale < s
	individu_reconnu = classe_test;
	title({['Posture numero ' num2str(posture) ' de l''individu numero ' num2str(individu+3)];...
		['Je reconnais l''individu numero ' num2str(individu_reconnu+3)]},'FontSize',20);

    % Réalisation de l'affichage de la Requête et des K choix trouvées:
    figure();
    
    % Requête:
    colormap gray;
    subplot(1,K+1,1);
    imagesc(I);
    axis image;
    axis off;
    title("Requête :",'Fontsize',8);
    
    % K choix trouvées:
    for i = 1:K 
        subplot(1,K+1,i+1);
        individu_choix = classes_voisins(i);
        posture_choix  = numeros_postures(mod(voisins(i)-1,nb_postures)+1);
        fichier_choix = [chemin '/' num2str(individu_choix+3) '-' num2str(posture_choix) '.jpg'];
        Im_choix = importdata(fichier_choix);
        I_choix = rgb2gray(Im_choix);
        I_choix = im2double(I_choix);
        imagesc(I_choix);
        axis image;
        axis off;
        title(sprintf('Trouvée- choix %s',num2str(i,'%1d')),'Fontsize',8);
    end
    
else
	title({['Posture numero ' num2str(posture) ' de l''individu numero ' num2str(individu+3)];...
		'Je ne reconnais pas cet individu !'},'FontSize',20);
end

% Matrice de confusion.

Nbre_ind = 37;
Nbre_pos = 6;
Matrice_confusion = zeros(Nbre_ind,Nbre_ind);
K = 3;

for i = 1:Nbre_ind
    for j = 1:Nbre_pos
        individu = i;
        posture = j;
        chemin = './Images_Projet_2020';
        fichier = [chemin '/' num2str(individu+3) '-' num2str(posture) '.jpg'];
        Im=importdata(fichier);
        I=rgb2gray(Im);
        I=im2double(I);
        image_test=I(:)';

        C_apprentissage = X_c*W(:, 1:N);
        C_test = (image_test-individu_moyen)*W(:,1:N);
        distances = sqrt(sum((C_apprentissage - C_test).^2,2));
        [~,ind] = sort(distances);
        voisins = ind(1:K);
        labelA = kron(numeros_individus,ones(1,length(numeros_postures)));
        classes_voisins = labelA(voisins);
        A =hist(classes_voisins,numeros_individus);
        [~,Ind] = sort(A,'descend');
        classe_test = numeros_individus(Ind(1));
        distance_minimale = distances(voisins(1));
        if distance_minimale < s
            Matrice_confusion(i,classe_test) = Matrice_confusion(i,classe_test) + 1;
        end
    end
end

% Taux d'erreur:

m = Matrice_confusion + eye(Nbre_ind);
taux_erreur = (length(find(m)) - Nbre_ind)/(Nbre_ind * Nbre_pos);
fprintf("Taux d'erreur obtenue pour N = %s est : %s \n",num2str(N,'%2d'),num2str(taux_erreur))
