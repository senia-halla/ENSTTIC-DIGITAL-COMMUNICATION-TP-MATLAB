function e_zf=ffe_zf(y,c,nom_canal)
% SYNTAXE: e_zf=ffe_zf(y,c,nom_canal)
%
% DESCRIPTION : Calcul de la r�ponse impulsionnelle
% d�un �galiseur par zero forcing. Le principe est de
% r�soudre le syst�me lin�aire pr�sent� dans le paragraphe
% << �galisation par zero forcing >>, pour forcer la
% convolution entre la RI de l��galiseur et la RI du
% canal a �tre une impulsion de Dirac d�cal�e en R.
% En termes matriciels, ce syst�me s��crit ici Q*e_zf=delta.
%
% ENTR?ES :
% - y : signal observ�
% - c : r�ponse impulsionnelle du canal
% - nom_canal : nom du canal
%
% SORTIE :
% - e_zf : r�ponse impulsionnelle de l��galiseur
%
% Auteurs : P. Jardin et J.-F Bercher
% Date : nov. 2000
% ===================================================================
% Initialisations :
N=length(c); % Longueur du canal
M=N;
Q=zeros(N+M-1,M); % Initialisation de Q
delta=zeros(N+M-1,1); % D�finition de Delta(n-R)
R=(N+M)/2;
delta(floor(R))=1;
% D�finition de la matrice Q d�crivant le syst�me lin�aire
for i=1:N+M-1
for j=max(1,i-N+1):min(M,i)
Q(i,j)=c(i-j+1);
end
end
% Inversion du syst�me
e_zf=pinv(Q)*delta;