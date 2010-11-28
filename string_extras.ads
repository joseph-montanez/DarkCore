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
   function Explode (Source : Ada.Strings.Unbounded.Unbounded_String) 
      return Segment_Container.Vector;
end Items;
