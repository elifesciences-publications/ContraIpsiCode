close ALL

cd('../../')



cd('functions')

% [ind_sign_posture ] = anova_each_cell_posture( convolved_H );

[pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c,pert1i,pert2i,pert3i...
    ,pert4i,pert5i,pert6i,pert7i,pert8i ] = get_neuron_data_tuned_posture( convolved_H );

numb_neuron=length(pert1c);

%get neurons that are tuned for ipsi and contra
[ind_contr,pd_contra,~,~,mag_contra,pval_contra]=get_tuned_neurons( pert1c,pert2c,pert3c,pert4c,pert5c,pert6c,pert7c,pert8c );
[ind_ipsi,pd_ipsi,~,~,mag_ipsi,pval_ipsi]=get_tuned_neurons( pert1i,pert2i,pert3i,pert4i,pert5i,pert6i,pert7i,pert8i );

ind_contr=intersect(ind_contr,ind_sign);
ind_ipsi=intersect(ind_ipsi,ind_sign);

ind_resp=ind_sign;

if dup_flag==1
    %get only the non-duplicate cells
    ind_contr=intersect(ind_contr,good_indices);
    ind_ipsi=intersect(ind_ipsi,good_indices);
    %ind_comb=intersect(ind_comb,good_indices); %use the tuning from perturbation epoch
    ind_resp=intersect(ind_resp,good_indices);
    ind_sign=intersect(ind_sign,good_indices);
end

% ind_comb=intersect(ind_contr,ind_ipsi);
% ind_resp=union(ind_contr,ind_ipsi);       %use the tuning from perturbation epoch
 

rad=30;
figure(1)
hold on
subplot(2,3,1)
hold on
[r_contra_resp,theta_contra_resp]=plot_polar_histogram_pd(pd_contra(ind_resp),'k');
[r_contra_comb,theta_contra_comb]=plot_polar_histogram_pd(pd_contra(ind_comb),'b');
plot([0,rad*cos(theta_contra_resp*pi/180)],[0,rad*sin(theta_contra_resp*pi/180)],'k')
plot([0,rad*cos(theta_contra_comb*pi/180)],[0,rad*sin(theta_contra_comb*pi/180)],'b')
plot([0,rad*cos((theta_contra_resp+180)*pi/180)],[0,rad*sin((theta_contra_resp+180)*pi/180)],'k')
plot([0,rad*cos((theta_contra_comb+180)*pi/180)],[0,rad*sin((theta_contra_comb+180)*pi/180)],'b')
title(strcat('Angle: black:',num2str(theta_contra_resp),' blue: ',num2str(theta_contra_comb)))

subplot(2,3,2)
hold on
[r_ipsi_resp,theta_ipsi_resp]=plot_polar_histogram_pd(pd_ipsi(ind_resp),'k');
[r_ipsi_comb,theta_ipsi_comb]=plot_polar_histogram_pd(pd_ipsi(ind_comb),'r');
plot([0,rad*cos(theta_ipsi_resp*pi/180)],[0,rad*sin(theta_ipsi_resp*pi/180)],'k')
plot([0,rad*cos(theta_ipsi_comb*pi/180)],[0,rad*sin(theta_ipsi_comb*pi/180)],'r')
plot([0,rad*cos((theta_ipsi_resp+180)*pi/180)],[0,rad*sin((theta_ipsi_resp+180)*pi/180)],'k')
plot([0,rad*cos((theta_ipsi_comb+180)*pi/180)],[0,rad*sin((theta_ipsi_comb+180)*pi/180)],'r')
title(strcat('Angle: black:',num2str(theta_ipsi_resp),' red: ',num2str(theta_ipsi_comb)))

diff=pd_contra-pd_ipsi;

for i=1:length(diff)
    if diff(i)>180
        diff(i)=diff(i)-360;
    end
    
    if diff(i)<-180
        diff(i)=diff(i)+360;
    end
end

subplot(2,3,3)
hold on
[r_diff_resp,theta_diff_resp]=plot_polar_histogram_pd_diff(diff(ind_resp),'k');
[r_diff_comb,theta_diff_comb]=plot_polar_histogram_pd_diff(diff(ind_comb),'m');
plot([0,rad*cos(theta_diff_resp*pi/180)],[0,rad*sin(theta_diff_resp*pi/180)],'k')
plot([0,rad*cos(theta_diff_comb*pi/180)],[0,rad*sin(theta_diff_comb*pi/180)],'m')
% plot([0,rad*cos((theta_diff_resp+180)*pi/180)],[0,rad*sin((theta_diff_resp+180)*pi/180)],'k')
% plot([0,rad*cos((theta_diff_comb+180)*pi/180)],[0,rad*sin((theta_diff_comb+180)*pi/180)],'m')
title(strcat('Angle: black:',num2str(theta_diff_resp),' magenta: ',num2str(theta_diff_comb)))


for i=1:3
    subplot(2,3,i)
    xlim([-32,32])
    ylim([-32,32])
    axis square
end



numb_it=1000;
numb_bstrap=length(ind_resp);
r_distro_resp=zeros(1,numb_it);
for i=1:numb_it
    rand_pds=rand([1,numb_bstrap])*360;
    rcos=sum(cos(rand_pds*pi/180*2));
    rsin=sum(sin(rand_pds*pi/180*2));
    r=sqrt(rcos^2+rsin^2)/numb_bstrap;
    r_distro_resp(i)=r;
end

numb_bstrap=length(ind_comb);
r_distro_comb=zeros(1,numb_it);
for i=1:numb_it
    rand_pds=rand([1,numb_bstrap])*360;
    rcos=sum(cos(rand_pds*pi/180*2));
    rsin=sum(sin(rand_pds*pi/180*2));
    r=sqrt(rcos^2+rsin^2)/numb_bstrap;
    r_distro_comb(i)=r;
end


subplot(2,3,4)
hold on
h=cdfplot(r_distro_resp);
h.Color='k';
h=cdfplot(r_distro_comb);
h.Color='b';
vline(r_contra_resp,'k')
vline(r_contra_comb,'b')

numb_resp=find(r_distro_resp>r_contra_resp);
numb_resp=length(numb_resp)/length(r_distro_resp);

numb_comb=find(r_distro_comb>r_contra_comb);
numb_comb=length(numb_comb)/length(r_distro_comb);

title(strcat('Pval of All Cells (black): ',num2str(numb_resp),' Pval of Combined Resp Cells (Blue): ',num2str(numb_comb)));


subplot(2,3,5)
hold on
h=cdfplot(r_distro_resp);
h.Color='k';
h=cdfplot(r_distro_comb);
h.Color='r';
vline(r_ipsi_resp,'k')
vline(r_ipsi_comb,'r')

numb_resp=find(r_distro_resp>r_ipsi_resp);
numb_resp=length(numb_resp)/length(r_distro_resp);

numb_comb=find(r_distro_comb>r_ipsi_comb);
numb_comb=length(numb_comb)/length(r_distro_comb);

title(strcat('Pval of All Cells (black): ',num2str(numb_resp),' Pval of Combined Resp Cells (Red): ',num2str(numb_comb)));






numb_bstrap=length(ind_resp);
r_distro_resp=zeros(1,numb_it);
for i=1:numb_it
    rand_pds=rand([1,numb_bstrap])*360;
    rcos=sum(cos(rand_pds*pi/180));
    rsin=sum(sin(rand_pds*pi/180));
    r=sqrt(rcos^2+rsin^2)/numb_bstrap;
    r_distro_resp(i)=r;
end

numb_bstrap=length(ind_comb);
r_distro_comb=zeros(1,numb_it);
for i=1:numb_it
    rand_pds=rand([1,numb_bstrap])*360;
    rcos=sum(cos(rand_pds*pi/180));
    rsin=sum(sin(rand_pds*pi/180));
    r=sqrt(rcos^2+rsin^2)/numb_bstrap;
    r_distro_comb(i)=r;
end

subplot(2,3,6)
hold on
h=cdfplot(r_distro_resp);
h.Color='k';
h=cdfplot(r_distro_comb);
h.Color='m';
vline(r_diff_resp,'k')
vline(r_diff_comb,'m')

numb_resp=find(r_distro_resp>r_diff_resp);
numb_resp=length(numb_resp)/length(r_distro_resp);

numb_comb=find(r_distro_comb>r_diff_comb);
numb_comb=length(numb_comb)/length(r_distro_comb);

title(strcat('Pval of All Cells (black): ',num2str(numb_resp),' Pval of Combined Resp Cells (Magenta): ',num2str(numb_comb)));









low=min([mag_contra;mag_ipsi]);
upp=max([mag_contra;mag_ipsi]);
low=0.0;
upp=120;
t=linspace(low,upp,10);
figure(2)
hold on
subplot(1,2,1)
hold on
scatter(mag_contra(ind_resp),mag_ipsi(ind_resp),'k');
scatter(mag_contra(ind_ipsi),mag_ipsi(ind_ipsi),'filled','r');
scatter(mag_contra(ind_contr),mag_ipsi(ind_contr),'filled','b');
scatter(mag_contra(ind_comb),mag_ipsi(ind_comb),'filled','k');

% errorbar(mean(mag_contra(ind_resp)),mean(mag_ipsi(ind_resp)),std(mag_contra(ind_resp))/sqrt(length(ind_resp)),std(mag_contra(ind_resp))/sqrt(length(ind_resp)),std(mag_ipsi(ind_resp))/sqrt(length(ind_resp)),std(mag_ipsi(ind_resp))/sqrt(length(ind_resp)))

prc_ipsi_25=prctile(mag_ipsi(ind_resp),25);
prc_ipsi_75=prctile(mag_ipsi(ind_resp),75);

prc_contr_25=prctile(mag_contra(ind_resp),25);
prc_contr_75=prctile(mag_contra(ind_resp),75);
med_ipsi=median(mag_ipsi(ind_resp));
med_contr=median(mag_contra(ind_resp));

errorbar(med_contr,med_ipsi,abs(prc_ipsi_25-med_ipsi),abs(prc_ipsi_75-med_ipsi),abs(prc_contr_25-med_contr),abs(prc_contr_75-med_contr))

plot(t,t,'k')
xlabel('Contra Mag')
ylabel('Ipsi Mag')
xlim([low,upp])
ylim([low,upp])
axis square
vline(0,'k')
hline(0,'k')
set(gca,'XTick',low:20:upp)


subplot(1,2,2)
hold on
h=cdfplot(mag_contra(ind_resp)-mag_ipsi(ind_resp));
h.Color='k';
h=cdfplot(mag_contra(ind_comb)-mag_ipsi(ind_comb));
[p_resp,~,stat_resp]=signrank(mag_contra(ind_resp)-mag_ipsi(ind_resp));
[p_comb,~,stat_comb]=signrank(mag_contra(ind_comb)-mag_ipsi(ind_comb));
h.Color=[0.5,0.5,0.5];
title(strcat('Contra Mag - Ipsi Mag Signed Rank Test Both Responsive pval: ',num2str(p_resp),' Z-value: ',num2str(stat_resp.zval)))
xlabel('Magnitude Diff (Hz)')
xlim([-50,100])
set(gca,'XTick',-50:25:100)
vline(0,'k')



figure(3)
hold on
subplot(1,2,1)
hold on
scatter(pval_contra,pval_ipsi,'k')
scatter(pval_contra(ind_resp),pval_ipsi(ind_resp),'filled','k')
scatter(pval_contra(ind_comb),pval_ipsi(ind_comb),'filled','r')
xlabel('Pval Contra')
ylabel('Pval Ipsi')
legend('All Cells','Resp Cells','Combined Responsive')
xlim([-6,0])
ylim([-6,0])
axis square

subplot(1,2,2)
hold on
scatter(log10(pval_contra),log10(pval_ipsi),'k')
scatter(log10(pval_contra(ind_resp)),log10(pval_ipsi(ind_resp)),'filled','k')
scatter(log10(pval_contra(ind_comb)),log10(pval_ipsi(ind_comb)),'filled','r')
xlabel('log 10 Pval Contra')
ylabel('log 10 Pval Ipsi')
legend('All Cells','Resp Cells','Combined Responsive')
xlim([-6,0])
ylim([-6,0])
axis square


rho_all=[];
rho=corr(pval_contra.',pval_ipsi.');
rho_all(1,1)=rho;
rho=corr(pval_contra(ind_resp).',pval_ipsi(ind_resp).');
rho_all(1,2)=rho;
rho=corr(pval_contra(ind_comb).',pval_ipsi(ind_comb).');
rho_all(1,3)=rho;

rho=corr(log10(pval_contra).',log10(pval_ipsi).');
rho_all(2,1)=rho;
rho=corr(log10(pval_contra(ind_resp)).',log10(pval_ipsi(ind_resp)).');
rho_all(2,2)=rho;
rho=corr(log10(pval_contra(ind_comb)).',log10(pval_ipsi(ind_comb)).');
rho_all(2,3)=rho;



cd('../')
direct=strcat('figures/',data_type,'/single_cell/tuning/posture');
if dup_flag==1
    direct=strcat(direct,'/no_duplicates');
end
mkdir(direct)
cd(direct)
h=figure(1);
saveas(h,'polar_histogram')
saveas(h,'polar_histogram','epsc')


h=figure(2);
saveas(h,'Magnitude Contra vs Ipsi')
saveas(h,'Magnitude Contra vs Ipsi','epsc')


h=figure(3);
saveas(h,'Sign Thresholds Contra vs Ipsi')
saveas(h,'Sign Thresholds vs Ipsi','epsc')