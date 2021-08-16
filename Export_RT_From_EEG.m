
%% Export RT from EEG by using ERPLAB
% Author:Jingqing Nian
% Email:nianjingqing@126.com
% School of Psychology,Guizhou Normal University
% V1.0 2021.08.16

%% close gui & clear workspace & clear command
close all;
clear all;
clc;

%% open EEGLAB
eeglab;

%% Parameters
% File & Data Path

Homepath = 'H:\Yangrun\';
EEGpath =[Homepath 'EEG\'];
RTpath =[Homepath 'Behavior\From_EEG\'];
Codepath =[Homepath 'Script\'];

% Subject 

sub ={'S1001','S1002'};

for i =1:length(sub)
    
    Subname = sub{i} (1:end);
    Sname = [EEGpath 'Post_ICA\' Subname '_Post_ICA' '.set'];
    
    if exist (Sname,'file')<=0 %
       % Whether the file exists.If it does not exist,skip it.If it does exist, proceed to the next steps.
       fprintf('\n *** WARING:%s does not exit ***\n',Sname);
       fprintf ('\n *** Skip all Processing for this subject *** \n');
    else
        % Import data 
        EEG = pop_loadset('filename',[sub{i} '_Post_ICA' '.set'],'filepath',[EEGpath '\Post_ICA\']);
        % Create EEG Eventlist
        EEG = pop_editeventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',[Codepath 'Event_Code.txt'], 'SendEL2', 'EEG' );
        % Overwrite EEG Eventlist
        EEG = pop_overwritevent( EEG, 'code'  ); 
        % Assign bins(BINLISTER) 
        EEG = pop_binlister( EEG , 'BDF', [Codepath '\Bin_List.txt'], 'IndexEL',1, 'SendEL2','EEG', 'Voutput','EEG' ); 
        % Save RT data from EEG
        values = pop_rt2text(EEG, 'arfilter', 'on', 'eventlist',  1, 'filename', [RTpath Subname '.xls'], 'header', 'on', 'listformat','itemized' );  
    end
end
