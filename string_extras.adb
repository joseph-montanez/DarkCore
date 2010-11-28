with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Streams;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Containers.Indefinite_Vectors;

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
end String_Extras;
