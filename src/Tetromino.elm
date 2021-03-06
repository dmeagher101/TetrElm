module Tetromino exposing (..)

import Array exposing (..)
import Board exposing (..)

type TetroType = L | T | I | O | S | Z | J

type alias Tetromino =
    { tetro : TetroType
    , current : List (Int, Int)
    , position : Int
    }

l_type : TetroType
l_type =
  L

t_type : TetroType
t_type =
  T

i_type : TetroType
i_type =
  I

o_type : TetroType
o_type =
  O

s_type : TetroType
s_type =
  S

j_type : TetroType
j_type =
  J

z_type : TetroType
z_type =
  Z

tetroBlock : Tetromino -> Block
tetroBlock t =
  case t.tetro of
    L -> Orange
    I -> Cyan
    T -> Purple
    O -> Yellow
    S -> Green
    J -> Blue
    Z -> Red

resetTetro : Tetromino -> Tetromino
resetTetro t =
    case t.tetro of
        L -> makeTetro 0
        T -> makeTetro 1
        I -> makeTetro 2
        O -> makeTetro 3
        S -> makeTetro 4
        J -> makeTetro 5
        Z -> makeTetro 6

makeTetro : Int -> Tetromino
makeTetro i =
    case i of
        0 -> { tetro = l_type
             , current = [(0,0), (1,0), (2,0),(2,-1)]
             , position = 0
             }
        1 -> { tetro = t_type
             , current = [(0,0), (1,0), (1,-1),(2,0)]
             , position = 0
             }
        2 -> { tetro = i_type
             , current = [(0,0), (1,0), (2,0),(3,0)]
             , position = 0
             }
        3 -> { tetro = o_type
             , current = [(0,0),(1,0),(0,1),(1,1)]
             , position = 0
             }
        4 -> { tetro = s_type
             , current = [(0,0),(1,0),(1,-1),(2,-1)]
             , position = 0
             }
        5 -> { tetro = j_type
             , current = [(0,-1),(0,0),(1,0),(2,0)]
             , position = 0
             }
        6 -> { tetro = z_type
             , current = [(0,0),(1,0),(1,1),(2,1)]
             , position = 0
             }
        _ -> { tetro = l_type
             , current = [(0,0), (1,0), (2,0),(2,-1)]
             , position = 0
             }

checkCollision_ : Board -> (Int, Int) -> Bool
checkCollision_ b (x, y) =
  (x < 0) || (x > 9) || (y > 19) || ((getBlock b x y) /= E)

checkCollision : Board -> List (Int, Int) -> Bool
checkCollision b ps =
  List.foldr (||) False <| List.map (\ps_ -> checkCollision_ b ps_) ps

checkBelow_ : Board -> (Int, Int) -> Bool
checkBelow_ b (x, y) =
  let b_ = getBlock b x (y+1) in
  (y + 1) >= 20 || b_ /= E || b_ == Out

checkBelow : Board -> List (Int , Int) -> Bool
checkBelow b ps =
  case ps of
    [] -> False
    _ ->
      List.foldr (||) False <| List.map (checkBelow_ b) ps

checkLeft_ : Board -> (Int, Int) -> Bool
checkLeft_ b (x, y) =
  let b_ = getBlock b (x-1) y in
  x <= 0 || b_ /= E || b_ == Out

checkLeft : Board -> List (Int , Int) -> Bool
checkLeft b ps =
  case ps of
    [] -> False
    _ ->
      List.foldr (||) False <| List.map (checkLeft_ b) ps

checkRight_ : Board -> (Int, Int) -> Bool
checkRight_ b (x, y) =
  let b_ = getBlock b (x+1) y in
  x >= 10 || b_ /= E || b_ == Out

checkRight : Board -> List (Int , Int) -> Bool
checkRight b ps =
  case ps of
    [] -> False
    _ ->
      List.foldr (||) False <| List.map (checkRight_ b) ps

setTetro : Board -> Tetromino -> Board
setTetro b t =
  setTetro_ (tetroBlock t) b t.current

setTetro_ : Block -> Board -> List (Int, Int) -> Board
setTetro_ bl bo ps =
  case ps of
    [] -> bo
    (x,y)::tl ->
      let bo_ = setBlock bl bo x (y-1) in
      setTetro_ bl bo_ tl

rotateTetro: Board -> Tetromino -> Tetromino
rotateTetro b t =
    let
       (cs_, p_) = rotate t.tetro t.current t.position
    in
      if (checkCollision b cs_) then
        t
      else
       {tetro = t.tetro, current = cs_, position = p_}

rotate : TetroType -> List (Int,Int) -> Int -> (List (Int,Int), Int)
rotate tet cs p =
    case cs of
      [(x0,y0),(x1,y1),(x2,y2),(x3,y3)] ->
                if tet == l_type then
                        case p of
                            0 -> ([(x0+1,y0-1),
                                   (x1,  y1),
                                   (x2-1,y2+1),
                                   (x3  ,y3+2)],
                                   1)
                            1 -> ([(x0+1,y0+1),
                                   (x1,  y1),
                                   (x2-1,y2-1),
                                   (x3-2,y3)],
                                   2)
                            2 -> ([(x0-1,y0+1),
                                   (x1,  y1),
                                   (x2+1,y2-1),
                                   (x3,  y3-2)],
                                   3)
                            3 -> ([(x0-1,y0-1),
                                   (x1,  y1),
                                   (x2+1,y2+1),
                                   (x3+2,y3)],
                                   0)
                            _ -> (cs, 0)
                else if tet == t_type then
                        case p of
                            0 -> ([(x0+1,y0-1),
                                     (x1,  y1),
                                     (x2+1,y2+1),
                                     (x3-1,y3+1)],
                                     1)
                            1 -> ([(x0+1,y0+1),
                                     (x1,  y1),
                                     (x2-1,y2+1),
                                     (x3-1,y3-1)],
                                     2)
                            2 -> ([(x0-1,y0+1),
                                     (x1,  y1),
                                     (x2-1,y2-1),
                                     (x3+1,y3-1)],
                                     3)
                            3 -> ([(x0-1,y0-1),
                                     (x1,  y1),
                                     (x2+1,y2-1),
                                     (x3+1,y3+1)],
                                     0)
                            _ -> (cs, 0)
                else if tet == i_type then
                        case p of
                            0 -> ([(x0+2,y0-1),
                                     (x1+1,y1),
                                     (x2,  y2+1),
                                     (x3-1,y3+2)],
                                     1)
                            1 -> ([(x0+1,y0+2),
                                     (x1,  y1+1),
                                     (x2-1,y2),
                                     (x3-2,y3-1)],
                                     2)
                            2 -> ([(x0-2,y0+1),
                                     (x1-1,y1),
                                     (x2,  y2-1),
                                     (x3+1,y3-2)],
                                     3)
                            3 -> ([(x0-1,y0-2),
                                     (x1,  y1-1),
                                     (x2+1,y2),
                                     (x3+2,y3+1)],
                                     0)
                            _ -> (cs, 0)

                else if tet == o_type then (cs,0)

                else if tet == s_type then
                        case p of
                            0 -> ([(x0+1,y0-1),
                                     (x1,  y1),
                                     (x2+1,y2+1),
                                     (x3,  y3+2)],
                                     1)
                            1 -> ([(x0+1,y0+1),
                                     (x1,  y1),
                                     (x2-1,y2+1),
                                     (x3-2,y3)],
                                     2)
                            2 -> ([(x0-1,y0+1),
                                     (x1,  y1),
                                     (x2-1,y2-1),
                                     (x3,  y3-2)],
                                     3)
                            3 -> ([(x0-1,y0-1),
                                     (x1,  y1),
                                     (x2+1,y2-1),
                                     (x3+2,y3)],
                                     0)
                            _ -> (cs, 0)

                else if tet == j_type then
                        case p of
                            0 -> ([(x0+2,y0),
                                     (x1+1,y1-1),
                                     (x2,  y2),
                                     (x3-1,y3+1)],
                                     1)
                            1 -> ([(x0,  y0+2),
                                     (x1+1,y1+1),
                                     (x2,  y2),
                                     (x3-1,y3-1)],
                                     2)
                            2 -> ([(x0-2,y0),
                                     (x1-1,y1+1),
                                     (x2,  y2),
                                     (x3+1,y3-1)],
                                     3)
                            3 -> ([(x0,  y0-2),
                                     (x1-1,y1-1),
                                     (x2,  y2),
                                     (x3+1,y3+1)],
                                     0)
                            _ -> (cs, 0)

                else if tet == z_type then
                        case p of
                            0 -> ([(x0+2,y0),
                                     (x1+1,y1+1),
                                     (x2,  y2),
                                     (x3-1,y3+1)],
                                     1)
                            1 -> ([(x0,  y0+2),
                                     (x1-1,y1+1),
                                     (x2,  y2),
                                     (x3-1,y3-1)],
                                     2)
                            2 -> ([(x0-2,y0),
                                     (x1-1,y1-1),
                                     (x2,  y2),
                                     (x3+1,y3-1)],
                                     3)
                            3 -> ([(x0,  y0-2),
                                     (x1+1,y1-1),
                                     (x2,  y2),
                                     (x3+1,y3+1)],
                                     0)
                            _ -> (cs, 0)

                else (cs, 0)
      _ -> (cs, 0)

downTetro : Tetromino -> Tetromino
downTetro t =
    let
      cs = down t.current
    in
      {tetro = t.tetro, current = cs, position = t.position}

down : List (Int, Int) -> List (Int, Int)
down cs =
    case cs of
        [(x0,y0),(x1,y1),(x2,y2),(x3,y3)] ->
            List.map (\(x,y)-> (x,y+1)) cs
        _ -> cs

leftTetro : Tetromino -> Tetromino
leftTetro t =
    let
      cs = left t.current
      new = if (List.isEmpty (List.filter (\(x,y)->x<0) cs))
            then cs
            else t.current
    in
      {tetro = t.tetro, current = new, position = t.position}

left : List (Int, Int) -> List (Int, Int)
left cs =
    case cs of
        [(x0,y0),(x1,y1),(x2,y2),(x3,y3)] ->
            List.map (\(x,y)-> (x-1,y)) cs
        _ -> cs

rightTetro : Tetromino -> Tetromino
rightTetro t =
    let
      cs = right t.current
      new = if (List.isEmpty (List.filter (\(x,y)->x>=10) cs))
            then cs
            else t.current
    in
      {tetro = t.tetro, current = new, position = t.position}

right : List (Int, Int) -> List (Int, Int)
right cs =
    case cs of
        [(x0,y0),(x1,y1),(x2,y2),(x3,y3)] ->
            List.map (\(x,y)-> (x+1,y)) cs
        _ -> cs
