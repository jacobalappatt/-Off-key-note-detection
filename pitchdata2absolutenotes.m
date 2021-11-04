% Convert pitch map to tones
%expects csv data of pitch track information output from
%Tony/SonicVisualizer

%Removes frequencies under 65Hz to prevent Tanpura interference in Tony's
%melody extraction
    %csv_data = csvread('insertcsvname.csv');
    %csv_data_filtered=csv_data; 
   %csv_data_filtered=csv_data;
   %indices = find(abs(csv_data)<65);
   %csv_data_filtered(indices) = NaN;
   %csv_data_filtered(any(isnan(csv_data_filtered), 2), :) = [];
   %csvwrite('C:\Users\Jacob_ASUS2018\Desktop\SHBT\McDermott\Bhairavi Data\BhoolGayeSanwariyaMohe_filtered_freq.csv',csv_data_filtered)
   
   
   
function NotesData = pitchdata2absolutenotes(csv_data,out_path_filename) % Here, csv_data is expecting a path, not an csvread object
data=csvread(csv_data);

Tones=[];
for i = 1:length(data)
T = freq2tone(data(i,2));
Tones=[Tones, T];
end

Tones_transposed=transpose(Tones);

Notes={};
for i = 1:length(Tones_transposed)
N = music.tone2note(Tones_transposed(i));
Notes=[Notes, N];
end

Notes_transposed=transpose(Notes);
Notes_absolute = regexprep(Notes_transposed,'[\d"]','');
xlswrite(out_path_filename,Notes_absolute);
