%#########################################################################
%Análise resultado da otimização do leito de fusão gerado pelo Java em
%arquivo data-output.txt conforme sequência abaixo:
% 1- Ler dados do leito objetivado, denominado "leito original" e resultados 
% do leito otimizado, denominado leito recalculado, conforme variáveis 
% abaixo:
    
    %leitoOriginalVariaveisDecisao                  # Leito original
    %leitoOriginalResultadoPesoOrdenado             #
    %lPSolveEntradaIterIni                          # Primeira Iteração
    %lPSolveResultadoPesoIterIni                    #       " 
    %leitoRecalculadoVariaveisDecisaoIterIni        #       " 
    %leitoRecalculadoResultadoPesoOrdenadoIterIni   #       "
    %lPSolveEntradaIterFim                          # Ùltima Iteração
    %lPSolveResultadoPesoIterFim                    #       "
    %leitoRecalculadoVariaveisDecisaoIterFim        #       "
    %leitoRecalculadoResultadoPesoOrdenadoIterFim   #       "
  
%#########################################################################

%function OtimizacaoLeito(numLeito)
%Projeto Otimização Leito Fusão
clc;
clear all;
format long;

numiter = 4;
%Posição inicial das variáveis do resultado de otimização

posLeitoOriginalVariaveisDecisao = 2;
posleitoOriginalResultadoPeso = 6;
poslPSolveEntradaIterIni = 16;             
poslPSolveResultadoPesoIterIni = 27;                    
posleitoRecalculadoVariaveisDecisaoIterIni = 38;
posleitoRecalculadoResultadoPesoIterIni = 42;   
poslPSolveEntradaIterFim = 129;
poslPSolveResultadoPesoIterFim = 141;                  
posleitoRecalculadoVariaveisDecisaoIterFim = 152;        
posleitoRecalculadoResultadoPesoIterFim = 156;   

%list = importdata('data-output2802202008h48m.txt','',55161);
list = importdata('data-output2802202008h48m.txt','',100000');

s1 = regexp(list, '^Leito=');
size(list);
linhasLeito = zeros();
numeroLeitoAtual = 0;
leitoAnterior = 0;
leitoAtual = 0;
for i=1:length(s1)
    if (eq(s1{i,1},1))
        STR = split(list(i),'-');
        leitoAtual = STR(2,1);
        S1 = leitoAtual;      
        S2 = leitoAnterior;
        TF = strcmp(S1,S2);
            if TF ~= 1
                numeroLeitoAtual = numeroLeitoAtual + 1;
                linhasLeito(numeroLeitoAtual, 1) = i;
            end
    end
    leitoAnterior = leitoAtual;
end

% --------------------------------------------------------------------
% Define posicionamento (linhas de inicio e final) para cada leito do
% arquivo
posicionamentoLeitos = zeros(length(linhasLeito),2);

for i=1:length(linhasLeito)-1
    posicionamentoLeitos(i, 1) = linhasLeito(i);
    posicionamentoLeitos(i, 2) = linhasLeito(i + 1) - 1;
end
posicionamentoLeitos(length(linhasLeito), 1) = linhasLeito(length(linhasLeito));
posicionamentoLeitos(length(linhasLeito), 2) = length(list);



%-----------------------------------------------------------------------
% Ler variáveis de decisão originais de todos os leitos
leitoOriginalVariaveisDecisao = zeros(length(posicionamentoLeitos)-1,3);

for i=1:length(posicionamentoLeitos)-1
    leitoIni = posicionamentoLeitos(i, 1);
    %varTemp1 = strsplit(list{leitoIni+3},'=');
    varTemp1 = strsplit(list{leitoIni+posLeitoOriginalVariaveisDecisao},'='); 
    leitoOriginalVariaveisDecisao(i,1) = str2double(varTemp1(1,2));
    varTemp1 = strsplit(list{leitoIni+(posLeitoOriginalVariaveisDecisao+1)},'='); 
    leitoOriginalVariaveisDecisao(i,2) = str2double(varTemp1(1,2));
    varTemp1 = strsplit(list{leitoIni+(posLeitoOriginalVariaveisDecisao+2)},'='); 
    leitoOriginalVariaveisDecisao(i,3) = str2double(varTemp1(1,2));
end
leitoOriginalVariaveisDecisao;



%-----------------------------------------------------------------------
% Ler variáveis de decisão recalculado de todos os leitos
leitoRecalculadoVariaveisDecisao = zeros(length(posicionamentoLeitos)-1,3);
TFidentificado = zeros(length(posicionamentoLeitos)-1,1);
for i=1:length(posicionamentoLeitos)-1
    leitoIni = posicionamentoLeitos(i, 1);
    
    for j=posicionamentoLeitos(i,1):posicionamentoLeitos(i,2)
    S1 = list(j);
    S2 = 'Inicio iteração=3';
    TF = strcmp(S1,S2);
           if TF ==1
            for k=1:40
                S1 = list(j+k);
                S2 = '#Leito Recalculado - variáveis decisão';
                TFF = strcmp(S1,S2);
                if TFF == 1
                    TFidentificado(k,1) = TF;
                    varTemp1 = strsplit(list{1+j+k},'='); 
                    leitoRecalculadoVariaveisDecisao(i,1) = str2double(varTemp1(1,2));
                    varTemp1 = strsplit(list{2+j+k},'='); 
                    leitoRecalculadoVariaveisDecisao(i,2) = str2double(varTemp1(1,2));
                    varTemp1 = strsplit(list{3+j+k},'='); 
                    leitoRecalculadoVariaveisDecisao(i,3) = str2double(varTemp1(1,2));
                end
            end
            
          end

    end
        
end
leitoRecalculadoVariaveisDecisao;
leitoOriginalVariaveisDecisao;


%Média das "Variáveis de Decisão Original"
MedvariaveisDecisaoOriginal = mean(leitoOriginalVariaveisDecisao);

%Média das "Variáveis de Decisão Reotimizado"
MedvariaveisDecisaoRecalculado = mean(leitoRecalculadoVariaveisDecisao);

%Diferença "Média das "Variáveis de Decisão Original vS Reotimizado"
DifMedvariaveisDecisaoOrigReot = MedvariaveisDecisaoOriginal - MedvariaveisDecisaoRecalculado;


%-----------------------------------------------------------------------
% Fundentes: pesos Original 
leitoOriginalResultadoPesoFund = zeros(length(posicionamentoLeitos)-1,4);
for i=1:length(posicionamentoLeitos)-1
    leitoIni = posicionamentoLeitos(i, 1);
    
    for j=posicionamentoLeitos(i,1):posicionamentoLeitos(i,2)
        S1 = list(j);
        S2 = '#Leito original - Resultado PESO';
        TF = strcmp(S1,S2);
            if TF == 1
                TF = 0;
                k = 1;
                while TF == 0
                    varTemp1 = strsplit(list{j+k},'=');
                    material = char(varTemp1(1,1));
                    S1 = material;
                    S2 = 'al2O3';
                    TF = strcmp(S1,S2); 
                        if TF == 0
                            varTemp = strsplit(list{leitoIni+5+k},'=');
                            temp = char(varTemp(1,1));
                            fundente = temp(1:3);
                                switch fundente
                                    case 'QZO'
                                        varTemp = strsplit(list{leitoIni+5+k},'=');
                                        leitoOriginalResultadoPesoFund(i,1) = str2double(varTemp(1,2));
                                    case 'DOL'
                                        varTemp = strsplit(list{leitoIni+5+k},'=');
                                        leitoOriginalResultadoPesoFund(i,2) = str2double(varTemp(1,2));
                                    case 'KCA'
                                        varTemp = strsplit(list{leitoIni+5+k},'=');
                                        leitoOriginalResultadoPesoFund(i,3) = str2double(varTemp(1,2));
                                    case 'MMN'
                                        varTemp = strsplit(list{leitoIni+5+k},'=');
                                        leitoOriginalResultadoPesoFund(i,4) = str2double(varTemp(1,2));
                                end
                            k = k +1;
                        end

                end
        
            end
                                
    end
            
end
       
leitoOriginalResultadoPesoFund;

%-----------------------------------------------------------------------
% Fundentes: pesos Reotimizado 
leitoRecalculadoResultadoPesoFund = zeros(length(posicionamentoLeitos)-1,4);
for i=1:length(posicionamentoLeitos)-1
    leitoIni = posicionamentoLeitos(i, 1);
    
    for j=posicionamentoLeitos(i,1):posicionamentoLeitos(i,2)
    S1 = list(j);
    S2 = 'Inicio iteração=3';
    TF = strcmp(S1,S2);
           if TF ==1
                for k=1:30
                    S1 = list(j+k);
                    S2 = '#Leito Recalculado - Resultado PESO';
                    TFF = strcmp(S1,S2);
                    if TFF == 1
                        TFFF = 0;
                        k = k +1;
                        while TFFF == 0
                            varTemp1 = strsplit(list{j+k},'='); 
                            material = char(varTemp1(1,1));
                            S1 = material;
                            S2 = 'al2O3';
                            TFFF = strcmp(S1,S2); 
                                if TFFF == 0
                                    varTemp = strsplit(list{j+k},'=');
                                    temp = char(varTemp(1,1));
                                    fundente = temp(1:3);
                                        switch fundente
                                            case 'QZO'
                                                varTemp = strsplit(list{j+k},'=');
                                                leitoRecalculadoResultadoPesoFund(i,1) = str2double(varTemp(1,2));
                                            case 'DOL'
                                                varTemp = strsplit(list{j+k},'=');
                                                leitoRecalculadoResultadoPesoFund(i,2) = str2double(varTemp(1,2));
                                            case 'KCA'
                                                varTemp = strsplit(list{j+k},'=');
                                                leitoRecalculadoResultadoPesoFund(i,3) = str2double(varTemp(1,2));
                                            case 'MMN'
                                                varTemp = strsplit(list{j+k},'=');
                                                leitoRecalculadoResultadoPesoFund(i,4) = str2double(varTemp(1,2));
                                        end
                                    k = k +1;
                                end

                        end
                    end
                end
           end                   
    end
end            

leitoOriginalResultadoPesoFund;      
leitoRecalculadoResultadoPesoFund;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plot variáveis decisão Original Vs Reotimizado

ya = zeros(length(posicionamentoLeitos)-1,3);
yb = zeros(length(posicionamentoLeitos)-1,3);
ya = leitoOriginalVariaveisDecisao;
yb = leitoRecalculadoVariaveisDecisao;
x = linspace(1,(numeroLeitoAtual-1),(numeroLeitoAtual-1));


figure(1)%Volume de escória
plot(x, ya(:,1),'m','linewidth',2)
grid on
hold on
plot(x, yb(:,1),'k','linewidth',2)
hold on
%ylim([150 250])
title('Volume de escória: Original Vs Otimizado','fontsize',12)
xlabel('Número de Leitos de Fusão','fontsize',12)
ylabel('Volume de escória (Kg/t)','fontsize',12)
legend('Original','Otimizado','Location','NorthWest')


%Plot pesos *Original Vs *Reotimizado

za = zeros(length(posicionamentoLeitos)-1,3);
zb = zeros(length(posicionamentoLeitos)-1,3);
za = leitoOriginalResultadoPesoFund;
zb = leitoRecalculadoResultadoPesoFund;
x = linspace(1,(numeroLeitoAtual-1),(numeroLeitoAtual-1));

leitoOriginalResultadoPesoFund;      
leitoRecalculadoResultadoPesoFund;

figure(2)%QZ01
plot(x, za(:,1),'m','linewidth',2)
grid on
hold on
plot(x, zb(:,1),'g','linewidth',2)
hold on
% plot(x, yc(:,1),'g','linewidth',2)
% ylim([10 250])
title('Otimização do leito de fusão')
xlabel('Número de leitos')
ylabel('QZ01')
legend('Leito Original','Leito Otimizado')


% %-----------------------------------------------------------------------
% % Ordena pesos Reotimizado
% leitoRecalculadoResultadoPesoIterFim = zeros(length(posicionamentoLeitos)-1,4);
% for i=1:length(posicionamentoLeitos)-1
%     leitoIni = posicionamentoLeitos(i, 1);
%             varTemp = strsplit(list{leitoIni+159},'=');
%             mat = char(varTemp(1,1));            
%             
%             switch mat
%                 
%                 case 'QZO1'
%                     leitoRecalculadoResultadoPesoIterFim(i,1) = str2double(varTemp(1,2));
%                     
%                 case 'MMN2'
%                     leitoRecalculadoResultadoPesoIterFim(i,2) = str2double(varTemp(1,2));
%                     
%                 case 'KCA2'
%                     leitoRecalculadoResultadoPesoIterFim(i,3) = str2double(varTemp(1,2));
%                     
%                 case 'DOLA'
%                     leitoRecalculadoResultadoPesoIterFim(i,4) = str2double(varTemp(1,2));
%             end     
%             
%             varTemp = strsplit(list{leitoIni+160},'=');
%             mat = char(varTemp(1,1));            
%             
%             switch mat
%                 
%                 case 'QZO1'
%                     leitoRecalculadoResultadoPesoIterFim(i,1) = str2double(varTemp(1,2));
%                     
%                 case 'MMN2'
%                     leitoRecalculadoResultadoPesoIterFim(i,2) = str2double(varTemp(1,2));
%                     
%                 case 'KCA2'
%                     leitoRecalculadoResultadoPesoIterFim(i,3) = str2double(varTemp(1,2));
%                     
%                 case 'DOLA'
%                     leitoRecalculadoResultadoPesoIterFim(i,4) = str2double(varTemp(1,2));
%             end    
%             
%             varTemp = strsplit(list{leitoIni+161},'=');
%             mat = char(varTemp(1,1));            
%             
%             switch mat
%                 
%                 case 'QZO1'
%                     leitoRecalculadoResultadoPesoIterFim(i,1) = str2double(varTemp(1,2));
%                     
%                 case 'MMN2'
%                     leitoRecalculadoResultadoPesoIterFim(i,2) = str2double(varTemp(1,2));
%                     
%                 case 'KCA2'
%                     leitoRecalculadoResultadoPesoIterFim(i,3) = str2double(varTemp(1,2));
%                     
%                 case 'DOLA'
%                     leitoRecalculadoResultadoPesoIterFim(i,4) = str2double(varTemp(1,2));
%             end     
%             
%             varTemp = strsplit(list{leitoIni+162},'=');
%             mat = char(varTemp(1,1));            
%             
%             switch mat
%                 
%                 case 'QZO1'
%                     leitoRecalculadoResultadoPesoIterFim(i,1) = str2double(varTemp(1,2));
%                     
%                 case 'MMN2'
%                     leitoRecalculadoResultadoPesoIterFim(i,2) = str2double(varTemp(1,2));
%                     
%                 case 'KCA2'
%                     leitoRecalculadoResultadoPesoIterFim(i,3) = str2double(varTemp(1,2));
%                     
%                 case 'DOLA'
%                     leitoRecalculadoResultadoPesoIterFim(i,4) = str2double(varTemp(1,2));
%             end                
%                              
%  end
%             
% % leitoRecalculadoResultadoPesoIterFim;
% 
% 
% %-----------------------------------------------------------------------
% %Diferença de pesos  Original X Reotimizado
% 
% difPesoOrigReot = zeros(length(posicionamentoLeitos)-1,4);
% difPesoOrigReotTot = zeros(1,4);
% MedDifPesos = zeros(1,4);
% for i=1:length(posicionamentoLeitos)-1
%     for j=1:4   
%     difPesoOrigReot(i,j) = leitoOriginalResultadoPesoFund(i,j) - leitoRecalculadoResultadoPesoIterFim(i,j);
%     end
% end
% 
% %Média "Peso Original" dos 100 leitos por materialMedOrdenadoOriginal(1,1) = mean(leitoOriginalResultadoPeso(:,1));
% MedOrdenadoOriginal(1,2) = mean(leitoOriginalResultadoPesoFund(:,2));
% MedOrdenadoOriginal(1,3) = mean(leitoOriginalResultadoPesoFund(:,3));
% MedOrdenadoOriginal(1,4) = mean(leitoOriginalResultadoPesoFund(:,4));
% 
% 
% %Média "Peso Otimizado" dos 100 leitos por material
% MedOrdenadoReotimizado(1,1) = mean(leitoRecalculadoResultadoPesoIterFim(:,1));
% MedOrdenadoReotimizado(1,2) = mean(leitoRecalculadoResultadoPesoIterFim(:,2));
% MedOrdenadoReotimizado(1,3) = mean(leitoRecalculadoResultadoPesoIterFim(:,3));
% MedOrdenadoReotimizado(1,4) = mean(leitoRecalculadoResultadoPesoIterFim(:,4));
% 
% 
% %Média "Diferença Peso Original X Otimizado" dos 100 leitos por material
% MedDifPesos(1,1) = mean(difPesoOrigReot(:,1));% HGVB
% MedDifPesos(1,2) = mean(difPesoOrigReot(:,2));% HGSB
% MedDifPesos(1,3) = mean(difPesoOrigReot(:,3));% PACB
% MedDifPesos(1,4) = mean(difPesoOrigReot(:,4));% MMN2
% 
% %Percentual "Diferença Peso Original X Otimizado" dos 100 leitos por material
% %MedPercDifPesosOrigOtim = zeros(MedDifPesos, 8);
% 
% 
% 
% for i=1:1
%     for j=1:4
% MedPercDifPesosOrigOtim(i,j) = (MedOrdenadoReotimizado(i,j)/MedOrdenadoOriginal(i,j)*100);        
% MedPercDifPesosOrigOtim2(i,j) = (MedOrdenadoReotimizado(i,j)/MedOrdenadoOriginal(i,j)*100)-100;
%     end
% end
% 
% MedOrdenadoOriginal;
% MedOrdenadoReotimizado;
% MedDifPesos;
% MedPercDifPesosOrigOtim;
% 
% MedPercDifPesosOrigOtim2;
% 
% 
% MedDifPesos;
% % Como resultado da média de diferença de peso dos 100 leitos temos redução
% de 28kg e 232 kg por leito de fusão

% %-----------------------------------------------------------------------
% %Diferença de pesos reotimizado LPSolve X Recalculado
% 
% diferPesosReoRecLPS = zeros(length(posicionamentoLeitos)-1,7);
% 
% diferPesosOrigReot = zeros(length(posicionamentoLeitos)-1,7);
% diferPesos4 = zeros(length(posicionamentoLeitos)-1,7);
% 
% for i=1:length(posicionamentoLeitos)-1
%     for j=1:7        
%         diferPesosReoRecLPS(i,j) = pesosReotimizadoRecalculado(i,j) - pesosReotimizadoLPSolve(i,j);        
%         diferPesosOrigReot(i,j) = pesosOriginal(i,j) - pesosReotimizadoRecalculado(i,j);       
%     end
% end
% diferPesosReoRecLPS;
% diferPesosOrigReot;
% 
% 
% diferVariaveisDecisaoOrigReo = zeros(length(posicionamentoLeitos)-1,3);
% diferVariaveisDecisaoRecReo = zeros(length(posicionamentoLeitos)-1,3);
% for i=1:length(posicionamentoLeitos)-1
%     for j=1:3                
%         diferVariaveisDecisaoOrigReo(i,j) = variaveisDecisaoOriginal(i,j) - variaveisDecisaoReotimizado(i,j);
%         diferVariaveisDecisaoRecReo(i,j) = variaveisDecisaoRecalculado(i,j) - variaveisDecisaoReotimizado(i,j);        
%     end
% end
% diferVariaveisDecisaoOrigReo;
% diferVariaveisDecisaoRecReo;



%-----------------------------------------------------------------------
% ler "Erros linearização" de todos os leitos #####Primeira Execução####

% errorLinearizacaoError1 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMin1 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMax1 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoRange1 = zeros(length(posicionamentoLeitos)-1,3);
% for i=1:length(posicionamentoLeitos)-1
%     leitoIni = posicionamentoLeitos(i, 1);
% 
%     
%     varTemp1 = strsplit(list{leitoIni+20},';');
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,1) = str2double(error);
%     errorLinearizacaoMin1(i,1) = str2double(errorMin);
%     errorLinearizacaoMax1(i,1) = str2double(errorMax);
%     errorLinearizacaoRange1(i,1) = str2double(range);
%     
%     
%     varTemp1 = strsplit(list{leitoIni+21},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,2) = str2double(error);
%     errorLinearizacaoMin1(i,2) = str2double(errorMin);
%     errorLinearizacaoMax1(i,2) = str2double(errorMax);
%     errorLinearizacaoRange1(i,2) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+22},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,3) = str2double(error);
%     errorLinearizacaoMin1(i,3) = str2double(errorMin);
%     errorLinearizacaoMax1(i,3) = str2double(errorMax);
%     errorLinearizacaoRange1(i,3) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+23},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,4) = str2double(error);
%     errorLinearizacaoMin1(i,4) = str2double(errorMin);
%     errorLinearizacaoMax1(i,4) = str2double(errorMax);
%     errorLinearizacaoRange1(i,4) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+24},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,5) = str2double(error);
%     errorLinearizacaoMin1(i,5) = str2double(errorMin);
%     errorLinearizacaoMax1(i,5) = str2double(errorMax);
%     errorLinearizacaoRange1(i,5) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+25},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,6) = str2double(error);
%     errorLinearizacaoMin1(i,6) = str2double(errorMin);
%     errorLinearizacaoMax1(i,6) = str2double(errorMax);
%     errorLinearizacaoRange1(i,6) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+26},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%    % errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,7) = str2double(error);
%     errorLinearizacaoMin1(i,7) = str2double(errorMin);
%     errorLinearizacaoMax1(i,7) = str2double(errorMax);
%     errorLinearizacaoRange1(i,7) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+29},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError1(i,8) = str2double(error);
%     errorLinearizacaoMin1(i,8) = str2double(errorMin);
%     errorLinearizacaoMax1(i,8) = str2double(errorMax);
%     errorLinearizacaoRange1(i,8) = str2double(range);
% 
% end
% 
% errorLinearizacaoError1;
% errorLinearizacaoMin1;
% errorLinearizacaoMax1;
% errorLinearizacaoRange1;
% 
% %-----------------------------------------------------------------------
% % ler "Erros linearização" de todos os leitos #####Segunda Ececução Execução####
% errorLinearizacaoError2 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMin2 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMax2 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoRange2 = zeros(length(posicionamentoLeitos)-1,3);
% for i=1:length(posicionamentoLeitos)-1
%     leitoIni = posicionamentoLeitos(i, 1);
% 
%     
%     varTemp1 = strsplit(list{leitoIni+79},';');
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,1) = str2double(error);
%     errorLinearizacaoMin2(i,1) = str2double(errorMin);
%     errorLinearizacaoMax2(i,1) = str2double(errorMax);
%     errorLinearizacaoRange2(i,1) = str2double(range);
%     
%     
%     varTemp1 = strsplit(list{leitoIni+80},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,2) = str2double(error);
%     errorLinearizacaoMin2(i,2) = str2double(errorMin);
%     errorLinearizacaoMax2(i,2) = str2double(errorMax);
%     errorLinearizacaoRange2(i,2) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+81},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,3) = str2double(error);
%     errorLinearizacaoMin2(i,3) = str2double(errorMin);
%     errorLinearizacaoMax2(i,3) = str2double(errorMax);
%     errorLinearizacaoRange2(i,3) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+82},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,4) = str2double(error);
%     errorLinearizacaoMin2(i,4) = str2double(errorMin);
%     errorLinearizacaoMax2(i,4) = str2double(errorMax);
%     errorLinearizacaoRange2(i,4) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+83},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,5) = str2double(error);
%     errorLinearizacaoMin2(i,5) = str2double(errorMin);
%     errorLinearizacaoMax2(i,5) = str2double(errorMax);
%     errorLinearizacaoRange2(i,5) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+84},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,6) = str2double(error);
%     errorLinearizacaoMin2(i,6) = str2double(errorMin);
%     errorLinearizacaoMax2(i,6) = str2double(errorMax);
%     errorLinearizacaoRange2(i,6) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+85},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,7) = str2double(error);
%     errorLinearizacaoMin2(i,7) = str2double(errorMin);
%     errorLinearizacaoMax2(i,7) = str2double(errorMax);
%     errorLinearizacaoRange2(i,7) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+88},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError2(i,8) = str2double(error);
%     errorLinearizacaoMin2(i,8) = str2double(errorMin);
%     errorLinearizacaoMax2(i,8) = str2double(errorMax);
%     errorLinearizacaoRange2(i,8) = str2double(range);
% 
% end
% 
% errorLinearizacaoError2;
% errorLinearizacaoMin2;
% errorLinearizacaoMax2;
% errorLinearizacaoRange2;
% 
% %-----------------------------------------------------------------------
% % ler "Erros linearização" de todos os leitos #####Terceira Ececução Execução####
% errorLinearizacaoError3 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMin3 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMax3 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoRange3 = zeros(length(posicionamentoLeitos)-1,3);
% for i=1:length(posicionamentoLeitos)-1
%     leitoIni = posicionamentoLeitos(i, 1);
% 
%     
%     varTemp1 = strsplit(list{leitoIni+138},';');
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,1) = str2double(error);
%     errorLinearizacaoMin3(i,1) = str2double(errorMin);
%     errorLinearizacaoMax3(i,1) = str2double(errorMax);
%     errorLinearizacaoRange3(i,1) = str2double(range);
%     
%     
%     varTemp1 = strsplit(list{leitoIni+139},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,2) = str2double(error);
%     errorLinearizacaoMin3(i,2) = str2double(errorMin);
%     errorLinearizacaoMax3(i,2) = str2double(errorMax);
%     errorLinearizacaoRange3(i,2) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+140},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,3) = str2double(error);
%     errorLinearizacaoMin3(i,3) = str2double(errorMin);
%     errorLinearizacaoMax3(i,3) = str2double(errorMax);
%     errorLinearizacaoRange3(i,3) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+141},';'); 
%     errorMatTemp = char(varTemp1(1));
%    % errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,4) = str2double(error);
%     errorLinearizacaoMin3(i,4) = str2double(errorMin);
%     errorLinearizacaoMax3(i,4) = str2double(errorMax);
%     errorLinearizacaoRange3(i,4) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+142},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,5) = str2double(error);
%     errorLinearizacaoMin3(i,5) = str2double(errorMin);
%     errorLinearizacaoMax3(i,5) = str2double(errorMax);
%     errorLinearizacaoRange3(i,5) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+143},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,6) = str2double(error);
%     errorLinearizacaoMin3(i,6) = str2double(errorMin);
%     errorLinearizacaoMax3(i,6) = str2double(errorMax);
%     errorLinearizacaoRange3(i,6) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+144},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,7) = str2double(error);
%     errorLinearizacaoMin3(i,7) = str2double(errorMin);
%     errorLinearizacaoMax3(i,7) = str2double(errorMax);
%     errorLinearizacaoRange3(i,7) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+147},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError3(i,8) = str2double(error);
%     errorLinearizacaoMin3(i,8) = str2double(errorMin);
%     errorLinearizacaoMax3(i,8) = str2double(errorMax);
%     errorLinearizacaoRange3(i,8) = str2double(range);
% 
% end
% 
% errorLinearizacaoError3;
% errorLinearizacaoMin3;
% errorLinearizacaoMax3;
% errorLinearizacaoRange3;
% 
% 
% %-----------------------------------------------------------------------
% % ler "Erros linearização" de todos os leitos #####Quarta Ececução Execução####
% errorLinearizacaoError4 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMin4 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoMax4 = zeros(length(posicionamentoLeitos)-1,3);
% errorLinearizacaoRange4 = zeros(length(posicionamentoLeitos)-1,3);
% for i=1:length(posicionamentoLeitos)-1
%     leitoIni = posicionamentoLeitos(i, 1);
% 
%     
%     varTemp1 = strsplit(list{leitoIni+197},';');
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,1) = str2double(error);
%     errorLinearizacaoMin4(i,1) = str2double(errorMin);
%     errorLinearizacaoMax4(i,1) = str2double(errorMax);
%     errorLinearizacaoRange4(i,1) = str2double(range);
%     
%     
%     varTemp1 = strsplit(list{leitoIni+198},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,2) = str2double(error);
%     errorLinearizacaoMin4(i,2) = str2double(errorMin);
%     errorLinearizacaoMax4(i,2) = str2double(errorMax);
%     errorLinearizacaoRange4(i,2) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+199},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,3) = str2double(error);
%     errorLinearizacaoMin4(i,3) = str2double(errorMin);
%     errorLinearizacaoMax4(i,3) = str2double(errorMax);
%     errorLinearizacaoRange4(i,3) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+200},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,4) = str2double(error);
%     errorLinearizacaoMin4(i,4) = str2double(errorMin);
%     errorLinearizacaoMax4(i,4) = str2double(errorMax);
%     errorLinearizacaoRange4(i,4) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+201},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,5) = str2double(error);
%     errorLinearizacaoMin4(i,5) = str2double(errorMin);
%     errorLinearizacaoMax4(i,5) = str2double(errorMax);
%     errorLinearizacaoRange4(i,5) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+202},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,6) = str2double(error);
%     errorLinearizacaoMin4(i,6) = str2double(errorMin);
%     errorLinearizacaoMax4(i,6) = str2double(errorMax);
%     errorLinearizacaoRang4(i,6) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+203},';'); 
% errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,7) = str2double(error);
%     errorLinearizacaoMin4(i,7) = str2double(errorMin);
%     errorLinearizacaoMax4(i,7) = str2double(errorMax);
%     errorLinearizacaoRange4(i,7) = str2double(range);
% 
%     varTemp1 = strsplit(list{leitoIni+206},';'); 
%     errorMatTemp = char(varTemp1(1));
%     errorMat = errorMatTemp(2:end);
%     errorTemp = char(varTemp1(2));
%     error = errorTemp(7:end);
%     errorMinTemp = char(varTemp1(3));
%     errorMin = errorMinTemp(6:end);
%     errorMaxTemp = char(varTemp1(4));
%     errorMax = errorMaxTemp(6:end);
%     rangeTemp = char(varTemp1(5));
%     range = rangeTemp(8:end);
%     errorLinearizacaoError4(i,8) = str2double(error);
%     errorLinearizacaoMin4(i,8) = str2double(errorMin);
%     errorLinearizacaoMax4(i,8) = str2double(errorMax);
%     errorLinearizacaoRange4(i,8) = str2double(range);
% 
% end
% 
% errorLinearizacaoError4;
% errorLinearizacaoMin4;
% errorLinearizacaoMax4;
% errorLinearizacaoRange4;
% 
% 
% 
% %-----------------------------------------------------------------------
% % Média dos ErrorMax
% 
% MaxErrorPriExecTemp = max(errorLinearizacaoError1);
% MaxErrorPriExec = max(MaxErrorPriExecTemp);
% MaxErrorSecExecTemp = max(errorLinearizacaoError2);
% MaxErrorSecExec = max(MaxErrorSecExecTemp);
% MaxErrorTerExecTemp = max(errorLinearizacaoError3);
% MaxErrorTerExec = max(MaxErrorTerExecTemp);
% MaxErrorQuarExecTemp = max(errorLinearizacaoError4);
% MaxErrorQuarExec = max(MaxErrorQuarExecTemp);
% 
% % Média dos Error matriz 1x1
% % média de cada um dos materiais de todos leitos juntos
% 
% MedErrorPriExecTemp = mean(errorLinearizacaoError1);
% MedErrorPriExec = mean(MedErrorPriExecTemp);
% MedErrorSecExecTemp = mean(errorLinearizacaoError2);
% MedErrorSecExec = mean(MedErrorSecExecTemp);
% MedErrorTerExecTemp = mean(errorLinearizacaoError3);
% MedErrorTerExec = mean(MedErrorTerExecTemp);
% MedErrorQuarExecTemp = mean(errorLinearizacaoError4);
% MedErrorQuarExec = mean(MedErrorQuarExecTemp);
% 
% 
% % Média dos Error matriz 100x1
% % média de todos materiais para cada um dos leitos
% 
% for i=1:100
% MedErrorPriExecAllMat(i,1) = mean(errorLinearizacaoError1(i,:));
% MedErrorSecExecAllMat(i,1) = mean(errorLinearizacaoError2(i,:));
% MedErrorTriExecAllMat(i,1) = mean(errorLinearizacaoError3(i,:));
% MedErrorQuarExecAllMat(i,1) = mean(errorLinearizacaoError4(i,:));
% end
% 
% for i=1:100
% MedErrorExecAllMat(i,1) = mean(errorLinearizacaoError1(i,:));
% MedErrorExecAllMat(i,2) = mean(errorLinearizacaoError2(i,:));
% MedErrorExecAllMat(i,3) = mean(errorLinearizacaoError3(i,:));
% MedErrorExecAllMat(i,4) = mean(errorLinearizacaoError4(i,:));
% end
% 

%Desvio Padrão erros
% StdErrorPriExecTemp = std(errorLinearizacaoError1);
% StdErrorPriExec = std(StdErrorPriExecTemp);

%csvwrite('errorLinearizacaoError1.csv',errorLinearizacaoError1)
% csvwrite('MedErrorPriExecAllMat.csv',MedErrorPriExecAllMat);
% csvwrite('MedErrorSecExecAllMat.csv',MedErrorSecExecAllMat);
% csvwrite('MedErrorTriExecAllMat.csv',MedErrorTriExecAllMat);
% csvwrite('MedErrorQuarExecAllMat.csv',MedErrorQuarExecAllMat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------


% figure(3)%MgO
% plot(x, ya(:,3),'m','linewidth',2)
% grid on
% hold on
% plot(x, yb(:,3),'k','linewidth',2)
% hold on
% % plot(x, yc(:,1),'g','linewidth',2)
% % ylim([10 250])
% title('Otimização do leito de fusão')
% xlabel('Número de leitos')
% ylabel('MgO')
% legend('Leito Original','Leito Otimizado')


 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2)% MMN2
% %subplot(2,2,1)
% plot(x, za(:,4),'m','linewidth',2)
% hold on
% plot(x, zb(:,4),'K','linewidth',2)
% hold on
% grid on
% %title('Pesos Original')
% xlabel('Número de leitos')
% ylabel('MMN2')
% %legend('Leito Original','Leito Otimizado')

% figure(1)%QZO1
% %title('Pesos Original')
% %legend('Original','Otimizado','Location','NorthWestOutside')
% %subplot(2,2,1)
% plot(x, za(:,1),'m','linewidth',2)
% hold on
% plot(x, zb(:,1),'K','linewidth',2)
% hold on
% grid on
% title('Pesos Original Vs Otimizado')
% xlabel('Número de leitos')
% ylabel('Quartzo')



% figure(4)%KCA2
% %subplot(1,2,1)
% plot(x, za(:,6),'m','linewidth',2)
% hold on
% plot(x, zb(:,6),'K','linewidth',2)
% hold on
% grid on
% %title('Pesos Original')
% title('Calcário: Original Vs Otimizado','fontsize',12,'fontweight','b')
% %legend('Original','Otimizado','Location','NorthWest','fontsize',12,'fontweight','b')
% xlabel('Número de leitos','fontsize',12,'fontweight','b')
% ylabel('Calcário (Kg/t)','fontsize',12,'fontweight','b')
% %legend('Original','Otimizado','Location','NorthWest')
% 
% figure(5)%DOLB
% %subplot(1,2,2)
% plot(x, za(:,7),'m','linewidth',2)
% hold on
% plot(x, zb(:,7),'K','linewidth',2)
% hold on
% grid on
% title('Dolomita: Original Vs Otimizado','fontsize',12,'fontweight','b')
% xlabel('Número de leitos','fontsize',12,'fontweight','b')
% ylabel('Dolomita (Kg/t)','fontsize',12,'fontweight','b')
% legend('Original','Otimizado','Location','NorthWest')
% 
% figure(7)%Al2O3
% %subplot(2,2,4)
% plot(x, za(:,8),'m','linewidth',2)
% hold on
% plot(x, zb(:,8),'K','linewidth',2)
% hold on
% grid on
% title('Alumina: Original Vs Otimizado','fontsize',12,'fontweight','b')
% xlabel('Número de leitos','fontsize',12,'fontweight','b')
% ylabel('Alumina (%)','fontsize',12,'fontweight','b')
% legend('Original','Otimizado','Location','NorthWest')
% hold off
% 
% 
% figure(8)
% boxplot(MedErrorExecAllMat);
% title('Evolução do percentual de erro a cada iteração','fontsize',12,'fontweight','b')
% xlabel('Número de Iterações (PLS)','fontsize',12,'fontweight','b')
% ylabel('Percentual de erro (%)','fontsize',12,'fontweight','b')





