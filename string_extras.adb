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
      Data      : Segment_Container.Vector
   ) return String is
      i      : Integer;
      Output : Ada.Strings.Unbounded.Unbounded_String;
   begin
      i := 0;
      for i in Data.First_Index .. Data.Last_Index loop
         Ada.Strings.Unbounded.Append (
            Output,
            Ada.Strings.Unbounded.To_Unbounded_String (Data.Element (i))
         );
         if i /= Data.Last_Index then
            Ada.Strings.Unbounded.Append (
               Output,
               Ada.Strings.Unbounded.To_Unbounded_String (Delimiter)
            );
         end if;
      end loop;

      return Ada.Strings.Unbounded.To_String (Output);
   end Implode;

   function ParseHeader (Data : String) return Http.Header.Object is
      Header        : Segment_Container.Vector;
      Line          : Ada.Strings.Unbounded.Unbounded_String;
      Header_Object : Http.Header.Object;
   begin
      Header := Explode (
         CR & LF,
         Ada.Strings.Unbounded.To_Unbounded_String (Data)
      );

      for i in Header.First_Index .. Header.Last_Index loop
         declare
            KeyVal       : Segment_Container.Vector;
            Line         : Ada.Strings.Unbounded.Unbounded_String;
         begin
            Ada.Strings.Unbounded.Append (Line, Header.Element (i));
            KeyVal := Explode (
               ":",
               Line
            );
            Header_Object.Set_Key (KeyVal.Element (0));
            KeyVal.Delete_First;
            Header_Object.Set_Value (Implode (":", KeyVal));
         end;
      end loop;
      return Header_Object;
   end ParseHeader;
end String_Extras;
