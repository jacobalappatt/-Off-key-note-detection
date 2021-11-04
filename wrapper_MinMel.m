% Wrapper to generate Minor melodies

n = 16;  % #notes
type={1,-1};
% Key Profile changed so 0 probability on off scale notes
% Original data from Van Essen - see make_newmel_sour_Jacob_FromMalinda.m
mode = double([0.149, 0.179, 0, 0.144, 0, 0.201, 0.038, 0, 0.053,	0, 0.192, 0, 0.149, 0.179, 0, 0.144, 0, 0.201, 0.038, 0, 0.053,	0, 0.192, 0, 0.149, 0.179, 0, 0.144, 0, 0.201, 0.038, 0, 0.053,	0, 0.192, 0]);

for i = 1:length(type) % Loop over 1 and -1 for sour and not-sour respectively
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
        melody = make_newmel_sour_Jacob(n, sour, scale_degree_soured, mode)
        
        % Setting F0 to the melody
        full_melody = GenerateTones_v1(melody, 264)
        
        scale_degree_soured_num=num2str(scale_degree_soured);
        sample_num=num2str(sample);
        
       % Writing files
        fs=44100; % sampling in Hz
        filename=['C:\Users\Jacob_ASUS2018\Desktop\SHBT\McDermott\audiofiles\minor\minor_',type_name,'_scaledegree',scale_degree_soured_num,'_sample',sample_num,'.wav']
        audiowrite(filename,full_melody,fs);
        
    end
end
