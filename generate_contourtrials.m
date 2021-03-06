% Final script to generate contour trials
% Generates 5 tones for a pair of melody contours, identical or different
% Added rms normalization
% Pitch shifts the second melody by half an octave
% UNADDRESSED - Saving a lot of intermediate files - consider deleting the first merged copy 

rng('shuffle');

for i = 1:20
    dirname=num2str(i);
    dir=['/Users/jacob/Desktop/audiofiles/ContourTrials4_11192021/Set',dirname];
    mkdir(dir);
    
    cd(dir); 
    lookup_data=[];
    
    for sample = 1:40
        
        melody = randsample([1 -1], 4, 1);
        note_to_change = randsample(2:3, 1);
        sample_num=num2str(sample); 
        
        if rem(sample,2) == 0 % Even samples are same 
           condition = 2;; 
        else
           condition =1;
        end
        %condition = randsample([1,2],1)
 
        if condition ==1 % ref and second are different
            melody2 = melody;
            melody2(note_to_change) = -melody2(note_to_change);
        else
            melody2 = melody; % ref and second are the same 
        end
 
        ref = [0, cumsum(melody)];
        second = [0, cumsum(melody2)];

        frequencies =[220.00, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88, 523.25];
        which_f0=randi([1 8]) % We want the reference F0 between A3-E4
        half_oct_f0=(which_f0 + 6) % We want the second F0 half an octave, i.e. 6 half-steps above reference F0.
        
        Fzero_num=frequencies(which_f0);
        Fzero_num_halfoct=frequencies(half_oct_f0);
        
        ref_tones = GenerateTones_v1(ref, Fzero_num);
        second_tones=GenerateTones_v1(second, Fzero_num_halfoct);

        lookup_data=[lookup_data; sample, condition];

        ref_filename=['trial_',sample_num,'_ref.wav'];
        second_filename=['trial_',sample_num,'_second.wav'];
        fs=44100;

%Writing the ref and second audio files
        audiowrite(ref_filename,ref_tones,fs);
        audiowrite(second_filename,second_tones,fs);
        
% Read files, merge them, and write merged file
        audio1=audioread(ref_filename);
        audio2=audioread(second_filename);
        merged_data = [audio1; zeros(fs * 1.5, size(audio1, 2)); audio2];
        merged_file=['trial_',sample_num,'_merged.wav'];
        audiowrite(merged_file, merged_data, fs);
        
% Read merged file, rms normalize, write rms norm file
        ampMax = 0.05;
        rms_file=['trial_',sample_num,'_merged_rms.wav'];
        pause(0.1);
        output=rmsnorm(audioread(merged_file));
        pause(0.1);
        audiowrite(rms_file, output, fs);
    end

    T=array2table(lookup_data); % Some jugaad to get the array of strings in a writable form
    writetable(T,['LookupFileOrder_major.csv']);
    clear T lookup_data;

end