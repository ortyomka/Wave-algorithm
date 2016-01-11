PROGRAM Way(INPUT, OUTPUT);
CONST S = 1001;
VAR 
  StartX, StartY, FinishX, FinishY, Y, X, BorderX, BorderY, CheckRoad, Steps: INTEGER;
  A: ARRAY [0 .. S, 0 .. S] OF INTEGER; {Массив для обработки}
  B: ARRAY [0 .. S, 0 .. S] OF CHAR; {Массив для вывода}

FUNCTION Reading():INTEGER; {Чтение}
VAR
  F2: TEXT;
  SaveX: INTEGER;
BEGIN {READING}
  ASSIGN(F2, 'LABIRINT.TXT');
  RESET(F2);
  StartY := -1;
  BorderY := 0;
  WHILE NOT EOF(F2)
  DO
    BEGIN
      BorderX := 0;
      WHILE NOT EOLN(F2)
      DO
        BEGIN
          READ(F2, B[BorderX, BorderY]);
          IF (B[BorderX, BorderY] = '*') {Назначение начального и конечного значения}
          THEN
            BEGIN
              IF StartY = -1 {Начальное значение}
              THEN
                BEGIN
                  StartX := BorderX;
                  StartY := BorderY;
                  A[StartX, StartY] := 1;
                  FinishX := BorderX;
                  FinishY := BorderY;
                  B[StartX, StartY] := 'O'
                END {Начальное значение}
              ELSE
                BEGIN {Конечное значение}
                  FinishX := BorderX;
                  FinishY := BorderY;
                  B[FinishX, FinishY] := 'O'
                END {Конечное значение}
            END; {Назначение начального и конечного значения}         
          IF B[BorderX, BorderY] = '#' {проверка на стенки} 
          THEN
            A[BorderX, BorderY] := -1
          ELSE {проверка на стенки}
            IF B[BorderX, BorderY] = ' ' {проверка на пустое место}
            THEN
              A[BorderX, BorderY] := 0; {проверка на пустое место}
          BorderX := BorderX + 1;
          IF SaveX < BorderX
            THEN
              SaveX := BorderX    
        END;  
      READLN(F2);
      BorderY := BorderY + 1
    END; {READ}
  CLOSE(F2);
  BorderX := SaveX - 1;
  BorderY := BorderY - 2;
  RETURN 0  
END; {READING}

FUNCTION WAVES(CountSteps: INTEGER): INTEGER;
BEGIN {WAVES}
  CheckRoad := 1;
  WHILE (A[FinishX, FinishY] = 0) AND (CheckRoad = 1) {WAVES}
  DO
    BEGIN
      CheckRoad := 0; {Проверка на заполненость}
      FOR Y := 0 TO BorderY 
      DO
        BEGIN
          FOR X := 0 TO BorderX
          DO
            BEGIN
              IF A[X, Y] = CountSteps - 1
              THEN
                BEGIN
                  IF A[X + 1, Y] = 0 {Расспростронение волны}
                  THEN
                    BEGIN                
                      A[X + 1, Y] := CountSteps; {Вправо}
                      CheckRoad := 1
                    END;
                  IF A[X - 1, Y] = 0
                  THEN
                    BEGIN
                      A[X - 1, Y] := CountSteps; {Влево}
                      CheckRoad := 1
                    END;
                  IF A[X, Y + 1] = 0
                  THEN
                    BEGIN
                      A[X, Y + 1] := CountSteps; {Вниз}
                      CheckRoad := 1
                    END;
                  IF A[X, Y - 1] = 0
                  THEN
                    BEGIN
                      A[X, Y - 1] := CountSteps; {Вверх}
                      CheckRoad := 1
                    END {Расспростронение волны} 
                END  
            END
        END;
      CountSteps := CountSteps + 1 {Счетчик иттераций}  
    END; {WAVES}
  CountSteps := CountSteps - 2; {Вычитаем движение в начале и в конце}
  Steps := CountSteps; {Сохранение пути}
  RETURN(CountSteps)
END; {WAVES}
 
FUNCTION WAY: INTEGER;
VAR
  CountSteps, SX, SY: INTEGER;
BEGIN {WAY}
  CountSteps := WAVES(2);
  IF CheckRoad = 1 {Проверка на наличие пути}
    THEN
      BEGIN
        IF (StartX <> FinishX) OR (StartY <> FinishY)
          THEN
            BEGIN
              IF A[FinishX + 1, FinishY] = CountSteps {Проверям клетки рядом и задаем первую координату}
                THEN
                  BEGIN
                    B[FinishX + 1, FinishY] := '*'; {проверка Справа}
                    SX := FinishX + 1; {Задание координат начала пути}
                    SY := FinishY 
                  END
                ELSE  
                  IF A[FinishX - 1, FinishY] = CountSteps 
                    THEN
                      BEGIN
                        B[FinishX - 1, FinishY] := '*'; {проверка Слева}
                        SX := FinishX - 1; {Задание координат начала пути}
                        SY := FinishY 
                      END
                    ELSE
                      IF A[FinishX, FinishY + 1] = CountSteps 
                        THEN
                          BEGIN
                            B[FinishX, FinishY + 1] := '*'; {проверка Снизу}
                            SX := FinishX; {Задание координат начала пути}
                            SY := FinishY + 1
                          END
                        ELSE
                          IF A[FinishX, FinishY - 1] = CountSteps 
                            THEN
                              BEGIN
                                B[FinishX, FinishY - 1] := '*'; {проверка Сверху}
                                SX := FinishX; {Задание координат начала пути}
                                SY := FinishY - 1
                              END;
              WHILE (B[StartX, StartY] = 'O') AND (CountSteps >= 0)
              DO
                BEGIN
                  CountSteps := CountSteps - 1;
                  IF A[SX + 1, SY] = CountSteps {Проверям клетки рядом и выстраиваем путь}
                    THEN
                      BEGIN
                        B[SX + 1, SY] := '*'; {Проверям Справа}
                        SX := SX + 1
                      END
                    ELSE  
                      IF A[SX - 1, SY] = CountSteps 
                        THEN
                          BEGIN
                            B[SX - 1, SY] := '*'; {Проверям Слева}
                            SX := SX - 1
                          END
                        ELSE
                          IF A[SX, SY + 1] = CountSteps 
                            THEN
                              BEGIN
                                B[SX, SY + 1] := '*'; {Проверям Снизу}
                                SY := SY + 1
                              END
                            ELSE
                              IF A[SX, SY - 1] = CountSteps 
                                THEN
                                  BEGIN
                                    B[SX, SY - 1] := '*'; {Проверям Сверху}
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
      WRITELN(F1, 'МИНИМАЛЬНЫЙ ПУТЬ РАВЕН ', Steps) {Если путь имеется}
    ELSE
      WRITELN(F1, 'ПУТИ НЕТ'); {Если к концу нет дорги} 
    FOR Y := 0 TO BorderY {Печть результата}
      DO
        BEGIN
          FOR X := 0 TO BorderX
          DO
            BEGIN             
              WRITE(F1, B[X, Y])  
            END;
          WRITELN(F1) 
        END; {Печть результата}
    CLOSE(F1);
    RETURN 0     
END;
 
BEGIN
  Reading();{ЧТЕНИЕ}
  Way();{ПОСТРОЕННИЕ МИНИМАЛЬНОГО ПУТИ}
  Print(){ВЫВОД РЕЗУЛЬТАТА}
END.
