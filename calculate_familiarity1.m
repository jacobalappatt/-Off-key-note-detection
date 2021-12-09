% Script to analyze familiaraity
% get all responses and condnums
% sort by stimuli 1-160
% mean/median/mode per condition
% Save 12 values per participant

function familiarity1 = calculate_familiarity1(RawData)

familiarity = [];
for i = 1:160 % Loop to assign values to data1 and change format
    data1(i,1)=str2num(RawData.cond1{i});
    data1(i,2)=str2num(RawData.resp_familiarity1{i});
end
    
data1_sort=sortrows(data1,'ascend'); % sort ascending to match LUT

% Familiarity ratings for Expt 1
conditions={'major', 'minor', 'bhairavi','octatonic'};
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
        if condition =='bhairavi'
            start=81;
            final=120;
        end
        if condition =='octatonic'
            start=121;
            final=160;
        end
        subj_data1 = data1_sort(start:final,2)
        
        familiarity = [familiarity mean(subj_data1) median(subj_data1), mode(subj_data1)];
        
    end
    familiarity1 = familiarity;
end

