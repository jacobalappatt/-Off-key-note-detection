% Wrapper to generate Major/Ionian melodies

n = 16;  % #notes
type={1,-1}; % sour and not sour, respectively
% Key Profile changed so 0 probability on off scale notes
% Original data from Van Essen - see make_newmel_sour_Jacob_FromMalinda.m
FILES=[];
mode =  double([0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055, 0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055,0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055, 0.184,  0.000]);
 

    
for sample = 1:40 % We want 20 of each type condition
        
        if rem(sample,2) == 0 % Even samples are sour 
            type_name='sour';
        else
            type_name='not_sour';
        end     

        degrees = {1,5};
        scale_degree_soured = degrees{randi([1 2])};
        
        % Generating melody and sometimes souring it
        melody =  make_newmel_sour_Jacob(n, sour, scale_degree_soured, mode);
        
        % Setting F0 to the melody
        frequencies =[220.00, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63];
        Fzero_num=frequencies(randi([1 8]));
        full_melody = GenerateTones_v1(melody, Fzero_num);
        
        scale_degree_soured_num=num2str(scale_degree_soured);
        sample_num=num2str(sample);
        Fzero=num2str(Fzero_num);
        
        scale_degree_soured_num=num2str(scale_degree_soured);
        sample_num=num2str(sample);
        
       % Writing files
        fs=44100; % sampling in Hz
        filename=['sample',sample_num,'_type',type_name,'_scaledegree',scale_degree_soured_num,'_freq',Fzero];
        stim_name=['trial_',sample_num,'.wav']; % Actual stimulus file name
        FILES=[FILES, convertCharsToStrings(filename)]; % For lookup table
       
        audiowrite(stim_name,full_melody,fs);
        
end
T=array2table(FILES'); % Some jugaad to get the array of strings in a writable form
writetable(T,['LookupFileOrder_major.csv']);
clear T FILES;
