function [ melody ] = make_newmel_sour_Jacob(n, sour, scale_degree_soured, mode)
% Function designed to generate a melody and then sour scale degree 1, 3,
% or 5. Makes a melody using range profile, proximity profile and key
% profiles according to the Temperley 2008 model.

%Sets starting note as either 67, 68 or 69 (gets removed in the final step
%so melody starts at 0)

% Based on code from David Temperley 

%% Parameters
% n = number of notes - Should be 16 for experiment, but could be anything >4;
% mode = double list input, to be normalized.
% sour = 1 or -1 (1 for sour note, -1 for no sour note);
% scale degree soured = 1, 3, 5

%  VERY IMPORTANT - FROM MALINDA 11/01/21
%Modes should be passed such that the distribution begins on the second
% note of the scale. Needs to match notes generated from 58:93 with 68 as
% 0, the tonic center.

final = 1; %Final melody
while final == 1
    
    %% Choose a starting note and corresponding key profile
        note1 = 68;
        
        a = 58:1:57+(12*3);
        mode_normalized = (mode./sum(mode)); % normalize so sum is 1 

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
        
        
        
        A = [a', mode_normalized', y', z'] ;
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
        if isempty(find(rem((melody1(n-3:n-1)-melody1(1)),12)==0)) % if remainder is 0, it means we have that scale degree in the final 3 notes
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
