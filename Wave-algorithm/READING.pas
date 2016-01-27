UNIT READING;
INTERFACE
  CONST S = 1001;
  TYPE intDig = ARRAY [0 .. S, 0 .. S] OF INTEGER;
  TYPE intSym = ARRAY [0 .. S, 0 .. S] OF CHAR;
  PROCEDURE instalSizeX(fileMaze: TEXT; sizeX: ^INTEGER);
  PROCEDURE instalSizeY(fileMaze: TEXT; sizeY: ^INTEGER);
  PROCEDURE SizeMaze(sizeX, sizeY: ^INTEGER);
  PROCEDURE errorOneOrNotPoint(startX, startY, finishX, finishY: INTEGER; statusWay: ^BYTE);
  PROCEDURE errorWithWallDown(X, Y, currentValue,Border: INTEGER; statusWay: ^BYTE; Symbol: intSym);
  PROCEDURE errorWithWallUp(windowX, sizeX, windowY, sizeY: INTEGER; statusWay: ^BYTE; Symbol: intSym);
  PROCEDURE fillingSymbolArray(windowX, windowY: INTEGER; startX, startY, finishX, finishY: ^INTEGER; statusWay: ^BYTE; Digit: intDig; Symbol: intSym);
  PROCEDURE fillingArrays(maze: TEXT; WindowX, WindowY: INTEGER; StartX, StartY, FinishX, FinishY, SizeX, SizeY: ^INTEGER; statusWay: ^BYTE; Digit: intDig; Symbol: intSym);
  PROCEDURE ReadingFile(Digit: intDig; Symbol: intSym; SizeX, SizeY, StartX, StartY, FinishX, FinishY: ^INTEGER; statusWay: ^BYTE);
IMPLEMENTATION
  PROCEDURE instalSizeX(fileMaze: TEXT; sizeX: ^INTEGER);
    VAR
      Ch: CHAR;
  BEGIN
    READ(fileMaze, Ch); {INSTAL SizeX}
    WHILE (Ch = '#') AND (NOT EOLN(fileMaze))
    DO
      BEGIN
        READ(fileMaze, Ch);
        IF Ch = '#'
        THEN
          INC(sizeX^)
      END; {INSTAL SizeX}   
  END;
  
  PROCEDURE instalSizeY(fileMaze: TEXT; sizeY: ^INTEGER);
  VAR
    Ch: CHAR;
  BEGIN
    Ch := '#'; {INSTAL SizeY}
    READLN(fileMaze);
    WHILE (Ch = '#') AND (NOT EOF(fileMaze))
    DO
      BEGIN
        READ(fileMaze, Ch);
        READLN(fileMaze);
        IF Ch = '#'
        THEN
          INC(sizeY^)  
      END; {INSTAL SizeY}
  END;
  
  PROCEDURE SizeMaze(sizeX, sizeY: ^INTEGER);
  VAR
    fileLabyrinth: TEXT;
  BEGIN
    ASSIGN(fileLabyrinth, 'LABIRINT.TXT');
    RESET(fileLabyrinth);
    instalSizeX(fileLabyrinth, sizeX);
    instalSizeY(fileLabyrinth, sizeY);
    CLOSE(fileLabyrinth)
  END;
  
  PROCEDURE errorOneOrNotPoint(startX, startY, finishX, finishY: INTEGER; statusWay: ^BYTE);
  BEGIN
    IF ((startX = 0) AND (startY = 0)) OR ((finishX = startX) AND (finishY = startY))
    THEN
      statusWay^ := 4 
  END;
  
  PROCEDURE errorWithWallDown(X, Y, currentValue,Border: INTEGER; statusWay: ^BYTE; Symbol: intSym);
  BEGIN
    IF (Symbol[X, Y] <> '#') AND (currentValue <= Border) {Check INTEGRITY BOX IN WindowY}
    THEN
      statusWay^ := 3 {Check INTEGRITY BOX IN WindowX}
  END;
  
  PROCEDURE errorWithWallUp(windowX, sizeX, windowY, sizeY: INTEGER; statusWay: ^BYTE; Symbol: intSym);
  BEGIN
    IF ((windowX > sizeX) OR (windowY > sizeY)) AND (Symbol[windowX, windowY] <> ' ') {CHECK FRAME}
    THEN
      statusWay^ := 3;
  END;
  
  PROCEDURE fillingSymbolArray(windowX, windowY: INTEGER; startX, startY, finishX, finishY: ^INTEGER; statusWay: ^BYTE; Digit: intDig; Symbol: intSym);
  BEGIN
    CASE Symbol[windowX, windowY] OF
      '*': 
        IF (startY^ = 0) AND (startX^ = 0) {Specify start}
        THEN
          BEGIN
            startX^ := windowX;
            startY^ := windowY;
            Digit[startX^, startY^] := 1;
            finishX^ := windowX;
            finishY^ := windowY;
            Symbol[startX^, startY^] := 'O'
          END {Specify start}
        ELSE
          IF (finishX^ = startX^) AND (finishY^ = startY^) {Specify finish}
          THEN
            BEGIN 
              finishX^ := windowX;
              finishY^ := windowY;
              Symbol[finishX^, finishY^] := 'O'
            END {Specify finish}
          ELSE
            statusWay^ := 2; {ERROR} 
      '#': Digit[windowX, windowY] := -1;
      ' ': Digit[windowX, windowY] := 0
    END
  END;
  
  PROCEDURE fillingArrays(maze: TEXT; WindowX, WindowY: INTEGER; StartX, StartY, FinishX, FinishY, SizeX, SizeY: ^INTEGER; statusWay: ^BYTE; Digit: intDig; Symbol: intSym);
  BEGIN
    WHILE NOT EOF(maze)
    DO
      BEGIN
        WindowX := 0;
        WHILE NOT EOLN(maze)
        DO
          BEGIN
            READ(maze, Symbol[WindowX, WindowY]);
            fillingSymbolArray(WindowX, WindowY, StartX, StartY, FinishX, FinishY, statusWay, Digit, Symbol);
            errorWithWallUp(WindowX, SizeX^, WindowY, SizeY^, statusWay, Symbol);
            IF WindowY = SizeY^ {Check INTEGRITY BOX IN WindowX}
            THEN
              errorWithWallDown(WindowX, SizeY^, WindowX, SizeX^, statusWay, Symbol);
            INC(WindowX)    
          END;  
        READLN(maze);
        errorWithWallDown(SizeX^, WindowY, WindowY, SizeY^, statusWay, Symbol);
        INC(WindowY)
      END; {READ FILE}
  END;
  
  PROCEDURE ReadingFile(Digit:intDig; Symbol:intSym; SizeX, SizeY, StartX, StartY, FinishX, FinishY: ^INTEGER; statusWay: ^BYTE); {READING}
  VAR
    fileLabyrinth: TEXT;
    WindowX, WindowY: INTEGER;  
  BEGIN {READ FILE}
    SizeMaze(SizeX, SizeY);
    ASSIGN(fileLabyrinth, 'LABIRINT.TXT');
    RESET(fileLabyrinth);
    StartY^ := 0;
    StartX^ := 0;
    WindowY := 0;
    fillingArrays(fileLabyrinth, WindowX, WindowY, StartX, StartY, FinishX, FinishY, SizeX, SizeY, statusWay, Digit, Symbol);
    errorOneOrNotPoint(StartX^, StartY^, FinishX^, FinishY^, statusWay);
    CLOSE(fileLabyrinth) 
  END; {READING}
END.  