% Analysis script for Bhairavi experiment. 

%Currently does:
% Calculation of percent corr for exp 1 & exp 2
% Calculation of d' for exp1. 
% Plots of percent correct using all data and filtered data


clear all
path3 = sprintf('%s', 'Run*RawData.mat');
full = dir(path3);
full_list = (char(full.name));
PER_CORR=[];
D_PRIME=[];
FAMILIARITY=[]; % 12 values per row, mean/median/mode across 4 scales
% Brewer map needs to be added


for i = 1:size(full_list,1)
    
    n=1;
    % for f = 1:Files_per_Sbj(SbjN)
    Subj_datamat = strtrim(full_list(i, :));
    
    load(Subj_datamat); 
    
    % for exp1
    conds = str2double(RawData.cond1);
    temp_resp = str2double(RawData.resp1);
    temp_both = sortrows([conds,temp_resp]);
    all_data1(:,:,i) = temp_both(:,2); 
    
    % for exp2
    conds = str2double(RawData.cond2);
    temp_resp = str2double(RawData.resp2);
    temp_both = sortrows([conds,temp_resp]);
    all_data2(:,:,i) = temp_both(:,2);
    
    % Get appropriate LOOKUP sheet
    set_number=RawData.stim1{size(RawData.stim1,2)} % Gets the last stim1 entry which corresponds to this subject
    LUT_master=readtable(['/Users/jacob/Desktop/audiofiles/ExperimentRun2_11182021/Set',set_number,'/LookupMaster_Corrected.csv']);
    
    per_cor1= calculate_performance1(RawData, LUT_master);
    per_cor2= calculate_performance2(RawData, LUT_master);
    
    answers=vertcat(per_cor1, per_cor2)';
    PER_CORR=[PER_CORR;answers];
    
    d_prime1=calculate_dprime(RawData, LUT_master);
    D_PRIME=[D_PRIME;d_prime1];

    %familiarity1 = calculate_familiarity1(RawData);
    familiarity2 = calculate_familiarity2(RawData, LUT_master);
    FAMILIARITY=[FAMILIARITY;familiarity2];
    
    musornot = str2double(RawData.musician(1)); %will go in third column of all_data
    
    %% Check to see if html is wrongly coded for musornot. 
    if musornot == 1
        num_years = str2double(RawData.musician{2, 1}{1,1}); %will go in fourth column of all_data
       
            num_formal_years = str2double(RawData.musician{3, 1}{1,1}); %will go in fifth column
       
    elseif musornot == 0
        num_years = 0;
        num_formal_years =0;
    else
        num_years = NaN;
        num_formal_years =NaN;
    end
   %%
    
    %SES = str2double(RawData.musician(4:6));
    if isempty(num_formal_years) 
        num_formal_years = NaN;
    end
    
    musicianship = [musornot, num_years, num_formal_years];
    
    if isempty(RawData.demo{1,1}{1,1})
        age = NaN;
    else
        age = str2double(RawData.demo{1,1});
    end
    
    if strcmp(RawData.demo{2,1}{1,1}, 'Male')
        sex = 0;
    elseif strcmp(RawData.demo{2,1}{1,1}, 'Female')
        sex=1;
     elseif strcmp(RawData.demo{2,1}{1,1}, 'Nonbinary')
        sex = .5;
    else
        sex = NaN;
    end
    demog = [age,sex];

    musicianship_data48(i,:) = [musicianship];
    demo_data48(i,:)= demog;
  
end

total_participants = size(all_data1,3)
fname = sprintf('PerCorr_SourNote_v1_Run1.mat');
save(fname, 'PER_CORR');


%% Summary plots

f1=figure
hold on
bar(diag(mean(PER_CORR(:,1:4))), 'stacked')
hold on
errorbar(mean(PER_CORR(:,1:4))', std(PER_CORR(:,1:4))'./sqrt(size(PER_CORR,1)), '.k')
ylim([30 100]);
annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR,1))]);
set(gca, 'FontSize', 15, 'XTick', 1:4, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
xlabel('Mode')
title('Performance across modes')
ylabel('Percent Correct')
saveas(gcf,'PerCorr_AllModes.jpg')
close(f1)

%Plot only those than cross 80% in contour task
idx=and(PER_CORR(:,5) > 80,2);
PER_CORR_PASS=PER_CORR(idx,:);
f2=figure
hold on
bar(diag(mean(PER_CORR_PASS(:,1:4))), 'stacked')
hold on
errorbar(mean(PER_CORR_PASS(:,1:4))', std(PER_CORR_PASS(:,1:4))'./sqrt(size(PER_CORR_PASS,1)), '.k')
ylim([30 100]);
annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR_PASS,1))])
set(gca, 'FontSize', 15, 'XTick', 1:4, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
xlabel('Mode')
title('Performance across modes')
ylabel('Percent Correct')
saveas(gcf,'PerCorr_AllModes_PassCatchTrials.jpg')
close(f2)

%% d prime for Expt 1

% Plot d_prime
f3=figure;
bar(mean(D_PRIME))
hold on;
errorbar(mean(D_PRIME), std(D_PRIME)./sqrt(size(PER_CORR,1)), '.k')
ylim([-0.25 2.5]);
annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR,1))])
set(gca, 'FontSize', 15, 'XTick', 1:4, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
xlabel('Mode')
title('Performance across modes - d prime')
ylabel('d prime')
saveas(gcf,'dprime_AllModes_PassHC.jpg')
close(f3)

%Plot d prime on those who pass contour trials
f4=figure;
D_PRIME_PASS=D_PRIME(idx,:);
bar(mean(D_PRIME_PASS))
hold on;
errorbar(mean(D_PRIME_PASS), std(D_PRIME_PASS)./sqrt(size(PER_CORR_PASS,1)), '.k')
ylim([-0.25 2.5]);
annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR_PASS,1))])
set(gca, 'FontSize', 15, 'XTick', 1:4, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
xlabel('Mode')
title('Performance across modes - d prime')
ylabel('d prime')
saveas(gcf,'dprime_AllModes_PassCatchTrials.jpg')
close(f4)

%Plot individual line plots for D prime pass
f5=figure;
plot(D_PRIME_PASS')
set(gca, 'FontSize', 15, 'XTick', 1:5, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
xlabel('Mode')
annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR_PASS,1))])
title('D Prime for individuals')
ylabel('d prime')
saveas(gcf,'individualdata_dprime.jpg')
close(f5)


%Plot Familiarity PASS - mode data
%FAMILIARITY_PASS=FAMILIARITY(idx,:);
%f6=figure;
%bar(mean(FAMILIARITY_PASS(:,[3,6,9,12])))
%hold on;
%errorbar(mean(FAMILIARITY_PASS(:,[3,6,9,12])), std(FAMILIARITY_PASS(:,[3,6,9,12]))./sqrt(size(PER_CORR_PASS,1)), '.k')
%set(gca, 'FontSize', 15, 'XTick', 1:4, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
%xlabel('Mode')
%annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR_PASS,1))])
%title('Mean familiarity across modes')
%ylabel('Mean familiarity')
%saveas(gcf,'MeanFamiliarity_PassContourTrials.jpg')
%close(f6)

%Plot Familiarity PASS - mean data
FAMILIARITY_PASS=FAMILIARITY(idx,:);
f6=figure;
bar(mean(FAMILIARITY_PASS(:,[1,4,7,10])))
hold on;
errorbar(mean(FAMILIARITY_PASS(:,[1,4,7,10])), std(FAMILIARITY_PASS(:,[1,4,7,10]))./sqrt(size(PER_CORR_PASS,1)), '.k')
set(gca, 'FontSize', 15, 'XTick', 1:4, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
xlabel('Mode')
annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR_PASS,1))])
title('Mean familiarity across modes')
ylabel('Mean familiarity')
saveas(gcf,'MeanFamiliarity_PassContourTrials.jpg')
close(f6)

%Plot individual line plots for Familiarity pass
f7=figure;
plot(FAMILIARITY_PASS(:,[1,4,7,10])')
set(gca, 'FontSize', 15, 'XTick', 1:5, 'XTickLabel', {'major', 'minor', 'bhairavi', 'octatonic'});
xlabel('Mode')
annotation('textbox', [0.8, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["n = " num2str(size(PER_CORR_PASS,1))])
title('Mean familiarity ratings for individuals')
ylabel('Mean familiarity')
saveas(gcf,'Individuals_meanfamiliarity_PassCatchTrials.jpg')
close(f7)
