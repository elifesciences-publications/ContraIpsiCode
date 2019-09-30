close ALL

cd('../../')


bin_size=1;
cd('functions')

time=linspace(-200,300,501);
%get the neuron responses for each conditon
[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_timing(convolved_H,bin_size );

%find each neuron's PD
[pd_contra ] = get_pert_pd_old( pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c );
[pd_ipsi ] = get_pert_pd_old( pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i );


if dup_flag==1
    %get only the non-duplicate cells
    ind_sign=intersect(ind_sign,good_indices);
end

%get each neuron's onset
% curr_ind=ind_resp;
[onset_contra] = onset_by_diff_func(pd_contra(ind_sign,:));
[onset_ipsi] = onset_by_diff_func(pd_ipsi(ind_sign,:));

onset_contra_sign=find(onset_contra>0);
onset_ipsi_sign=find(onset_ipsi>0);
overlap=intersect(onset_contra_sign,onset_ipsi_sign);

%plot the onsets across neurons as a cdfplot
figure(1)
hold on
h=cdfplot(onset_contra(onset_contra_sign));
h.Color='b';
h=cdfplot(onset_ipsi(onset_ipsi_sign));
h.Color='r';
%calculate if contra is significantly earlier than ipsi
[h,pval]=ttest2(onset_contra(onset_contra_sign),onset_ipsi(onset_ipsi_sign))
legend('Contra','Ipsi')
xlabel('Onset Times (ms)')


%find neurons that have significant onset for contra and ipsi loads
%compare onsets using a scatter
%store data for comparison 
figure(2)
hold on
subplot(1,2,1)
hold on
scatter(onset_contra(overlap),onset_ipsi(overlap))

%create data structure to store onsets
data=struct;
data.index=overlap;
data.contra_onset=onset_contra(overlap);
data.ipsi_onset=onset_ipsi(overlap);

%calculate percentiles to plot on graph
prc_ipsi_25=prctile(onset_ipsi(overlap),25);
prc_ipsi_75=prctile(onset_ipsi(overlap),75);
prc_contr_25=prctile(onset_contra(overlap),25);
prc_contr_75=prctile(onset_contra(overlap),75);
med_ipsi=median(onset_ipsi(overlap));
med_contr=median(onset_contra(overlap));
%plot median and prctiles
errorbar(med_contr,med_ipsi,abs(prc_ipsi_25-med_ipsi),abs(prc_ipsi_75-med_ipsi),abs(prc_contr_25-med_contr),abs(prc_contr_75-med_contr))

%plotting management
a=0;
b=250;
t=linspace(a,b,10);
plot(t,t,'k')
xlim([a,b])
ylim([a,b])
axis square
xlabel('Contralateral Onset (ms)')
ylabel('Ipsilateral Onset (ms)')

%plot cdfplot contrasting the onsets between contra and ipsi activity
subplot(1,2,2)
hold on
cdfplot(onset_contra(overlap)-onset_ipsi(overlap))
[p,~,stats]=signrank(onset_contra(overlap)-onset_ipsi(overlap));
xlabel('Onset Times (ms)')
title(strcat('Onset Contra - Onset Ipsi, Signed Rank Test pval: ',num2str(p),' z val: ', num2str(stats.zval)))




figure(3)
hold on
subplot(1,2,1)
hold on
curr_ind=overlap;
% curr_ind=onset_contra_sign;
contra_avg=mean(pd_contra(curr_ind,:),1);
contra_ste=std(pd_contra(curr_ind,:),[],1)/sqrt(size(pd_contra(curr_ind,:),1));

% curr_ind=onset_ipsi_sign;
ipsi_avg=mean(pd_ipsi(curr_ind,:),1);
ipsi_ste=std(pd_ipsi(curr_ind,:),[],1)/sqrt(size(pd_ipsi(curr_ind,:),1));

[onset_contra] = onset_by_diff_func(contra_avg);
[onset_ipsi] = onset_by_diff_func(ipsi_avg);

shadedErrorBar(time,contra_avg,contra_ste,'b')
shadedErrorBar(time,ipsi_avg,ipsi_ste,'r')
vline(onset_contra,'b')
vline(onset_ipsi,'r')
vline(0,'k')
hline(0,'k')
xlim([-50,150])
title('Neurons with onsets for contra or ipsi activity')

subplot(1,2,2)
hold on
curr_ind=ind_sign;
contra_avg=mean(pd_contra(curr_ind,:),1);
contra_ste=std(pd_contra(curr_ind,:),[],1)/sqrt(size(pd_contra(curr_ind,:),1));

% curr_ind=overlap;
ipsi_avg=mean(pd_ipsi(curr_ind,:),1);
ipsi_ste=std(pd_ipsi(curr_ind,:),[],1)/sqrt(size(pd_ipsi(curr_ind,:),1));

[onset_contra] = onset_by_diff_func(contra_avg);
[onset_ipsi] = onset_by_diff_func(ipsi_avg);

shadedErrorBar(time,contra_avg,contra_ste,'b')
shadedErrorBar(time,ipsi_avg,ipsi_ste,'r')
vline(onset_contra,'b')
vline(onset_ipsi,'r')
vline(0,'k')
hline(0,'k')
xlim([-100,300])
title('All neurons responsive to either contra or ipsi perts')


% assert(false)

cd('../')
direct=strcat('figures/',data_type,'/single_cell/timing');
if dup_flag
    direct=strcat(direct,'/no_duplicates');
end
mkdir(direct)
cd(direct)
h=figure(1);
saveas(h,'cdfplot_of_onsets')
saveas(h,'cdfplot_of_onsets','epsc')

h=figure(2);
saveas(h,'scatter of contra and ipsi onsets')
saveas(h,'scatter of contra and ipsi onsets','epsc')

h=figure(3);
saveas(h,'population response')
saveas(h,'population response','epsc')

save('Onset Timing','data')