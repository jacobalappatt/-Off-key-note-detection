% Wrapper to generate Major/Ionian melodies

n = 16;  % #notes
type={1,-1};
% Key Profile changed so 0 probability on off scale notes
% Original data from Van Essen - see make_newmel_sour_Jacob_FromMalinda.m
mode =  double([0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055, 0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055,0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055, 0.184,  0.000]);
 
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
        melody =  make_newmel_sour_Jacob(n, sour, scale_degree_soured, mode)
        
        % Setting F0 to the melody
        full_melody = GenerateTones_v1(melody, 264);
        
        scale_degree_soured_num=num2str(scale_degree_soured);
        sample_num=num2str(sample);
        
       % Writing files
        fs=44100; % sampling in Hz
        filename=['C:\Users\Jacob_ASUS2018\Desktop\SHBT\McDermott\audiofiles\major\major_',type_name,'_scaledegree',scale_degree_soured_num,'_sample',sample_num,'.wav']
        audiowrite(filename,full_melody,fs);
        
    end
end
