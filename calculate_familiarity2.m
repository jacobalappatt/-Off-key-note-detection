% Script to analyze familiaraity on non-sour trials

% gets all responses and condition numberss
% sort by stimuli 1-160
% delete columns where LUT shows sour trial
% mean/median/mode per condition
% Saves 12 values per participant across 80 trials

function familiarity2 = calculate_familiarity2(RawData,LUT_master)

familiarity = [];
for i = 1:160 % Loop to assign values to data1 and change format
    data1(i,1)=str2num(RawData.cond1{i});
    data1(i,2)=str2num(RawData.resp_familiarity1{i});
end
    
data1_sort=sortrows(data1,'ascend'); % sort ascending to match LUT

% Familiarity ratings for Expt 1
conditions={'major', 'minor', 'poorvi','octatonic'};
    for j =1:4
        condition=convertCharsToStrings(conditions{j}); % Select which condition - determines the x dimension length
        if condition =='major'
            start=1;
            final=40;
        end
        if condition =='minor'
            start=41;
            final=80;
        end
        if condition =='poorvi'
            start=81;
            final=120;
        end
        if condition =='octatonic'
            start=121;
            final=160;
        end
        
        %append data1_sort with LUT's answer column
        data1_sort_LUT=[data1_sort,table2array(LUT_master(:,2))];
        
        %grab only rows of data1_sort_LUT where the LUT column is '2' , i.e. CORRECT TRIAL
        subj_data1 = data1_sort_LUT(start:final,:);
        correct_trials=subj_data1(subj_data1(:,3)==2,2);
        
        familiarity = [familiarity mean(correct_trials) median(correct_trials), mode(correct_trials)];
        
    end
    familiarity2 = familiarity;
end

