uses GraphABC;


var
  dir, snakeSize, W, H, level: integer;
  field: array [1..100, 1..100] of integer;
  snake: array [1..1000] of Point;
  food: Point;

const
  wall = 1;
  ground = 0;
  level_max = 10;
  cell_size = 20;
  
function min(a, b: integer):integer;
begin
  if (a < b)then
    min:=a
  else
    min:=b;
end;  

function can_fit(x, y: integer): boolean;
begin
  can_fit:= (x > 0) and (y > 0) and (x <= W) and (y <= H);
end;

procedure generate_field(W, H: integer);
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
          
      if (cutpoints = true) or (random(2, level_max + 1) > {level}8) then
        field[i, j] := ground;
      
      
    end;
end;


var i, j: integer;
begin
  W:=20;
  H:=20;
  setWindowSize(W*cell_size, H*cell_size);
  
  for i:=1 to W do
    for j:=1 to H do
      field[i, j] := 0;
      
  generate_field(W, H);
  
  
end.