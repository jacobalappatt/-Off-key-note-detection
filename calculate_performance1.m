% Own analysis script for Expt 1
% Returns a 4x1 double array

% Usage : performance1= calculate_performance1(RawData, LUT_master) 
function performance1= calculate_performance1(RawData, LUT_master)

PC1=[];
data1=[];
for i = 1:160 % Loop to assign values to data1 and change format
    data1(i,1)=str2num(RawData.cond1{i});
    data1(i,2)=str2num(RawData.resp1{i});
end
    
data1_sort=sortrows(data1,'ascend'); % sort ascending to match LUT

correct=0;
per_cor1=0;
for i=1:40 % Loop through Major, compare answers, add to 'correct'
    response=data1_sort(i,2);
    answer=double(LUT_master{i,2});
    if response == answer
        correct=correct + 1;
    end
    
end
per_cor1=correct/40 * 100;
PC1=[PC1; per_cor1];

correct=0;
per_cor1=0;
for i=41:80
    response=data1_sort(i,2);
    answer=double(LUT_master{i,2});
    if response == answer
        correct=correct + 1;
    end
    
end
per_cor1=correct/40 * 100;
PC1=[PC1; per_cor1];

correct=0;
per_cor1=0;
for i=81:120
    response=data1_sort(i,2);
    answer=double(LUT_master{i,2});
    if response == answer
        correct=correct + 1;
    end
    
end
per_cor1=correct/40 * 100;
PC1=[PC1; per_cor1];

correct=0;
per_cor1=0;
for i=121:160
    response=data1_sort(i,2);
    answer=double(LUT_master{i,2});
    if response == answer
        correct=correct + 1;
    end
    
end

per_cor1=correct/40 * 100;
PC1=[PC1; per_cor1];

performance1=PC1;