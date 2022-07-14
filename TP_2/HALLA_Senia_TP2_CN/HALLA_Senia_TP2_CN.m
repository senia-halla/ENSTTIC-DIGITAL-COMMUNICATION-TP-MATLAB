%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NRZ Unipolaire 
clear all; 
close all;
clc;

[y,Fs] = audioread('spidermonkey.wav') ; % Lire l'audio
n=8 ; % Définir la résolution
x = quantify(y,n) ; % Quantifier le signal audio
fe = 8000 ; 
Ts=125 ;  

%1. 
    %Signal NRZ Unipolaire 
x=x(:) ; % Mettre toutes les bits du signal dans un seule vecteur
y = bi2de(x(:,1)); % Convertir les bits du signal en code binaire 

pulse= ones(50,1) ; % La forme de g(t) : rect de T=50/8000=6.3ms
signal = pulse*(y'); % Multiplier le nouveau signal par cette forme g(t) pour construire le signal base bande
Bas_bnd_sig = signal(:); % Mettre toutes les valeurs du signal dans un seul vecteur.
figure()
plot(Bas_bnd_sig) ; 
title('Signal NRZ unipolaire')  ;

    %DSP
DSP(Bas_bnd_sig,fe,"NRZ unipolaire") ; % Afficher la DSP du signal base bande 

    % Diagramme de l'oeil
eye_diagram(Bas_bnd_sig,"NRZ unipolaire") ; % Afficher le diagramme de l'oeil du signal


%2. 
    % Ajouter le bruit au signal : passer par un canal AWGN
Noisy_bas_bnd_sig= Bas_bnd_sig + 0.2*randn(size(Bas_bnd_sig)); % Ajouter des valeurs aléatoires au signal ( bruit )
figure()
plot(Noisy_bas_bnd_sig) ; 
title('Signal NRZ unipolaire bruité')  

    %DSP
DSP(Noisy_bas_bnd_sig,fe,"NRZ unipolaire bruité") ; % Afficher la DSP du signal bruité

    % Diagramme de l'oeil
eye_diagram(Noisy_bas_bnd_sig,"NRZ unipolaire bruité") ; % Afficher le diagramme de l'oeuil du signal bruité 


%3. 
    % Restituer le signal 
echantillons = 25:50:length(Noisy_bas_bnd_sig) ; % définir les échantillons utilisé pour la restauration du signal
new_x = Noisy_bas_bnd_sig(echantillons,1) ; % Voir la valeur assigné à chaque échantillon
new_x = new_x>0.5 ; % si une valeur est supérieur à 0.5 on la donne le bit 1 sinon le bit 0
new_x = bi2de(new_x) ; 
figure()
plot(new_x) ; 
title('Signal Restitué')  ;
sum(abs(x-new_x))/length(new_x) % calculer et afficher le taux d'erreur entre le signal d'origine x et le signal restauré

%4. 
    % Introduire un Délai de signal 
delayed_out=[zeros(10,1); Bas_bnd_sig]; % Ajouter un délai au début de signal 
eye_diagram(delayed_out,"NRZ unipolaire avec un délai") ; % Afficher son diagramme de l'oeuil

%5.
    % L’addition du signal d’origine avec sa version retardée
original_delayed = [Bas_bnd_sig;zeros(10,1)] + delayed_out ; % sommez le signal et le signal avec délai
eye_diagram(original_delayed,"NRZ unipolaire avec un délai additioné au signal original") ; % Afficher son diagramme de l'oeuil

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%NRZ Polaire 
clear all; 
close all;
clc;

[y,Fs] = audioread('spidermonkey.wav') ; % Lire l'audio
n=8 ; % Définir la résolution
x = quantify(y,n) ; % Quantifier le signal audio
fe = 8000 ;
Ts=125 ; 

%1.
    %Signal NRZ Polaire
x=x(:) ; % mettre toutes les bits du signal dans une seule cologne
y=bi2de(x(:,1)); 
y = (2*y)-1 ; % assigner au bit 1 la valeur 1 et au bit 0 la valeur -1

pulse= ones(50,1) ; % la forme de g(t) : rect de T=50/8000=6.3ms
sig =pulse*(y'); % multiplier le nouveau signal par cette forme g(t) pour construire le signal base bande
Bas_bnd_sig = sig (:); % Assigner toute les valeures de signal dans un seul vecteur.
figure()
plot(Bas_bnd_sig) ; 
title('Signal NRZ polaire')  ;

    %DSP
DSP(Bas_bnd_sig,fe,"NRZ polaire") ; % Afficher la DSP du signal base bande 

    % Diagramme de l'oeil
eye_diagram(Bas_bnd_sig,"NRZ polaire") ; % Afficher le diagramme de l'oeil du signal

%2. 
    % Ajouter le bruit au signal : passer par un canal AWGN
Noisy_bas_bnd_sig= Bas_bnd_sig + 0.2*randn(size(Bas_bnd_sig)); % Ajouter des valeurs aléatoires au signal ( bruit )
figure()
plot(Noisy_bas_bnd_sig) ; 
title('Signal NRZ polaire bruité')  

    %DSP
DSP(Noisy_bas_bnd_sig,fe,"NRZ polaire bruité") ; % Afficher la DSP du signal bruité

    % Diagramme de l'oeil
eye_diagram(Noisy_bas_bnd_sig,"NRZ polaire bruité") ; % Afficher le diagramme de l'oeuil du signal bruité 

%3. 
    % Restituer le signal 
echantillons = 25:50:length(Noisy_bas_bnd_sig) ; % définir les échantillons utilisé pour la restauration du signal
new_x = Noisy_bas_bnd_sig(echantillons,1) ; % Voir la valeur assigné à chaque échantillon
new_x = new_x>0 ; % si une valeur est supérieur à 0 on la donne le bit 1 sinon le bit 0
new_x = bi2de(new_x) ; 
figure()
plot(new_x) ; 
title('Signal Restitué')  ;
sum(abs(x-new_x))/length(new_x) % calculer et afficher le taux d'erreur entre le signal d'origine x et le signal restauré

%4.
    % Introduire un Délai de signal 
delayed_out=[zeros(10,1); Bas_bnd_sig]; % Ajouter un délai au début de signal 
eye_diagram(delayed_out,"NRZ polaire avec un délai") ; % Afficher son diagramme de l'oeuil

%5.
    %  L’addition du signal d’origine avec sa version retardée
original_delayed = [Bas_bnd_sig;zeros(10,1)] + delayed_out ; % sommez le signal et le signal avec délai
eye_diagram(original_delayed,"NRZ polaire avec un délai additioné au signal original") ; % Afficher son diagramme de l'oeuil 
