% Wrapper to generate Octatonic melodies

n = 16;  % #notes
type={1,-1};

% Original data from scales_from_marcus, a word doc passed to me by Josh

mode =  double([0, .7, .5, 0, .7, .4, 0, .4, .4, 0, .8, .5, 0, .7, .5, 0, .7, .4, 0, .4, .4, 0, .8, .5, 0, .7, .5, 0, .7, .4, 0, .4, .4, 0, .8, .5]);
 
for i = 1:length(type) % Loop for sour and not-sour respectively
    sour = type{i};
    
    for sample = 1:20 % We want 20 of each type condition, per mode

        degrees = {1,5};
        scale_degree_soured = degrees{randi([1 2])};
    
        if type{i} == 1
            type_name='sour';
        else
            type_name='notsour';
        end
        
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
        filename=['octatonic_',type_name,'_scaledegree',scale_degree_soured_num,'_sample',sample_num,'_freq_',Fzero,'.wav']
        audiowrite(filename,full_melody,fs);
        
    end
end
