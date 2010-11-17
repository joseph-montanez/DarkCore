with Ada.Text_IO;
with GNAT.Sockets;
with Ada.Characters.Latin_1;

procedure Server is
   LF : Character renames Ada.Characters.Latin_1.LF;
   CR : Character renames Ada.Characters.Latin_1.CR;

   function Reply (S : String) return String is
      Res : String (S'Range);
      J : Integer := S'First;
   begin
      for I in reverse S'Range loop
         Res (J) := S (I);
         J := J + 1;
      end loop;
      return Res;
   end Reply;

   task type Socket_Task (message : Integer) is
      entry start;             --  Entry Point Into The Task
   end Socket_Task;

   task body Socket_Task is       --  Task Body Definition
      server_host : constant String := "localhost";
      server_port : constant GNAT.Sockets.Port_Type := 5876;

      Server_Address : GNAT.Sockets.Sock_Addr_Type;
      Server_Socket  : GNAT.Sockets.Socket_Type;
      Client_Socket  : GNAT.Sockets.Socket_Type;
      Client_Stream  : GNAT.Sockets.Stream_Access;

      Data : String (1 .. 1024);
   begin
      accept start;            --  Entry Point Into The Task

      Server_Address.Addr := GNAT.Sockets.Addresses (
         GNAT.Sockets.Get_Host_By_Name (server_host), 1
      );
      Server_Address.Port := server_port;
      GNAT.Sockets.Create_Socket (Server_Socket);
      GNAT.Sockets.Set_Socket_Option (
         Server_Socket, GNAT.Sockets.Socket_Level, (
            GNAT.Sockets.Reuse_Address, True
         )
      );
      begin
         Ada.Text_IO.Put_Line ("Binding...");
         GNAT.Sockets.Bind_Socket (Server_Socket, Server_Address);
      exception when GNAT.Sockets.Socket_Error =>
         Ada.Text_IO.Put_Line (
            Ada.Text_IO.Standard_Error, "Bind_Socket raised Socket_Error"
         );
      end;
      begin
         Ada.Text_IO.Put_Line ("Listening...");
         GNAT.Sockets.Listen_Socket (Server_Socket);
      exception when GNAT.Sockets.Socket_Error =>
         Ada.Text_IO.Put_Line (
            Ada.Text_IO.Standard_Error, "Listen_Socket raised Socket_Error"
         );
      end;
      --   TODO: This needs to be in a loop
      begin
         Ada.Text_IO.Put_Line ("Accepting...");
         GNAT.Sockets.Accept_Socket (
            Server_Socket, Client_Socket, Server_Address
         );
         --   TODO: Spawn another task!
         Ada.Text_IO.Put_Line ("GAH!...");
      exception when GNAT.Sockets.Socket_Error =>
         Ada.Text_IO.Put_Line (
            Ada.Text_IO.Standard_Error, "Accept_Socket raised Socket_Error"
         );
      end;
      Client_Stream := GNAT.Sockets.Stream (Client_Socket);
      String'Read (Client_Stream, Data);
      Ada.Text_IO.Put_Line ("Streamed...");
      Ada.Text_IO.Put_Line ("Blocking...");
      delay 0.2;
      Ada.Text_IO.Put_Line ("Reading channel..");
      declare
         message : String := String'Input (Client_Stream);
      begin
         Ada.Text_IO.Put_Line ("Message:");
         Ada.Text_IO.Put_Line ("Message Addr: " & GNAT.Sockets.Image (
            GNAT.Sockets.Get_Address (Client_Stream)
         ));
         Ada.Text_IO.Put_Line ("Message Text: '" & message & "'");
         Ada.Text_IO.Put_Line ("Message Len:  " & message'Length'Img);
      exception when Ada.Text_IO.End_Error =>
         Ada.Text_IO.Put_Line ("Premature end of data  error");
      end;
      String'Write (Client_Stream,
         "HTTP/1.1 101 WebSocket Protocol Handshake" & CR & LF &
         "Upgrade: WebSocket" & CR & LF &
         "Connection: Upgrade" & CR & LF &
         "Sec-WebSocket-Origin: http://localhost" & CR & LF &
         "Sec-WebSocket-Location: ws://localhost/demo" & CR & LF &
         "Sec-WebSocket-Protocol: sample" & CR & LF &
         CR & LF & CR & LF &
         "8jKS'y:G*Co,Wxa-"
      );
      --   TODO: I don't really want to close sockets after one read ~_~
      GNAT.Sockets.Close_Socket (Server_Socket);
      GNAT.Sockets.Close_Socket (Client_Socket);
   end Socket_Task;

   task type Echo is
      entry Start (N_Sock : in GNAT.Sockets.Socket_Type);
   end Echo;

   task body Echo is
      Sock : GNAT.Sockets.Socket_Type;
      S : GNAT.Sockets.Stream_Access;
   begin
      --   In a more realistic example we could
      --   perform some routine initialisation here
      --   before rendezvous with the main task

      accept Start (N_Sock : in GNAT.Sockets.Socket_Type) do
         Sock := N_Sock;
      end Start;

      S := GNAT.Sockets.Stream (Sock);
      Boolean'Write (S, True);    -- acknowledge connection

      loop
         declare
            Str : String := String'Input (S);
         begin
            exit when Str = "quit";
            String'Output (S, Reply (Str));
         end;
      end loop;

      Ada.Text_IO.Put_Line ("Closing Connection");
      GNAT.Sockets.Shutdown_Socket (Sock, GNAT.Sockets.Shut_Read_Write);

   exception when others =>
         Ada.Text_IO.Put_Line ("Connection Closed");
         GNAT.Sockets.Close_Socket (Sock);
   end Echo;

   Socket : Socket_Task (message => 1);
begin
   --   Stuff here
   Socket.start;
   Ada.Text_IO.Put_Line ("I can do other stuff while the server is running!");
   --   Like simulate the world...
   loop
      Ada.Text_IO.Put_Line ("tick");
      delay 1.0;
   end loop;
end Server;
