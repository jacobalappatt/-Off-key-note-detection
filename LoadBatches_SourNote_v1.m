% Script to extract familiarity ratings


clear all

Bnames = {'Batch_4612166_batch_results','Batch_4613886_batch_results','Batch_4613270_batch_results','Batch_4617286_batch_results'}

%WorkerID_all is a cell array of worker IDs to exclude (1 column x n rows)

%%
z = 0;
n_paid = 0;
ind_w = 0;

for b =1:length(Bnames);
    Batch = strcat(Bnames{b},'.csv')
    
    Batch_number = sprintf('Run%d',b)
    
    
    
    
    data = csv2cell(Batch,'fromfile');  % you may need to download csv2cell
    n_workers = (length(data(:,1))-1);  % number of workers total
    
    AssignmentID = data(2:length(data(:,1)),15);
    WorkerID = data(2:length(data(:,1)),16);
    Passed_HC = data(2:length(data(:,1)),50); % Column 50 is just a data column from the main task (0 if blank)
    
    for worker = 1:n_workers
        worker
        %cond_indiv = [];
        % resp_indiv = [];
        if Passed_HC{worker,:} > 0
            ind_w = ind_w+1;
            
            n_paid = n_paid+1;
            
            for j = 44:54% columns to look in
                if strcmp(sprintf('Answer.WhichStimSet1'), data{1,j})
                    
                    randStim1(ind_w,1)  = data(worker+1, j);
                end
                if strcmp(sprintf('Answer.WhichStimSet2'), data{1,j})
                    
                    randStim2(ind_w,1)  = data(worker+1, j);
                end
                
                
                if strcmp('Answer.condnum_for_expt_1_',data{1,j})
                    temp1 = split(data(worker+1, j), '|');
                    cond_indiv1(ind_w,:) = temp1;  
                end
                % end
                
                  
                if strcmp('Answer.condnum_for_expt_2_',data{1,j})
                    temp1 = split(data(worker+1, j), '|');
                    cond_indiv2(ind_w,:) = temp1;  
                end
                
                
                %   for j = 43:74
                if strcmp('Answer.Resp_for_expt_1', data{1,j})
                   temp1 = split(data(worker+1, j), '|');
                    resp_indiv1(ind_w,:) = temp1;  
                    
                end
                
                if strcmp('Answer.Resp_for_expt_2', data{1,j})
                    temp1 = split(data(worker+1, j), '|');
                    resp_indiv2(ind_w,:) = temp1;  
                    
                end
                
                if strcmp('Answer.RespFamiliarity_for_expt_1', data{1,j})
                   temp1 = split(data(worker+1, j), '|');
                    resp_familiarity1(ind_w,:) = temp1;  
                    
                end
                
 
            end
            
            
            
            if strcmp(data(worker+1, 42),'musician')==1
                X = '1';
            else
                X = '0';
            end
            
           % Edited becayse yrs_music_training is at 58, not 56. ASK
           % MALINDA 11/28/2021
           % for j = 52:56
           for j = 52:57
                if strcmp('Answer.yrs_music', data{1,j})
                    
                    Y = data(worker+1,j);
                    
                end
                if strcmp('Answer.yrs_music_training', data{1,j})
                    
                    Z = data(worker+1,j);
                    
                end
            end
            RawData.musician = {X;Y;Z};
            
            Age = data(worker+1, 37);
            Sex = data(worker+1, 36);
            
            RawData.demo = {Age;Sex};
            RawData.cond1 =[ cond_indiv1(ind_w, :)'];
            
            RawData.resp1 = [resp_indiv1( ind_w, :)'];
            RawData.cond2 =[cond_indiv2(ind_w, :)'];
            
            RawData.resp2 = [resp_indiv2( ind_w, :)'];
            RawData.resp_familiarity1 = [resp_familiarity1( ind_w, :)'];
            
            RawData.stim1 = randStim1';
            RawData.stim2 = randStim2';
            
            RawData.worker = WorkerID{worker};
           
            
            
            fname = sprintf('%s_%d_%s%s', Batch_number, worker, 'RawData', '.mat');
            save(fname, 'RawData');
            
            
            
        end
    end
    n_paid
    
end