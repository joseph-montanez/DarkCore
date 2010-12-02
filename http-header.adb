with Ada.Containers.Indefinite_Vectors;

package body Http.Header is

   function Get_Key_Index (Self : Object; Key : String) return Natural is
      Index : Natural;
   begin
      Index := Self.Keys.Find_Index (
         Item => Key
      );
      return Index;
   end Get_Key_Index;

   function Get_Value (Self : Object; Key : String) return String is
      Index : Natural;
   begin
      Index := Self.Get_Key_Index (Key);
      return Self.Values.Element (Index);
   end Get_Value;

   procedure Set_Key (Self : in out Object; Key : String) is
   begin
      Self.Keys.Append (New_Item => Key);
   end Set_Key;

   procedure Set_Value (Self : in out Object; Value : String) is
   begin
      Self.Values.Append (New_Item => Value);
   end Set_Value;
end Http.Header;
