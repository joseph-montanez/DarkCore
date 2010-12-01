with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Streams;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Hashed_Maps;

package body String_Extras is
   function Explode (
      Delimiter : String;
      Data : Ada.Strings.Unbounded.Unbounded_String
   ) return Segment_Container.Vector is
      Segments   : Segment_Container.Vector;
      Index_Of   : Natural;
      Source : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Source := Data;
      Index_Of  := 1;
      while Index_Of /= 0 loop
         Index_Of := Ada.Strings.Unbounded.Index (
            Source => Source,
            Pattern => Delimiter
         );
         if Index_Of /= 0 then
            declare
               Segment : Ada.Strings.Unbounded.Unbounded_String;
            begin
               Segment := Ada.Strings.Unbounded.To_Unbounded_String (
                  Ada.Strings.Unbounded.Slice (Source, 1, Index_Of)
               );
               Source := Ada.Strings.Unbounded.To_Unbounded_String (
                  Ada.Strings.Unbounded.Slice (
                     Source,
                     Index_Of + Delimiter'Length,
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

      Segments.Append (New_Item => Ada.Strings.Unbounded.To_String (Source));

      return Segments;
   end Explode;

   function Implode (
      Delimiter : String;
      Data      : Segment_Container.Vector;
   ) return String is
      i      : Integer;
      Output : Ada.Strings.Unbounded.Unbounded_String;
   begin
      i := 0;
      for i in Header.First_Index .. Header.Last_Index loop
         Ada.Strings.Unbounded.Append (
            Output, 
            Ada.Strings.Unbounded.To_Unbounded_String (Header.Element (i))
         );
         if i /= Header.Last_Index then
            Ada.Strings.Unbounded.Append (
               Output, 
               Ada.Strings.Unbounded.To_Unbounded_String (Delimiter)
            );
         end if;
      end loop;
      
      return Output;
   end Implode;
   
   function ParseHeader (Data : String) return Hashed is
      Header       : String_Extras.Segment_Container.Vector;
      Length       : Ada.Containers.Count_Type;
      Index_Of_Key : Natural;
      Line         : Ada.Strings.Unbounded.Unbounded_String;
      Header_Map   : Http.Header.Map;
   begin
      Header := String_Extras.Explode (
         CR & LF,
         Str
      );
      
      for i in Header.First_Index .. Header.Last_Index loop
         Ada.Text_IO.Put_Line ("Line: " & Header.Element (i));
         declare
            Index_Of_Key : Natural;
            Line : Ada.Strings.Unbounded.Unbounded_String;
         begin
            Ada.Strings.Unbounded.Append (Line, Header.Element (i));
            Index_Of_Key := Ada.Strings.Unbounded.Index (
               Line,
               "Sec-WebSocket-Key1"
            );
            Ada.Text_IO.Put_Line (Natural'Image (Index_Of_Key));
         end;
      end loop;
   end;
end String_Extras;
