function [B] = expand_orthogonal(A,flg,method)

% EXPAND_ORTHOGONAL determines an orthogonal expansion of the orthogonal basis
% for the subspace spanned by the columns of the matrix input argument, which
% must have more rows than columns, using either singular value decomposition
% (svd) or the Gram-Schmidt method, see e.g., [1], (reference in code header).
%
% Usage:
%   B = expand_orthogonal(A);
%   B = expand_orthogonal(A,flg);
%   B = expand_orthogonal(A,flg,method);
%
% Input (Required):
%   A is a [nrows by ncols] matrix of (finite) numbers with nrows>=ncols
%
% Input (Optional):
%   flg is a number specifying whether the output should contain the columns
%   of A (flg = 0; default) normalized to unit length, or the orthogonal basis
%   for the subspace spanned by the columns of A (flg = 1)
%
%   method  = 'svd' (default) or 'gram-schmidt' specifies which method to use
%   for generating the orthogonal expansion of the input matrix
%
% Output:
%   B is a [nrows by nrows] matrix whose first ncols columns reflect either the
%   (normalized) columns of the intput or an orthonormal basis for the subspace
%   spanned by A; and the remaining (nrows-ncols) columns contain the orthogonal
%   expansions of the subspace spanned by A.
%
% See also: SVD


% Copyright (C) 2007, Christian Hesse
% F.C. Donders Centre for Cognitive Neuroimaging, Nijmegen, NL
%
% $Log: not supported by cvs2svn $
% Revision 1.2  2007/03/05 15:29:10  chrhes
% added new (default) option to compute the orthogonal basis expansion using
% singular value decomposition instead of the Gram-Schmidt method (which can
% still be specified); updated the function declaration and documentation.
%
% Revision 1.1  2007/03/05 14:08:02  chrhes
% initial version of this code added to FieldTrip
%


% References:
% [1] G.H. Golub and C.F. van Loan, Matrix Computations, 3rd ed., Johns Hopkins
% University Press, Baltimore, 1996.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check the input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin<1) || (nargin>3), error('incorrect number of input arrguments'); end;
if (nargin<3), method = 'svd'; end;
if (nargin<2), flg = 0; end;

% A must be a matrix with more rows than columns containing only real numbers
if isempty(A) || ~isnumeric(A) || ~isreal(A) || any(~isfinite(A(:))) ...
      || (ndims(A)>2) || (size(A,1)<size(A,2)) || (max(size(A))==1)
   error('input argument ''A'' must be a real matrix with more rows than columns');
end

% flg must be a logical
if (flg~=0) && (flg~=1)
   error('input argument ''flg'' must be either 0 (default) or 1');
end

% method must be a string
if ~isstr(method)
   error('input argument ''method'' must be a string');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pre-process input matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalize the columns of A to unit length
[nrows, ncols] = size(A);
for i=1:ncols, A(:,i) = A(:,i)./norm(A(:,i),2); end;
% determine how many columns have to be expanded
nxpnd = nrows-ncols;
if (nxpnd<1)
   warning('A is already a square matrix: orthogonal expansion not possible');
   if (flg==0)
      warning('columns of input have been normalized to unit lenth for output');
      B = A;
   else
      warning('output contains orthonormal basis of the range space of input');
      B = orth(A);
   end
   return;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use specified method for orthonormal expansion of the input matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(method)

   case 'svd'
      % compute orthonormal expansion of A using the left singular vectors
      % from singular value decomposition (svd) of A
      [B, dummy1, dummy2] = svd(A);

   case 'gram-schmidt'
      % compute orthonormal expansion of A using the Gram-Schmidt method:
      % (1) find an orthonormal basis for A
      X = orth(A);
      % (2) find all canonical vectors in nrows space that are closest to
      % orthogonal to X
      I = eye(nrows);
      d = zeros(nrows,2);
      for i=1:nrows,
         d(i,1) = i;
         d(i,2) = sum(abs(A'*I(:,i)));
      end
      d = sortrows(d,[2]);
      B = [X,I(:,d(1:nxpnd,1))];
      % (3) apply Gram-Schmidt orthogonalization (orthonormalization) the
      % columns B(:,ncols+1:end)
      tmp = zeros(nrows,1);
      for i=ncols+1:nrows
         % determine and accumulate the vector projections of the first i-1 columns
         % onto the ith column
         tmp = tmp.*0;
         for j=1:i-1, tmp = tmp + B(:,j).*(B(:,j)'*B(:,i)); end;
         % subtract the projections
         B(:,i) = B(:,i) - tmp;
         % normalize to unit norm
         B(:,i) = B(:,i)./norm(B(:,i),2);
         % ith column is now orthonormal to the first i-1 columns
      end

   otherwise
      error(['unknown or unsupported method: ',method]);

end % switch lower(method)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finalize output matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optionally replace the first ncols columns of B with normalized columns of A
% for output
if (flg==0), B(:,1:ncols) = A; end;


% end of function