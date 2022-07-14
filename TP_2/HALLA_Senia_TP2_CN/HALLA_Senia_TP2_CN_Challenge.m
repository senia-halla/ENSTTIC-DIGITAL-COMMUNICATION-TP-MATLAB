%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Challenge 1
clear all ;
close all
clc

[y,Fs] = audioread('spidermonkey.wav') ; % Lire l'audio

n=8 ; % Définir la résolution
x = quantify(y,n) ; % Quantifier le signal audio
fe = 8000 ; Ts=125 ; 

%1.
    %Signal NRZ à 4 états 
x=x(:) ; % mettre toutes les bits du signal dans une seule cologne
x = reshape(x,2,[]) ; % Remoduler le vecteur sous la forme (2,..)
x=x' ; % Transposer le vecteur pour qu'il devient sous la forme (..,2) (une combinaison de 2 bits)
y=bi2de(x(:,:)); % On assigne a chaque bit sa valeur décimale
y = (2*y)-3 ; % assigner au bit 00 la valeur -3, au bit 01 la valeur -1, au bit 10 la valeur 1 et au bit 11 la valeur 3

pulse= ones(50,1) ; % la forme de g(t) : rect de T=50/8000=6.3ms
signal =pulse*(y'); % multiplier le nouveau signal par cette forme g(t) pour construire le signal base bande
Bas_bnd_sig = signal (:); % Assigner toute les valeures de signal dans un seul vecteur.
figure()
plot(Bas_bnd_sig) ; 
title('Signal NRZ polaire à 4 états')  ;

    %DSP
DSP(Bas_bnd_sig,fe,"NRZ polaire à 4 états") ; % Afficher la DSP du signal base bande 

    % Diagramme de l'oeil
eye_diagram(Bas_bnd_sig,"NRZ polaire à 4 états") ; % Afficher le diagramme de l'oeil du signal


%2. 
    % Ajouter le bruit au signal : passer par un canal AWGN
Noisy_bas_bnd_sig= Bas_bnd_sig + 0.2*randn(size(Bas_bnd_sig)); % Ajouter des valeurs aléatoires au signal ( bruit )
figure()
plot(Noisy_bas_bnd_sig) ; 
title('Signal NRZ polaire bruité à 4 états')  

    %DSP
DSP(Noisy_bas_bnd_sig,fe,"NRZ polaire bruité à 4 états") ; % Afficher la DSP du signal bruité

    % Diagramme de l'oeil
eye_diagram(Noisy_bas_bnd_sig,"NRZ polaire bruité à 4 états") ; % Afficher le diagramme de l'oeuil du signal bruité 

%3. 
    % Restituer le signal 
echantillons = 25:50:length(Noisy_bas_bnd_sig) ; % définir les échantillons utilisé pour la restauration du signal
new_x = Noisy_bas_bnd_sig(echantillons,1) ; % Voir la valeur assigné à chaque échantillon

for i=1:length(new_x)
    if new_x(i)<-2 
        new_x(i) = 0 ; % si la valeur est inférieur à -2 on l'assigne la valeur décimale du bit 00
    elseif new_x(i) <0
        new_x(i) = 1 ; % si la valeur est entre -2 et 0 on l'assigne la valeur décimale du bit 01
    elseif new_x(i)<2
        new_x(i) = 2 ; % si la valeur est entre 0 et 2 on l'assigne la valeur décimale du bit 10
    else 
        new_x(i) = 3 ; % si la valeur est supérieur à 2 on l'assigne la valeur décimale du bit 11
    end
end
new_x = de2bi(new_x) ;  % On convertis les valeurs décimale en binaires
new_x = bi2de(new_x(:)) ; % On reconsruit notre signal numérique
figure()
plot(new_x) ; 
title('Signal Restitué')  ;
sum(abs(x(:)-new_x))/length(new_x) % calculer et afficher le taux d'erreur entre le signal d'origine x et le signal restauré


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Challenge 2
clear all; 
close all;
clc;

[y,Fs] = audioread('spidermonkey.wav') ; % Lire l'audio
n=8 ; % Définir la résolution
x = quantify(y,n) ; % Quantifier le signal audio
fe = 8000 ; Ts=125 ; 

%1.
    %Signal NRZ Polaire 
x=x(:) ; % mettre toutes les bits du signal dans une seule cologne
y=bi2de(x(:,1)); 
y = 2.5*((2*y)-1) ; % assigner au bit 1 la valeur 1 et au bit 0 la valeur -1

pulse= [-1*ones(25,1);zeros(25,1)]+[zeros(25,1);ones(25,1)] ; % la forme de g(t) pour une période T=50/8000=6.3ms
sig =pulse*(y'); % multiplier le nouveau signal par cette forme g(t) pour construire le signal base bande
Bas_bnd_sig = sig (:); % Assigner toute les valeures de signal dans un seul vecteur.
figure()
plot(Bas_bnd_sig(30560*50:30580*50,1)) ; 
title('Signal Manchester')  ;

    %DSP
DSP(Bas_bnd_sig,fe,"Manchester") ; % Afficher la DSP du signal base bande 

    % Diagramme de l'oeil
eye_diagram(Bas_bnd_sig,"Manchester") ; % Afficher le diagramme de l'oeil du signal

%2.
    %Ajouter Bruit
Noisy_bas_bnd_sig= Bas_bnd_sig + 0.2*randn(size(Bas_bnd_sig)); % Ajouter des valeurs aléatoires au signal ( bruit )
plot(Noisy_bas_bnd_sig) ; 
title('SignaL Manchester bruité') 

    %DSP
DSP(Noisy_bas_bnd_sig,fe,"Manchester") ; % Afficher la DSP du signal base bande 

    % Diagramme de l'oeil
eye_diagram(Noisy_bas_bnd_sig,"Manchester") ; % Afficher le diagramme de l'oeil du signal

%3.
    %Ajouter Délai
Noisy_bas_bnd_sig=[zeros(10,1); Noisy_bas_bnd_sig]; % Ajouter un délai au début de signal 
figure()
plot(Noisy_bas_bnd_sig(30560*50:30580*50)) ; 
title('Signal Manchester avec bruit et délai') ;

    %DSP
DSP(Noisy_bas_bnd_sig,fe,"Manchester avec bruit et délai") ; % Afficher la DSP du signal avec bruit et délai

    % Diagramme de l'oeil
eye_diagram(Noisy_bas_bnd_sig,"Manchester avec bruit et délai") ; % Afficher le diagramme de l'oeuil du signal avec bruit et délai 

%4.
    % Restituer le signal 
echantillons = 25:50:length(Noisy_bas_bnd_sig) ; % définir les échantillons utilisé pour la restauration du signal
new_x = Noisy_bas_bnd_sig(echantillons,1) ; % Voir la valeur assigné à chaque échantillon
new_x = new_x<0 ; % si une valeur est supérieur à 0 on la donne le bit 1 sinon le bit 0
new_x = bi2de(new_x) ; 
figure()
plot(new_x) ; 
title('Signal Restitué')  ;



