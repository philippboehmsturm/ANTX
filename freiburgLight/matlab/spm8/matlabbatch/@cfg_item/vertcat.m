function varargout = vertcat(varargin)

% function varargout = vertcat(varargin)
% Prevent vertcat for cfg_item objects.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: vertcat.m 299 2008-06-20 11:46:59Z glauche $

rev = '$Rev: 299 $'; %#ok

cfg_message('matlabbatch:cfg_item:cat', ['Concatenation of cfg_item objects is ' ...
                    'not allowed.']);