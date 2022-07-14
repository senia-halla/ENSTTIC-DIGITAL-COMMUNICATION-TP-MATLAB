function DSP(Bas_bnd_sig,fe,write) 
    % Cette fonction est utilisé pour calculer la DSP d'un signal Base bande pour une fréquence d'échantillonage fe
    [Psd1,freq] = pwelch(Bas_bnd_sig(:,1),512,0,512,fe); % Calculer la DSP
    figure()
    plot (freq, 10*log10(Psd1)) % Afficher la DSP
    title(string(strcat("La DSP du signal ",write))) ; 
end