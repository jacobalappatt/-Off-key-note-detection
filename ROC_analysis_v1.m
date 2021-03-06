% First attempt at doing ROC analysis 

% Currently does:
% Calculation of percent corr for exp 1 & exp 2
% Calculation of d' for exp1. 
% Plots of percent correct using all data and filtered data

clear all
path3 = sprintf('%s', 'Run*RawData.mat');
full = dir(path3);
full_list = (char(full.name));
PER_CORR=[];


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
    
    data1=[];
    for trial = 1:160 % Loop to assign values to data1 and change format
        data1(trial,1)=str2num(RawData.cond1{trial});
        data1(trial,2)=str2num(RawData.resp1{trial});
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
        
% criterion 1: - 1 maps to 1, 2/3/4 maps to 2
        % Calculate hits
        sour_trials = subj_data1(table2array(subj_data1(:,2))==1,:);% find sour trials
        denominator=size(sour_trials,1);
        criterion1=[]; %Create new response column for calculations
        for k=1:size(sour_trials)
            if table2array(sour_trials(k,1)) == 1
                criterion1(k,1) = 1;
            end
            if table2array(sour_trials(k,1)) == 2
                criterion1(k,1) = 2;
            end
            if table2array(sour_trials(k,1)) == 3
                criterion1(k,1) = 2;
            end
            if table2array(sour_trials(k,1)) == 4
                criterion1(k,1) = 2;
            end
        end
        
        hits_temp1=sum(criterion1(:,1)==table2array(sour_trials(:,2)))/denominator; % Add up how many things in column 1 are equal column 2
    
        if hits_temp1==1
            hits_temp1 =.99;
        end
                
        if hits_temp1==0
            hits_temp1 =.01;
        end
             
        hits1(i,j)=hits_temp1;
         
        % Calculate false alarms
        correct_trials = subj_data1(table2array(subj_data1(:,2))==2,:); % find correct trials
        denominator=size(correct_trials,1);
        criterion1=[];
        for k=1:size(correct_trials)
            if table2array(correct_trials(k,1)) == 1
                criterion1(k,1) = 1;
            end
            if table2array(correct_trials(k,1)) == 2
                criterion1(k,1) = 2;
            end
            if table2array(correct_trials(k,1)) == 3
                criterion1(k,1) = 2;
            end
            if table2array(correct_trials(k,1)) == 4
                criterion1(k,1) = 2;
            end
        end
        FAs_temp1=sum(criterion1(:,1)~=table2array(correct_trials(:,2)))/denominator; % Add up how many things in column 1 are NOT equal to column 2
        
        if FAs_temp1==1
            FAs_temp1 =.99;
        end
                
        if FAs_temp1==0
            FAs_temp1 =.01;
        end
             
        FAs1(i,j)=FAs_temp1; 
    
        
     
% criterion 2: - 1/2 maps to 1, 3/4 maps to 2
    % Calculate hits
        sour_trials = subj_data1(table2array(subj_data1(:,2))==1,:);% find sour trials
        denominator=size(sour_trials,1);
        criterion2=[]; %Create new response column for calculations
        for k=1:size(sour_trials)
            if table2array(sour_trials(k,1)) == 1
                criterion2(k,1) = 1;
            end
            if table2array(sour_trials(k,1)) == 2
                criterion2(k,1) = 1;
            end
            if table2array(sour_trials(k,1)) == 3
                criterion2(k,1) = 2;
            end
            if table2array(sour_trials(k,1)) == 4
                criterion2(k,1) = 2;
            end
        end
        
        hits_temp2=sum(criterion2(:,1)==table2array(sour_trials(:,2)))/denominator; % Add up how many things in column 1 are equal column 2
    
        if hits_temp2==1
            hits_temp2 =.99;
        end
                
        if hits_temp2==0
            hits_temp2 =.01;
        end
             
        hits2(i,j)=hits_temp2;
         
        % Calculate false alarms
        correct_trials = subj_data1(table2array(subj_data1(:,2))==2,:); % find correct trials
        denominator=size(correct_trials,1);
        criterion2=[];
        for k=1:size(correct_trials)
            if table2array(correct_trials(k,1)) == 1
                criterion2(k,1) = 1;
            end
            if table2array(correct_trials(k,1)) == 2
                criterion2(k,1) = 1;
            end
            if table2array(correct_trials(k,1)) == 3
                criterion2(k,1) = 2;
            end
            if table2array(correct_trials(k,1)) == 4
                criterion2(k,1) = 2;
            end
        end
        FAs_temp2=sum(criterion2(:,1)~=table2array(correct_trials(:,2)))/denominator; % Add up how many things in column 1 are NOT equal to column 2
        
        if FAs_temp2==1
            FAs_temp2 =.99;
        end
                
        if FAs_temp2==0
            FAs_temp2 =.01;
        end
             
        FAs2(i,j)=FAs_temp2;

% criterion 3: - 1/2/3 maps to 1, 4 maps to 2
        % Calculate hits
        sour_trials = subj_data1(table2array(subj_data1(:,2))==1,:);% find sour trials
        denominator=size(sour_trials,1);
        criterion3=[]; %Create new response column for calculations
        for k=1:size(sour_trials)
            if table2array(sour_trials(k,1)) == 1
                criterion3(k,1) = 1;
            end
            if table2array(sour_trials(k,1)) == 2
                criterion3(k,1) = 1;
            end
            if table2array(sour_trials(k,1)) == 3
                criterion3(k,1) = 1;
            end
            if table2array(sour_trials(k,1)) == 4
                criterion3(k,1) = 2;
            end
        end
        
        hits_temp3=sum(criterion3(:,1)==table2array(sour_trials(:,2)))/denominator; % Add up how many things in column 1 are equal column 2
    
        if hits_temp3==1
            hits_temp3 =.99;
        end
                
        if hits_temp3==0
            hits_temp3 =.01;
        end
             
        hits3(i,j)=hits_temp3;
         
        % Calculate false alarms
        correct_trials = subj_data1(table2array(subj_data1(:,2))==2,:); % find correct trials
        denominator=size(correct_trials,1);
        criterion3=[];
        for k=1:size(correct_trials)
            if table2array(correct_trials(k,1)) == 1
                criterion3(k,1) = 1;
            end
            if table2array(correct_trials(k,1)) == 2
                criterion3(k,1) = 1;
            end
            if table2array(correct_trials(k,1)) == 3
                criterion3(k,1) = 1;
            end
            if table2array(correct_trials(k,1)) == 4
                criterion3(k,1) = 2;
            end
        end
        FAs_temp3=sum(criterion3(:,1)~=table2array(correct_trials(:,2)))/denominator; % Add up how many things in column 1 are NOT equal to column 2
        
        if FAs_temp3==1
            FAs_temp3 =.99;
        end
                
        if FAs_temp3==0
            FAs_temp3 =.01;
        end
             
        FAs3(i,j)=FAs_temp3;  
    end
    
    
    % Filter using Percent correct
per_cor2= calculate_performance2(RawData, LUT_master);
    
PER_CORR=[PER_CORR;per_cor2];
end
    
idx=and(PER_CORR > 80,2);

%Plotting and calculating area under curve after getting array of FAs and
%hits
f1=figure
hold on;
x=[0;mean(FAs1(:,1));mean(FAs2(:,1));mean(FAs3(:,1));1]
y=[0;mean(hits1(:,1));mean(hits2(:,1));mean(hits3(:,1));1]
scatter(x,y)
hold on;
ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title('ROC curve for sensitivity - Major')

x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_major.jpg')

close(f1)

f2=figure
hold on;
x=[0;mean(FAs1(:,2));mean(FAs2(:,2));mean(FAs3(:,2));1]
y=[0;mean(hits1(:,2));mean(hits2(:,2));mean(hits3(:,2));1]
scatter(x,y)
hold on;
ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title('ROC curve for sensitivity - Minor')


x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_minor.jpg')

close(f2)
trapz(x1,y1)

f3=figure
hold on;
x=[0;mean(FAs1(:,3));mean(FAs2(:,3));mean(FAs3(:,3));1]
y=[0;mean(hits1(:,3));mean(hits2(:,3));mean(hits3(:,3));1]
scatter(x,y)
hold on;
ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title('ROC curve for sensitivity - Poorvi')


x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_Poorvi.jpg')

close(f3)
trapz(x1,y1)

f4=figure
hold on;
x=[0;mean(FAs1(:,4));mean(FAs2(:,4));mean(FAs3(:,4));1]
y=[0;mean(hits1(:,4));mean(hits2(:,4));mean(hits3(:,4));1]
scatter(x,y)
hold on;
ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title(['ROC curve for sensitivity' condition])


x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_octatonic.jpg')

close(f4)
trapz(x1,y1)

% Do the same with per_corr_pass data
f5=figure
hold on;
x=[0;mean(FAs1(idx,1));mean(FAs2(idx,1));mean(FAs3(idx,1));1]
y=[0;mean(hits1(idx,1));mean(hits2(idx,1));mean(hits3(idx,1));1]
scatter(x,y)
hold on;


ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title('ROC curve for sensitivity - Major')

x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
errorbar(mean(y1), std(y1)./sqrt(sum(idx)), '.k')
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_major_CatchPass.jpg')

close(f5)

f6=figure
hold on;
x=[0;mean(FAs1(idx,2));mean(FAs2(idx,2));mean(FAs3(idx,2));1]
y=[0;mean(hits1(idx,2));mean(hits2(idx,2));mean(hits3(idx,2));1]
scatter(x,y)
hold on;
ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title('ROC curve for sensitivity - Minor')


x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_minor_CatchPass.jpg')

close(f6)
trapz(x1,y1)

f7=figure
hold on;
x=[0;mean(FAs1(idx,3));mean(FAs2(idx,3));mean(FAs3(idx,3));1]
y=[0;mean(hits1(idx,3));mean(hits2(idx,3));mean(hits3(idx,3));1]
scatter(x,y)
hold on;
ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title('ROC curve for sensitivity - Poorvi')


x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_Poorvi_CatchPass.jpg')

close(f7)
trapz(x1,y1)

f8=figure
hold on;
x=[0;mean(FAs1(idx,4));mean(FAs2(idx,4));mean(FAs3(idx,4));1]
y=[0;mean(hits1(idx,4));mean(hits2(idx,4));mean(hits3(idx,4));1]
scatter(x,y)
hold on;
ylim([0 1])
xlim([0 1])   
xlabel('mean false alarm rate')
ylabel('mean hit rate')
title(['ROC curve for sensitivity' condition])


x1=x;
p=polyfit(x,y,4);
y1=polyval(p,x1);
plot(x1,y1)
annotation('textbox', [0.15, 0.8, 0.3, 0.1], 'FontSize', 15, 'FitBoxToText','on', 'String', ["area = " num2str(round(trapz(x1,y1),2))])

box on;
saveas(gcf,'ROC_octatonic_CatchPass.jpg')

close(f8)
trapz(x1,y1)
 