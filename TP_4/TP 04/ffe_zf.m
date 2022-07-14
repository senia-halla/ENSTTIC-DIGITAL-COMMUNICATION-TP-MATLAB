function e_zf=ffe_zf(y,c,nom_canal)
% SYNTAXE: e_zf=ffe_zf(y,c,nom_canal)
%
% DESCRIPTION : Calcul de la réponse impulsionnelle
% d’un égaliseur par zero forcing. Le principe est de
% résoudre le système linéaire présenté dans le paragraphe
% << égalisation par zero forcing >>, pour forcer la
% convolution entre la RI de l’égaliseur et la RI du
% canal a être une impulsion de Dirac décalée en R.
% En termes matriciels, ce système s’écrit ici Q*e_zf=delta.
%
% ENTR?ES :
% - y : signal observé
% - c : réponse impulsionnelle du canal
% - nom_canal : nom du canal
%
% SORTIE :
% - e_zf : réponse impulsionnelle de l’égaliseur
%
% Auteurs : P. Jardin et J.-F Bercher
% Date : nov. 2000
% ===================================================================
% Initialisations :
N=length(c); % Longueur du canal
M=N;
Q=zeros(N+M-1,M); % Initialisation de Q
delta=zeros(N+M-1,1); % Définition de Delta(n-R)
R=(N+M)/2;
delta(floor(R))=1;
% Définition de la matrice Q décrivant le système linéaire
for i=1:N+M-1
for j=max(1,i-N+1):min(M,i)
Q(i,j)=c(i-j+1);
end
end
% Inversion du système
e_zf=pinv(Q)*delta;