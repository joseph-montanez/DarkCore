with Ada.Containers.Hashed_Maps;  
--  use Ada.Containers;

package Http is

   type Header_Key is new String (1 .. 256);

   type Header_Value is new String (1 .. 1024);

   function Id_Hashed (id: Header_Key) return Ada.Containers.Hash_Type;

   package Header is new Ada.Containers.Hashed_Maps (
      Key_Type => Header_Key,
      Element_Type => Header_Value,
      Hash => Id_Hashed,
      Equivalent_Keys => "="
   );

end Http;
