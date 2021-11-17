% script to concatenate the generated contour trials and save new directory.
fs=44100;

for i = 1:20
    dirname=num2str(i);
    dir=['/Users/jacob/Desktop/audiofiles/ContourTrials2_11172021/Set',dirname];
    dirout=['/Users/jacob/Desktop/audiofiles/ContourTrials2_11172021_CONCAT/Set',dirname];
    mkdir(dirout);
    cd(dir); 
    
    for sample = 1:40
        sample_num=num2str(sample);
        ref_filename=[dir,'/trial_',sample_num,'_ref.wav'];
        second_filename=[dir,'/trial_',sample_num,'_second.wav'];
        
        audio1=audioread(ref_filename);
        audio2=audioread(second_filename);
        
        merged_wav = [audio1; zeros(fs * 1.5, size(audio1, 2)); audio2];
        
        cd(dirout);
        merged_filename=[dirout,'/trial_',sample_num,'_merged.wav'];
        audiowrite(merged_filename,merged_wav,fs);
        
    end
end

