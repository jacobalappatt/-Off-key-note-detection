% 
% Add F0 jitter. Use array and select F0s randomly. Pass to tone generation.
% Generate 20 sets of each category, with 40 samples in each - 20 good, 20 bad.

for i = 1:20
    dirname=num2str(i);
    dir=['/Users/jacob/Desktop/audiofiles/ExperimentRun1_11152021/Set',dirname];
    mkdir(dir);
    
    cd(dir); 
    wrapper_MajMel
    
    
    wrapper_MinMel
    
   
    wrapper_BhairaviMel
    
   
    wrapper_OctMel
end

