%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 630 $)
%-----------------------------------------------------------------------
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.type = 'cfg_files';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.name = 'Source Image';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.tag = 'filemip';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.filter = 'image';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.ufilter = '.*';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.dir = '';
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.num = [1 1];
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.check = [];
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.help = {'Source image for MIP. Non-NaN voxels in the image will be displayed as MIP. Also, if an image contains only positive voxel values, all zero value voxels will be excluded as well.'};
matlabbatch{1}.menu_cfg{1}.menu_entry{1}.conf_files.def = [];
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'Z';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'Z';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'e';
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [1 Inf];
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.check = [];
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {'List of voxel values to be displayed in MIP.'};
matlabbatch{2}.menu_cfg{1}.menu_entry{1}.conf_entry.def = [];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'XYZ';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'XYZ';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'e';
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [3 Inf];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.check = [];
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {'List of voxel coordinates in mm (MNI) space.'};
matlabbatch{3}.menu_cfg{1}.menu_entry{1}.conf_entry.def = [];
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'M';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'M';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'e';
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [4 4];
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.check = [];
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {'A 4x4 transformation matrix to transform voxel coordinates into world coordinates.'};
matlabbatch{4}.menu_cfg{1}.menu_entry{1}.conf_entry.def = [];
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.type = 'cfg_branch';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.name = 'Source Voxel List';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.tag = 'spmmip';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).sname = 'Entry: Z (cfg_entry)';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).sname = 'Entry: XYZ (cfg_entry)';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).sname = 'Entry: M (cfg_entry)';
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.check = @(subjob)tbxrend_multi_cmip('check','spmmip',subjob);
matlabbatch{5}.menu_cfg{1}.menu_struct{1}.conf_branch.help = {'Specify a MIP similar to output from e.g. spm_getSPM.'};
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.type = 'cfg_choice';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.name = 'MIP Source Type';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.tag = 'mip';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1) = cfg_dep;
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).tname = 'Values Item';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).sname = 'Files: Source Image (cfg_files)';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{1}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1) = cfg_dep;
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).tname = 'Values Item';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).tgt_spec = {};
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).sname = 'Branch: Source Voxel List (cfg_branch)';
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.values{2}(1).src_output = substruct('()',{1});
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.check = [];
matlabbatch{6}.menu_cfg{1}.menu_struct{1}.conf_choice.help = {};
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'Bounding Box';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'bbox';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'e';
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [2 3];
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.check = [];
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {'Bounding box to select voxels from (in mm). Enter [xmin ymin zmin; xmax ymax zmax] values. An interval -Inf Inf means no restrictions.'};
matlabbatch{7}.menu_cfg{1}.menu_entry{1}.conf_entry.def = @(val)tbxrend_multi_cmip('defaults','bbox',val{:});
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'Colour';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'colour';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'e';
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [3 1];
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.check = [];
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {'RGB colour for this MIP.'};
matlabbatch{8}.menu_cfg{1}.menu_entry{1}.conf_entry.def = @(val)tbxrend_multi_cmip('defaults','colour',val{:});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.type = 'cfg_branch';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.name = 'MIP';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.tag = 'mips';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1) = cfg_dep;
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tname = 'Val Item';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).tgt_spec = {};
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).sname = 'Choice: MIP Source Type (cfg_choice)';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_exbranch = substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1) = cfg_dep;
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tname = 'Val Item';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).tgt_spec = {};
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).sname = 'Entry: Bounding Box (cfg_entry)';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_exbranch = substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1) = cfg_dep;
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).tname = 'Val Item';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).tgt_spec = {};
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).sname = 'Entry: Colour (cfg_entry)';
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).src_exbranch = substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.val{3}(1).src_output = substruct('()',{1});
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.check = [];
matlabbatch{9}.menu_cfg{1}.menu_struct{1}.conf_branch.help = {};
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.type = 'cfg_repeat';
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.name = 'MIPS';
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.tag = 'unused';
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.values{1}(1) = cfg_dep;
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.values{1}(1).tname = 'Values Item';
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.values{1}(1).tgt_spec = {};
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.values{1}(1).sname = 'Branch: MIP (cfg_branch)';
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.values{1}(1).src_exbranch = substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.values{1}(1).src_output = substruct('()',{1});
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.num = [1 Inf];
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.forcestruct = false;
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.check = [];
matlabbatch{10}.menu_cfg{1}.menu_struct{1}.conf_repeat.help = {};
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.type = 'cfg_entry';
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.name = 'Units';
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.tag = 'units';
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.strtype = 'e';
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.extras = [];
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.num = [1 3];
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.check = @(subjob)tbxrend_multi_cmip('check','units',subjob);
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.help = {};
matlabbatch{11}.menu_cfg{1}.menu_entry{1}.conf_entry.def = @(val)tbxrend_multi_cmip('defaults','units',val{:});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.type = 'cfg_exbranch';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.name = 'Coloured MIPs';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.tag = 'multi_cmips';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1) = cfg_dep;
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).sname = 'Repeat: MIPS (cfg_repeat)';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).src_exbranch = substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{1}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1) = cfg_dep;
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).tname = 'Val Item';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).tgt_spec = {};
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).sname = 'Entry: Units (cfg_entry)';
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).src_exbranch = substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.val{2}(1).src_output = substruct('()',{1});
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.prog = @(job)tbxrend_multi_cmip('run',job);
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.vout = @(job)tbxrend_multi_cmip('vout',job);
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.check = [];
matlabbatch{12}.menu_cfg{1}.menu_struct{1}.conf_exbranch.help = {'Overlay one or more MIPs onto the SPM standard glassbrain.'};