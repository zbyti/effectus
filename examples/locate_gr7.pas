// Effectus auto-generated Mad Pascal source code listing
program locate_gr7Prg;

uses
  Crt, SySutils, Graph, CIO;

var
  strBuffer : string;
// Effectus example
// ----------------
// Using Locate in graphics mode

procedure MAINProc;
var
  key : byte;
  loc : byte;
begin  // 2
  InitGraph(7);
  SetColor(1);
  PutPixel(10, 10);
  MoveTo(10, 10);
  SetColor(2);
  PutPixel(20, 20);
  MoveTo(20, 20);
  SetColor(3);
  PutPixel(30, 30);
  MoveTo(30, 30);
  loc := GetPixel(20, 20);
  SetColor(LOC);
  PutPixel(60, 60);
  MoveTo(60, 60);
  key := Get(7);
  ReadKey;
end;

begin
  MAINProc;
end.
