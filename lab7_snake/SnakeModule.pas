uses GraphABC;


var
  dir, snakeSize: integer;
  field: array [1..100, 1..100] of integer;
  snake: array [1..1000] of Point;
  food: Point;

const
  wall = 1;
  ground = 0;
  level_max = 10;
  cell_size = 20;
  H = 20;
  W = 20;
  speed = 200;

function min(a, b: integer): integer;
begin
  if (a < b) then
    min := a
  else
    min := b;
end;

function can_fit(x, y: integer): boolean;
begin
  can_fit := (x >= 1) and (y >= 1) and (x <= W) and (y <= H);
end;

procedure generate_field(W, H, level: integer);
var
  tin, tout, used: array[1..100, 1..100] of integer;
  d: array[1..4] of point;
  cutpoints: boolean;
  timer: integer;
  
  procedure cutpoints_dfs(x, y, par_x, par_y: integer);
  var
    children, next_x, next_y: integer;
  begin
    children := 0;
    used[x, y] := 1;
    tin[x, y] := timer;
    tout[x, y] := timer;
    inc(timer);
    
    for var i :integer:= 1 to 4 do
    begin
      next_x := x + d[i].X;
      next_y := y + d[i].Y;
      if (can_fit(next_x, next_y)) and (field[next_x, next_y] = 0) and ((next_x <> par_x) or (next_y <> par_y)) then
        if (used[next_x, next_y] = 1) then
          tout[x, y] := min(tout[x, y], tin[next_x, next_y])
        else
        begin
          inc(children);
          cutpoints_dfs(next_x, next_y, x, y);
          tout[x, y] := min(tout[x, y], tout[next_x, next_y]);
          if (tout[next_x, next_y] >= tin[x, y]) and (par_x <> -1) then
            cutpoints := true;
        end;
      
      if (par_x = -1) and (par_y = -1) and (children > 1) then
        cutpoints := true;
    end;
  end;

var
  start_x, start_y: integer;
begin
  d[1] := (-1, 0);
  d[2] := (1, 0);
  d[3] := (0, -1);
  d[4] := (0, 1);
  for var i : integer := 1 to H do
    for var j: integer := 1 to W do
    begin
      field[i][j] := wall;
      
      start_x := 1;
      start_y := 1;
      while (field[start_x, start_y] = wall) do
      begin
        inc(start_x);
        start_y := start_y + (start_x - 1) div W;
        start_x := (start_x - 1) mod W + 1;      
      end;
      
      for var ii : integer := 1 to H do
        for var jj : integer := 1 to W do
          used[ii, jj] := 0;
      timer := 0;
      cutpoints := false;
      cutpoints_dfs(start_x, start_y, -1, -1);
      
      if (cutpoints = true) or (random(2, level_max + 1) > level) then
        field[i, j] := ground;
      
    end;
end;

procedure drawWall(x, y: integer);
begin
  setbrushcolor(clBlack);//todo
  fillrectangle((x - 1) * cell_size, (y - 1) * cell_size, x * cell_size, y * cell_size);
end;

procedure drawFood(x, y: integer);
begin
  setbrushcolor(clGreen);//todo
  fillrectangle((x - 1) * cell_size, (y - 1) * cell_size, x * cell_size, y * cell_size);
end;

procedure drawSnake(i: integer);
begin
  setbrushcolor(rgb(0, 0, 255 div snakeSize * i));//todo
  fillrectangle(cell_size * (snake[i].X - 1), cell_size * (snake[i].y - 1), cell_size * snake[i].X, cell_size * snake[i].Y);
end;

procedure drawAll();
begin
  clearWindow;
  
  for var y: integer := 1 to H do
    for var x: integer := 1 to W do
      if (field[x, y] = wall) then
        drawWall(x, y);
  
  for var i: integer := 1 to snakeSize do
    drawSnake(i);
  
  DrawFood(food.X, food.Y);
  
  redraw;
  
end;

procedure get_level(var level: integer);
begin
  setbrushColor(rgb(125, 150, 160));
  fillRectangle(0, H * cell_size div 3, W * cell_size, H * cell_size div 3 * 2);
  setFontSize(H * cell_size div 18);
  drawTextCentered(W * cell_size div 2, H * cell_size div 2, 'ENTER LEVEL: 1-10');
  redraw;
  read(level);
end;

procedure LoseScreen();
begin
  setbrushColor(clRed);
  fillRectangle(0, H * cell_size div 3, W * cell_size, H * cell_size div 3 * 2);
  setFontSize(H * cell_size div 18);
  drawTextCentered(W * cell_size div 2, H * cell_size div 2, 'ZRADA');
  redraw;
end;

function is_alive(): boolean;
var
  head: point;
begin
  head := snake[1];
  is_alive := true;
  if not (can_fit(head.X, head.Y)) then
    is_alive := false
  else
  if (field[head.x, head.y] = wall) then
    is_alive := false
  else
  for var i: integer := 2 to snakeSize do
    if (head = snake[i]) then
      is_alive := false;    
  
end;

procedure turn(vk: integer);
begin
  if (vk >= 37) and (vk <= 40) then
    dir := vk;
end;

procedure newFood();
begin
  food.X:=random(1, W);
  food.Y:=random(1, H);
  while (field[food.X, food.Y] = wall) do
  begin
    food.X:=random(1, W);
    food.Y:=random(1, H);
  end;
  //todo
end;

procedure move();
var
  head: point;
begin
  head := snake[1];
  if (dir = vk_up) then
    head.Y := head.Y - 1;
  
  if (dir = vk_down) then
    head.Y := head.Y + 1;
  
  if (dir = vk_left) then
    head.X := head.X - 1;
  
  if (dir = vk_right) then
    head.X := head.X + 1;
    
  if(head = food) then
  begin
    inc(snakeSize);
    newFood();
  end;
  
  if (dir <>0) then
  begin
    for var i: integer := snakesize downto 2 do
      snake[i] := snake[i - 1];
  
    snake[1] := head;
  end;
  
end;



var
  level: integer;

begin
  lockDrawing;//todo code cleanup
  setWindowSize(W * cell_size, H * cell_size);
  dir := 0;
  snakeSize := 1; 
  for var i: integer := 1 to W do
    for var j: integer := 1 to H do
      field[i, j] := 0; 
  
  get_level(level);      
  generate_field(W, H, level);
  snake[1].X := 1; 
  snake[1].Y := 1;
  while (field[snake[1].X, snake[1].Y] = wall) do
  begin
     snake[1].X:=snake[1].X + 1;
     snake[1].Y := snake[1].Y + (snake[1].X - 1) div W;
     snake[1].X := (snake[1].X- 1) mod W + 1;      
  end;
  
  
  onkeydown := turn;
  newFood();
  
  while (is_alive()) do
  begin
    drawAll();
    sleep(speed*level - 10*level*level);
    move();
  end;
  
  LoseScreen();
  onKeyDown:=nil;
  
end.