% LEARN - Increments the specified example into the current SVM solution.  
%         Assumes alpha_c = 0 initially.
%
% Syntax: nstatus = learn(indc,rflag)
%
% nstatus: new status for indc
%    indc: index of the example to learn
%   rflag: flag indicating whether or not to check if any reserve vectors
%          become margin vectors during learning
%

function nstatus = learn(indc,rflag)

% flags for example state
MARGIN    = 1;
ERROR     = 2;
RESERVE   = 3;
UNLEARNED = 4;

% define global variables 
% global a;             % alpha coefficients
% global b;             % bias
% global C;             % regularization parameters
% global deps;          % jitter factor in kernel matrix
% global g;             % partial derivatives of cost function w.r.t. alpha coefficients
% global ind;           % structure containing indices of margin, error, reserve and unlearned vectors
% global perturbations; % number of perturbations
% global Q;             % extended kernel matrix for all vectors
% global Rs;            % inverse of extended kernel matrix for margin vectors   
% global scale;         % kernel scale
% global type;          % kernel type
% global X;             % matrix of margin, error, reserve and unlearned vectors stored columnwise
% global y;             % column vector of class labels (-1/+1) for margin, error, reserve and unlearned vectors
global model;

% compute g(indc) 
[f_c,K] = svmeval(model.X(:,indc));
model.g(indc) = model.y(indc)*f_c - 1;

% if g(indc) > 0, place this example into the reserve set directly
if (model.g(indc) >= 0)
   
   % move the example to the reserve set
   bookkeeping(indc,UNLEARNED,RESERVE);
   nstatus = RESERVE;
   
   return;
end;

% compute Qcc and Qc if necessary

num_MVs = length(model.ind{MARGIN});

Qc = cell(3,1);
if (num_MVs == 0)
	if (length(model.ind{ERROR}) > 0)
   	Qc{ERROR} = (model.y(model.ind{ERROR})*model.y(indc)).*kernel(model.X(:,ind{ERROR}),model.X(:,indc),model.type,model.scale);
   end;
else
	Qc{MARGIN} = (model.y(model.ind{MARGIN})*model.y(indc)).*K(1:num_MVs);
	if (length(model.ind{ERROR}) > 0)
   	Qc{ERROR} = (model.y(model.ind{ERROR})*model.y(indc)).*K(num_MVs+1:length(K));
	end;
end;
if (length(model.ind{RESERVE}) > 0)
   Qc{RESERVE} = (model.y(model.ind{RESERVE})*model.y(indc)).*kernel(model.X(:,model.ind{RESERVE}),model.X(:,indc),model.type,model.scale);
end;
Qcc = kernel(model.X(:,indc),model.X(:,indc),model.type,model.scale) + model.deps;

converged = 0;
while (~converged)
   
   model.perturbations = model.perturbations + 1;
   
   if (num_MVs > 0)  % change in alpha_c permitted
   
      % compute Qc, beta and gamma
      beta = -model.Rs*[model.y(indc) ; Qc{MARGIN}];
      gamma = zeros(size(model.Q,2),1);
      ind_temp = [model.ind{ERROR} model.ind{RESERVE} indc];
      gamma(ind_temp) = [Qc{ERROR} ; Qc{RESERVE} ; Qcc] + model.Q(:,ind_temp)'*beta;
      
      % check if gamma_c < 0 (kernel matrix is not positive semi-definite)
      if (gamma(indc) < 0)
         error('LEARN: gamma_c < 0');
      end;
      
   else  % change in alpha_c not permitted since the constraint on the sum of the
         % alphas must be preserved.  only b can change.  
      
      % set beta and gamma
      beta = model.y(indc);
      gamma = model.y(indc)*model.y;
      
   end;
   
   % minimum acceptable parameter change (change in alpha_c (num_MVs > 0) or b (num_MVs = 0))
   [min_delta_param,indss,cstatus,nstatus] = min_delta_acb(indc,gamma,beta,1,rflag);
   
   % update a, b, and g
   if (num_MVs > 0)
      model.a(indc) = model.a(indc) + min_delta_param;
      model.a(model.ind{MARGIN}) = model.a(model.ind{MARGIN}) + beta(2:num_MVs+1)*min_delta_param;

   end;   
   model.b = model.b + beta(1)*min_delta_param;
   model.g = model.g + gamma*min_delta_param;
         
   % update Qc and perform bookkeeping         
   converged = (indss == indc);
   if (converged)
      cstatus = UNLEARNED;
     	Qc{nstatus} = [Qc{nstatus} ; Qcc];
  	else
  		ind_temp = find(model.ind{cstatus} == indss);
  		Qc{nstatus} = [Qc{nstatus} ; Qc{cstatus}(ind_temp)];
  		Qc{cstatus}(ind_temp) = [];
   end;
   [indco,removed_i] = bookkeeping(indss,cstatus,nstatus);
   if ((nstatus == RESERVE) & (removed_i > 0))
      Qc{nstatus}(removed_i) = [];
   end;
      
   % set g(ind{MARGIN}) to zero
   model.g(model.ind{MARGIN}) = 0;
   
   % update Rs and Q if necessary
   if (nstatus == MARGIN)
              
      num_MVs = num_MVs + 1;
      if (num_MVs > 1)
         if (converged)
            gamma = gamma(indss);
         else
               
            % compute beta and gamma for indss            
            beta = -model.Rs*model.Q(:,indss);
            gamma = kernel(model.X(:,indss),model.X(:,indss),model.type,model.scale) + model.deps + model.Q(:,indss)'*beta;
            
         end;
      end;
            
      % expand Rs and Q
      updateRQ(beta,gamma,indss);
      
   elseif (cstatus == MARGIN)      
              
      % compress Rs and Q      
      num_MVs = num_MVs - 1;
      updateRQ(indco);
            
   end;         
   
end;
