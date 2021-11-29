for set1 = 1:20
set_number=num2str(set1);    
file=['/Users/jacob/Desktop/audiofiles/ExperimentRun3_11292021/Set',set_number,'/LookupFileOrder_minor.csv']
data=csv2cell(file, 'fromfile');

NewLookup=[];
for i=2:41 %Skip header
    sour_cond=contains(data(i),'not_sour')
    degree_cond=contains(data(i),'scaledegree5')
    
    if sour_cond == 1 % file contains 'not_sour'. All such files are not sour. 
        NewLookup = [NewLookup; 2];
    end
    
    if sour_cond == 0 % Not all 'soured files' are actually sour
        if degree_cond == 0
            NewLookup = [NewLookup; 1]; % All degree1 that's sour, is sour
        end
        if degree_cond == 1 
            NewLookup = [NewLookup; 2]; % degree5 that's sour, is actually not sour.
        end
    end
    
end

LUT_master=readtable('/Users/jacob/Desktop/audiofiles/ExperimentRun2_11182021/LUT_MASTER.csv');

% Write final tables in each Set directory. Use that table in analysis script. 11/28/2021
LUT_FINAL=[];

segment1=[LUT_master(1:40,1), LUT_master(1:40,2)];
segment2=[LUT_master(41:80,1), array2table(NewLookup(1:40))];
segment3=[LUT_master(81:160,1), LUT_master(81:160,2)];

LUT_FINAL=[ table2array(segment1); table2array(segment2); table2array(segment3) ];


writematrix(LUT_FINAL, ['/Users/jacob/Desktop/audiofiles/ExperimentRun3_11292021/Set',set_number,'/LookupMaster_Corrected.csv'])


end

