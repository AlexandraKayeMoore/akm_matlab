function clear_ST_files(dataDir)

clc
cd(dataDir)

fprintf('\n\n  Are you *sure* you want to delete all %.0f daqout',...
    length(dir('*.mat')))
fprintf('\n  files in ''%s''?',dataDir)

prompt=sprintf('\n\n  Type ''delete'' to confirm, or ''cancel'' to abort: ');
strIn=input(prompt,'s');

if strcmp(strIn,'delete')
   dfiles=dir('*.mat');
   for f=1:length(dfiles)
       delete(dfiles(f).name);
   end
   close all
   fprintf('\n  -- files cleared--\n\n')
end
