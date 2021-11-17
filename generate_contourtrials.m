% Second script to generate contour trials
% First script was deleted so I removed the upload from mindhive and
% replaced it with these trials. Committed to Git repo on 11/17/2021. 

for i = 1:20
    dirname=num2str(i);
    dir=['/Users/jacob/Desktop/audiofiles/ContourTrials2_11172021/Set',dirname];
    mkdir(dir);
    
    cd(dir); 
    lookup_data=[];
    for sample = 1:40
        
    
   
melody = randsample([1 -1], 4, 1);
note_to_change = randsample(2:3, 1);
sample_num=num2str(sample); 
condition = randsample([1,2],1)
 
if condition ==1 % ref and second are different
  melody2 = melody;
  melody2(note_to_change) = -melody2(note_to_change);
else
  melody2 = melody; % ref and second are the same 
end
 
ref = [0, cumsum(melody)];
second = [0, cumsum(melody2)];

frequencies =[220.00, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63];
Fzero_num=frequencies(randi([1 8]));
ref_tones = GenerateTones_v1(ref, Fzero_num);
second_tones=GenerateTones_v1(second, Fzero_num);

lookup_data=[lookup_data; sample, condition];

ref_filename=['trial_',sample_num,'_ref.wav'];
second_filename=['trial_',sample_num,'_second.wav'];
fs=44100;
%merged_wav = [ref_tones; zeros(fs * 1.5, size(ref_tones, 2)); second_tones]; % https://www.mathworks.com/matlabcentral/answers/318452-how-can-i-merge-to-wav-files-with-a-pause-of-3-seconds-between-them

% RMS normalization to 0.05
        ampMax = 0.05;
        ref_output = ampMax*ref_tones/rms(ref_tones);
        second_output = ampMax*second_tones/rms(second_tones);
        audiowrite(ref_filename,ref_output,fs);
        audiowrite(second_filename,second_output,fs);
end

T=array2table(lookup_data); % Some jugaad to get the array of strings in a writable form
writetable(T,['LookupFileOrder_major.csv']);
clear T lookup_data;

end