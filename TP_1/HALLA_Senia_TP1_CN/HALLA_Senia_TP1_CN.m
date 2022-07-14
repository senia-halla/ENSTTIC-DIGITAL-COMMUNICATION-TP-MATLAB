clear all; 
close all;
clc;

[y,Fs] = audioread('spidermonkey.wav') ; % Lire l'audio
sound(y,Fs) ; % Lancer l'audio
pause(3) ; 

% Bocule pour les different resolutions : 4, 8 et 12
for n=[4,8,12]
    Vmax = max(y); % Calculer la valeur maximale de l'audio
    L = 2^n ; % Calculer le nombre de plages
    delta= 2*Vmax/L ; % Calculer la largeur de plage 
     
    
    Yq = quantify(y,delta) ; % Quantifier le signal audio en utilisant la fonction crée
    SQNR = performance(y,Yq) ; %Calculer le rapport signal-bruit : SQNR, en utilisant le signal originale et le signal quantifié
    Peq = (delta^2)/12 ; % Calculer la puissance de bruit en utilisant l'approche statistique
    
    [n, SQNR, Peq] % Afficher la résolution, le SQNR ainsi que la puissance statistique du bruit 
    sound(Yq,Fs) ; % Lancer l'audio 
    %On remarque que plus la résolution augmente, l'audio devient plus
    %clair, et que le SQNR augmente, qui veut dire que la puissance de
    %bruit devient plus petite par rapport à la puissance du signal
    
    figure() ; 
    plot(Yq,y) ; % Tracer la courbe signal quantifié en fonction du signal original
    ylabel('Quantified Signal--->');
    xlabel('Original Signal--->');
    title(['la courbe signal quantifié en fonction du signal original - résolution n = ' num2str( n ) '.']);
    
    figure() ; 
    histogram(y-Yq) ; % Tracer l'histogramme de l'erreur
    title(['Error Histogram - résolution n = ' num2str( n ) '.']);
    
    pause(2) ; % Wait for 2 seconds
       
end


function [Yq,SQNR] = quantify(y,delta)
    Yq=delta*fix((y-delta/2)/delta)+delta/2; % Calculer le signal quantifié en utilisant le signal et la largeur de plage
end

function [SQNR] = performance(x,y)
    z = x-y ; % Calculer l'erreur ( singal originale - signal quantitifé )
    Px = mean(x.^2) ; % Calculer la puissance du signal originale
    Pz = mean(z.^2) ; % Calculer la puissance d'erreur
    
    SNR = Px/Pz ; % Calculer le ration signal bruit
    SQNR= 10*log10(SNR) ; % Calculer le sqnr en dB
end