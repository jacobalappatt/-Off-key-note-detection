% Own analysis script for Expt 1
% Returns a 4x1 double array

% Usage : performance1= calculate_performance2(RawData, LUT_master) 
function performance2= calculate_performance2(RawData, LUT_master)

PC2=[];
data2=[];
for i = 1:40
    data2(i,1)=str2num(RawData.cond2{i});
    data2(i,2)=str2num(RawData.resp2{i});
end
    
data2_sort=sortrows(data2,'ascend');

correct=0;
for i=1:40
    response=data2_sort(i,2);
    answer=double(LUT_master{i,2});
    if response == answer
        correct=correct + 1;
    end
    
end

performance2=correct/40 * 100;