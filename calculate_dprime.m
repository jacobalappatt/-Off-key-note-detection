% Analysis script for sour note trials
% Launched by analysis_jacob_vn.m scripts
% Returns a 4x1 double array of d prime values per subject, per mode/condition

% Usage : d_prime1= calculate_dprime(RawData, LUT_master) 
function d_prime1= calculate_dprime(RawData, LUT_master)

data1=[];
for i = 1:160 % Loop to assign values to data1 and change format
    data1(i,1)=str2num(RawData.cond1{i});
    data1(i,2)=str2num(RawData.resp1{i});
end
    
data1_sort=sortrows(data1,'ascend'); % sort ascending to match LUT

% d prime for Expt 1
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
        subj_data1 = [array2table(data1_sort(start:final,2)),LUT_master(start:final,2)]; %operations only on one mode
        
        % Calculate hits
        sour_trials = subj_data1(table2array(subj_data1(:,2))==1,:);% find sour trials
        denominator=size(sour_trials,1);
        hits_temp=sum(table2array(sour_trials(:,1))==table2array(sour_trials(:,2)))/denominator; % Add up how many things in column 1 are equal column 2
    
        if hits_temp==1
            hits_temp =.99;
        end
                
        if hits_temp==0
            hits_temp =.01;
        end
             
        hits(j)=hits_temp;
         
        % Calculate false alarms
        correct_trials = subj_data1(table2array(subj_data1(:,2))==2,:); % find correct trials
        denominator=size(correct_trials,1);
        FAs_temp=sum(table2array(correct_trials(:,1))~=table2array(correct_trials(:,2)))/denominator; % Add up how many things in column 1 are NOT equal to column 2
        
        if FAs_temp==1
            FAs_temp =.99;
        end
                
        if FAs_temp==0
            FAs_temp =.01;
        end
             
        FAs(j)=FAs_temp; 
    end
        
    
d_prime1 = norminv(hits)-norminv(FAs);

