PROGRAM Way(INPUT, OUTPUT);
CONST S = 1001;
VAR 
  StartX, StartY, FinishX, FinishY, Y, X, BorderX, BorderY, CheckRoad, Steps: INTEGER;
  A: ARRAY [0 .. S, 0 .. S] OF INTEGER; {Iannea aey ia?aaioee}
  B: ARRAY [0 .. S, 0 .. S] OF CHAR; {Iannea aey auaiaa}

PROCEDURE CheckSize;
VAR
  F: TEXT;
BEGIN
  ASSIGN(F, 'LABIRINT.TXT');
  RESET(F);
  READ(F, B[0, 0]);
  WHILE (B[0, 0] = '#') AND (NOT EOLN(F))
  DO
    BEGIN
      READ(F, B[0, 0]);
      IF B[0, 0] = '#'
      THEN
        INC(BorderX)
    END; 
  B[0, 0] := '#';
  READLN(F);
  WHILE (B[0, 0] = '#') AND (NOT EOF(F))
  DO
    BEGIN
    READ(F, B[0, 0]);
    READLN(F);
    IF B[0, 0] = '#'
    THEN
      INC(BorderY)  
    END; 
  CLOSE(F)  
END;
PROCEDURE Reading; {?oaiea}
VAR
  F2: TEXT;                                                   
  SaveX: INTEGER;
  Ch: CHAR;
BEGIN {READING}
  ASSIGN(F2, 'LABIRINT.TXT');
  RESET(F2);   
  StartY := 0;
  StartX := 0;
  Y := 0;
  WHILE NOT EOF(F2)
  DO
    BEGIN
      X := 0;
      WHILE NOT EOLN(F2)
      DO
        BEGIN
          READ(F2, B[X, Y]);
          IF (B[X, Y] = '*') {Iacia?aiea ia?aeuiiai e eiia?iiai cia?aiey}
          THEN
            BEGIN
              IF (StartY = 0) AND (StartX = 0) {Ia?aeuiia cia?aiea}
              THEN
                BEGIN
                  StartX := X;
                  StartY := Y;
                  A[StartX, StartY] := 1;
                  FinishX := X;
                  FinishY := Y;
                  B[StartX, StartY] := 'O'
                END {Ia?aeuiia cia?aiea}
              ELSE
                IF (FinishX = StartX) AND (FinishY = StartY)
                THEN
                  BEGIN {Eiia?iia cia?aiea}
                    FinishX := X;
                    FinishY := Y;
                    B[FinishX, FinishY] := 'O'
                  END {Eiia?iia cia?aiea}
                ELSE
                  CheckRoad := 3;  
            END; {Iacia?aiea ia?aeuiiai e eiia?iiai cia?aiey}         
          IF B[X, Y] = '#' {i?iaa?ea ia noaiee} 
          THEN
            A[X, Y] := -1
          ELSE {i?iaa?ea ia noaiee}
            IF B[X, Y] = ' ' {i?iaa?ea ia ionoia ianoi}
            THEN
              A[X, Y] := 0; {i?iaa?ea ia ionoia ianoi}
          IF ((X > BorderX) OR (Y > BorderY)) AND (B[X, Y] <> ' ')
          THEN
            CheckRoad := 3;
          IF Y = BorderY
          THEN
            IF (B[X, BorderY] <> '#') AND (X <= BorderX)
            THEN
              CheckRoad := 3;      
          X := X + 1;    
        END;  
      READLN(F2);
      IF (B[BorderX, Y] <> '#') AND (Y <= BorderY)
      THEN
        CheckRoad := 3;  
      Y := Y + 1
    END; {READ}
    IF ((StartX = 0) AND (StartY = 0)) OR ((FinishX = StartX) AND (FinishY = StartY))
    THEN
      CheckRoad := 3;
  CLOSE(F2); 
END; {READING}

FUNCTION WAVES(CountSteps: INTEGER): INTEGER;
BEGIN {WAVES}
  IF CheckRoad <> 3 
  THEN
    CheckRoad := 1;
  WHILE (A[FinishX, FinishY] = 0) AND (CheckRoad = 1) {WAVES}
  DO
    BEGIN
      CheckRoad := 0; {I?iaa?ea ia caiieiaiinou}
      FOR Y := 0 TO BorderY 
      DO
        BEGIN
          FOR X := 0 TO BorderX
          DO
            BEGIN
              IF A[X, Y] = CountSteps - 1
              THEN
                BEGIN
                  IF A[X + 1, Y] = 0 {?anni?ino?iiaiea aieiu}
                  THEN
                    BEGIN                
                      A[X + 1, Y] := CountSteps; {Ai?aai}
                      CheckRoad := 1
                    END;
                  IF A[X - 1, Y] = 0
                  THEN
                    BEGIN
                      A[X - 1, Y] := CountSteps; {Aeaai}
                      CheckRoad := 1
                    END;
                  IF A[X, Y + 1] = 0
                  THEN
                    BEGIN
                      A[X, Y + 1] := CountSteps; {Aiec}
                      CheckRoad := 1
                    END;
                  IF A[X, Y - 1] = 0
                  THEN
                    BEGIN
                      A[X, Y - 1] := CountSteps; {Aaa?o}
                      CheckRoad := 1
                    END {?anni?ino?iiaiea aieiu} 
                END  
            END
        END;
      CountSteps := CountSteps + 1 {N?ao?ee eooa?aoee}  
    END; {WAVES}
  CountSteps := CountSteps - 2; {Au?eoaai aae?aiea a ia?aea e a eiioa}
  Steps := CountSteps; {Nio?aiaiea iooe}
  RETURN(CountSteps)
END; {WAVES}
 
FUNCTION WAY: INTEGER;
VAR
  CountSteps, SX, SY: INTEGER;
BEGIN {WAY}
  CountSteps := WAVES(2);
  IF CheckRoad = 1 {I?iaa?ea ia iaee?ea iooe}
  THEN
    BEGIN
      IF (StartX <> FinishX) OR (StartY <> FinishY)
      THEN
        BEGIN
          IF A[FinishX + 1, FinishY] = CountSteps {I?iaa?yi eeaoee ?yaii e caaaai ia?ao? eii?aeiaoo}
          THEN
            BEGIN
              B[FinishX + 1, FinishY] := '*'; {i?iaa?ea Ni?aaa}
              SX := FinishX + 1; {Caaaiea eii?aeiao ia?aea iooe}
              SY := FinishY 
            END
          ELSE  
            IF A[FinishX - 1, FinishY] = CountSteps 
            THEN
              BEGIN
                B[FinishX - 1, FinishY] := '*'; {i?iaa?ea Neaaa}
                SX := FinishX - 1; {Caaaiea eii?aeiao ia?aea iooe}
                SY := FinishY 
              END
            ELSE
              IF A[FinishX, FinishY + 1] = CountSteps 
              THEN
                BEGIN
                  B[FinishX, FinishY + 1] := '*'; {i?iaa?ea Nieco}
                  SX := FinishX; {Caaaiea eii?aeiao ia?aea iooe}
                  SY := FinishY + 1
                END
              ELSE
                IF A[FinishX, FinishY - 1] = CountSteps 
                THEN
                  BEGIN
                    B[FinishX, FinishY - 1] := '*'; {i?iaa?ea Naa?oo}
                    SX := FinishX; {Caaaiea eii?aeiao ia?aea iooe}
                    SY := FinishY - 1
                  END;
            WHILE (B[StartX, StartY] = 'O') AND (CountSteps >= 0)
            DO
              BEGIN
                CountSteps := CountSteps - 1;
                IF A[SX + 1, SY] = CountSteps {I?iaa?yi eeaoee ?yaii e auno?aeaaai ioou}
                THEN
                  BEGIN
                    B[SX + 1, SY] := '*'; {I?iaa?yi Ni?aaa}
                    SX := SX + 1
                  END
                ELSE  
                  IF A[SX - 1, SY] = CountSteps 
                  THEN
                    BEGIN
                      B[SX - 1, SY] := '*'; {I?iaa?yi Neaaa}
                      SX := SX - 1
                    END
                  ELSE
                    IF A[SX, SY + 1] = CountSteps 
                    THEN
                      BEGIN
                        B[SX, SY + 1] := '*'; {I?iaa?yi Nieco}
                        SY := SY + 1
                      END
                    ELSE
                      IF A[SX, SY - 1] = CountSteps 
                      THEN
                        BEGIN
                          B[SX, SY - 1] := '*'; {I?iaa?yi Naa?oo}
                          SY := SY - 1
                        END;     
              END
        END      
    END;
  RETURN 0    
END;{WAY} 

FUNCTION Print(): INTEGER;
VAR
  F1: TEXT;
BEGIN
  ASSIGN(F1, 'LABIRINT_EXIT.TXT');
  REWRITE(F1);
  B[StartX, StartY] := 'O'; 
  IF CheckRoad = 1 
  THEN
    WRITELN(F1, 'Shortest way is ', Steps) {Anee ioou eiaaony}
  ELSE
    IF CheckRoad = 0
    THEN
      WRITELN(F1, 'There is no way!!!') {Anee e eiioo iao ai?ae} 
    ELSE
      WRITE(F1, 'ERROR');
  IF CheckRoad <> 3 
  THEN      
    FOR Y := 0 TO BorderY {Ia?ou ?acoeuoaoa}
    DO
      BEGIN
        FOR X := 0 TO BorderX
        DO
          BEGIN             
            WRITE(F1, B[X, Y])  
          END;
        WRITELN(F1) 
      END; {Ia?ou ?acoeuoaoa}
  CLOSE(F1);
  RETURN 0     
END;
 
BEGIN
  CheckSize;
  Reading();{?OAIEA}
  Way();{IINO?IAIIEA IEIEIAEUIIAI IOOE}
  Print(){AUAIA ?ACOEUOAOA}
END.
