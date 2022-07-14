clear all;
close all;
clc;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Èmission %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% QAM sans porteuse 

M = 4 ; %définir les différents états
data = randi([0 M-1],100,1) ; %Générer un signal binaire contenant 100 points 
a = qam_mod(data,M); % Calculer le signal modulé

figure() ; 
plot(a) ; % Tracer le signal numérique du signal modulant
title(append("Le signal numérique ",num2str(M),"-QAM"));

scatterplot(a) ; % Tracer le diagramme de constellation
title(append("Diagramme de Constellation de ",num2str(M),"-QAM"));
    
figure() ;
plot(abs(fft(a))) ; %Tracer le spectre
title(append("Spectre du signal ",num2str(M),"-QAM"));

%% QAM avec porteuse
fc = 1000; % freq max
fe = 20000 ; %freq d'echantillonage
Te = 1/fe ; % période d'echantillonage
t=[0:Te: (50-1)*Te]; % vecteur du temps

cos_wave = cos(2*pi*fc*t); % créer le signal cos
sin_wave = sin(2*pi*fc*t); % créer le signal sin 

modulee = real(a)*cos_wave - imag(a)*sin_wave ; % Le signal modulée

figure(); 
plot(modulee'); 
title("Le signal modulé");

figure(); 
plot(abs(fft(modulee))); 
title("Le spectre du signal modulé");

%L'introduction d'une envelope au signal bande de base modifie le spectre
%du signal, le spectre du signal en bande de base est centré et a une bande de base etroite tandis que
%celui du signal modulé avec envelope est etalé sur plusieurs frequences 

%Pour differente execution du script, on remarquera que l'envelope
%spectrale change d'allure

%%Bruit AWGN 
modulee_bruit = awgn(modulee,20); % Passer le signal modulé par un canal AWGN 

figure() ; 
plot(modulee_bruit') ; % tracer le signal modulé
title("Le signal modulé bruité") ;

figure() ; 
plot(abs(fft(modulee_bruit))) ; % tracer son spectre 
title("Le spectre du signal modulé bruité") ;

%l'introduction d'un bruit gaussien modifie uniquement l'amplitude du
%signal, or un canal awgn introduit un bruit additive, ce qui explique le
%fait que signal modulé et signal bruité aient la meme allure spectral

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Réception %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Recuperation de r_i et r_q et implementation du traitment de la figure
r = modulee_bruit ;

r_anltc_x2 = hilbert( r) ; % calcul de la tranformée d'hilbert 
r_=real(r_anltc_x2); % sa partie réelle
r_hlb=imag(r_anltc_x2); % sa partie imaginaire 

ri = cos_wave.*r_ + sin_wave.*r_hlb ;  % calcul de ri
rq = -1*sin_wave.*r_ + cos_wave.*r_hlb ; % calcul de rq 

r_recue = ri+1j*rq ; % le signal reçue 

figure() ; 
plot(abs(r_recue')) ; 
title("Le signal reçue") ;

figure() ; 
plot(abs(fft(r_recue))) ; 
title("Le spectre du signal reçue") ;


%% Detecteur Optimal : 
s=zeros(4,length(t));
g=ones(length(t),1);
s(1,:)=0*g';
s(2,:)=1*g';
s(3,:)=2*g';
s(4,:)=3*g';
sig=r_recue;
[n1,n2]=size(r);
for i=1:n2
    m=norm(sig(:,i)'.*s(1,:)')-0.5*norm(s(1)).*norm(s(1));
    r_demod(i)=0;
    for j=2:4
        a=norm(sig(:,i)'.*s(j,:)')-0.5*norm(s(j)).*norm(s(j));
        if(a>m)
            m=a;
            r_demod(i)=j-1;

        end
    end
end

numErrs = symerr(r_demod,sig); % Taux d'erreur 
scatterplot(r_demod) ; % Tracer le diagramme de constellation
title(append("Diagramme de Constellation de ",num2str(M),"-QAM | Le détecteur."));

%Pour Fc=2Fs on aura cos(2*pi*fc*t)~1 et sin ~0 or le signal passe bande ne
%comportera que la composante Q sans tenir compte de la composante I ce qui
%peut fausser les resultats obtenu lors de la detection

%% Les fonctions 
function a = qam_mod(data,M) 
    if (M==2)
        a = (2*data-1); % Transformer chaque code binaire à 1 ou -1 
    else
        data = decimalToBinaryVector(data) ; % Transformer notre symboles en binaire
        [H W] = size(data) ; % Trouver la taille de nos bits dans W
        w_a= ceil(W/2) ; % diviser les bits en 2, une partie pour le a_k
        w_b = W-w_a ; % et une partie pour le b_k
        
        data_a = binaryVectorToDecimal( data(:,1:w_a) ) ; % séparer les a_k
        data_b = binaryVectorToDecimal( data(:,w_a+1:W) ) ; % séparer les b_k
        
        M_a = 2^w_a ; 
        a_k = (2*data_a-(M_a-1))*1 ; % utiliser une modulation ask sur les a_k
        M_b = 2^w_b ;
        b_k = (2*data_b-(M_b-1))*1 ; % utiliser une modulation ask sur les b_k
        
        a = a_k + 1j*b_k ; % construire le signal modulant 
     
    end 
end

function data = qam_demod(a,M)
    if (M==2)
       data = (a+(M-1))/2 ; % démodulation 2-ask 
    else
        a_k = real(a) ; % On extrait les symboles modulé a_k
        a_bits = ceil(log2(M)/2) ; % On calcule le nombre de bits dans a_k
        a_M = 2^a_bits ; % et puis on calcule le nombre de symboles
        
        a_k = (a_k+(a_M-1))/2 ; % On fait une démodulation ask sur les a_k 
        a_k = decimalToBinaryVector(a_k) ; % et on le transforme en binaire 
        
        b_k = imag(a) ; % On extrait les symboles modulé b_k 
        b_bits = log2(M) - a_bits ; % On calcule le nombre de bits dans b_k
        b_M = 2^b_bits ; % et puis on calcule le nombre de symboles
        
        b_k = (b_k+(b_M-1))/2 ; % On fait une démodulation ask sur les b_k 
        b_k = decimalToBinaryVector(b_k) ; % et on le transforme en binaire 
        
        a = [a_k b_k] ; % On fait la concatenation des symboles a_k et b_k démodulé pour obtenir le signal binaire démodulé
        
        data = binaryVectorToDecimal(a) ; % on transforme le signal démodulé en décimale 
        
    end 
    
end