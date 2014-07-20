H2048
=====
A Haskell implementation of the game 2048 + expectimax solver.

Gregor Ulm / Bill Murphy
2014


The original version of 2048 can be played online here:
gabrielecirulli.github.io/2048/

This program covers the game logic and IO, allowing you to
play 2048 in the console, as well as 2084-playing program.

***********************************************************

Files:
-----
- README.md: this file
- h2048.bak01: initial release, referred to in my blog post
 	"Implementing the game 2048 in less than 90 lines of
	 Haskell"
- h2048.hs: current version, with changes due to community
 	feedback
- hSolve2048.hs: expectimax implementation in Haskell and
    functions for applying it to this implementation of
    2048

Rules:
-----
- the starting position is always the same
- there are 4 moves: up, down, left, right; those
    inputs move all tiles in the respective direction
- two adjacent tiles with the same number merge into one
    tile that holds the sum of those numbers
- if, after a move, the board position has changed, one of
    the free tiles will turn into a 2 or a 4
- the game is over when the player has no move left, or
    when the number 2048 has been reached


Controls:
---------
- QUERTY: WASD
- Dvorak: CHTN
- e.g. in order to move all tiles up, you would have to press
	and release W or C


Execution:
----------
- play the game by running h2048.hs
- run the solver by running hSolve2048.hs


Notes:
------
- this is a prototype with a minimal terminal window UI
- it has been tested in GHCi 7.6.3 in Apple OS X and Linux

***********************************************************

Change Log:
===========

2014-06-15 (Gregor Ulm)
-----------------------
Initial release; game fully functional, but might require
pushing ENTER after a move was entered, depending on your
system configuration. I noticed that this was only an issue
in OS X, but not in Linux.

2014-06-16 (Gregor Ulm)
-----------------------
Dan Rosén (https://github.com/danr) sent a pull request,
containing several changes and additions. The following is a
direct consequence of his submission:
- disabled input buffering
- support for Dvorak
- printf for printing the grid
- separate function for randomly choosing an element of a list

2014-06-17 (Gregor Ulm)
-----------------------
Github user qzchenwl (https://github.com/qzchenwl) submitted a
patch that allows eta-reduction for the function 'move'.

2014-06-18 (Gregor Ulm)
-----------------------
The starting position was randomized.

2014-07-19 (Bill Murphy)
------------------------
The hSolve2048.hs file was added, and h2048.hs was converted
into a module so that its functions could be exported.
