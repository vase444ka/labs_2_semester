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
  speed=300;
  
function min(a, b: integer):integer;
begin
  if (a < b)then
    min:=a
  else
    min:=b;
end;  

function can_fit(x, y: integer): boolean;
begin
  can_fit:= (x >= 1) and (y >= 1) and (x <= W) and (y <= H);
end;

procedure generate_field(W, H, level: integer);
var
  tin, tout, used: array[1..100, 1..100] of integer;
  d:array[1..4] of point;
  cutpoints: boolean;
  timer: integer;
  
  procedure cutpoints_dfs(x, y, par_x, par_y: integer);  
  var children, i, next_x, next_y: integer;
  begin
    children := 0;
    used[x, y] := 1;
    tin[x, y] := timer;
    tout[x, y] := timer;
    inc(timer);
    
    for i:=1 to 4 do
    begin
      next_x := x + d[i].X;
      next_y := y + d[i].Y;
      if  (can_fit(next_x, next_y)) and (field[next_x, next_y] = 0) and ((next_x <> par_x) or (next_y <> par_y)) then
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
  
var i, j, ii, jj, start_x, start_y: integer;
begin
  d[1] := (-1, 0);
  d[2] := (1, 0);
  d[3] := (0, -1);
  d[4] := (0, 1);
  for i := 1 to H do
    for j := 1 to W do
    begin
      field[i][j] := wall;
      
      start_x := 1;
      start_y := 1;
      while (field[start_x, start_y] = wall) do
      begin
        inc(start_x);
        start_y := start_y + (start_x -1) div W;
        start_x := (start_x - 1) mod W + 1;      
      end;
      
      for ii := 1 to H do
        for jj := 1 to W do
          used[ii, jj] := 0;
      timer:=0;
      cutpoints := false;
      cutpoints_dfs(start_x, start_y, -1, -1);
          
      if (cutpoints = true) or (random(2, level_max + 1) > level) then
        field[i, j] := ground;
      
    end;
end;

procedure drawWall(x, y: integer);
begin
  setbrushcolor(clBlack);
  rectangle((x-1)*cell_size, (y - 1)*cell_size, x*cell_size, y*cell_size);
end;

procedure draw();
var
  y, x, i, lineX, lineY: integer;
begin
  clearWindow;
  
  for y := 1 to H do
    for x := 1 to W do
      if (field[x, y] = wall) then
        drawWall(x, y);
   
  for i:=1 to snakeSize do
  begin
    setbrushcolor(rgb(0,0, 255 div snakeSize * i));
    fillrectangle(cell_size*(snake[i].X - 1), cell_size*(snake[i].y - 1), cell_size*snake[i].X, cell_size*snake[i].Y);
  end;
  
  //DrawFood(food.X, food.Y);
  
  redraw;
  
end;

procedure get_level(var level: integer);
begin
  setbrushColor(rgb(125, 150, 160));
  fillRectangle(0, H*cell_size div 3, W*cell_size, H*cell_size div 3 *2);
  setFontSize(H*cell_size div 18);
  drawTextCentered(W*cell_size div 2, H*cell_size div 2, 'ENTER LEVEL: 1-10');
  redraw;
  read(level);
end;

procedure LoseScreen();
begin
  setbrushColor(clRed);
  fillRectangle(0, H*cell_size div 3, W*cell_size, H*cell_size div 3 *2);
  setFontSize(H*cell_size div 18);
  drawTextCentered(W*cell_size div 2, H*cell_size div 2, 'ZRADA');
  redraw;
end;

function is_alive(): boolean;
var head:point;
var i: integer;
begin
  head:=snake[1];
  is_alive:=true;
  if (field[head.x, head.y] = wall) then
    is_alive:=false;
  
  if not(can_fit(head.X, head.Y)) then
    is_alive:=false;
    
  for i:=2 to snakeSize do
    if (head = snake[i]) then
      is_alive:=false;    

end;

procedure turn(vk: integer);
begin
  if (vk>=37) and (vk<=40) then
    dir:=vk;
end;

procedure move();
begin

end;



var i, j, level: integer;
begin
  lockDrawing;
  setWindowSize(W*cell_size, H*cell_size);
  dir := 0;
  snakeSize:=1; snake[1].X := 1; snake[1].Y:=1;//snake head + first food;   
  for i:=1 to W do
    for j:=1 to H do
      field[i, j] := 0;
      
  get_level(level);      
  generate_field(W, H, level);
  
  onkeydown:=turn;
  
  while (true) do
  begin
    draw();
    sleep(speed);
    move();
  end;
  LoseScreen();
  
end.