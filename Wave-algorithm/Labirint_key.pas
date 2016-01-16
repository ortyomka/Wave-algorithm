PROGRAM Way(INPUT, OUTPUT);
CONST S = 1001;
VAR 
  StartX, StartY, FinishX, FinishY, WindowY, WindowX, SizeX, SizeY, Status, Steps: INTEGER;
  Digit: ARRAY [0 .. S, 0 .. S] OF INTEGER; {Array for processing}
  Symbol: ARRAY [0 .. S, 0 .. S] OF CHAR; {Array for save results}

PROCEDURE CheckSize;
VAR
  F: TEXT;
BEGIN {WAY}
  ASSIGN(F, 'LABIRINT.TXT');
  RESET(F);
  READ(F, Symbol[0, 0]);{INSTAL SizeX}
  WHILE (Symbol[0, 0] = '#') AND (NOT EOLN(F))
  DO
    BEGIN
      READ(F, Symbol[0, 0]);
      IF Symbol[0, 0] = '#'
      THEN
        INC(SizeX)
    END;{INSTAL SizeX} 
  Symbol[0, 0] := '#';{INSTAL SizeY}
  READLN(F);
  WHILE (Symbol[0, 0] = '#') AND (NOT EOF(F))
  DO
    BEGIN
      READ(F, Symbol[0, 0]);
      READLN(F);
      IF Symbol[0, 0] = '#'
      THEN
        INC(SizeY)  
    END;{INSTAL SizeY} 
  CLOSE(F)  
END;
PROCEDURE Reading; {READING}
VAR
  F2: TEXT;                                                   
BEGIN {READ FILE}
  ASSIGN(F2, 'LABIRINT.TXT');
  RESET(F2);   
  StartY := 0;
  StartX := 0;
  WindowY := 0;
  WHILE NOT EOF(F2)
  DO
    BEGIN
      WindowX := 0;
      WHILE NOT EOLN(F2)
      DO
        BEGIN
          READ(F2, Symbol[WindowX, WindowY]);
          IF (Symbol[WindowX, WindowY] = '*') {Specify start and finish}
          THEN
            BEGIN
              IF (StartY = 0) AND (StartX = 0) {Specify start}
              THEN
                BEGIN
                  StartX := WindowX;
                  StartY := WindowY;
                  Digit[StartX, StartY] := 1;
                  FinishX := WindowX;
                  FinishY := WindowY;
                  Symbol[StartX, StartY] := 'O'
                END {Specify start}
              ELSE
                IF (FinishX = StartX) AND (FinishY = StartY) {Specify finish}
                THEN
                  BEGIN 
                    FinishX := WindowX;
                    FinishY := WindowY;
                    Symbol[FinishX, FinishY] := 'O'
                  END {Specify finish}
                ELSE
                  Status := 3;{ERROR}  
            END; {Specify start and finish}         
          IF Symbol[WindowX, WindowY] = '#' {Indicates walls} 
          THEN
            Digit[WindowX, WindowY] := -1
          ELSE {Indicates walls}
            IF Symbol[WindowX, WindowY] = ' ' {Indicates spaces}
            THEN
              Digit[WindowX, WindowY] := 0; {Indicates spaces}
          IF ((WindowX > SizeX) OR (WindowY > SizeY)) AND (Symbol[WindowX, WindowY] <> ' '){CHECK FRAME}
          THEN
            Status := 3;{CHECK FRAME}
          IF WindowY = SizeY {Check INTEGRITY BOX IN WindowX}
          THEN
            IF (Symbol[WindowX, SizeY] <> '#') AND (WindowX <= SizeX)
            THEN
              Status := 3;{Check INTEGRITY BOX IN WindowX}      
          INC(WindowX)    
        END;  
      READLN(F2);
      IF (Symbol[SizeX, WindowY] <> '#') AND (WindowY <= SizeY) {Check INTEGRITY BOX IN WindowY}
      THEN
        Status := 3;{Check INTEGRITY BOX IN WindowX}  
      INC(WindowY)
    END; {READ FILE}
    IF ((StartX = 0) AND (StartY = 0)) OR ((FinishX = StartX) AND (FinishY = StartY))
    THEN
      Status := 3;
  CLOSE(F2); 
END; {READING}

FUNCTION LetWaves(CountSteps: INTEGER): INTEGER;
BEGIN {WAVES}
  IF Status <> 3 
  THEN
    Status := 1;
  WHILE (Digit[FinishX, FinishY] = 0) AND (Status = 1) {WAVES}
  DO
    BEGIN
      Status := 0; {Check for occupancy}
      FOR WindowY := 0 TO SizeY 
      DO
        BEGIN
          FOR WindowX := 0 TO SizeX
          DO
            BEGIN
              IF Digit[WindowX, WindowY] = CountSteps - 1
              THEN
                BEGIN
                  IF Digit[WindowX + 1, WindowY] = 0 {Wave propagation}
                  THEN
                    BEGIN                
                      Digit[WindowX + 1, WindowY] := CountSteps; {Right}
                      Status := 1
                    END;
                  IF Digit[WindowX - 1, WindowY] = 0
                  THEN
                    BEGIN
                      Digit[WindowX - 1, WindowY] := CountSteps; {Left}
                      Status := 1
                    END;
                  IF Digit[WindowX, WindowY + 1] = 0
                  THEN
                    BEGIN
                      Digit[WindowX, WindowY + 1] := CountSteps; {Down}
                      Status := 1
                    END;
                  IF Digit[WindowX, WindowY - 1] = 0
                  THEN
                    BEGIN
                      Digit[WindowX, WindowY - 1] := CountSteps; {Up}
                      Status := 1
                    END {Wave propagation} 
                END  
            END
        END;
      INC(CountSteps) {Count Steps}  
    END; {WAVES}
  CountSteps := CountSteps - 2; {Subtract movement at the beginning and at the end}
  Steps := CountSteps; {Save resault}
  RETURN(CountSteps)
END; {WAVES}
 
PROCEDURE SearchWay;
VAR
  CountSteps, WayX, WayY: INTEGER;
BEGIN {WAY}
  CountSteps := LetWaves(2);
  IF Status = 1 {Checking for path}
  THEN
    BEGIN
      IF (StartX <> FinishX) OR (StartY <> FinishY)
      THEN
        BEGIN
          IF Digit[FinishX + 1, FinishY] = CountSteps {Check the box next and sets the first coordinate}
          THEN
            BEGIN
              Symbol[FinishX + 1, FinishY] := '*'; {Check Right}
              WayX := FinishX + 1; {Setting coordinate beginning of the path}
              WayY := FinishY 
            END
          ELSE  
            IF Digit[FinishX - 1, FinishY] = CountSteps 
            THEN
              BEGIN
                Symbol[FinishX - 1, FinishY] := '*'; {Check Left}
                WayX := FinishX - 1; {Setting coordinate beginning of the path}
                WayY := FinishY 
              END
            ELSE
              IF Digit[FinishX, FinishY + 1] = CountSteps 
              THEN
                BEGIN
                  Symbol[FinishX, FinishY + 1] := '*'; {Check Down}
                  WayX := FinishX; {Setting coordinate beginning of the path}
                  WayY := FinishY + 1
                END
              ELSE
                IF Digit[FinishX, FinishY - 1] = CountSteps 
                THEN
                  BEGIN
                    Symbol[FinishX, FinishY - 1] := '*'; {Check Up}
                    WayX := FinishX; {Setting coordinate beginning of the path}
                    WayY := FinishY - 1
                  END;
            WHILE (Symbol[StartX, StartY] = 'O') AND (CountSteps >= 0)
            DO
              BEGIN
                CountSteps := CountSteps - 1;
                IF Digit[WayX + 1, WayY] = CountSteps {Check the box next and build the way}
                THEN
                  BEGIN
                    Symbol[WayX + 1, WayY] := '*'; {Check Right}
                    INC(WayX)
                  END
                ELSE  
                  IF Digit[WayX - 1, WayY] = CountSteps 
                  THEN
                    BEGIN
                      Symbol[WayX - 1, WayY] := '*'; {Check Left}
                      DEC(WayX)
                    END
                  ELSE
                    IF Digit[WayX, WayY + 1] = CountSteps 
                    THEN
                      BEGIN
                        Symbol[WayX, WayY + 1] := '*'; {Check Down}
                        INC(WayY)
                      END
                    ELSE
                      IF Digit[WayX, WayY - 1] = CountSteps 
                      THEN
                        BEGIN
                          Symbol[WayX, WayY - 1] := '*'; {Check Up}
                          DEC(WayY)
                        END;     
              END
        END      
    END;   
END;{WAY} 

PROCEDURE Print;
VAR
  F1: TEXT;
BEGIN
  ASSIGN(F1, 'LABIRINT_EXIT.TXT');
  REWRITE(F1);
  Symbol[StartX, StartY] := 'O'; 
  IF Status = 1 
  THEN
    WRITELN(F1, 'Shortest way is ', Steps) {If there is Digit the way}
  ELSE
    IF Status = 0
    THEN
      WRITELN(F1, 'There is no way!!!') {If at the end there is no way} 
    ELSE
      WRITE(F1, 'ERROR'); {If the data is not correct}
  IF Status <> 3 
  THEN      
    FOR WindowY := 0 TO SizeY {Print Result}
    DO
      BEGIN
        FOR WindowX := 0 TO SizeX
        DO             
          WRITE(F1, Symbol[WindowX, WindowY]);  
        WRITELN(F1) 
      END; {Print Result}
  CLOSE(F1)     
END;
 
BEGIN
  CheckSize;
  Reading;
  SearchWay;
  Print
END. {WAY}
