% 
% Add F0 jitter. Use array and select F0s randomly. Pass to tone generation.
% Generate 20 sets of each category, with 40 samples in each - 20 good, 20 bad.

for i = 1:20
    dirname=num2str(i);
    dir=['/Users/jacob/Desktop/audiofiles/ExperimentRun1_11152021/Set',dirname];
    mkdir(dir);
    
    %Create directory for octatonic, and write files
    cd(dir); 
    mkdir octatonic;
    cd octatonic;
    wrapper_OctMel
    
    cd(dir); 
    mkdir minor;
    cd minor;
    wrapper_MinMel
    
    cd(dir); 
    mkdir major;
    cd major;
    wrapper_MajMel
    
    cd(dir); 
    mkdir bhairavi;
    cd bhairavi;
    wrapper_BhairaviMel
    
end

