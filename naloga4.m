function izhod = naloga4(vhod,Fs)
% Funkcija naloga4 skusa poiskati akord v zvocnem zapisu.
%
% vhod  - vhodni zvocni zapis (vrsticni vektor tipa double) 
% Fs    - frekvenca vzorcenja
% izhod - ime akorda, ki se skriva v zvocnem zapisu (niz);
%         ce frekvence v zvocnem zapisu ne ustrezajo nobenemu
%         od navedenih akordov, vrnemo prazen niz [].

keySet = [261.63 277.18 293.66 311.13 329.63 349.23 369.99 392 415.30 440 466.16 493.88];
valueSet = {'C', 'CIS', 'D', 'DIS', 'E', 'F', 'FIS', 'G', 'GIS', 'A', 'B', 'H'};

M = containers.Map(keySet, valueSet);

keyString = {'CEG', 'CDISG', 'DFISA', 'DFA', 'EGISH', 'EGH', 'FAC', 'FGISC', 'GHD', 'GBD', 'ACISE', 'ACE', 'HDISFIS', 'HDFIS'};
valueString = {'Cdur', 'Cmol', 'Ddur', 'Dmol', 'Edur', 'Emol', 'Fdur', 'Fmol', 'Gdur', 'Gmol', 'Adur', 'Amol', 'Hdur', 'Hmol'};

Rez = containers.Map(keyString, valueString);

X = fft(vhod);

N = length(vhod);

%T = N / Fs;

P = abs(X).^2./N^2;

plot(P);

P2 = P(1:N/2);
P3 = P(1:N/2);

P2 = sort(P2, 'descend');

[~,idx] = ismember(P2, P3);

stTonov = 1;

indeksi = zeros(1,3);

for i=1:N/2
   
    ix = idx(i);
    
    temp = (Fs / N) * ix;
    
    if(temp <= 940 && temp <= Fs)
        if(stTonov == 1)
            indeksi(stTonov) = ix;
            stTonov = stTonov + 1;
        elseif(stTonov == 2)
            if(indeksi(1) + 1 ~= ix && indeksi(1) - 1 ~= ix)
                indeksi(stTonov) = ix;
                stTonov = stTonov + 1;
            end
        elseif(stTonov == 3)
            if(indeksi(1) + 1 ~= ix && indeksi(1) - 1 ~= ix && indeksi(2) + 1 ~= ix && indeksi(2) - 1 ~= ix)
                indeksi(stTonov) = ix;
                stTonov = stTonov + 1;
            end
        end
    end
            
end

indeksi = sort(indeksi, 'ascend');

prvi = (Fs / N) * indeksi(1);
drugi = (Fs / N) * indeksi(2);
tretji = (Fs / N) * indeksi(3);

if(prvi <= 500)
    [~, aIx] = min(abs(prvi - keySet));
else
    [~, aIx] = min(abs((prvi / 2) - keySet));
end

if(drugi <= 500)
    [~, bIx] = min(abs(drugi - keySet));
else
    [~, bIx] = min(abs((drugi / 2) - keySet));
end

if(tretji <= 500)
    [~, cIx] = min(abs(tretji - keySet));
else
    [~, cIx] = min(abs((tretji / 2) - keySet));
end

% disp(aIx);
% disp(bIx);
% disp(cIx);

keySet(aIx);
M(keySet(aIx));

r = strcat(M(keySet(aIx)),M(keySet(bIx)),M(keySet(cIx)));

if(isKey(Rez, r)) 
    izpis = Rez(r);
else
    izpis = [];
end

izhod = izpis;
end
