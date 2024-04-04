function POF_Banchmark = getBenchmarkPOF( testfunc,group,T )
                   
     T_paramiter = [10 10 300
                        5 10 300
                        10 5 150];
           
    switch testfunc
        case 1
            tempFuncName = 'DF1';
        case 2
            tempFuncName = 'DF2';
        case 3
            tempFuncName = 'DF3';
        case 4
            tempFuncName = 'DF4';      
        case 5
            tempFuncName = 'DF5';
        case 6
            tempFuncName = 'DF6';
        case 7
            tempFuncName = 'DF7';
        case 8
            tempFuncName = 'DF8';
        case 9
            tempFuncName = 'DF9';
        case 10
            tempFuncName = 'DF10';
        case 11
            tempFuncName = 'DF11';
        case 12
            tempFuncName = 'DF12';
        case 13
            tempFuncName = 'DF13';
        case 14
            tempFuncName = 'DF14';
    end
    tempPosition = T;
   POF_Banchmark = importdata(['.\Benchmark\pof\' 'POF-nt' num2str(T_paramiter(group,1)) '-taut' num2str(T_paramiter(group,2)) '-' tempFuncName '-' num2str(tempPosition) '.txt']);
end

