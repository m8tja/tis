function H = naloga1(besedilo,p)
  
% besedilo - stolpicni vektor znakov (char)
% p  - stevilo poznanih predhodnih znakov; 0, 1, 2 ali 3.
%    p = 0 pomeni, da racunamo povprecno informacijo na znak
%        abecede brez poznanih predhodnih znakov: H(X1)
%    p = 1 pomeni, da racunamo povprecno informacijo na znak 
%        abecede pri enem poznanem predhodnemu znaku: H(X2|X1)
%    p = 2: H(X3|X1,X2)
%    p = 3: H(X4|X1,X2,X3)
%
% H - skalar; povprecna informacija na znak abecede 
%     z upostevanjem stevila poznanih predhodnih znakov p

    besedilo = besedilo';
    crke = isletter(besedilo);
    B = upper(besedilo(crke));
    
    N = 0;
%     f1 = histc(B, unique(B));
%     P1 = f1/length(B);
 
    if p == 0
        f1 = histc(B, unique(B));
        P1 = f1/length(B);
        N = nedolocenost(P1);
        
    elseif p == 1
        pari = [B(1:end-1);B(2:end)]';
        u = unique(pari, 'rows');
        [U, iA, iB] = unique(pari, 'rows');
        f2 = histc(iB, unique(iB));
        P2 = f2/(length(B) - 1);
        
        f1 = histc(B, unique(B));
        P1 = f1/length(B);
        
        N = nedolocenost(P2) - nedolocenost(P1);
        
    elseif p == 2
        trojice = [B(1:end-2);B(2:end-1);B(3:end)]';
        [U, iA, iB] = unique(trojice, 'rows');
        f3 = histc(iB, unique(iB));
        P3 = f3/(length(B) - 2);
        
        pari = [B(1:end-1);B(2:end)]';
        u = unique(pari, 'rows');
        [U, iA, iB] = unique(pari, 'rows');
        f2 = histc(iB, unique(iB));
        P2 = f2/(length(B) - 1);
        
        %fprintf("%f\n", P3);
        N = nedolocenost(P3) - nedolocenost(P2);
        
    elseif p == 3
        cetvorke = [B(1:end-3);B(2:end-2);B(3:end-1);B(4:end)]';
        [U, iA, iB] = unique(cetvorke, 'rows');
        f4 = histc(iB, unique(iB));
        P4 = f4/(length(B) - 3);
        
        trojice = [B(1:end-2);B(2:end-1);B(3:end)]';
        [U, iA, iB] = unique(trojice, 'rows');
        f3 = histc(iB, unique(iB));
        P3 = f3/(length(B) - 2);
        
        N = nedolocenost(P4) - nedolocenost(P3);
        %fprintf("%f\n", P4);
    end
    %fprintf("%s\n", B);
    %fprintf("%f\n", P);
    %fprintf("%f\n", N); 

H = N;
end

function H = nedolocenost(P)
    P = P(:)';
    N = -P * log2(P');
H = N;
end
