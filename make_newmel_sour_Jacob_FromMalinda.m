function [ melody ] = make_newmel_sour_Jacob(n, sour, scale_degree_soured)
% Function designed to generate a melody and then sour scale degree 1, 3,
% or 5. Makes a melody using range profile, proximity profile and key
% profiles according to the Temperley 2008 model.

%Sets starting note as either 67, 68 or 69 (gets removed in the final step
%so melody starts at 0)

% Based on code from David Temperley 

%% Parameters
%n = number of notes - Should be 16 for experiment, but could be anything >4;
%
% mode = 1 or 0 for major or minor. - parameter removed for this experiment
% because we are only using major. Minor key profiles are commented out
% below
%
% sour = 1 or -1 (1 for sour note, -1 for no sour note);
%
% scale degree soured = 1, 3, 5

% mode = 1 for major, 2 for minor
% n = number of notes

% Original key profiles from Essen Collection
%major_key_profile =  double([0.184,  0.001,  0.155,  0.003,  0.191,  0.109,  0.005,  0.214,  0.001,  0.078,  0.004,  0.055,0.184,  0.001,  0.155,  0.003,  0.191,  0.109,  0.005,  0.214,  0.001,  0.078,  0.004,  0.055, 0.184,  0.001,  0.155,  0.003,  0.191,  0.109,  0.005,  0.214,  0.001,  0.078,  0.004,  0.055]);
%minor_key_profile =  double([0.192,  0.005,  0.149,  0.179,  0.002,  0.144,  0.002,  0.201,  0.038,  0.012,  0.053,  0.022, 0.192,  0.005,  0.149,  0.179,  0.002,  0.144,  0.002,  0.201,  0.038,  0.012,  0.053,  0.022, 0.192,  0.005,  0.149,  0.179,  0.002,  0.144,  0.002,  0.201,  0.038,  0.012,  0.053,  0.022]);

% Key Profile changed so 0 probability on off scale notes
%major_key_profile =  double([0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055,0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055,0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055]);
%Major key profile (3 octaves) has been changed to remove possibility of sour notes.
%Only notes in the major scale have any probability of occurring.

%major = (major_key_profile./sum(major_key_profile)); %Normalize

%minor = (minor_key_profile./sum(minor_key_profile));

%choose key key ==1, major, key ==2,

final = 1; %Final melody
while final == 1
    
    %% Choose a starting note and corresponding key profile
        note1 = 68;
        major_key_profile =  double([0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055,0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055,0.184,  0.000,  0.155,  0.000,  0.191,  0.109,  0.000,  0.214,  0.000,  0.078,  0.00,  0.055, 0.184,  0.000]);
        %Major key profile (3 octaves) has been changed to remove possibility of sour notes.
        %Only notes in the major scale have any probability of occurring.
        a = 58:1:57+(12*3);
        major = (major_key_profile./sum(major_key_profile)); % normalize so sum is 1 

    melody1 = [note1, zeros(1,n-1)]; % Setting note1 to be the tonic center. 
    
    %% Designate Parameters for Range Profile
    mu = 68; %From Essen Collection
    sigma = 10.6; %From essen collection
    % Designate parameters for Proximity Profile
    sigma_prox = 7.2; %Should be 7.2 to follow Essen Data, not used in this
    % code because proximity profile is reduced to -+5 steps
    
    %% Generate Melody
    for i = 2:1:n
        
        %range profile
        % Derived from Essen model
        pd = makedist('Normal',mu,sigma); %Probability distribution
        c_1 = 58:1:57+(12*3); %Taken from Temperley Model
        y = pdf(pd,c_1); %Returns probability density function
        
        
        prev_note = melody1(i-1);
        
        
        %Proximity profile - adjusted as melody is developed
        pdz = makedist('Uniform','upper', prev_note+5, 'lower', prev_note-5); %7.2 derived from Essen data, changed to -5 (P4) in McPherson & McDermott, 
        pd = makedist('Normal',prev_note,sigma_prox);
        c_1 = 58:1:93; %Range of notes
        z_1 = pdf(pdz,c_1);
        z_1(find(z_1~=0))=1;
        z_2 = pdf(pd, c_1);
        z = z_1.*z_2;
        %Set probability of being previous note to 0;
        ind = find(a==prev_note);
        z(ind) =0;
        
        z = z/sum(z); %Normalize
        
        
        
        A = [a', major', y', z'] ;
        B = prod(A(:,2:4), 2);
        
        Bprime = B./(sum(B))';
        seq = datasample(A(:,1), 1, 'Weights', Bprime);
        note = [seq];
        melody1(i) = note;
    end
    
    %%
    %Make selected note sour - scale degree 1 (melody1(1)), scale degree 3
    %(melody1(1)+4), and scale degree 5 (melody1(1)+7;
    
    %If there does not need to be a sour note, make sure there is the equivalent scale degree in the final 4 notes.
    if sour ==-1 && scale_degree_soured==1
        if isempty(find(rem((melody1(n-3:n-1)-melody1(1)),12)==0))
            final =1;
        else
            final = 0;
        end
        
        
    elseif sour ==-1 &&  scale_degree_soured==3
        if isempty(find(rem((melody1(n-3:n-1)-(melody1(1)+4)),12)==0))
            final =1;
        else
            final = 0;
        end
        
    elseif sour ==-1 && scale_degree_soured==5
        if isempty(find(rem((melody1(n-3:n-1)-(melody1(1)+7)),12)==0))
            final =1;
        else
            final = 0;
        end
        
    elseif sour ==1 && scale_degree_soured==1 %Make a sour note
        if isempty(find(rem((melody1(n-3:n-1)-melody1(1)),12)==0))
            final = 1;
        else
            indices = find(rem((melody1(n-3:n-1)-melody1(1)),12)==0);
            ind = indices(1);
            melody1(ind+(n-4)) = melody1(ind+(n-4))+1;
            final = 0;
            
        end
    elseif sour ==1 && scale_degree_soured==3
        
        if isempty(find(rem((melody1(n-3:n-1)-(melody1(1)+4)),12)==0))
            final = 1;
        else
            indices = find(rem((melody1(n-3:n-1)-(melody1(1)+4)),12)==0);
            ind = indices(1);
            melody1(ind+(n-4)) = melody1(ind+(n-4))+2;
            final = 0;
            
        end
    elseif sour ==1 && scale_degree_soured==5
        
        if isempty(find(rem((melody1(n-3:n-1)-(melody1(1)+7)),12)==0))
            final = 1;
        else
            indices = find(rem((melody1(n-3:n-1)-(melody1(1)+7)),12)==0);
            ind = indices(1);
            melody1(ind+(n-4)) = melody1(ind+(n-4))+1;
            final = 0;
            
        end
    elseif sour ~=1||-1 &&scale_degree_soured~=1||3||5 
        error('Unrecognized sour note or scale degree parameter');
    end
end

melody = melody1-melody1(1);
