function eye_diagram(Bas_bnd_sig,write)
    % Cette fonction est utilisé pour afficher la diagramme de l'oeuil d'un signal
    
    Start_eye_data = 304601; % commencer l'affichage pour le symbole 304604.
    End_eye_data = 304700; % Stoper l'affichage pour le symbole 304700.
    Delay = 0.9; % temp de transmission du canal.
    Nb_Pt_Pls = 50 ; %nombre d'éhantillons par symbole
    P=3; %Nombre de période de symbole qu'on va afficher
    eyediagram(Bas_bnd_sig(round((Start_eye_data+Delay)*Nb_Pt_Pls):(End_eye_data*Nb_Pt_Pls),:),P*Nb_Pt_Pls,P);
    title(string(strcat("Diagramme de l'oeil du signal ",write)));
end