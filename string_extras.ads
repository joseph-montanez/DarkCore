with Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Streams;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Containers.Indefinite_Vectors;

package String_Extras is
   package Segment_Container is new Ada.Containers.Indefinite_Vectors (
      Index_Type => Natural,
      Element_Type => String
   );
   LF : Character renames Ada.Characters.Latin_1.LF;
   CR : Character renames Ada.Characters.Latin_1.CR;
   function Explode (
      Delimiter : String;
      Data : Ada.Strings.Unbounded.Unbounded_String
   ) return Segment_Container.Vector;
end String_Extras;
