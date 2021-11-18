% Wrapper to generate bhairavi melodies
% Uses a modified script to sour 1 and 5 by adding 2 semitones

n = 16;  % #notes
type={1,-1};
MEL=[]; %Stack to store all melodies for rejection sampling
% Originaly created the note profile from pieces
% Tweaked it to reduce the tonic, increase minor 2nd and perf 4th. See Rotation Notes

%mode = double([0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.115, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.115, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.115]);
FILES=[];
mode = double([0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.17, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.17, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.17]);
rng('shuffle'); 

    
for sample = 81:120 % We want 20 of each type condition, per mode
        if rem(sample,2) == 0 % Even samples are sour 
            type_name='sour';
            sour=1;
        else
            type_name='not_sour';
            sour=-1;
        end 
        
        degrees = {1,5};
        scale_degree_soured = degrees{randi([1 2])}; % Malinda has data about the effect of scale degree souring. Currently doing this randomly, but if there is an actual effect we should sour  1 and 5 equally in the stimulus sample set
    
       
        
        % Generating melody and sometimes souring it
        melody =  make_newmel_sour_Bhairavi(n, sour, scale_degree_soured, mode);
           
            
        % Setting F0 to the melody
        frequencies =[220.00, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63];
        Fzero_num=frequencies(randi([1 8]));
        full_melody = GenerateTones_v1(melody, Fzero_num);
        
        scale_degree_soured_num=num2str(scale_degree_soured);
        sample_num=num2str(sample);
        Fzero=num2str(Fzero_num);
       
        % Writing files
        fs=44100; % sampling in Hz
        filename=['sample',sample_num,'_type',type_name,'_scaledegree',scale_degree_soured_num,'_freq',Fzero];
        stim_name=['trial_',sample_num,'.wav']; 
        rms_name=['trial_',sample_num,'_rms.wav']; % Actual stimulus file name
        FILES=[FILES, convertCharsToStrings(filename)]; % For lookup table
       
        % RMS normalization to 0.05
        ampMax = 0.05;
        pause(0.5);
        audiowrite(stim_name,full_melody,fs)
        pause(0.5);
        output = rmsnorm(audioread(stim_name)); % Malinda's script
        pause(0.5);
        audiowrite(rms_name,output,fs);
        
end

T=array2table(FILES'); % Some jugaad to get the array of strings in a writable form
writetable(T,['LookupFileOrder_bhairavi.csv']);
clear T FILES;
