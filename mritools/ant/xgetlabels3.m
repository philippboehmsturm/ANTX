



% function [Stat, excvec] = xgetlabels(files, hemisphere,type, templatepath)
function [z] = xgetlabels3(showgui,x)
warning off;

if 0
    
    x.filetag='x_t2'
    x.masktag='x_hemi'
    
    xgetlabels3(1,x)
    
    xgetlabels3(0,  struct( 'filetag','x_hemi','masktag','x_hemi'))
    
    xgetlabels3(0,  struct( 'files',{'O:\TOMsampleData\study1\dat\s20150909_FK_C2M10_1_3_1\test.nii'},'masktag',''))
end

%����������������������������������������������������������������������������������������������������

if exist('showgui')~=1;  showgui=1; end
if exist('x')~=1;        x=[]; end
if isempty(x); showgui=1; end
%����������������������������������������������������������������������������������������������������

pa=antcb('getsubjects');
v=getuniquefiles(pa);

p={...
    'inf98'      '*** ALLEN LABELING                 '                         '' ''
    'inf99'      'USE EITHER APPROACH-1 OR APPROACH-2'                         '' ''
    'inf100'     '==================================='                          '' ''
    'inf1'      '% APPROACH-1 (fullpathfiles: file/mask)          '                                    ''  ''
    'files'      ''                                                           'files used for calculation' ,  {@selectfile,v,'single'} ;%'mf'
    'masks'      ''                                                           '<optional> maskfiles (order is irrelevant)', {@selectfile,v,'single'} % ,'mf' ...
    %
    'inf2'      '% APPROACH-2 (use filetags)' ''  ''
    'filetag'      ''   'matching stringpattern of filename' ,''
    'masktag'      ''   '<optional> matching stringpattern of masksname (value=1 is usef for inclusion)' ,''
    'hemisphere' 'both'     'calculation over [left,right,both] hemisphere' {'left','right','both'}
    
    'inf3'      '% OTHER PARAMETERS ' ''  ''
    'threshold'    0     'lower threshold value (when files without masks are used) otherwise leave empty [] ' {'' 0}
    'space'    'allen'   'calculation in {allen,native} space '      {'allen' 'native'}
    
    %
    'inf4'      '% PARAMETERS TO EXTRACT' ''  ''
    'frequency'    1     'frequency [n-voxels] within Allen structure' 'b'
    'percOverlapp' 1     'percent overlapp between MASK and Allen structure' 'b'
    'volref'          1  'volume [qmm] of Allen structure (REFERENCE)'       'b'
    'vol'          1     'volume [qmm] of masked Allen structure'           'b'
    'mean'         1     'mean over values within structure' 'b'
    'std'          1     'standard deviation over values within structure' 'b'
    'median'       1     'median over values within structure' 'b'
    'min'          1     'min value within structure' 'b'
    'max'          1     'max value within structure' 'b'
    };


p=paramadd(p,x);%add/replace parameter



%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.5 .3 .3 .5 ],...
        'title','LABELING','info',hlp);
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


 
   

%����fill parameters   �������������������������������������������������������������������������������
global an



%% fullpath-files -check sanity for files and masks
if ~isempty(z.files)
    if ischar(z.files);  z.files=cellstr(z.files); end
    
    if ~isempty(z.masks)
        if ischar(z.masks);  z.masks=cellstr(z.masks); end
        files={};
        for i=1:length(z.masks)
            patx=fileparts(z.masks{i});
            id=~cellfun('isempty',strfind(z.files,patx));
            if ~isempty(id)
                files(end+1,:)=[z.files(id) z.masks(i)  ];
            end
        end
        z.files=files(:,1);
        z.masks=files(:,2);
        files=files(:,1); %copy to use maskfiletag for fullpath stuff
    end
end


%% FILETAG
if ~isempty(z.filetag)
    paths=antcb('getsubjects');
    vcheck=[];
    files={};
    for i=1:length(paths)
        [fi,dirs] = spm_select('FPList',paths{i},z.filetag);
        if ~isempty(fi)
            files{i,1}=fi  ;
            vcheck(i,1)=1;
        else
            files{i,1}='';
            vcheck(i,1)=0;
        end
    end
    files(vcheck==0)=[];
    z.files=files;
end

%% MASK
if ~isempty(z.masktag)
    vcheck=[];
    for i=1:length(files)
        [fi,dirs] = spm_select('FPList',fileparts(files{i}),z.masktag);
        if ~isempty(fi)
            files{i,2}=fi  ;
            vcheck(i,1)=1;
        else
            vcheck(i,1)=0;
        end
    end
    
    idtake=find(vcheck==1)    ;
    if isempty(idtake)
        error('no masks found');
    end
    z.files=files(idtake,1)   ;
    z.masks=files(idtake,2)   ;
end




%����������������������������������������������������������������������������������������������������
%�����������������������������������������������
%% NATIVE-SPACE: CHECK EXISTENCE OF FIBT and MASK 
%�����������������������������������������������

if strcmp(z.space,'native')
    
    for i=1:length(z.files)
        pas=fileparts(z.files{i});
        
        % FIBT-FILE
        fibfile=fullfile(pas,'ix_FIBT.nii');
        if exist(fibfile)~=2
            disp(['..transform [FIBT.nii] to native space']);
            fibfile0=fullfile(pas,'FIBT.nii');
            if exist(fibfile0)~=2
                fibfilesource=fullfile(fileparts(fileparts(pas)),'templates','FIBT.nii');
                copyfile(fibfilesource, fibfile0,'f'); %copy FIB from templateDir to MouseDir
            end
            doelastix('transforminv'  , pas,    fibfile0 ,0,'local' );
        end
        
        % MASKFILE
        bbox=fullfile(pas,'ix_bbox.nii');
        if exist(bbox)~=2
            disp(['..create/transform [bboxVolume.nii] to native space']);
            
            
            %% CREATE LARGE BBOX-HEMI-IMAGE IN TEMPLATE-PATH (..LARGE..TO ALLOW INVERSE TRAFO)
            templpath = fullfile(fileparts(fileparts(pas)),'templates');
            f1=fullfile(templpath,'AVGTmask.nii');
            f2=fullfile(templpath,'bbox_tmp.nii');
            f3=fullfile(templpath,'bbox.nii');
            
          if exist(f3)~=2
                midline=82;           % MIDLINE make LEFT/RIGHT-MASK: orig 82
                [hc c]=rgetnii(f1);
                % c(1:midline,:,:)   = c(1:midline,:,:).*1;
                % c(midline+1:end,:,:) = c(midline+1:end,:,:).*2;
                c(1:midline,:,:)     =  1;
                c(midline+1:end,:,:) =  2;
                rsavenii(f2,hc,c);
                
                [bb vx] = world_bb(f2);
               % bb2=[-10 -10 -15; 10 10 5];
               % bb2=[-15 -20 -15; 15 15 10];
                bb2=[-13 -13 -25; 15 10 10];
                resize_img5(f2,f3, vx, bb2, [],0); %extend bounding box to allow warping to native Space
                try;             delete(f2); end
                
                %% fill entire volume with hemispheric-code [1,2]
                [hd d]=rgetnii(f3);
                ds=squeeze(d(:,:,round(size(d,3)/2)));%plane
                dl=ds(:,round(size(ds,2)/2)); % midline line
                df=interp1(find(dl>0), dl(find(dl>0)),  [1:length(dl)],'nearest','extrap'); %filld
                d2=repmat(df(:),[1 size(d,2) size(d,3)]);
                rsavenii(f3,hd,d2);
             end
            
            doelastix('transforminv'  , pas,    f3 ,0,'local' );
            
            
            %    [hd d]=rgetnii(f3);
            %fg,imagesc(squeeze(hem(:,:,end))) 
             
%             disp(['..create/transform [bboxHemi.nii] to native space']);
%             amaskfile0=fullfile(pas,'AVGTmask.nii');
%             if exist(amaskfile0)~=2
%                 amaskfilesource=fullfile(fileparts(fileparts(pas)),'templates','AVGTmask.nii');
%                 copyfile(amaskfilesource, amaskfile0,'f'); %copy FIB from templateDir to MouseDir
%             end
%             midline=82;
%             [hc c]=rgetnii(amaskfile0);
% %             c(1:midline,:,:)   = c(1:midline,:,:).*1;
% %             c(midline+1:end,:,:) = c(midline+1:end,:,:).*2;
%             c(1:midline,:,:)     =  1;
%             c(midline+1:end,:,:) =  2;
%             
%             amaskfilehemi0=fullfile(pas,'AVGTHemi.nii');
%             rsavenii(amaskfilehemi0,hc,c);
%            doelastix('transforminv'  , pas,    amaskfilehemi0 ,0,'local' )
        end %BOXIMAGE EXIST
    end % FILES
end %NATIVE


if strcmp(z.space,'native')
    chk=[];
    for i=1:length(z.files)
        pas=fileparts(z.files{i});
        anofile{i,1}=fullfile(pas,'ix_ANO.nii');
        if exist(anofile{i,1})==2
            chk(i)=1;
        else
            chk(i)=0;
        end
    end
    is=find(chk==1);
    %keep only those files
    z.files  =z.files(is);
    z.anofile=anofile(is);
    if ~isempty(z.masks)
        z.masks=z.masks(is);
    end
    
    
end

%����������������������������������������������������������������������������������������������������








% return

format compact;




if exist('templatepath')
    if isdir(templatepath)
        useTemplatepath=1;
    end
else
    useTemplatepath=0;
end



disp(['..extract ALLEN-ATLAS ...']);


%����������������������������������������������������������������������������������������������������
xx = load('gematlabt_labels.mat');
[table idxLUT] = buildtable(xx.matlab_results{1}.msg{1});
network= {};

%����������������������������������������������������������������������������������������������������

%
% homefolder:     O:\matlabToolsFreiburg\allen\
% Compfile:  [1x54 char]    [1x62 char]
% hemisphere:   'Both'
% ,type: 4
% ,network: {}

% if 0
%     disp('paul hack:  BrAt_BrowseAtlas_fcn_paul ')
%     % load atlas
%     AVGT = nifti(fullfile(homefolder,'wAVGT.nii')); AVGT = double(AVGT.dat);
%     ANOstruct = nifti(fullfile(homefolder,'wANO.nii')); ANO = double(ANOstruct.dat);
%     FIBT = nifti(fullfile(homefolder,'wFIBT.nii')); FIBT = double(FIBT.dat);
% end
%size:     165   230   135
%% ���������� hack   paul������������������������������������������������������������������������������������������


if strcmp(z.space,'allen')==1
    if useTemplatepath==0
        [pathx s]=antpath;
        avg0=stradd(s.avg,'s',1);
        ano0=stradd(s.ano,'s',1);
        fib0  =stradd(s.fib,'s',1);
    else %studyTemplatePath given as input
        avg0=fullfile(templatepath,'AVGT.nii');
        ano0=fullfile(templatepath,'ANO.nii');
        fib0=fullfile(templatepath,'FIBT.nii');
        disp(' ......use MOUSE''s local templates');
    end
    
    avg = nifti(avg0);
    avg = double(avg.dat);
    
    anostruct = nifti(ano0);
    ano       = double(anostruct.dat);
    
    fib = nifti(fib0);
    fib       = double(fib.dat);
end

%% replacex
clear files
for ii=1:length(z.files)
    
    Compfile=z.files(ii);
    disp([ '[' pnum(ii,3) '] .. reading ' Compfile{1} ]);
    
    if strcmp(z.space,'allen')==1
        AVGT=avg;
        ANO=ano;
        ANOstruct=anostruct;
        FIBT =fib;
    else
        ano0=z.anofile{ii};
        anostruct = nifti(ano0);
        ano       = double(anostruct.dat);
        ANO=ano;
        
        fib0=fullfile(fileparts(z.files{ii}),'ix_FIBT.nii') ;%FIBFILE IN NATIVE
        fibstruct = nifti(fib0);
        FIBT       = double(fibstruct.dat);
    end
    %����������������������������������������������������������������������������������������������������
    if ~isempty(z.masks)
        Maskfile=z.masks{ii};
    else
        Maskfile='';
    end
    
    COL = buildColLabeling(ANO,idxLUT);
    
    %����������������������� hack2  paul �����������������������������������������������������������������������������
    % if not(strcmp(Compfile,'nocomp'))
    %     fprintf('Working on Volumes..')
    %     actmap = BrAt_resliceActmap(Compfile,ANOstruct);
    % end
    
    %     for i=1:length(Compfile)
    %         [h,dum ]=rreslice2target(Compfile{1}, ano0, [], 0);
    %         actmap(:,:,:,i)=dum;
    %     end
    
    hcom=spm_vol(Compfile{1});
    hano=spm_vol(ano0);
    
    %     if sum((hcom.dim-hano.dim).^2)==0 %% SAME SIZE
    %         [hh actmap]=  rgetnii(Compfile{1});
    %
    %     else
    [hh actmap]=    rreslice2target(Compfile{1}, ano0, [], 0);
    %actmap=ones(size(actmap));%check of full label structure
    
    %% MASK OR SET THRESHOLD
    if ~isempty(Maskfile)
        [hm maskmap]=    rreslice2target(Maskfile, ano0, [], 0);
        maskmap(maskmap~=1)=nan;
        actmap=actmap.*(maskmap);
    else
        if ~isempty(z.threshold)
            actmap(actmap<=z.threshold)=nan;
        end
    end
    
    %         disp('...reslize necessary...')
    %     end
    
    % actmap=double(actmap>-.1);
    %����������������������������������������������������������������������������������������������������
    % threshold of activation map intensity
    threshold = 0.0003;
    
    %%%Relations from Set Theory: A = activation, L = atlas label
    % type == 1 :  rankscore = |A cap L| / |A|
    % type == 2 :  rankscore = |A cap L| / |L|
    % type == 3 :  rankscore = |A cap L| / |A cup L|
    % type == 4 :  rankscore = |A cap L|
    % type = 2; % Sortierung
    
    % volume of activation area weighted by t-value
    weighted = true;
    %      weighted = false;
    
    % size of region ranking
    rN = 25;
    
    % area coloring blending
    calpha = 0.2;
    
    z.hemisphere=lower(z.hemisphere);
    
    if strcmp(z.space,'allen')
        %�����������������������������������������������
        %%   ALLEN
        %�����������������������������������������������
        %Hemisphere
        if strcmp(z.hemisphere,'left')==1
            %         ANO2 = ANO; ANO2(:,86:end,:) = 0;
            %         FIBT2 = FIBT; FIBT2(:,86:end,:) = 0;
            
            ANO2  = ANO;   ANO2(83:end,:,:)   = 0;
            FIBT2 = FIBT;  FIBT2(83:end,:,:)  = 0;
            
            hem=ones(size(ANO2)); %hemiMask
            hem(83:end,:,:)=0;
            
            
        elseif strcmp(z.hemisphere,'right')==1
            %         ANO2 = ANO; ANO2(:,1:85,:) = 0;
            %         FIBT2 = FIBT; FIBT2(:,1:85,:) = 0;
            
            ANO2  = ANO;   ANO2(1:82,:,:) = 0;
            FIBT2 = FIBT; FIBT2(1:82,:,:) = 0;
            
            hem=ones(size(ANO2)); %hemiMask
            hem(1:82,:,:)=0;
        else
            ANO2 = ANO; z.hemisphere = 'both';
            FIBT2 = FIBT;
            
            hem=ones(size(ANO2)); %MASK
        end
        ANO2(isnan(ANO)) =0;
        FIBT2(isnan(ANO))=0;
        
        % compute region sizes for annotations
        idxLUT = BrAt_ComputeAreaSize(idxLUT,ANO2,FIBT2);
        
        % flip and permute to get right anatomical view
        perm = @(x) flipdim(permute(x(:,1:3:end,:,:),[3 1 2 4]),1);
        AVGT = perm(AVGT);
        COL = perm(COL);
        
        luts.info = idxLUT; % create lookup table
    else
        %�����������������������������������������������
        %%   NATIVE
        %�����������������������������������������������
        
        [hhem hem]=rgetnii(fullfile(fileparts(z.files{ii}),'ix_bbox.nii'));
        if strcmp(z.hemisphere,'left')==1          
            hem(hem==2) =0; %set Right-Side_to_ZERO
            ANO2        = ANO.*hem;
            FIBT2       = FIBT.*hem;  
        elseif strcmp(z.hemisphere,'right')==1
            hem(hem==1) = 0; %set Left-Side_to_ZERO
            hem(hem==2) =1; %set Right-Side_to_ONE
            ANO2        = ANO.*hem;
            FIBT2       = FIBT.*hem;  
        else
            ANO2         = ANO; %z.hemisphere = 'Both';
            FIBT2        = FIBT;
            z.hemisphere = 'both';
            
            hem=ones(size(ANO2)); %MASK
        end
        ANO2(isnan(ANO))=0;
        FIBT2(isnan(ANO))=0;
        
        
        % compute region sizes for annotations
        idxLUT = BrAt_ComputeAreaSize(idxLUT,ANO2,FIBT2);
        luts.info = idxLUT; % create lookup table
        
        
        
%         %% ORIG
%         ANO2=ANO;
%         idxLUT = BrAt_ComputeAreaSize(idxLUT,ANO2,ANO2.*0);
%         luts.info = idxLUT; % create lookup table
        
    end
    
    
    [id idshort]=getFileID(Compfile{1}); % GET FILE-ID
    p1=getvalues(luts,ANO2,hano,actmap,z); %EXTRACT VALUES -ANO
    
    
    %% MAKE DATABASE (w-struct)
    if exist('FIBT2')==1
        p2=getvalues(luts,FIBT2,hano,actmap,z); %EXTRACT VALUES-FIBT
        
        w.info='label x subj x param, with FIBT';
        tab=[p1.params(:,1:986) p2.params(:,987:end)]';
        w.params(1:size(tab,1),ii,:)=tab;
        w.labels   = [p1.label(1:986) ;p2.label(987:end)] ;
        
    else %NO FIBT
        w.info='label x subj x param, no-FIBT';
        tab=[p1.params(:,1:end)]';
        w.params(1:size(tab,1),ii,:)=tab;
        w.labels   = [p1.label(1:end)] ;
    end
    w.id{ii}              =id;
    w.idshort{ii}         =idshort;
    w.paramname=p1.paramname;
    w.colorhex ={luts.info.color_hex_triplet};
    
    
    %% add 'imageWithMask' in LABELS
    hem(hem==0)=nan;
    vals2=actmap.*hem;

    s  =stats(vals2(:),z,hano); %treshIMG
    s2 =stats(hem(:),z,hano);   %
     
%     'frequency'       [    211175]
%     'percOverlapp'    [   16.1114]
%     'vol'             [1.0559e+03]
%     'volref'          [6.5536e+03]
%     'mean'            [  105.0729]
%     'std'             [  152.0912]
%     'median'          [    2.9860]
%     'min'             [3.1284e-26]
%     'max'             [  780.3038]
%      return
     

     
     labnum=size(tab,1)+1;
     w.params(labnum,ii,:)= cell2mat(s(:,2));
     w.labels{labnum,1}  = 'BrainMasked'  ;
     w.colorhex{1,labnum}='CA254D'  ;%red --> http://www.color-hex.com/
    
     labnum=size(tab,1)+2;
     w.params(labnum,ii,:)= cell2mat(s2(:,2));
     w.labels{labnum,1}  = 'HemisphereInBBox'  ;
     w.colorhex{1,labnum}='E7D925'  ;%yellow --> http://www.color-hex.com/
     
%�����������������������������������������������
%%     %% check 
%�����������������������������������������������
   
if 0
    
    r=[squeeze(w.params(28,1,:))';
        squeeze(w.params(end-1,1,:))'
        squeeze(w.params(end ,1,:))'];
    
    try
        v = evalin('base', 'vv');
    catch
        v=[];
        v.d=[];
        v.name=w.paramname;
        assignin('base','vv',v);
        v = evalin('base', 'vv');
    end
    
    v.d=[v.d; r];
    assignin('base','vv',v);
    
    %          fg; montage_p(hem)
    
    
    return
end
     
    %����������������������������������������������������������������������������������������������������
    if 0 %FREIBURG
        if not(strcmp(Compfile,'nocomp'))
            Stat = cell(1,size(actmap,4));
            cc = 1;
            excvec = zeros(size(actmap,4),1);
            for k = 1:size(actmap,4)
                if k > 1 && size(Compfile,2)>1
                    if strcmp(Compfile{k},Compfile{k-1})
                        cc = cc+1;
                        fileseps = strfind(Compfile{k},filesep);
                        name_tmp = [Compfile{k}(fileseps(end)+1:end-4) num2str(cc)];
                        Stat{k}.compname = name_tmp;
                    else
                        cc=1;
                        fileseps = strfind(Compfile{k},filesep);
                        name_tmp = [Compfile{k}(fileseps(end)+1:end-4)];
                        Stat{k}.compname = name_tmp;
                    end
                elseif size(Compfile,2)==1
                    fileseps = strfind(Compfile{1},filesep);
                    name_tmp = Compfile{1}(fileseps(end)+1:end-4);
                    Stat{k}.compname = name_tmp;
                else
                    fileseps = strfind(Compfile{k},filesep);
                    name_tmp = Compfile{k}(fileseps(end)+1:end-4);
                    Stat{k}.compname = name_tmp;
                end
                fprintf('%s \n',Stat{k}.compname)
                
                tmpVOL = squeeze(actmap(:,:,:,k));
                type=4;
                [Stat{k}.ANO, exclusion] = showRank(luts,ANO2,tmpVOL,threshold,rN,type,weighted,z.hemisphere,network,z,hano);
                [Stat{k}.FIBT, dummy] = showRank(luts,FIBT2,tmpVOL,threshold,rN,type,weighted,z.hemisphere,network,z,hano);
                fprintf('\n');
                %excvec(k) = exclusion;
                
                %% paul
                %  lut= test_atlasreadout(tmpVOL, ANO2,idxLUT);
            end
        end
        
        
        
        st{ii}=Stat{k};
        
        %����������������������������������������������������������������������������������������������������
        %% set  folderName
        [par fir ext]=fileparts((Compfile{1}));
        [par2 foldname]=fileparts(par);
        
        if 0
            token=['20\d\d\d\d\d\d_'];
            foldname=regexprep(foldname,'^s','') ;
            foldname=regexprep(foldname,['20\d\d\d\d\d\d_'],'');
            foldname=regexprep(foldname,['20\d\d\d\d\d\d'],'');
            
            %remove params from filename
            try
                iu=strfind(foldname,'_');
                foldname=foldname(1:iu(end-2)-1);
            end
        end
        st{ii}.name=foldname;
    end %FREIBURG
    
end %ii

%����������������������������������������������������������������������������������������������������
%% SAVE EXCELSHEET
%����������������������������������������������������������������������������������������������������

resultsfolder=fullfile(fileparts(fileparts(fileparts(z.files{1}))),'results');
fileout      =fullfile(resultsfolder, [  'labels_'   z.hemisphere  '_'  timestr(1) '.xls']);
warning off;
mkdir(resultsfolder);

%fileout=fullfile(pwd,'test2.xls')
disp(['GENERATING EXCELFILE ...']);
disp(['NAME: ' fileout]);

%add info
infox=struct2list(z);
infox(regexpi2(infox,'z.inf\d'))=[];
infox=[{'*** ALLEN LABELING*** '}; infox ];

xlswrite(fileout, infox,  'INFO'   )  ;

for i=1:length(w.paramname)
    tbx=[ [{''} w.id ] ;  [{''} w.idshort ]  ;[ w.labels  num2cell(squeeze(w.params(:,:,i)) )]];
    xlswrite(fileout, tbx,  w.paramname{i}    )  ;
end


%����������������������������������������������������������������������������������������������������
%%  colorize EXCELSHEET
%����������������������������������������������������������������������������������������������������

disp('..colorize sheets');
colorizeExcelsheet(fileout,  w.colorhex);
disp('..DONE');

try
    explorerpreselect(fileout)
catch
    try
    explorer(resultsfolder) ;
    end
end

makebatch(z);

return



%
%  %����������������������������������������������������������������������������������������������������
%  % OLDER    STUFF
%  %���� hack 4 paul ������������������������������������������������������������������������������������������������
%
% if 0
%    global at;
%     at=[];
%     header={'label'};
%     if isempty(st{1}.FIBT)% no FIBT available-->copy lalbels
%         at.name=[st{1}.ANO.name(1:986)'  ;st{1}.ANO.name(987:end)'];
%     else
%         at.name=[st{1}.ANO.name(1:986)'  ;st{1}.FIBT.name(987:end)'];
%     end
%     %����������������������������������������������������������������������������������������������������
%     %% extract DATA
%     fld=           {'t1'                    't2'                't3'           't4'                     't5'                 't6'                          't4'}    ;% last entry T4 to calc volume
%     fldname=  {'perMsk'          'perBR'         't3'           'NvoxBR'          'perBR2'           'NvoxTPL'             'vol'}  ;
%
%     x=[];
%     subjectID={};
%     for j=1:length(st)
%         subjectID{1,j}=st{j}.name;
%         for ipara=1:length(fld)
%             if (isempty(st{j}.FIBT)) %NO FIBT there
%                 fdum=[  ['dum= [ st{'  num2str(j) '}.ANO.'  fld{ipara} '(1:986)'  ]  ['    st{'  num2str(j) '}.ANO.'  fld{ipara} '(987:end)    ]'';'  ]     ];
%             else
%                 fdum=[  ['dum= [ st{'  num2str(j) '}.ANO.'  fld{ipara} '(1:986)'  ]  ['    st{'  num2str(j) '}.FIBT.'  fld{ipara} '(987:end)    ]'';'  ]     ];
%             end
%             eval(fdum);
%             x(:,j, ipara)=dum;
%         end %ipara
%     end %j
%
%     %calc volume
%     x(:,:, end)  =   x(:,:, end).*abs(det(ANOstruct.mat(1:3,1:3)));
%
%     %% write XLSfile
%     warning off;
%     resultsfolder=fullfile(fileparts(fileparts(fileparts(z.files{1}))) ,'results');
%     % resultsfolder=pwd;
%     xlsfile=fullfile(resultsfolder, [  'flabels_'   z.hemisphere  '_'  timestr '.xls']);
%     mkdir(resultsfolder);
%     % xlsfile='test4.xls';
%
%     fldsave=[1: 7]; %%  VARIABLES TO SAVE in that order
%     col1=[header; at.name];
%     for i=1:length(fldsave)
%         ix=fldsave(i);
%         dat=  [            [col1]       [  subjectID  ;  num2cell((x(:,:,ix)))  ]          ];
%         xlswrite(   xlsfile        ,dat,     fldname{ix}  );
%     end
%     disp(sprintf('saves as: %s',xlsfile));
%
% end

%% functions ����������������������������������������������������������������������������������������������������

%����������������������������������������������������������������������������������������������������
%��������������������  SUBS ��������������������������������������������������������������������������
%����������������������������������������������������������������������������������������������������

function makebatch(z)

try; 
    z=rmfield(z,'anofile'); %BUGfix 
end

try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('% ������������������������������������������������������');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% #b descr:' hlp];
hh{end+1,1}=('% ������������������������������������������������������');
hh=[hh; 'z=[];' ];
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ');' ]};
% uhelp(hh,1);
try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '};{'                '}];
assignin('base','anth',v);
disp(['BATCH: <a href="matlab: uhelp(anth,1,''cursor'',''end'')">' 'show history' '</a>'  ]);



%% EXTRACT VALUES
function p=getvalues(luts,ANO,hano,actmap,z)

an=(ANO(:));
ac=actmap(:);
uni=unique(an);
uni(1)=[];
si=size(ANO);

%% get all vox-idx for all labels within ANO.nii
iv={};
for i=1:length(uni)
    ix= find(an==uni(i));
    iv{i,1}=ix;
end
% toc
%% get label and ots children from LUTS
lab=[{luts.info.id }' {luts.info.children}'];


params={};
for i=1:size(lab,1)
    %% INTERSECTION UNIQUE LABEL IN ANO AND LUTS+ITS CHILDREN
    [com a1 a2]=intersect(uni, [lab{i,1} ;lab{i,2} ]); %
    vx=iv(a1);
    vz=cell2mat(vx); %get indices for label ( Nx2 array)
    vals=ac(vz); %get values of inputfile
    
    %% EXTRACT PARAMETERS (DEFINED IN Z-STRUCT)
    s=stats(vals,z,hano);
    params(:,i)=s(:,2);
end
p.paramname=s(:,1);
p.params   =cell2mat(params);
p.label    ={luts.info.name }';






function [params]=stats(an,z,hano)
% an: masked volume
%  z: parameterfile
% hano: header ANO
is=find(~isnan(an));%idx of noNAN

d.paramname ={};
d.param     ={};
if z.frequency==1
    d.param{1,end+1}=length(is);                        d.paramname{1,end+1}='frequency'  ;
end
if z.percOverlapp==1
    d.param{1,end+1}=(length(is)/length(an))*100;       d.paramname{1,end+1}='percOverlapp'    ;
end
if z.vol==1
    d.param{1,end+1}=abs(det(hano.mat(1:3,1:3)) *( length(is)  ));  d.paramname{1,end+1}='vol';
end
if z.volref==1
    d.param{1,end+1}=abs(det(hano.mat(1:3,1:3)) *( length(an)  ));  d.paramname{1,end+1}='volref';
end


if z.mean==1
    d.param{1,end+1}=mean(an(is));                      d.paramname{1,end+1}='mean'        ;
end
if z.std==1
    d.param{1,end+1}=std(an(is));                       d.paramname{1,end+1}='std'        ;
end
if z.median==1
    d.param{1,end+1}=median(an(is));                    d.paramname{1,end+1}='median'        ;
end
if z.min==1
    d.param{1,end+1}=min(an(is));                       d.paramname{1,end+1}='min'        ;
end
if z.max==1
    d.param{1,end+1}=max(an(is));                       d.paramname{1,end+1}='max'        ;
end
% % % d
% % %
% % % %  d.param{1,end+1}=(length(is)/length(an))*100;       d.paramname{1,end+1}='percOverlapp'
% % %
% % %
% % % d.param{1,end+1}=abs(det(hano.mat(1:3,1:3)) *( length(is)  ));  d.paramname{1,end+1}='volmsk'
% % %
% % % d.param{1,end+1}=abs(det(hano.mat(1:3,1:3)) *( length(an)  ));  d.paramname{1,end+1}='voltot'


d.param(cellfun('isempty',d.param))={nan};

params=[d.paramname' d.param'];

%����������������������������������������������������������������������������������������������������
function [statistics, exclusion] = showRank(luts,ANO,actmap,threshold,rN,type,weighted,hemisphere,network,z,hano)

% 'a'
% if 1
%     an=single(ANO(:));
%     ac=actmap(:);
%    uni=unique(an);
%    uni(1)=[]
%     si=size(ANO)
%
%    tic
%    iv={}
%    for i=1:length(uni)
%       ix= find(an==uni(i));
%      iv{i,1}=ix;
%    end
%    toc
%
%    lab=[{luts.info.id }' {luts.info.children}']
%
%    tic
%    params={};
%    for i=1:size(lab,1)
%
%
%        [com a1 a2]=intersect(uni, [lab{i,1} ;lab{i,2} ]);
%        vx=iv(a1);
%        vz=cell2mat(vx);
%
%        vals=ac(vz);
%
%        p=stats(vals,z,hano);
%        params(:,i)=p(:,2);
%
%    end
%    toc
%
% end
%
% %
% r=ANO.*0;
% r(vz)=1;
% r=reshape(r,si);
%
% r=ANO.*0;
% r(vz)=ac(vz);
% r=reshape(r,si);



% return








statistics = {};
exclusion = [];
iio = find(actmap>=threshold);
% Number of Voxels of the Activation map (below threshold)
if weighted
    F = sparse(ANO(iio)+1,ones(length(iio),1),actmap(iio));
    sz_activation = sum(actmap(iio));
else
    F = sparse(ANO(iio)+1,ones(length(iio),1),ones(length(iio),1));
    sz_activation = length(iio);
end

% List of Region-Ids covered by the Activation map
idx = find(F>0);
% Number of Voxels with one ID
freq = F(idx);
idx = idx-1;
afreq = full(freq(idx>0));
idx = full(idx(idx>0));

if not(isempty(idx))
    szreg = [];
    n = 0;
    
    [common, ia, ib] = intersect([luts.info.id],idx);
    szreg(ib,1) = [luts.info(ia).voxsz];
    
    ll = 1:length(luts.info); [dummy, t1, t2] = intersect(ll,ia); ll(t1)=[];
    
    for k = ll
        [common, ia, ib] = intersect([luts.info(k).children],idx);
        if not(isempty(ib))
            idx = [idx; luts.info(k).id];
            afreq = [afreq; sum([afreq(ib)])];
            szreg = [szreg; luts.info(k).voxsz];
        end
    end
    
    ifreq = afreq./(sz_activation+szreg-afreq);
    relfreq = afreq./szreg;
    
    %     %Network identification
    %     if not(isempty(network))
    %         [~, ia, ib] = intersect(idx, network);
    %         idx = idx(ia);
    %         afreq = afreq(ia);
    %         relfreq = relfreq(ia);
    %         ifreq = ifreq(ia);
    %     end
    
    
    if type == 1, % absolute
        [~, ii] = sort(afreq,'descend');
    elseif type == 2, %relative Voxelnumbers
        [~, ii] = sort(relfreq,'descend');
    elseif type == 3, %intersecting Voxels only
        [~, ii] = sort(ifreq,'descend');
    elseif type == 4, % absolute Voxelnumbers
        [~, ii] = sort(afreq,'descend');
    end;
    
    idx = idx(ii);
    afreq = afreq(ii);
    relfreq = relfreq(ii);
    ifreq = ifreq(ii);
    
    for k = 1:size(luts.info,2)
        statistics.name(k) = {luts.info(k).name};
        statistics.depth(k) = length(luts.info(k).includes);
        j = find([luts.info(k).id]==idx);
        
        if not(isempty(j));
            %  luts.info(k).name
            statistics.t1(k) = 100*afreq(j)/sz_activation;
            statistics.t2(k) = relfreq(j)*100;
            statistics.t3(k) = ifreq(j)*100;
            statistics.t4(k) = afreq(j);
            statistics.t5(k) =afreq(j).*100/luts.info(k).voxsz; %percent again (as control) should be same as T2
            statistics.t6(k) =luts.info(k).voxsz;  % number of voxels in brainRegion of template (should be same across subjects)
            if isempty(luts.info(k).voxsz)
                statistics.t5(k)=-1;
            end
            
        else
            statistics.t1(k) = 0;
            statistics.t2(k) = 0;
            statistics.t3(k) = 0;
            statistics.t4(k) = 0;
            statistics.t5(k) = 0;
            statistics.t6(k) = 0;
        end
    end
    
    if not(isempty(idx))
        exclusion = 1;
        %         try
        %             fprintf('Rank  t1     t2     t3     t4        %s Hemisphere(s)\n',hemisphere{1});
        %         catch
        %             fprintf('Rank  t1     t2     t3     t4        %s Hemisphere(s)\n',hemisphere(1)); %hack3 paul
        %
        %         end
        %         fprintf('-------------------------------------\n');
        %         if rN < length(idx)
        %             for j = 1:rN
        %                 k = find([luts.info.id]==idx(j));
        %                 fprintf('%.2i) %5.2f  %5.2f  %5.2f %5.2f   %s (depth %i)\n',j, statistics.t1(k), statistics.t2(k), statistics.t3(k), statistics.t4(k), statistics.name{k}, statistics.depth(k));
        %             end
        %         else
        %             for j = 1:length(idx)
        %                 k = find([luts.info.id]==idx(j));
        %                 fprintf('%.2i) %5.2f  %5.2f  %5.2f %5.2f   %s (depth %i)\n',j, statistics.t1(k), statistics.t2(k), statistics.t3(k), statistics.t4(k), statistics.name{k}, statistics.depth(k));
        %             end
        %         end
    else
        exclusion = 0;
    end
end


% Functions for the Figure
function txt = myupdatefcn(empt,event_obj,luts)
pos = get(event_obj,'Position');

R = [luts.X(pos(2),pos(1)) luts.Y(pos(2),pos(1)) luts.Z(pos(2),pos(1))];

idx = luts.ANO(R(1),R(2),R(3));
txt1 = genText(idx,luts,'ANO');
idx = luts.FIBT(R(1),R(2),R(3));
txt2 = genText(idx,luts,'FIBT');
txt = sprintf('%s\n%s',txt1,txt2);
function txt = genText(idx,luts,str)
k = find([luts.info.id]==idx);
if not(isempty(k)),
    txt = [luts.info(k).name ' (' num2str(luts.info(k).id) ')'];
else
    txt = ['unknown ' num2str(idx)];
end;
txt = [str ' ' txt];
function COL = buildColLabeling(ANO,idxLUT)
ANO(isnan(ANO)) = 0;
I = sparse([idxLUT.id]+1,ones(length(idxLUT),1),1:length(idxLUT));
for k = 1:length(idxLUT),
    col = sscanf(idxLUT(k).color_hex_triplet,'%x');
    cmap(k,1) = floor(col/256^2);
    cmap(k,2) = mod(floor(col/256),256);
    cmap(k,3) = mod(floor(col),256);
end;
cmap = [0 0 0 ; cmap]/255;
w = full(I(ANO+1));
COL = reshape(cmap(w+1,:),[size(ANO) 3]);


function [id idshort]=getFileID(name)

%% set  folderName
[par2 foldname]=fileparts(fileparts(name));

foldnamelong=foldname;

token=['20\d\d\d\d\d\d_'];
foldname=regexprep(foldname,'^s','') ;
foldname=regexprep(foldname,['20\d\d\d\d\d\d_'],'');
foldname=regexprep(foldname,['20\d\d\d\d\d\d'],'');

%remove params from filename
try
    iu=strfind(foldname,'_');
    idshort=foldname(1:iu(end-2)-1);
catch
    idshort=foldname;
end
% id=foldname;
id=foldnamelong;


function colorizeExcelsheet(filename,  colorhex)

% colorhex={idxLUT(:).color_hex_triplet}

rgb=[];
for i=1:length(colorhex)
    hexString=colorhex{i};
    r = double(hex2dec(hexString(1:2)))/255;
    g = double(hex2dec(hexString(3:4)))/255;
    b = double(hex2dec(hexString(5:6)))/255;
    rgb(i,:) = [r, g, b];
end

rgb=[1 1 1; 1 1 1 ;rgb];%add colored Header

xcol=[];
for i=1:size(rgb,1)
    rgb2=round(rgb(i,:).*255);
    rgb2(rgb2<0)=0;
    rgb2(rgb2>255)=255;
    binar=[dec2bin(rgb2(3),8)   dec2bin(rgb2(2),8) dec2bin(rgb2(1),8)];
    xcol(i,:)=bin2dec(binar);
    % Range.Interior.Color=xlscol
end

co=num2cell(1:size(xcol,1));%index in excel to colorize
co=cellfun(@(a){['A' num2str(a)]},co);




% tpl=fullfile(pwd,'test.xls')
Excel = actxserver('excel.application');
WB = Excel.Workbooks.Open(filename,0,false);

%����������������������������������������������������������������������������������������������������
sheets = WB.Sheets;
numsheets = sheets.Count;
names = cell(1, numsheets);
%del SHEETS
for i = 1:numsheets
    names{i} = sheets.Item(i).Name;
end
ix=find(strcmp(names,'Tabelle3'));
if ~isempty(ix)
    sheets.Item('Tabelle3').Delete;
end
ix=find(strcmp(names,'Tabelle2'));
if ~isempty(ix)
    sheets.Item('Tabelle2').Delete;
end
ix=find(strcmp(names,'Tabelle1'));
if ~isempty(ix)
    sheets.Item('Tabelle1').Delete;
end
%����������������������������������������������������������������������������������������������������
sheets = WB.Sheets;
numsheets = sheets.Count;

for i=1:numsheets
    
    thissheet = get(sheets, 'Item', i);
    thissheet.Activate;
    
    set(Excel.Selection.Font,'Size',8);
    set(Excel.Selection.Font,'Name','Calibri');
    
    % myCell = 'A3';
    % Range = thissheet.Range(myCell)
    % cellColor = Range.Interior.Color
    
    thissheet.Range(['A1:'  'X2']).Cell.Font.Bold=2;
    thissheet.Range(['A1:'  'A2000']).Cell.Font.Bold=2;
    % Set the color of cell "A1" of Sheet 1 to RED
    WB.Worksheets.Item(1).Range('A1').Interior.ColorIndex = 3;
    
    range=invoke(thissheet,'Range',['A1:X2' ]);
    borders=get(range,'Borders');
    borderspec=get(borders,'Item',4);
    set(borderspec,'ColorIndex',1);
    set(borderspec,'Linestyle',1);
    
    invoke(thissheet.Columns,'AutoFit');
    
    %%colorize
    % myCell = 'A3';
    if i>1
        for j=1:length(xcol)
            Range = thissheet.Range(co{j});
            Range.Interior.Color=xcol(j);
        end
    end
    
    %% delete ending rows
    sdelstart=num2str([length(colorhex)+5]);
%     range=invoke(thissheet,'Range',['A1500:A65536' ]);
    range=invoke(thissheet,'Range',['A' sdelstart ':A65536' ]);
    range.EntireRow.Delete;
%     thissheet.Range('A1500:A65536').Select
%     Excel.Selection.SpecialCells(xlCellTypeBlanks).EntireRow.Delete
%     for j=2000:thissheet.rows.Count
%     
% range=invoke(thissheet,'Range',['A1:A1206' ]);
%  range.Copy
% range2=invoke(thissheet,'Range',['B1:B1206' ]);
% range2.Select
% 
% 
% thissheet.Range([  'A1:A12' ]).Copy
% s=thissheet.Range(['B1:B12' ])
% v=s.Select
% 
% Sheets = Excel.ActiveWorkBook.Sheets;
%  new_sheet = Sheets.Add;
% thissheet.PasteSpecial(nan, nan, nan, true);
% 
%  curr_sheet = get(Workbook,'ActiveSheet');
%    rngObj = ('A1:C3')
%    rngObj.Copy
%    Sheets = Excel.ActiveWorkBook.Sheets;
%    new_sheet = Sheets.Add;
%    new_sheet.PasteSpecial; %This is where I am stuck!
% 
% 
% 
% % .PasteSpecial.xlPasteAll
% % set(s,'Pastespecial','xlPasteFormats')
% 
% thissheet.PasteSpecial(true, true, true, true);
% 
% invoke(Excel.Selection,'PasteSpecial','Paste:=xlPasteFormats, Operation:=xlNone, SkipBlanks:=False');
% 
% set(s.PasteSpecial,'Operation','xlNone')
% set(thissheet,'Paste','xlPasteFormats')
% 
% Selection.PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, SkipBlanks:=False
% 
% invoke(s.PasteSpecial,'xlPasteAll' )
% 
% Sheets("AdminSettings").Range("4:5").Copy
% Sheets(SheetName).Range("A1").PasteSpecial xlPasteAll
% Sheets(SheetName).Range("A1").PasteSpecial xlPasteColumnWidth

end



WB.DoNotPromptForConvert = true;
WB.CheckCompatibility = false;
WB.Save();% Save Workbook
WB.Close();% Close Workbook
Excel.Quit();% Quit Excel






%����������������������������������������������������������������������������������������������������
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
function v=getuniquefiles(pa)
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
% pa=antcb('getsubjects'); %path

li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii*$']);
    if ischar(files); files=cellstr(files);   end;
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
    fifull=[fifull; files];
end
li=unique(fi2);
[li dum ncountid]=unique(fi2);
%% count files
ncount=zeros(size(li,1),1);
for i=1:size(li,1)
    ncount(i,1) =length(find(ncountid==i));
end
%% get properties spm_vol
fifull2=fifull(dum);
tb  = repmat({''},[size(fifull2,1)  ,4]);
tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
for i=1:size(fifull2,1)
    ha=spm_vol(fifull2{i});
    ha0=ha;
    ha=ha(1);
    if length(ha0)==1
        tb{i,1}='3';
        tag='';
    else
        tb{i,1}='4' ;
        tag= length(ha0);
    end
    tb{i,2}=sprintf('%i ',[ha.dim tag]);
    tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
    tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
end


v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];

%����������������������������������������������������������������������������������������������������
function he=selectfile(v,selectiontype)
h1=selector2(v.tb,v.tbh,...%'iswait',0,...
    'out','col-1','selection',selectiontype);

%fullpath
pa=antcb('getsubjects');
he={};
for i=1:length(h1)
    for j=1:size(pa,1)
        dum=fullfile(pa{j},h1{i})
        if exist(dum)==2;
            he{end+1,1}=dum;
        end
    end
end





%����������������������������������������������������������������������������������������������������
% 
% 
% function makebatch(z)
% try
%     hlp=help(mfilename);
%     hlp=hlp(1:min(strfind(hlp,char(10)))-1);
% catch
%     hlp='';
% end
% 
% hh={};
% hh{end+1,1}=('% ������������������������������������������������������');
% hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
% hh{end+1,1}=[ '% descr:' hlp];
% hh{end+1,1}=('% ������������������������������������������������������');
% hh=[hh; 'z.files=[];' ];
% hh=[hh; struct2list(z)];
% hh(end+1,1)={[mfilename '(' '1',  ',z' ');' ]};
% % disp(char(hh));
% % uhelp(hh,1);
% 
% try
%     v = evalin('base', 'anth');
% catch
%     v={};
%     assignin('base','anth',v);
%     v = evalin('base', 'anth');
% end
% v=[v; hh; {'                '}];
% assignin('base','anth',v);





