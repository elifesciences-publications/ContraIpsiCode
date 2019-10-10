close ALL
load('data/Monkey_M')
cd('functions')

[ind_sign ] = anova_each_cell( data );
[indices,mag_struct] = get_magnitude_and_tuning(data,ind_sign);
get_timing_analysis(data,ind_sign);

%population analysis
numb_dim=10; %number of dimensions
numb_it=100; %number of iterations to perform
population_analysis(data,numb_dim,numb_it);

