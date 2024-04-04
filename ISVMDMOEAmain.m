clear
warning off
for testfunc=[1:14]%test functions
    clearvars -except testfunc
    clc
    close all;
    functions = {'DF1', 'DF2','DF3','DF4','DF5','DF6','DF7','DF8','DF9','DF10','DF11','DF12','DF13','DF14'};
    experitype= 'ISVMDMOEA';
    Algoritype= 'RMMEDA';
    T_paramiter = [10 10 300
        5 10 300
        10 5 150];
    
    Generator.Name  = 'LPCA';       % name of generator
    Generator.NClu  = 5;            % parameter of generator, the number of clusters(default)
    Generator.Iter  = 50;           % maximum trainning steps in LPCA
    Generator.Exte  = 0.25;                             % usually, LPCA stops less than 10
    % iterationsGenerator.Exte  = 0.25;         % parameter of generator, extension rate(default)
    if testfunc <= 9
        NIni = 100;
    else
        NIni = 150;%popsize
    end
    for repeat = 1:20  %repeat numbers
        groupIGD = zeros(1,size(T_paramiter,1));
        groupHV = zeros(1,(size(T_paramiter,1)));
        nIni = round(NIni*0.75);
        save_IGD=zeros(size(T_paramiter,1),30);
        save_hv=zeros(size(T_paramiter,1),30);%30=T_paramiter(group,3)/T_paramiter(group,2)
        
        for group = 1:3%environment parameters
            clc
            fprintf('正在运行第%d个函数的第%d组环境变量 第%d次\n',testfunc,group,repeat);
            IGD = zeros(1,round(T_paramiter(group,3)/T_paramiter(group,2)));
            hv = zeros(1,round(T_paramiter(group,3)/T_paramiter(group,2)));
            IterMax = T_paramiter(group,2);
            save_iterIGD=zeros(30,IterMax);
            save_iterHV=zeros(30,IterMax);%30=T_paramiter(group,3)/T_paramiter(group,2)
            for T = 1:T_paramiter(group,3)/T_paramiter(group,2)
                t= 1/T_paramiter(group,1)*(T-1);
                POF_Benchmark = getBenchmarkPOF(testfunc,group,T);
                Problem=getproblem(testfunc,t);%XLow and XUpp in getproblem should be changed if the range of decision vector is not in (0,1)
                if T==1
                    [Pareto,iterIGD,iterhv,PoptX] = RMMEDA( Problem, Generator, NIni, IterMax, t, testfunc, group, repeat, T, POF_Benchmark);
                else
                    [Pareto,iterIGD,iterhv,PoptX] = RMMEDA( Problem, Generator, NIni, IterMax, t, testfunc, group, repeat, T, POF_Benchmark,E);
                end
                save_iterIGD(T,:)=iterIGD;
                save_iterHV(T,:)=iterhv;
                E=(PoptX(:,1:(NIni-nIni)))';
                FILEPATHiteIGD =['.\result\',experitype,'\',Algoritype,'\rep',num2str(repeat),'\'];
                mkdir(FILEPATHiteIGD);
                filenameiterIGD = ['iterIGD',num2str(testfunc),'.txt'];
                save([ FILEPATHiteIGD,filenameiterIGD],'save_iterIGD','-ascii');
                FILEPATHiteHV = ['.\result\',experitype,'\',Algoritype,'\rep',num2str(repeat),'\'];
                filenameiterHV = ['iterhv',num2str(testfunc),'.txt'];
                save([ FILEPATHiteHV,filenameiterHV],'save_iterHV','-ascii');
                IGD(T) =save_iterIGD(T,IterMax);
                hv(T)= save_iterHV(T,IterMax);
                
                POF = Pareto.F';
                POS = Pareto.X';
                [POFrow ,POFcolume]  = size(POF);
                [POSrow ,POScolume]  = size(POS);
                A=POS(1:POSrow,:);
                sample=SMOTE(A',POSrow*5,5);
                N_p=[];
                N_p=[sample';A];
                N_p_size=size(N_p,1);
                C=ones(N_p_size,1);
                N_n=rand(N_p_size,POScolume);% range of decision vector is in (0,1)
                D=-ones(N_p_size,1);
                traindata=[N_p;N_n];
                trainlabeldata=[C;D];
                
                % ISVM update
                if T==1
                    [bestacc,bestc,bestg] = SVMcg(trainlabeldata,traindata,-5,5,-5,5,5,1,1,1.5);
                    mcp_svmtrain(traindata,trainlabeldata,bestc,5,1);
                else
                    mcp_svmtrain_next(traindata,trainlabeldata,bestc);
                end
                
                count=1;
                while count<=nIni
                    testdata=rand(1,POScolume);% range of decision vector is in (0,1)
                    %                     for irand = 1:POScolume
                    %                         testdata(1,irand) = Problem.XLow(irand,1)+(Problem.XUpp(irand,1)-Problem.XLow(irand,1)).*rand(1,1);
                    %                     end    %if the range of decision vector is not in(0,1)
                    testlabeldata=-1;
                    [pred_cl pred_probs] = mcp_svmpredict(testdata);
                    if pred_cl==1
                        count=count+1;
                         E=[E;testdata];
                    else
                        count=count;
                    end
                end
            end
            
            save_IGD(group,:)=IGD;
            save_hv(group,:)=hv;
            FILEPATHIGD = ['.\result\',experitype,'\',Algoritype,'\rep',num2str(repeat),'\'];
            filenameIGD = ['IGD',num2str(testfunc),'.txt'];
            save([ FILEPATHIGD,filenameIGD],'save_IGD','-ascii');
            FILEPATHhv = ['.\result\',experitype,'\',Algoritype,'\rep',num2str(repeat),'\'];
            filenamehv = ['hv',num2str(testfunc),'.txt'];
            save([ FILEPATHhv,filenamehv],'save_hv','-ascii');
            
            groupIGD(group) = mean(IGD);
            groupHV(group) = mean(hv);
            FILEPATHGroupIGD = ['.\result\',experitype,'\',Algoritype,'\rep',num2str(repeat),'\'];
            filenamegroupIGD= ['groupIGD',num2str(testfunc),'.txt'];
            save([ FILEPATHGroupIGD,filenamegroupIGD],'groupIGD','-ascii');
            FILEPATHgroupHV = ['.\result\',experitype,'\',Algoritype,'\rep',num2str(repeat),'\'];
            filenamegroupHV = ['grouphv',num2str(testfunc),'.txt'];
            save([FILEPATHgroupHV, filenamegroupHV],'groupHV','-ascii');
        end
    end
end