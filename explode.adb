with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Streams;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;

procedure Explode is
   LF : Character renames Ada.Characters.Latin_1.LF;
   CR : Character renames Ada.Characters.Latin_1.CR;

   Lines      : array (1 .. 64) of Ada.Strings.Unbounded.Unbounded_String;
   Source     : Ada.Strings.Unbounded.Unbounded_String :=
      Ada.Strings.Unbounded.To_Unbounded_String (
         "GET /demo HTTP/1.1" & CR & LF &
         "Host: example.com" & CR & LF &
         "Connection: Upgrade" & CR & LF &
         "Sec-WebSocket-Key2: 12998 5 Y3 1  .P00" & CR & LF &
         "Sec-WebSocket-Protocol: sample" & CR & LF &
         "Upgrade: WebSocket" & CR & LF &
         "Sec-WebSocket-Key1: 4 @1  46546xW%0l 1 5" & CR & LF &
         "Origin: http://example.com" & CR & LF &
         "" & CR & LF &
         "^n:ds[4U"
      );
--   Token_Set  : Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set (
--      Sequence => LF & CR
--   );
   First      : Positive;
   Last       : Natural;

begin
--   Ada.Strings.Unbounded.Find_Token (
--      Source => Source,
--      Set => Token_Set,
--      Test => Ada.Strings.Inside,
--      First => First,
--      Last => Last
--   );
   Last  := 1;
   First := 1;
   while Last /= 0 loop
      Last := Ada.Strings.Unbounded.Index (
         Source => Source,
         Pattern => CR & LF
      );
      if Last /= 0 then
         declare
            Segment : Ada.Strings.Unbounded.Unbounded_String;
         begin
            Segment := Ada.Strings.Unbounded.To_Unbounded_String (
               Ada.Strings.Unbounded.Slice (Source, 1, Last)
            );
            Source := Ada.Strings.Unbounded.To_Unbounded_String (
               Ada.Strings.Unbounded.Slice (Source, Last + 2,
                  Ada.Strings.Unbounded.Length (Source)
               )
            );
            Ada.Strings.Unbounded.Text_IO.Put_Line (Segment);
            Lines (First) := Segment;
            First := First + 1;
         end;
      end if;
   end loop;
end Explode;
