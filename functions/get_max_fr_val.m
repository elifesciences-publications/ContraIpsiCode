function [max_fr] = get_max_fr_val(pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    mat_all=[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c];
    max_fr=max(mat_all,[],2);
    max_fr=max_fr+5;
end

