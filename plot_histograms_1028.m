% Script to test if Malinda's original script is working
% Generates melodies, saves them to array, and plots note histogram


n=16;
sour=-1; % we don't want to sour anything here
scale_degree_soured = 5;

MEL=[];
for i = 1:1000
    melody = make_newmel_sour_FromMalinda_changedmodes(n, sour, scale_degree_soured);
    MEL=[MEL; melody]
end

MEL_unwrapped=MEL(:);
figure=histogram(MEL_unwrapped,'BinLimits',[-12,24])
title('Octatonic Mode note profile - 1000 samples');
xlabel('Semitone number: 0 is tonic')
ylabel('Note count');
