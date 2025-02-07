% BOOKKEEPING - Updates the status of example indss and modifies the corresponding
%               coefficient a(indss) in certain cases to avoid numerical errors.
%
% Syntax: [indco,i] = bookkeeping(indss,cstatus,nstatus)
%
%     indco: matrix row/col to remove from Rs and Q if removing a margin vector
%         i: when i > 0, the i-th element was removed from ind{RESERVE}
%     indss: the example changing status
%   cstatus: current status of the example
%   nstatus: new status of the example
%
%            example status values:
%            1: margin vector
%            2: error vector
%            3: reserve vector
%            4: unlearned vector
%

function [indco,i] = bookkeeping(indss,cstatus,nstatus)

indco = -1;
i = 0;
if (cstatus ~= nstatus)

	% flags for example state
	MARGIN    = 1;
	ERROR     = 2;
	RESERVE   = 3;
    UNLEARNED = 4;

	% define global variables
% 	global a;     % the alpha coefficients
% 	global C;     % regularization parameters
% 	global ind;   % cell array containing indices of margin, error, reserve and unlearned vectors           

global model;

	% adjust coefficient to avoid numerical errors if necessary
	switch nstatus
	case RESERVE
	   model.a(indss) = 0;
	case ERROR
	   model.a(indss) = model.C(indss);
	end;

	% if the example is currently a margin vector, determine the row
	% in the extended kernel matrix inverse that needs to be removed
	if (cstatus == MARGIN)
   	indco = find(indss == model.ind{MARGIN}) + 1;
	end;

	% change the status of the example
	switch nstatus
	case RESERVE
   	[model.ind{cstatus},i] = move_indr(model.ind{cstatus},indss);
	otherwise
	   [model.ind{cstatus},model.ind{nstatus}] = move_ind(model.ind{cstatus},model.ind{nstatus},indss);
	end;
 
end;
