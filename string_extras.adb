with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Streams;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Containers.Indefinite_Vectors;

procedure Explode is
   package Segment_Container is new Ada.Containers.Indefinite_Vectors (
      Index_Type => Natural,
      Element_Type => String
   );
   LF         : Character renames Ada.Characters.Latin_1.LF;
   CR         : Character renames Ada.Characters.Latin_1.CR;
   Segments   : Segment_Container.Vector;
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
   Last       : Natural;
begin
   Last  := 1;
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
            Segments.Append (New_Item => Ada.Strings.Unbounded.To_String (
               Segment
            ));
         end;
      end if;
   end loop;

   for i in Segments.First_Index .. Segments.Last_Index loop
      Ada.Text_IO.Put_Line (Segments.Element (i));
   end loop;
end Explode;
