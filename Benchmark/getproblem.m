function Problem = getproblem( testfunc,t )
functions = {'DF1', 'DF2', 'DF3', 'DF4', 'DF5', 'DF6', 'DF7', 'DF8', 'DF9', 'DF10', 'DF11', 'DF12', 'DF13', 'DF14'};
function [F,V] = F1(X,t)
    %% DF1
    Fn = 2;
    H = 0.75*sin(pi*t/2)+1.25;
    G = abs(sin(pi*t/2));
    f1 = X(1);
    g = 1+sum((X(2:end)-G).^2);
    h = 1-(f1/g)^H;    
    F = [f1
        g*h];    
    V = 0.0;
    
end

function [F,V] = F2(X,t)
    %% DF2
    n = size(X,2);
    G = abs(sin(pi*t/2));
    r=1+floor((n-1)*G);
    f1 = X(r);
    g=1;
    for i=1:n
        if i==r
            continue
        else
            g=g+(X(i)-G)^2;
        end
    end
    h = 1-sqrt(f1/g);
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V]  = F3(X,t)
%% DF3
    N = size(X,2);
    M = 2;
    f1=X(1);
    G = (sin(pi*t/2));
    H=1.5+G;
    x1H=X(1)^H;
    g=1;
    for i=2:N
        g=g+(X(i)-G-x1H)^2;
    end
    h = 1-(f1/g)^H;
    F = [f1
        g*h];
    V = 0.0;
end

function [F,V]  = F4(X,t)
%% DF4
    N = size(X,2);
    M = 2;
    g=1;
    a = (sin(pi*t/2));
    for i=2:N
        g=g+(X(i)-(a*X(1)^2/i))^2;
    end
    b=1+abs(cos(pi*t/2));
    
    H=1.5+a;
    f1=g*abs(X(1)-a)^H;
    f2=g*abs(X(1)-a-b)^H;
    F = [f1
        f2];
    V = 0.0;
end

function [F,V]  = F5(X,t)
%% DF5
    N = size(X,2);
    M = 2;
    G=(sin(pi*t/2));
    g=1;
    for i=2:N
        g=g+(X(i)-G)^2;
    end
    w=floor(10*G);
    f1=g*(X(1)+0.02*sin(w*pi*X(1)));
    f2=g*(1-X(1)+0.02*sin(w*pi*X(1)));
    F = [f1
        f2];
    V = 0.0;
end

function [F,V]  = F6(X,t)
%% DF6
    N = size(X,2);
    M = 2;
    G=(sin(pi*t/2));
    g=1;
    a=0.2+2.8*abs(G);
    Y=X-G;
    for i=2:N
        g=g+(abs(G)*Y(i)^2-10*cos(2*pi*Y(i))+10);
    end
    f1=g*(X(1)+0.1*sin(3*pi*X(1)))^a;
    f2=g*(1-X(1)+0.1*sin(3*pi*X(1)))^a;
    F = [f1
        f2];
    V = 0.0;
end



function [F,V]  = F7(X,t)
%% DF7
   N = size(X,2);
   M = 2;
   a=5*cos(0.5*pi*t);
       tmp=1/(1+exp(a*(X(1)-2.5)));
       g=1+sum(power(X(2:end)-tmp,2));
       f1=g*(1+t)/X(1);
       f2=g*X(1)/(1+t) ;  
        
   F = [f1
       f2];
   V = 0.0;

end

function [F,V]  = F8(X,t)
%% DF8
    N = size(X,2);
    M = 2;
    G=sin(0.5*pi*t);
    a=2.25+2*cos(2*pi*t);
    b=100*G^2;
    tmp=G*sin(power(4*pi*X(1),b))/(1+abs(G));
    g=1+sum((X(2:end)-tmp).^2);
    f1=g*(X(1)+0.1*sin(3*pi*X(1)));
    f2=g*power(1-X(1)+0.1*sin(3*pi*X(1)),a);   
    F = [f1
        f2];
    V = 0.0;
end


function [F,V]  = F9( X,t)
%% DF9
    n=size(X,2);
    N=1+floor(10*abs(sin(0.5*pi*t)));
    g=1;
    for i=2:n
        tmp=X(i)-cos(4*t+X(1)+X(i));
        g=g+tmp^2;
    end
        f1=g*(X(1)+max(0, (0.1+0.5/N)*sin(2*N*pi*X(1))));
        f2=g*(1-X(1)+max(0, (0.1+0.5/N)*sin(2*N*pi*X(1))))  ; 
    F = [f1
        f2];
    V = 0.0;
end

function [F,V]  = F10(X,t)
%% DF10 
    G=sin(0.5*pi*t);
        H=2.25+2*cos(0.5*pi*t);
        tmp=sin(2*pi*(X(1)+X(2)))/(1+abs(G));
        g=1+sum((X(3:end)-tmp).^2);
        f0=g*power(sin(0.5*pi*X(1)),H);
        f1=g*power(sin(0.5*pi*X(2)),H)*power(cos(0.5*pi*X(1)),H);
        f2=g*power(cos(0.5*pi*X(2)),H)*power(cos(0.5*pi*X(1)),H);
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = F11(X,t)
%% DF11
    G=abs(sin(0.5*pi*t));
        g=1+G+sum((X(3:end)-0.5*G*X(1)).^2);
       
        y1=pi*G/6.0+(pi/2-pi*G/3.0)*X(1);
        y2=pi*G/6.0+(pi/2-pi*G/3.0)*X(2);
        f0=g*sin(y1) ;
        f1=g*sin(y2)*cos(y1);
        f2=g*cos(y2)*cos(y1);
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = F12(X,t)
%% DF12
    k=10*sin(pi*t);
        tmp1=X(3:end)-sin(t*X(1));
        tmp2=abs(sin(floor(k*(2*X(1)-1))*pi/2)*sin(floor(k*(2*X(2)-1))*pi/2));
        g=1+sum(tmp1.^2)+tmp2;
        f0=g*cos(0.5*pi*X(2))*cos(0.5*pi*X(1));
        f1=g*sin(0.5*pi*X(2))*cos(0.5*pi*X(1));
        f2=g*sin(0.5*pi*X(2));
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = F13(X,t)
%% DF13
   G=sin(0.5*pi*t);
        p=floor(6*G);
        g=1+sum((X(3:end)-G).^2);
        f0=g*cos(0.5*pi*X(1))^2;
        f1=g*cos(0.5*pi*X(2))^2;
        f2=g*sin(0.5*pi*X(1))^2+sin(0.5*pi*X(1))*cos(p*pi*X(1))^2+sin(0.5*pi*X(2))^2+sin(0.5*pi*X(2))*cos(p*pi*X(2))^2;
    F = [f0
        f1
        f2];
    V = 0.0;
end

function [F,V]  = F14(X,t)
%% DF14   
    G=sin(0.5*pi*t);
        g=1+sum((X(3:end)-G).^2);
        y=0.5+G*(X(1)-0.5);
        f0=g*(1-y+0.05*sin(6*pi*y));
        f1=g*(1-X(2)+0.05*sin(6*pi*X(2)))*(y+0.05*sin(6*pi*y));
        f2=g*(X(2)+0.05*sin(6*pi*X(2)))*(y+0.05*sin(6*pi*y));
    F = [f0
        f1
        f2];
    V = 0.0;
end
%GETPROBLEM 此处显示有关此函数的摘要
%   此处显示详细说明
      switch testfunc
            % Objective function, please read the definition
                                        % F1 - F14
            case 1
                %% DF1
                Problem.FObj = @F1;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 2
                %% DF2
                Problem.FObj = @F2;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 3
                %% DF3
                Problem.FObj = @F3;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 4
                %% DF4
                Problem.FObj = @F4;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 5
                %% DF5
                Problem.FObj = @F5;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 6
                %% DF6
                Problem.FObj = @F6;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 7
                %% DF7
                Problem.FObj = @F6;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 8
                %% DF8
                Problem.FObj = @F8;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 9
                %% DF9
                Problem.FObj = @F9;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 2;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 10
                %% DF10
                Problem.FObj = @F10;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 3;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 11
                %% DF11
                Problem.FObj = @F11;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 3;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 12
               %% DF12
                Problem.FObj = @F12;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 3;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 13
                %% DF13
                Problem.FObj = @F13;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 3;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables
            case 14
               %% DF14
                Problem.FObj = @F14;
                Problem.Name = functions{testfunc};        % name of test problem
                Problem.NObj = 3;            % number of objectives
                Problem.XLow = zeros(10,1);  % lower boundary of decision variables, it also defines the number of decision variables
                Problem.XUpp = ones(10,1);   % upper boundary of decision variables                                                
            otherwise
                disp([funcname ' Not Found!']);
        end

end

