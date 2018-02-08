load('workspace_danewejsciowe.mat');

% dane uczace
D2u = D2(1:130,1);
DFAu = DFA(1:130,1);
HNRu = HNR(1:130,1);
Jitter_DDPu = JitterDDP(1:130,1);
MDVPAPQu = MDVPAPQ(1:130,1);
MDVPFhiHzu = MDVPFhiHz(1:130,1);
MDVPFloHzu = MDVPFloHz(1:130,1);
MDVPFoHzu = MDVPFoHz(1:130,1);
MDVPJitteru = MDVPJitter(1:130,1);
MDVPJitterAbsu = MDVPJitterAbs(1:130,1);
MDVPPPQu = MDVPPPQ(1:130,1);
MDVPRAPu = MDVPRAP(1:130,1);
MDVPShimmeru = MDVPShimmer(1:130,1);
MDVPShimmerdBu = MDVPShimmerdB(1:130,1);
NHRu = NHR(1:130,1);
PPEu = PPE(1:130,1);
RPDEu = RPDE(1:130,1);
ShimmerAPQ3u = ShimmerAPQ3(1:130,1);
ShimmerAPQ5u = ShimmerAPQ5(1:130,1);
ShimmerDDAu = ShimmerDDA(1:130,1);
spread1u = spread1(1:130,1);
spread2u = spread2(1:130,1);

% dane testowe
D2t = D2(131:195,1);
DFAt = DFA(131:195,1);
HNRt = HNR(131:195,1);
Jitter_DDPt = JitterDDP(131:195,1);
MDVPAPQt = MDVPAPQ(131:195,1);
MDVPFhiHzt = MDVPFhiHz(131:195,1);
MDVPFloHzt = MDVPFloHz(131:195,1);
MDVPFoHzt = MDVPFoHz(131:195,1);
MDVPJittert = MDVPJitter(131:195,1);
MDVPJitterAbst = MDVPJitterAbs(131:195,1);
MDVPPPQt = MDVPPPQ(131:195,1);
MDVPRAPt = MDVPRAP(131:195,1);
MDVPShimmert = MDVPShimmer(131:195,1);
MDVPShimmerdBt = MDVPShimmerdB(131:195,1);
NHRt = NHR(131:195,1);
PPEt = PPE(131:195,1);
RPDEt = RPDE(131:195,1);
ShimmerAPQ3t = ShimmerAPQ3(131:195,1);
ShimmerAPQ5t = ShimmerAPQ5(131:195,1);
ShimmerDDAt = ShimmerDDA(131:195,1);
spread1t = spread1(131:195,1);
spread2t = spread2(131:195,1);

%%
% status - oczekiwane wyjscia
statusu = status(1:130,1)';
statust = status(131:195,1)';
% wejscia sieci
Zbior_uczacy = [D2u DFAu HNRu Jitter_DDPu MDVPAPQu MDVPFhiHzu MDVPFloHzu MDVPFoHzu MDVPJitterAbsu MDVPJitteru MDVPPPQu MDVPRAPu MDVPShimmerdBu MDVPShimmeru NHRu PPEu RPDEu ShimmerAPQ3u ShimmerAPQ5u ShimmerDDAu spread1u spread2u]';
% zbior testowy
Zbior_testowy = [D2t DFAt HNRt Jitter_DDPt MDVPAPQt MDVPFhiHzt MDVPFloHzt MDVPFoHzt MDVPJitterAbst MDVPJittert MDVPPPQt MDVPRAPt MDVPShimmerdBt MDVPShimmert NHRt PPEt RPDEt ShimmerAPQ3t ShimmerAPQ5t ShimmerDDAt spread1t spread2t]';
% zbior wartosci oczekiwanych
Wartosci_oczekiwane = statusu;
for i=1:1:length(Wartosci_oczekiwane)
        if (Wartosci_oczekiwane(1,i) == 0)
            Wartosci_oczekiwane(2,i) = 1;
        else
             Wartosci_oczekiwane(2,i) = 0;  
        end   
end
% zbior wartosci oczekiawnych dla zbioru testowego
Wartosci_oczekiwane_zbioru_testowego = statust;
for i=1:1:length(Wartosci_oczekiwane_zbioru_testowego)
        if (Wartosci_oczekiwane_zbioru_testowego(1,i) == 0)
            Wartosci_oczekiwane_zbioru_testowego(2,i) = 1;
        else
             Wartosci_oczekiwane_zbioru_testowego(2,i) = 0;  
        end   
end
% utworzenie sieci

net = feedforwardnet([ 3 5 7 3 5 7 3 5 7], 'traingd'); 
% net = feedforwardnet([3 5 7], 'trainlm'); 
% parametry treningu sieci
net.trainParam.epochs=50;
Siec.trainParam.goal=1e-5;
% trening sieci
Siec_nauczona = train(net, Zbior_uczacy, Wartosci_oczekiwane);
% testowanie sieci
Test = Siec_nauczona(Zbior_testowy);

% sprawdzenie poprawnosci wynikow
licznikT=0;
licznikF=0;
for i=1:length(Test)
[wartoscmaxTest(i),indxTest(i)]=max(Test(:,i));
[wartoscmaxWartOczek(i),indxWartOczek(i)]=max(Wartosci_oczekiwane_zbioru_testowego(:,i));

if(indxTest(i) == indxWartOczek(i) && indxTest(i) == 1)
      disp('Pacjent chory');
    licznikT=licznikT+1;
elseif (indxTest(i)== indxWartOczek(i) && indxTest(i) == 2)
    disp('Pacjent zdrowy');
    licznikT=licznikT+1;
    
elseif(indxTest(i)~= indxWartOczek(i) && indxWartOczek(i) == 2)
    disp('Zdrowy wykryty jako chory')
    licznikF=licznikF+1;
else
    disp('Chory wykryty jako zdrowy')
    licznikF=licznikF+1;

end
end

%sprawdzenie poprawnoœci wyników 
disp('Wynik: ');
disp('dobrze rozpoznano: ');
disp(licznikT);
disp('Ÿle rozpoznano: ');
disp(licznikF);

%wyznaczenie skutecznoœci rozpoznawania
wynikprocent=(licznikT/65)*100;
disp('Skutecznoœæ rozpoznania: ');
disp(wynikprocent);

