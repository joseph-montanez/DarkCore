with Ada.Containers.Indefinite_Vectors;

package Http.Header is
   package Header_Container is new Ada.Containers.Indefinite_Vectors (
      Index_Type => Natural,
      Element_Type => String
   );

   type Object is record
      Keys   : Header_Container.Vector;
      Values : Header_Container.Vector;
   end record;

   function Get_Key (Self : Object; Key : String) return String;

   function Get_Value (Self : Object; Key : String) return String;

   procedure Set_Key (Self : in out Object; Key : String);

   procedure Set_Value (Self : in out Object; Value : String);
end Http.Header;
