function [izhod, crc] = naloga3(vhod, n)
  % Izvedemo dekodiranje binarnega niza vhod, ki je bilo
  % zakodirano s Hammingovim kodom dolzine n.
  % in poslano po zasumljenem kanalu.
  % Nad vhodom izracunamo vrednost crc po standardu CRC-8-CCITT.
  %
  % vhod  - binarni vektor y (vrstica tipa double)
  % n     - stevilo bitov v kodni zamenjavi
  % crc   - crc vrednost izracunana po CRC-8-CCITT 
  %         nad vhodnim vektorjem (sestnajstisko)
  % izhod - vektor podatkovnih bitov, dekodiranih iz vhoda

    stPod = n;
    neki = stPod + 1;
    m = 1;

    while(neki ~= 2)
      neki = neki / 2;
      m = m + 1;
    end
    
    k = stPod - m;

    H = zeros(m, stPod);
    
    stevilka = 1;

    iY = 1;

    for i=1:stPod
        bin = dec2bin(stevilka,m);
        bin = double(bin) - 48;
        sum(bin);
        iX = 1;

        if sum(bin) ~= 1
            for j=length(bin):-1:1

                %if sum(bin) ~= 1
                H(j,iY) = bin(iX);
                iX = iX + 1;
                %end
            end
            %H(m+1,iY) = stevilka;
            iY = iY + 1;
        end

        stevilka = stevilka + 1;
    end

    for i=iY:stPod
        for j=1:m

            if (i-iY+1)==j
                  H(j,i) = 1;
            end
        end
    end
    
    stY = 1;
    rez(1) = -1;
    
    while stY < (length(vhod))
        %stLoop = stLoop + 1;
        H = H';
        yy = vhod(stY:stY+n-1);
        
        sin = mod((yy * H), 2);
        %disp(sin);
        
        F = H;
        H = H';
        
        sBin2 = int2str(sin);
        sBin2 = bin2dec(sBin2);
        
        [ia,ib]=ismember(sin,F,'rows');
        %disp(ib);
        
        indeks = ib;
        
        if sBin2 == 0
            y = yy;
        else
            y = yy;
            y(indeks) = y(indeks) + 1;
            
            if y(indeks) == 2
                y(indeks) = 0;
            end
            
        end
        
        if rez(1) == -1
            rez = y(1:k);
        else
            rez = [rez,y(1:k)];
        end
      
        stY = stY + stPod;
    end
    
    CRC = zeros(1,8);
    
    for i=1:length(vhod)
        pM = xor(vhod(i),CRC(8));
        
        if pM == 1
            CRC = circshift(CRC,1);
            CRC(1) = pM;
            CRC(2) = not(CRC(2));
            CRC(3) = not(CRC(3));
        else
            CRC = circshift(CRC,1);
            CRC(1) = pM;
        end
    end
    
    %disp(CRC);
    CRC = fliplr(CRC);
    %disp(CRC);
    
    prvi = CRC(1:4);
    drugi = CRC(5:8);
    
    prvi = dec2hex(bin2dec(num2str(prvi)));
    drugi = dec2hex(bin2dec(num2str(drugi)));
    
    C = [prvi,drugi];
    
    izhod = rez;
    crc = C;
    %izhod = nan;
    %crc = nan;
end
