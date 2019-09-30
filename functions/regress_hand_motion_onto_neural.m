function [W_all,R_sq_all,tau_best,RMS_all] = regress_hand_motion_onto_neural(c_load_ipsi_mat,pert_matc,bsize)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    W_all=0;
    R_sq_all=-10^6;;
    kine_all=0;
    tau_best=0;
    RMS_all=0;

    for tau=0:10:300
        start_ep=1+tau;
        end_ep=300+tau;
        kine_mat=[];
        for i=1:8
            kine_mat=[kine_mat squeeze(c_load_ipsi_mat(i,:,start_ep:bsize:end_ep))];
        end

        %
        Rsq_xval=[];
        RMS=[];
        csize=300/bsize;
        for j=1:8
            %left out
            rand_in=j;%randi(8);
            kine_mat_left= kine_mat (:,1+csize*(rand_in-1):rand_in*csize);
            pert_matc_left=pert_matc(:,1+csize*(j-1):j*csize);

            %remaining conditions
            kine_mat_red=kine_mat;
            kine_mat_red (:,1+csize*(rand_in-1):rand_in*csize)=[];

            pert_matc_red=pert_matc;
            pert_matc_red(:,1+csize*(j-1):j*csize)=[];

            pert_matc_red=[pert_matc_red;ones(1,size(pert_matc_red,2))];
            pert_matc_left=[pert_matc_left;ones(1,size(pert_matc_left,2))];

            %regress neural responses onto torques
            W=mrdivide(kine_mat_red,pert_matc_red);

            %calculate the predicted torques from neural response
            %left out condition
            acc_pred=W*pert_matc_left;

    %         kine_mat_left

            resd=norm(acc_pred-kine_mat_left,'fro');

            kine_mat_left=kine_mat_left-repmat(mean(kine_mat_left,2),[1,size(kine_mat_left,2)]);
            VAR=norm(kine_mat_left,'fro');

            R_sq=1-resd^2/VAR^2;
            Rsq_xval(j)=R_sq;
            RMS(j)=(resd^2)/length(acc_pred);
        end

        if mean(Rsq_xval)>mean(R_sq_all)
            R_sq_all=(Rsq_xval);
            W_all=W;
            kine_all=kine_mat;
            tau_best=tau;
            RMS_all=RMS;
        end
    end
end

