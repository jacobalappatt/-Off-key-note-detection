function full_melody = GenerateTones_v1(melody, starting_f0)

% Basic script to take a melody vector and make tones

sr = 44100;
tone_dur = 400; %ms
spectral_slope = -14; %dB/octave attenuation in frequency domain % -14 
ramp_dur = 10; %ms half Hanning window  % 10
num_harm = 12; % how many harmonics  % 12
env_const = 4; % decay constant of 4s^-1   %4

% loop through melody 
full_melody = [];
for n = 1:length(melody)
    chord=[];
    f0_root = starting_f0*2^(melody(n)/12);
     ct = [];
     % loop through harmonics of each tone 
    for h=1:num_harm
       t = tone(f0_root*h,tone_dur,0,sr); 
        t = scale(t,spectral_slope*log2(h));
        ct = zadd(ct,t); % add harmonic to previous harmonics
    end
    ct = hann(ct,ramp_dur,sr); % apply hanning window to entire tone
    chord = ct; % rename for historical reasons (harmonic stack)

% add decay
x=[1:round((tone_dur./1000)*sr)]/sr; 
env = exp(-env_const*x); % calculate amplitude envelope 
chord = chord.*env; % Apply amplitude envelope 

full_melody = [full_melody, chord]; % add note to full melody 
end
end
