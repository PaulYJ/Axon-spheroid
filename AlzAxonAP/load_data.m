% load_data.m
%
% reads in data from simple_axon into a matrix
%
% results(simulation_number (1-3960), 1:3 parameter values for CanDiam,
% Strength, AxonDiam; 4 number of output APs, 5 time of input AP, 6 time of
% output AP)
%
% The results can then be mined for graphing
% This program assumes that you run it above a list of folders that
% contains the dat data files results of the simple_axon program

folders={'active/' 'passive/' 'sealed/'};

for f_index=1:length(folders)
    wildcardfilename=[folders{f_index} '*OutputAPtimes*'];
    disp(['Processing ' num2str(f_index) '/' num2str(length(folders)) ': ' wildcardfilename])
    output_time_files = dir(wildcardfilename);
    
    results=zeros(length(output_time_files), 6);
    
    for index=1: length(output_time_files)
        tmpfilename=output_time_files(index).name;
        % tmpcell=strsplit(tmpfilename, '_');
        tmpcell=regexp(tmpfilename, '_','split');
        results(index, 1) = eval(tmpcell{2});
        results(index, 2) = eval(tmpcell{4});
        results(index, 3) = eval(tmpcell{6});
        cmd = ['a=load(''' folders{f_index} tmpfilename ''');'];
        eval(cmd);
        tmpstring=tmpfilename(1:end-4);
        if length(tmpstring)>63
            tmpstring = tmpstring(1:63); % max length of variable name in matlab is 63 characters
        end
        % new method assigns a in above load statement on lines 29/30
        %tmpstring = strrep(tmpstring, '.', '_'); % replace dots with underbars for a variable name
        %cmd = ['a = ' tmpstring ';'];
        %eval(cmd); % use matrix name 'a' that is easier to manipulate
        results(index, 4) = length(a);
        inputfilename=strrep(tmpfilename, 'Output', 'Input');
        cmd = ['b=load(''' folders{f_index} inputfilename ''');'];
        eval(cmd);
        % new method loads b in above load command rather than below
%         tmpstring=inputfilename(1:end-4);
%         if length(tmpstring)>63
%             tmpstring = tmpstring(1:63); % max length of variable name in matlab is 63 characters
%         end
%         tmpstring = strrep(tmpstring, '.', '_'); % replace dots with underbars for a variable name
%         cmd = ['b = ' tmpstring ';'];
%         eval(cmd); % use matrix name 'b' that is easier to manipulate
        if length(b)>0
            results(index, 5) = b(1);
        end % use the pre-assigned results(index,5) time of zero for cases where there are no input APs (length(b)==0)
        if length(a)>0
            results(index, 6) = a(1);
        end % use the pre-assigned results(index,6) time of zero for cases where there are no output APs (length(a)==0)
    end
    
    % now assign a folder based matrix name to results
    matrixprefix=[folders{f_index}];
    matrixname=[matrixprefix(1:end-1) '_results'];
    cmd=[matrixname '=results;'];
    eval(cmd)
end
