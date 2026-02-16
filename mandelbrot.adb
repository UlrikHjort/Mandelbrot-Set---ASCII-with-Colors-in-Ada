-- ***************************************************************************
--               Mandelbrot Set - ASCII with Colors 
--
--           Copyright (C) 2026 By Ulrik Hørlyk Hjort
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
-- LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- ***************************************************************************    
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Mandelbrot is
   -- Terminal dimensions
   Width  : constant Integer := 120;
   Height : constant Integer := 40;

   -- Mandelbrot set bounds
   X_Min : constant Float := -2.5;
   X_Max : constant Float := 1.0;
   Y_Min : constant Float := -1.0;
   Y_Max : constant Float := 1.0;

   -- Maximum iterations
   Max_Iter : constant Integer := 100;

   -- ANSI color codes
   type Color_String is access String;

   function Get_Color(Iterations : Integer) return String is
   begin
      if Iterations = Max_Iter then
         return ASCII.ESC & "[48;5;0m"; -- Black background (inside set)
      elsif Iterations > 80 then
         return ASCII.ESC & "[48;5;53m"; -- Dark purple
      elsif Iterations > 60 then
         return ASCII.ESC & "[48;5;90m"; -- Purple
      elsif Iterations > 50 then
         return ASCII.ESC & "[48;5;127m"; -- Magenta
      elsif Iterations > 40 then
         return ASCII.ESC & "[48;5;196m"; -- Red
      elsif Iterations > 30 then
         return ASCII.ESC & "[48;5;208m"; -- Orange
      elsif Iterations > 20 then
         return ASCII.ESC & "[48;5;226m"; -- Yellow
      elsif Iterations > 10 then
         return ASCII.ESC & "[48;5;46m"; -- Green
      elsif Iterations > 5 then
         return ASCII.ESC & "[48;5;51m"; -- Cyan
      else
         return ASCII.ESC & "[48;5;21m"; -- Blue
      end if;
   end Get_Color;

   function Get_Character(Iterations : Integer) return Character is
   begin
      if Iterations = Max_Iter then
         return ' ';
      elsif Iterations > 80 then
         return '.';
      elsif Iterations > 60 then
         return ':';
      elsif Iterations > 40 then
         return '-';
      elsif Iterations > 20 then
         return '=';
      elsif Iterations > 10 then
         return '+';
      else
         return '#';
      end if;
   end Get_Character;

   function Calculate_Mandelbrot(C_Real, C_Imag : Float) return Integer is
      Z_Real : Float := 0.0;
      Z_Imag : Float := 0.0;
      Z_Real_Sq : Float;
      Z_Imag_Sq : Float;
      Temp : Float;
      Iter : Integer := 0;
   begin
      while Iter < Max_Iter loop
         Z_Real_Sq := Z_Real * Z_Real;
         Z_Imag_Sq := Z_Imag * Z_Imag;

         exit when Z_Real_Sq + Z_Imag_Sq > 4.0;

         Temp := Z_Real_Sq - Z_Imag_Sq + C_Real;
         Z_Imag := 2.0 * Z_Real * Z_Imag + C_Imag;
         Z_Real := Temp;

         Iter := Iter + 1;
      end loop;

      return Iter;
   end Calculate_Mandelbrot;

   X_Scale : constant Float := (X_Max - X_Min) / Float(Width);
   Y_Scale : constant Float := (Y_Max - Y_Min) / Float(Height);

   C_Real, C_Imag : Float;
   Iterations : Integer;
   Reset : constant String := ASCII.ESC & "[0m";

begin
   Put_Line(ASCII.ESC & "[2J" & ASCII.ESC & "[H"); -- Clear screen
   New_Line;

   for Y in 0 .. Height - 1 loop
      for X in 0 .. Width - 1 loop
         C_Real := X_Min + Float(X) * X_Scale;
         C_Imag := Y_Min + Float(Y) * Y_Scale;

         Iterations := Calculate_Mandelbrot(C_Real, C_Imag);

         Put(Get_Color(Iterations));
         Put(Get_Character(Iterations));
         Put(Reset);
      end loop;
      New_Line;
   end loop;

   New_Line;
end Mandelbrot;
