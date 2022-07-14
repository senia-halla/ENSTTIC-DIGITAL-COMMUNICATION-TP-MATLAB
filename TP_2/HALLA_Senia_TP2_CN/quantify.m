function code = quantify(y,n)

    vmax = max(y); % Calculer la valeur maximale de l'audio
    vmin = -vmax ; 
    L = 2^n ; % Calculer le nombre de plages

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
end