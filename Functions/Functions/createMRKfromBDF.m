% Create MRK files from BDF files
% Programmed by MDP
% Update: 03.2019
% =========================================================================
%
% createMRKfromBDF.m
%
% INPUTS
% - Folder containing the BDF files
%
% OUTPUTS
% - A Cartool MRK file for each BDF file.
%
% FUNCTION CALLED
% - open_bdf.m
%
% As simple as that...
%
% Updated by H. Najberg & C. Wicht (02.04.2019)
% =========================================================================

clear all
%% Select files

% Path of your upper folder containing your data
root_folder = uigetdir('title',...
    'Choose the path of your most upper folder containing the photodiode test BDF files');

extension = 'RVIP.bdf';
cd(root_folder)
FileList = dir(['**/*' extension]);

count_error = 0;
CountError = 0;

eeglab
close gcf

%% RETRIEVE EVENTS INFORMATION

for file = 1:length(FileList)
    openfilename = [FileList(file).folder,'\',FileList(file).name];

    EEG = pop_biosig(openfilename);
    if ~isempty(EEG.event)

        MRKonset = [EEG.event.latency];
        MRKname = [EEG.event.type];
        
        %% CODE TO CHANGE MARKERS
        
        % Copy original data
        NewMRKname=MRKname;
        
        % Sometimes a 205 is insterted after a 200 since the port is not
        % closed yet
        PortErrorIdx=find(MRKname==205);
        for k=1:length(PortErrorIdx)
            if MRKname(PortErrorIdx(k)-1)==200
                NewMRKname(PortErrorIdx(k))=5;
            end
        end
        
        % Double check to be sure that all 205 were replaced
        p=1;
        PortErrorIdx = find(NewMRKname==205);
        if ~isempty(PortErrorIdx)
            ErrorLog{p}=sprintf('the file "%s" contains %d times the "205" marker\n',openfilename,length(PortErrorIdx));
            p=p+1;
            CountError=CountError+1;
        end

        % It seems that the marker 22 is in fact a 6, hence I replace them
        NewMRKname(NewMRKname==22)=6;
        
        % This code finds where the participant made a HIT (trigger 5)
        % If it happened up to 1800ms after the last stim of a sequence
        % (200), the numbers are replaced as following:
        % 2 -> 25, 20 -> 205, 200 -> 2005
        % This will allow differentiate HITs from MISS
        HitsIdx = find(NewMRKname==5);
        for k=1:length(HitsIdx)
            
           if MRKname(HitsIdx(k)-1)==200 && MRKname(HitsIdx(k)-2)==20 && ...
                   MRKname(HitsIdx(k)-3)==2
               NewMRKname(HitsIdx(k)-1)=2005;
               NewMRKname(HitsIdx(k)-2)=205;
               NewMRKname(HitsIdx(k)-3)=25;
               
           elseif MRKname(HitsIdx(k)-2)==200 && MRKname(HitsIdx(k)-3)==20 && ...
                   MRKname(HitsIdx(k)-4)==2
               NewMRKname(HitsIdx(k)-2)=2005;
               NewMRKname(HitsIdx(k)-3)=205;
               NewMRKname(HitsIdx(k)-4)=25;
               
           elseif MRKname(HitsIdx(k)-3)==200 && MRKname(HitsIdx(k)-4)==20 && ...
                   MRKname(HitsIdx(k)-5)==2
               NewMRKname(HitsIdx(k)-3)=2005;
               NewMRKname(HitsIdx(k)-4)=205;
               NewMRKname(HitsIdx(k)-5)=25;
           end
        end

        % save data
        disp(['writing marker file for ' openfilename]);
        MRKfid = fopen([openfilename,'.mrk'],'w');
        fprintf(MRKfid,'%s\r\n','TL02');
        fprintf(MRKfid,'%d\t%d\t%d\r\n',vertcat(MRKonset,MRKonset,NewMRKname));
        fclose(MRKfid);
    else
        count_error = count_error +1;
        error_log(count_error+1,1) = {openfilename};
    end
end

disp('Finished :)')

%% Log 

if nnz(count_error) || nnz(CountError)
      
    cd(root_folder)
    date_name = datestr(now,'dd-mm-yy_HHMM');
    
    % Creating the error log
    fid = fopen(['errorlog_' date_name '.txt'],'w');
    fprintf(fid,'%s\r\n',['The following ' mat2str(count_error) ' .bdf files did not have loadable events:']);
    fprintf(fid,'\t%s\r\n', error_log{:});
    fprintf(fid,'%s\r\n','The following files still contain unexplained markers:');
    fprintf(fid,'\t%s\r\n',ErrorLog{:});
    fclose(fid);

    % Display a warning message
    opts = struct('WindowStyle','modal','Interpreter','tex');
    message = [{['\fontsize{12}' num2str(count_error) ' .bdf file(s) did not have loadable events.']};{'Check the log.'}];
    warndlg(message,'.mrk Importation Error',opts)

end

