PROGRAM Way(INPUT, OUTPUT);
CONST S = 1001;
VAR 
  StartX, StartY, FinishX, FinishY, WindowY, WindowX, SizeX, SizeY, Steps: INTEGER;
  statusWay: BYTE; {0 - No way, 1 - Labyrinth have way, 3 - ERROR}
  Digit: ARRAY [0 .. S, 0 .. S] OF INTEGER; {Array for processing}
  Symbol: ARRAY [0 .. S, 0 .. S] OF CHAR; {Array for save results}
  
PROCEDURE Reading; {READING}
VAR
  fileWithLabyrinth: TEXT;                                                   
BEGIN {READ FILE}
  ASSIGN(fileWithLabyrinth, 'LABIRINT.TXT');
  RESET(fileWithLabyrinth);
  READ(fileWithLabyrinth, Symbol[0, 0]); {INSTAL SizeX}
  WHILE (Symbol[0, 0] = '#') AND (NOT EOLN(fileWithLabyrinth))
  DO
    BEGIN
      READ(fileWithLabyrinth, Symbol[0, 0]);
      IF Symbol[0, 0] = '#'
      THEN
        INC(SizeX)
    END; {INSTAL SizeX} 
  Symbol[0, 0] := '#'; {INSTAL SizeY}
  READLN(fileWithLabyrinth);
  WHILE (Symbol[0, 0] = '#') AND (NOT EOF(fileWithLabyrinth))
  DO
    BEGIN
      READ(fileWithLabyrinth, Symbol[0, 0]);
      READLN(fileWithLabyrinth);
      IF Symbol[0, 0] = '#'
      THEN
        INC(SizeY)  
    END; {INSTAL SizeY}
  RESET(fileWithLabyrinth);  
  StartY := 0;
  StartX := 0;
  WindowY := 0;
  WHILE NOT EOF(fileWithLabyrinth)
  DO
    BEGIN
      WindowX := 0;
      WHILE NOT EOLN(fileWithLabyrinth)
      DO
        BEGIN
          READ(fileWithLabyrinth, Symbol[WindowX, WindowY]);
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
                  statusWay := 3; {ERROR}  
            END; {Specify start and finish}         
          IF Symbol[WindowX, WindowY] = '#' {Indicates walls} 
          THEN
            Digit[WindowX, WindowY] := -1
          ELSE {Indicates walls}
            IF Symbol[WindowX, WindowY] = ' ' {Indicates spaces}
            THEN
              Digit[WindowX, WindowY] := 0; {Indicates spaces}
          IF ((WindowX > SizeX) OR (WindowY > SizeY)) AND (Symbol[WindowX, WindowY] <> ' ') {CHECK FRAME}
          THEN
            statusWay := 3; {CHECK FRAME}
          IF WindowY = SizeY {Check INTEGRITY BOX IN WindowX}
          THEN
            IF (Symbol[WindowX, SizeY] <> '#') AND (WindowX <= SizeX)
            THEN
              statusWay := 3; {Check INTEGRITY BOX IN WindowX}      
          INC(WindowX)    
        END;  
      READLN(fileWithLabyrinth);
      IF (Symbol[SizeX, WindowY] <> '#') AND (WindowY <= SizeY) {Check INTEGRITY BOX IN WindowY}
      THEN
        statusWay := 3; {Check INTEGRITY BOX IN WindowX}  
      INC(WindowY)
    END; {READ FILE}
  IF ((StartX = 0) AND (StartY = 0)) OR ((FinishX = StartX) AND (FinishY = StartY))
  THEN
    statusWay := 3;
  CLOSE(fileWithLabyrinth) 
END; {READING}

FUNCTION LetWaves(CountSteps: INTEGER): INTEGER;
VAR
  WindowY, WindowX: INTEGER;
BEGIN {WAVES}
  IF statusWay <> 3 
  THEN
    statusWay := 1;
  WHILE (Digit[FinishX, FinishY] = 0) AND (statusWay = 1) {WAVES}
  DO
    BEGIN
      statusWay := 0; {Check for occupancy}
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
                      statusWay := 1
                    END;
                  IF Digit[WindowX - 1, WindowY] = 0
                  THEN
                    BEGIN
                      Digit[WindowX - 1, WindowY] := CountSteps; {Left}
                      statusWay := 1
                    END;
                  IF Digit[WindowX, WindowY + 1] = 0
                  THEN
                    BEGIN
                      Digit[WindowX, WindowY + 1] := CountSteps; {Down}
                      statusWay := 1
                    END;
                  IF Digit[WindowX, WindowY - 1] = 0
                  THEN
                    BEGIN
                      Digit[WindowX, WindowY - 1] := CountSteps; {Up}
                      statusWay := 1
                    END {Wave propagation} 
                END  
            END
        END;
      INC(CountSteps) {Count Steps}  
    END; {WAVES}
  CountSteps := CountSteps - 2; {Subtract movement at the beginning and at the end}
  Steps := CountSteps; {Save resault}
  LetWaves := CountStepS
END; {WAVES}
FUNCTION WayCoordinates(Summand, DigitX, finishCoordinate: INTEGER; secondCoordinate: ^INTEGER): INTEGER;
VAR 
  Sum: INTEGER;
BEGIN
  Sum := Summand + DigitX;
  secondCoordinate^ := finishCoordinate;
  WayCoordinates := Sum
END;
PROCEDURE SearchWay;
VAR
  CountSteps, WayX, WayY: INTEGER;   
BEGIN {WAY}
  CountSteps := LetWaves(2);
  IF statusWay = 1 {Checking for path}
  THEN
    BEGIN
      IF (StartX <> FinishX) OR (StartY <> FinishY)
      THEN
        BEGIN
          IF Digit[FinishX + 1, FinishY] = CountSteps {Check the box next and sets the first coordinate}
          THEN
            BEGIN
              Symbol[FinishX + 1, FinishY] := '*'; {Check Right}
              WayX := WayCoordinates(FinishX, 1, FinishY, @WayY) {Setting coordinate beginning of the path}
            END
          ELSE  
            IF Digit[FinishX - 1, FinishY] = CountSteps 
            THEN
              BEGIN
                Symbol[FinishX - 1, FinishY] := '*'; {Check Left}
                WayX := WayCoordinates(FinishX, -1, FinishY, @WayY) {Setting coordinate beginning of the path} 
              END
            ELSE
              IF Digit[FinishX, FinishY + 1] = CountSteps 
              THEN
                BEGIN
                  Symbol[FinishX, FinishY + 1] := '*'; {Check Down}
                  WayY := WayCoordinates(FinishY, 1, FinishX, @WayX) {Setting coordinate beginning of the path}
                END
              ELSE
                IF Digit[FinishX, FinishY - 1] = CountSteps 
                THEN
                  BEGIN
                    Symbol[FinishX, FinishY - 1] := '*'; {Check Up}
                    WayY := WayCoordinates(FinishY, -1, FinishX, @WayX) {Setting coordinate beginning of the path}
                  END;     
            WHILE (Symbol[StartX, StartY] = 'O') AND (CountSteps >= 0)
            DO
              BEGIN
                DEC(CountSteps);
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
END; {WAY} 

PROCEDURE Print;
VAR
  fileWithExit: TEXT;
  WindowX, WindowY: INTEGER;
BEGIN
  ASSIGN(fileWithExit, 'LABIRINT_EXIT.TXT');
  REWRITE(fileWithExit);
  Symbol[StartX, StartY] := 'O'; 
  IF statusWay = 1 
  THEN
    WRITELN(fileWithExit, 'Shortest way is ', Steps) {If there is Digit the way}
  ELSE
    IF statusWay = 0
    THEN
      WRITELN(fileWithExit, 'There is no way!!!') {If at the end there is no way} 
    ELSE
      WRITE(fileWithExit, 'ERROR'); {If the data is not correct}
  IF statusWay <> 3 
  THEN      
    FOR WindowY := 0 TO SizeY {Print Result}
    DO
      BEGIN
        FOR WindowX := 0 TO SizeX
        DO             
          WRITE(fileWithExit, Symbol[WindowX, WindowY]);  
        WRITELN(fileWithExit) 
      END; {Print Result}
  CLOSE(fileWithExit)     
END;
 
BEGIN
  Reading;     
  SearchWay;
  Print
END. {WAY}
