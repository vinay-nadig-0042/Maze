Maze
----

Generic Algorithm to solve a X cross Y maze which has one start point and one(or more) end point.

Algorithm
---------

Brute Force method is used to solve the maze. A maze can always be solved if the left wall is followed.

Data Format
-----------

The maze is represented as a series of boxes each of which has 4 sides. The total number of boxes in a maze is 30 for example if its a 6 x 5 maze.

      +----+----+----+----+----+----+
      |  1 |  2 |  3 |  4 |  5 |  6 |----> Box Number 6
      +----+----+----+----+----+----+
      |  7 |  8 |  9 | 10 | 11 | 12 |
      +----+----+----+----+----+----+
      | 13 | 14 | 15 | 16 | 17 | 18 |
      +----+----+----+----+----+----+
      | 19 | 20 | 21 | 22 | 23 | 24 |
      +----+----+----+----+----+----+
      | 25 | 26 | 27 | 28 | 29 | 23 |
      +----+----+----+----+----+----+

### A Solvable Maze

                                 IN
      +----+----+----+----+----+    +
      |         |      TP           |
      +    +    +    +    +----+----+
      |    |         |    |         |
      +    +----+----+    +----+    +
      |      TP      |         |    |
      +----+    +    +----+    +    +
      |         |         |         |
      +    +----+----+----+----+    +
      |                             |
      +    +----+----+----+----+----+
       OUT

The maze can be solved with the following sequence of moves:

6, 5, 4, 3, 9, 8, 2, 1, 7, 13, 14, 20, 19, 25

6, 5, 4, 10, 16, 17, 23, 24, 23, 29, 28, 27, 26, 25

Concepts
--------

**Start Point** - The Starting Point in a maze - Eg: Box 6 is the starting point in the above mentioned maze.

**End Point** - The Ending Point to be reached to solve a maze. Eg: Box 25 is the End Point.

**Box** - A section of the maze which contain 4 sides.

**Adjacent Boxes** - Every box has 4 adjacent boxes - Left, Right, Top, Bottom. Eg: Adjacent Boxes to Box 9 are 3, 10, 15, 8.

**Traversable Boxes** - A box has 0 or more traversable boxes adjacent to it. A traversable box is an adjacent box to which the Player can be moved to solve the maze. Eg: Traversable Boxes for Box 14 are 20, 15 if Box No 13 is already traversed. Traversable Boxes do not include Boxes that have already been traversed.

**Dead End** - A Box is called a Dead End if it contains 0 Traversable Boxes adjacent to it. Eg: Box 22 is a Dead End in the maze depicted above.

**Player** - The Entity that is solving the maze. A Player always belongs to a single Box and it's past positions identify the Path taken.

**Path** - The Path that the Player takes to solve the maze.

**Backtrack** - The Path needs to be backtracked to the last Turning Point if we hit a Dead End while solving a maze. Eg: If Dead End - Box 22 is encountered, Player needs to backtrack to the last Turning Point - Box No 14.

**Turning Point** - A Box is said to be a Turning Point if it contains more than 1 traversable box. Eg: Box Number 14.


Commands
--------

### Setup

```
bundle
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate
```

### Load a maze

```
b exec rake "maze:load[6, 5, maze]"
```
Loads a file called maze.csv located in `db/data/` folder into the database. (6 & 5 Represent the width & height of the mze)

### Solve a maze

```
b exec rake maze:solve
```

Solves the currently loaded maze.

Examples
--------

All the examples mentioned below are part of the repository. You can add additional repositories by adding csv files to `db/data/` folder.

### Load & Solve a Solvable Maze

```
b exec rake "maze:load[6, 5, maze]"
b exec rake maze:solve

```

### Load & Solve a Maze with Multiple Dead Ends

```
b exec rake "maze:load[6, 5, solvable_with_2_deadends]"
b exec rake maze:solve
```

### Load & Try to Solve an Unsolvable Maze

```
b exec rake "maze:load[6, 5, unsolvable]"
b exec rake maze:solve
```

### Solvable Maze with 2 Dead Ends

                                 IN
      +----+----+----+----+----+    +
      |         |      TP           |
      +    +    +    +    +----+----+
      |    |         |    |         |
      +    +----+----+    +----+    +
      |      TP      |         |    |
      +----+    +    +----+    +    +
      | DE      |      DE |         |
      +----+----+----+----+----+    +
      |                             |
      +    +----+----+----+----+----+
       OUT

**TP** - Turning Point
**DE** - Dead End

### Unsolvable Maze

                                 IN
      +----+----+----+----+----+    +
      |         |      TP           |
      +    +    +    +    +----+----+
      |    |         |    |         |
      +    +----+----+    +----+    +
      |      TP      |         |    |
      +----+    +    +----+    +    +
      | DE      |      DE |         |
      +----+----+----+----+----+----+
      |                             |
      +    +----+----+----+----+----+
       OUT

**TP** - Turning Point
**DE** - Dead End