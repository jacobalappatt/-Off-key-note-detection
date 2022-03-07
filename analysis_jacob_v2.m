% Currently does:
% Calculation of percent corr for exp 1 & exp 2
% Calculation of d' for exp1. 
% Plots of percent correct using all data and filtered data

clear all
path3 = sprintf('%s', 'Run*RawData.mat');
full = dir(path3);
full_list = (char(full.name));
PER_CORR=[];
D_PRIME=[];
BONUS_DATA=[];
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
    set_number=RawData.stim1{size(RawData.stim1,2)}; % Gets the last stim1 entry which corresponds to this subject
    LUT_master=readtable(['/Users/jacob/Desktop/audiofiles/ExperimentRun4_12062021/LUT_MASTER.csv']);
    
    %per_cor1= calculate_performance1(RawData, LUT_master);
    per_cor2= calculate_performance2(RawData, LUT_master);
    
    %answers=vertcat(per_cor1, per_cor2)';
    answers=vertcat(per_cor2)';
    PER_CORR=[PER_CORR;answers];
    
    subjdata=[convertCharsToStrings(RawData.worker), per_cor2];
    BONUS_DATA=[BONUS_DATA;subjdata];
    
    d_prime1=calculate_dprime(RawData, LUT_master);
    D_PRIME=[D_PRIME;d_prime1];

    %familiarity1 = calculate_familiarity1(RawData);
    familiarity2 = calculate_familiarity2(RawData, LUT_master);
    FAMILIARITY=[FAMILIARITY;familiarity2];
    
    idx=and(PER_CORR > 80,2);
    FAMILIARITY_PASS=FAMILIARITY(idx,:);
    
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

bonusname = sprintf('SubjBonuses_PerCorr2.mat');
save(bonusname, 'BONUS_DATA');

