function [izhod, R, kodBela, kodCrna] = naloga2(vhod)
% Kodiranje slike "vhod" po prilagojenem standardu ITU-T T.4.
%
% vhod     - matrika, ki predstavlja sliko [n X 1728]
% izhod    - binarni vrsticni vektor
% R        - kompresijsko razmerje
% kodBela  - tabela dolzin kodnih zamenjav belih slikovnih tock
% kodCrna  - tabela dolzin kodnih zamenjav crnih slikovnih tock

n = size(vhod);
a = n(1);
b = n(2);

bela = zeros(1,1);

for i=1:a
    
    fb = find(diff([0,vhod(i,:),0]==1));
    pb = fb(1:2:end-1);
    %disp(pb);
    
    if i == 1
        bela = fb(2:2:end)-pb;
    else
        app = fb(2:2:end)-pb;
        bela = cat(2,bela,app);
    end
        %bela = [bela; app];
    %disp(i);
    if(vhod(i,1) == 0)
        bela = [-1, bela];
    end
end

crna = zeros(1,1);

for i=1:a
    fc = find(diff([1,vhod(i,:),1]==0));
    pc = fc(1:2:end-1);
    %crna = fc(2:2:end)-pc;
    
    if i == 1
        crna = fc(2:2:end)-pc;
    else
        app = fc(2:2:end)-pc;
        crna = cat(2,crna,app);
    end
end

noviA = unique(bela);
f1 = histc(bela, unique(bela));
P1 = f1/length(bela);

matrikaA = [noviA;P1]';
mA = sortrows(matrikaA,2);

noviB = unique(crna);
f2 = histc(crna, unique(crna));
P2 = f2/length(crna);

matrikaB = [noviB;P2]';
mB = sortrows(matrikaB,2);

steviloA = length(noviA);
steviloB = length(noviB);

stPreostalihA = steviloA;
stPreostalihB = steviloB;

vS = mA(:,1);
vA = mA(:,2);
vU = mB(:,1);
vB = mB(:,2);

stOperacijA = steviloA - 1;
stOperacijB = steviloB - 1;

z = zeros(stOperacijA + steviloA,5);

for i=1:steviloA
    z(i,1) = vS(i);
    z(i,2) = vA(i);
    z(i,5) = -1;
end

for i=steviloA:steviloA + stOperacijA
    z(i,5) = -1;
end

z = sortrows(z,[-2 1]);

y = zeros(stOperacijB + steviloB,5);

for i=1:steviloB
    y(i,1) = vU(i);
    y(i,2) = vB(i);
    y(i,5) = -1;
end

for i=steviloB:steviloB + stOperacijB
    y(i,5) = -1;
end

y = sortrows(y,[-2 1]);

stevecA = 1;
stevecB = 1;

z(z==0) = NaN;
z(z<0) = 0;

while stPreostalihA > 1
     
     [M,I] = min(z(:,2));
     z(steviloA+stevecA,3) = I;
     vsota = z(I,2);
     z(I,2) = 1.5;
     [M,I] = min(z(:,2));
     
     z(steviloA+stevecA,4) = I;
     vsota = vsota+z(I,2);
     %disp(vsota);
     z(steviloA+stevecA,2) = vsota;
     stevecA = stevecA+1;
     z(I,2) = 1.5;
     %disp(z);
   
     stPreostalihA = stPreostalihA-1;
end

%disp(z);

while stOperacijA > 0

    indeks1 = z(stOperacijA+steviloA,3);
    indeks2 = z(stOperacijA+steviloA,4);
    
    vrednost = z(stOperacijA+steviloA,5);
    
    z(indeks1,5) = vrednost + 1;
    z(indeks2,5) = vrednost + 1;
    
    stOperacijA = stOperacijA-1;
end
%disp(z);

y(y==0) = NaN;
y(y<0) = 0;

while stPreostalihB > 1
     
     [M,I] = min(y(:,2));
     y(steviloB+stevecB,3) = I;
     vsota = y(I,2);
     y(I,2) = 1.5;
     
     [M,I] = min(y(:,2));
     
     y(steviloB+stevecB,4) = I;
     vsota = vsota+y(I,2);
     y(steviloB+stevecB,2) = vsota;
     stevecB = stevecB+1;
     y(I,2) = 1.5;
   
     stPreostalihB = stPreostalihB-1;
end

while stOperacijB > 0

    indeks1 = y(stOperacijB+steviloB,3);
    indeks2 = y(stOperacijB+steviloB,4);
    
    vrednost = y(stOperacijB+steviloB,5);
    
    y(indeks1,5) = vrednost + 1;
    y(indeks2,5) = vrednost + 1;
    
    stOperacijB = stOperacijB-1;
end

kBela = zeros(steviloA,2);
kCrna = zeros(steviloB,2);
binA = zeros(steviloA,3);
binB = zeros(steviloB,3);

for i=1:steviloA
    kBela(i,1) = z(i,1);
    kBela(i,2) = z(i,5);
end

kBela = sortrows(kBela,[2 1]);

for i=1:steviloA
    binA(i,1) = kBela(i,1);
    binA(i,2) = kBela(i,2);
end

for i=1:steviloB
    kCrna(i,1) = y(i,1);
    kCrna(i,2) = y(i,5);
end

for i=1:steviloB
    binB(i,1) = kCrna(i,1);
    binB(i,2) = kCrna(i,2);
end

binA = sortrows(binA, [2 1]);
binB = sortrows(binB, [2 1]);
kCrna = sortrows(kCrna,[2 1]);

for i=2:steviloA
    razlika = binA(i,2) - binA(i-1,2);
    dolzina = binA(i-1,3) + 1;
    
    if(razlika ~= 0)
        dolzina = dolzina * (razlika*2);
    end
    
    binA(i,3) = dolzina;
end

if(steviloA == 1)
   binA(1,2) = 1;
end

%disp(binA);

for i=2:steviloB
    razlika = binB(i,2) - binB(i-1,2);
    
    dolzina = binB(i-1,3) + 1;
    
    if(razlika ~= 0)
        dolzina = dolzina * (razlika*2);
    end
    
    binB(i,3) = dolzina;
end

if(steviloB == 1)
   binB(1,2) = 1;
end

bela(bela<0) = 0;

%r = length(rezultat) / length(vhod(1:end));
if(length(kBela(:,1)) == 1)
    if(kBela(1,2) == 0)
        kBela(1,2) = 1;
    end
end

if(length(kCrna(:,1)) == 1)
    if(kCrna(1,2) == 0)
        kCrna(1,2) = 1;
    end
end

if(a == 1 && bela(1) == 1728)
    kCrna = double.empty;
end

%disp(kBela);

rez(1) = 0;
rezultat(1) = 0;
stevec = 1;

for i=1:a
    stBelih = 0;
    stCrnih = 0;
    trenutni = 0;
    prejsnji = 0;
    %stevec = 1;
    
    for j=1:b
        prejsnji = trenutni;
        trenutni = vhod(i,j);
        
        if(j == 1)
            if(trenutni == 0)
                stCrnih = stCrnih + 1;
            else
                stBelih = stBelih + 1;
            end
        else
            if(trenutni == prejsnji && trenutni == 1) 
                stBelih = stBelih + 1;
            elseif(trenutni == prejsnji && trenutni == 0)
                stCrnih = stCrnih + 1;
            elseif(trenutni ~= prejsnji) 
                if(trenutni == 1)
                    %disp("JA");
                    stBelih = stBelih + 1;
                    rez(stevec) = (-1)*stCrnih;
                    stCrnih = 0;
                    stevec = stevec + 1;
                else
                    stCrnih = stCrnih + 1;
                    rez(stevec) = stBelih;
                    stBelih = 0;
                    stevec = stevec + 1;
                end
            end
        end
    end
    
    if(stBelih > 0)
        rez(stevec) = stBelih;
        stevec = stevec + 1;
    elseif(stCrnih > 0)
        rez(stevec) = (-1)*stCrnih;
        stevec = stevec + 1;
    end
    
    if(vhod(i,1) == 0)
        rez = [0,rez];
        stevec = stevec + 1;
    end
    
    for v=1:length(rez)
        if(rez(v) >= 0)
            %disp(rez(v));
            ixA = find(binA(:,1) == rez(v));
            kodA = binA(ixA,3);
            dKodA = binA(ixA,2);
            
            xA = dec2bin(kodA,dKodA);
            xA = double(xA) - 48;
            
            for k=1:dKodA
                o = xA(k);
                if(v == 1 && k == 1)
                    rezultat = o;
                else
                    rezultat = [rezultat,o];
                end
            end
        else
            element = abs(rez(v));
            ixB = find(binB(:,1) == element);
            kodB = binB(ixB,3);
            dKodB = binB(ixB,2);
            
            xB = dec2bin(kodB,dKodB);
            xB = double(xB) - 48;
            
            for k=1:dKodB
                o = xB(k);
                rezultat = [rezultat,o];
            end
        end
    end
    
    if(i == 1)
        matrix = rezultat;
    else
        matrix = [matrix,rezultat];
        %disp(matrix);
    end
    
    stevec = 1;
    %disp(rez);
    rez = [];
end

%disp(rezultat);
r = length(matrix) / (length(vhod)*a);

izhod = matrix;
R = r;
kodBela = kBela;
kodCrna = kCrna;
end
