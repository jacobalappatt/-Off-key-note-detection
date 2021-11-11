% Wrapper to generate bhairavi melodies
% Uses a modified script to sour 1 and 5 by adding 2 semitones

n = 16;  % #notes
type={1,-1};

% Originaly created the note profile from pieces
% Tweaked it to reduce the tonic, increase minor 2nd and perf 4th. See Rotation Notes

%mode = double([0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.115, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.115, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.115]);
mode = double([0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.17, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.17, 0, 0.07, 0, 0.183, 0, 0.184, 0.076, 0, 0.037, 0, 0.192, 0.17]);


for i = 1:length(type) % Loop for sour and not-sour respectively
    sour = type{i};
    
    for sample = 1:20 % We want 20 of each type condition, per mode

        degrees = {1,5};
        scale_degree_soured = degrees{randi([1 2])}; % Malinda has data about the effect of scale degree souring. Currently doing this randomly, but if there is an actual effect we should sour  1 and 5 equally in the stimulus sample set
    
        if type{i} == 1
            type_name='sour';
        else
            type_name='notsour';
        end
        
        % Generating melody and sometimes souring it
        melody =  make_newmel_sour_Bhairavi(n, sour, scale_degree_soured, mode)
        
        % Setting F0 to the melody
        full_melody = GenerateTones_v1(melody, 264);
        
        scale_degree_soured_num=num2str(scale_degree_soured);
        sample_num=num2str(sample);
        
       % Writing files
        fs=44100; % sampling in Hz
        filename=['/Users/jacob/Desktop/audiofiles/bhairavi/bhairavi_',type_name,'_scaledegree',scale_degree_soured_num,'_sample',sample_num,'.wav']
        audiowrite(filename,full_melody,fs);
        
    end
end