% Originally named ExperimentRun1_11152021 - renamed on 11182021
% Generate 20 sets of each category/mode, with 40 samples in each - 20 good, 20 bad.

for i = 1:20
    dirname=num2str(i);
    dir=['/Users/jacob/Desktop/audiofiles/ExperimentRun4_12062021/Set',dirname];
    mkdir(dir);
    
    cd(dir); 
    wrapper_MajMel
    
    
    wrapper_MinMel
    
   % Switching out bhairavi for Poorvi in StimSet v4
    %wrapper_BhairaviMel 
    wrapper_PoorviMel
   
    wrapper_OctMel
end
