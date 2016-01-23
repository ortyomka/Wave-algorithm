PROGRAM Way(INPUT, OUTPUT);
CONST S = 1001;
VAR 
  StartX, StartY, FinishX, FinishY, SizeX, SizeY, Steps: INTEGER;
  statusWay: BYTE; {0 - No way, 1 - Labyrinth have way, 3 - ERROR}
  Digit: ARRAY [0 .. S, 0 .. S] OF INTEGER; {Array for processing}
  Symbol: ARRAY [0 .. S, 0 .. S] OF CHAR; {Array for save results}
  
PROCEDURE Reading; {READING}
VAR
  fileLabyrinth: TEXT;
  WindowX, WindowY: INTEGER;  
BEGIN {READ FILE}
  ASSIGN(fileLabyrinth, 'LABIRINT.TXT');
  RESET(fileLabyrinth);
  READ(fileLabyrinth, Symbol[0, 0]); {INSTAL SizeX}
  WHILE (Symbol[0, 0] = '#') AND (NOT EOLN(fileLabyrinth))
  DO
    BEGIN
      READ(fileLabyrinth, Symbol[0, 0]);
      IF Symbol[0, 0] = '#'
      THEN
        INC(SizeX)
    END; {INSTAL SizeX} 
  Symbol[0, 0] := '#'; {INSTAL SizeY}
  READLN(fileLabyrinth);
  WHILE (Symbol[0, 0] = '#') AND (NOT EOF(fileLabyrinth))
  DO
    BEGIN
      READ(fileLabyrinth, Symbol[0, 0]);
      READLN(fileLabyrinth);
      IF Symbol[0, 0] = '#'
      THEN
        INC(SizeY)  
    END; {INSTAL SizeY}
  RESET(fileLabyrinth);  
  StartY := 0;
  StartX := 0;
  WindowY := 0;
  WHILE NOT EOF(fileLabyrinth)
  DO
    BEGIN
      WindowX := 0;
      WHILE NOT EOLN(fileLabyrinth)
      DO
        BEGIN
          READ(fileLabyrinth, Symbol[WindowX, WindowY]);
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
      READLN(fileLabyrinth);
      IF (Symbol[SizeX, WindowY] <> '#') AND (WindowY <= SizeY) {Check INTEGRITY BOX IN WindowY}
      THEN
        statusWay := 3; {Check INTEGRITY BOX IN WindowX}  
      INC(WindowY)
    END; {READ FILE}
  IF ((StartX = 0) AND (StartY = 0)) OR ((FinishX = StartX) AND (FinishY = StartY))
  THEN
    statusWay := 3;
  CLOSE(fileLabyrinth) 
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
PROCEDURE firstWayCoordinates(firstFinishCoordinate, firstAddendum, secondFinishCoordinate, secondAddendum: INTEGER; firstCoordinate, secondCoordinate: ^INTEGER);
BEGIN
  firstCoordinate^ := firstFinishCoordinate + firstAddendum;
  secondCoordinate^ := secondFinishCoordinate + secondAddendum;
  Symbol[firstCoordinate^, secondCoordinate^] := '*'
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
            firstWayCoordinates(FinishX, 1, FinishY, 0, @WayX, @WayY) {Setting coordinate beginning of the path}
          ELSE  
            IF Digit[FinishX - 1, FinishY] = CountSteps 
            THEN
              firstWayCoordinates(FinishX, -1, FinishY, 0, @WayX, @WayY) {Setting coordinate beginning of the path} 
            ELSE
              IF Digit[FinishX, FinishY + 1] = CountSteps 
              THEN
                firstWayCoordinates(FinishX, 0, FinishY, 1, @WayX, @WayY) {Setting coordinate beginning of the path}
              ELSE
                IF Digit[FinishX, FinishY - 1] = CountSteps 
                THEN
                  firstWayCoordinates(FinishX, 0, FinishY, -1, @WayX, @WayY);{Setting coordinate beginning of the path}     
            WHILE (Symbol[StartX, StartY] = 'O') AND (CountSteps >= 0)
            DO
              BEGIN
                DEC(CountSteps);
                IF Digit[WayX + 1, WayY] = CountSteps {Check the box next and build the way}
                THEN
                  firstWayCoordinates(WayX, 1, WayY, 0, @WayX, @WayY)
                ELSE  
                  IF Digit[WayX - 1, WayY] = CountSteps 
                  THEN
                    firstWayCoordinates(WayX, -1, WayY, 0, @WayX, @WayY)
                  ELSE
                    IF Digit[WayX, WayY + 1] = CountSteps 
                    THEN
                      firstWayCoordinates(WayX, 0, WayY, 1, @WayX, @WayY)
                    ELSE
                      IF Digit[WayX, WayY - 1] = CountSteps 
                      THEN
                        firstWayCoordinates(WayX, 0, WayY, -1, @WayX, @WayY)    
              END
        END      
    END;   
END; {WAY} 

PROCEDURE Print;
VAR
  fileExit: TEXT;
  WindowX, WindowY: INTEGER;
BEGIN
  ASSIGN(fileExit, 'LABIRINT_EXIT.TXT');
  REWRITE(fileExit);
  Symbol[StartX, StartY] := 'O'; 
  IF statusWay = 1 
  THEN
    WRITELN(fileExit, 'Shortest way is ', Steps) {If there is Digit the way}
  ELSE
    IF statusWay = 0
    THEN
      WRITELN(fileExit, 'There is no way!!!') {If at the end there is no way} 
    ELSE
      WRITE(fileExit, 'ERROR'); {If the data is not correct}
  IF statusWay <> 3 
  THEN      
    FOR WindowY := 0 TO SizeY {Print Result}
    DO
      BEGIN
        FOR WindowX := 0 TO SizeX
        DO             
          WRITE(fileExit, Symbol[WindowX, WindowY]);  
        WRITELN(fileExit) 
      END; {Print Result}
  CLOSE(fileExit)     
END;
 
BEGIN
  Reading;     
  SearchWay;
  Print
END. {WAY}
