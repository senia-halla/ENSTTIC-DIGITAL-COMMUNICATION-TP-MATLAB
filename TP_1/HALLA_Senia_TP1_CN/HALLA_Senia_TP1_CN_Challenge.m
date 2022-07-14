clear all;
close all;
clc;

[y,Fs] = audioread('spidermonkey.wav') ; % Lire l'audio
sound(y,Fs) ; %Ecouter l'audio

% Tracer l'amplitude du signal originale
subplot(3,1,1); grid on;
plot(y); 
title('Original Signal');
ylabel('Amplitude--->');
xlabel('Time--->');

% Définir la résolution 
n= 8 ;
L = 2^8 ; 

vmax = max(y) ; % La valeur maximale du signal
vmin = -vmax; % La valeur minimale du signal

interval = vmin:(vmax/n):vmax ; % Calculer l'intervalle entre la valeur minimale et maximale qui va être compressé à l'aide de la loi A
interval = compand(interval,87.6,max(interval),'A/expander') ; % Compresser l'intervalle avec la loi A pour avoir les segments

plages = zeros(L,1) ;
codes = zeros(L,1) ;
del = zeros(2*n,1) ;
Min_values = zeros(2*n,1) ; 

for i=1:2*n
    segment = interval(i+1) - interval(i) ; % Calculer les bornes de segment
    delta= segment/16 ; % Définir la largeur du plage de quantification uniforme de ce segment
    del(i) = delta ; 
    Min_values(i) = interval(i) ; 
    plages((i-1)*16+1:i*16+1)= interval(i):delta:interval(i+1); % Caluler les plages de ce segment
    codes((i-1)*16+1:i*16+2) = interval(i)-(delta/2):delta:interval(i+1)+(delta/2); % Calculer le points de quantification de ce segment
end

[ind,q]=quantiz(y,plages,codes); % Quantifier le signal en utilisant les plages et leur codes

l1=length(ind);
l2=length(q);

% Changer l'échelle des indexes pour qu'ils commencent à 0
 for i=1:l1
    if(ind(i)~=0)  
       ind(i)=ind(i)-1; 
    end 
    i=i+1;
 end   

%  Le Codage
code=de2bi(ind,'left-msb'); % Convertir les indexes en code binaire 

% Convertir la matrice de code en vecteur pour le tracer
k=1;
for i=1:l1
    for j=1:n
        coded(k)=code(i,j);                  
        j=j+1;
        k=k+1;
    end
    i=i+1;
end

% Tracer le signal codée
subplot(3,1,2); grid on;
stairs(coded);                                
axis([0 100 -2 3]);  title('Encoded Signal');
ylabel('Amplitude--->');
xlabel('Time--->');

% Le Décodage 
 
qunt=reshape(coded,n,length(coded)/n); % Remodifier la taille du code 

decoded = zeros(l2,1) ;

for i=1:l2
    j = bi2de(qunt(1:4,i)','left-msb')+1 ; % Trouver le segment ou chaque code appartient
    delta = del(j) ; % Trouver la largeur du plage de quantification de ce segment 
    vmin = Min_values(j) ; % Trouver la borne inférieur de ce segment
    plage = bi2de(qunt(5:8,i)','left-msb') ; % Trouver la plage du segment ou appartient le code
    decoded(i) = vmin + delta*plage + (delta/2); % Reconstruire le signal à partir du code
end

sound(decoded,Fs) % Ecouter au signal quantifié 

performance(y,decoded) % Calculer le SQNR du signal quantifié

% Tracer le signal quantifié
subplot(3,1,3); grid on;
plot(decoded);                                                        
title('Quantified Signal');
ylabel('Amplitude--->');
xlabel('Time--->');

% Tracer la courbe du signal quantifié par rapport au signal originale
figure()
plot(decoded,y) ; 
ylabel('Quantified Signal--->');
xlabel('Original Signal--->');
title(['la courbe signal quantifié en fonction du signal original - résolution n = ' num2str( n ) '.']);


function [SQNR] = performance(x,y)
   z = x-y ; % Calculer l'erreur ( singal originale - signal quantitifé )
   Px = mean(x.^2) ; % Calculer la puissance du signal originale
   Pz = mean(z.^2) ; % Calculer la puissance d'erreur
    
   SNR = Px/Pz ; % Calculer le ration signal bruit
   SQNR= 10*log10(SNR) ; % Calculer le sqnr en dB
end