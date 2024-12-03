with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   Debug                : constant Boolean := True;
   QuantityOfSemaphores : constant Integer := 15;
   MemorySize           : constant Integer := 127;

   task type Semaphore is
      entry Init (x : Integer); -- default 0
      entry Wait;
      entry Signal;
   end Semaphore;

   task body Semaphore is
      Value : Boolean := True;
   begin
      loop
         select
            accept Init (x : Integer) do
               if x = 1 then
                  Value := True;
               else
                  Value := False;
               end if;
            end Init;
         or
            when Value
            =>accept Wait do
               Value := False;
            end Wait;
         or
            accept Signal do
               Value := True;
            end Signal;
         or
            terminate;
         end select;
      end loop;

   end Semaphore;

   task type Memory is
      entry Write (pos : Integer; value : Integer);
      entry Read (pos : Integer; value : out Integer);
   end Memory;

   task body Memory is
      Data : array (0 .. MemorySize) of Integer;
   begin
      loop
         select
            accept Write (pos : Integer; value : Integer) do
               Data (pos) := value;
            end Write;
         or
            accept Read (pos : Integer; value : out Integer) do
               value := Data (pos);
            end Read;
         or
            terminate;
         end select;
      end loop;
   end Memory;

   Semaphores      : array (0 .. QuantityOfSemaphores) of Semaphore;
   Memory_Instance : Memory;

   task type CPU is
      entry Execute (x : Integer);
      entry Stop;
   end CPU;

   task body CPU is
      ProcessorID : Integer := 0;
      Acc         : Integer := 0;         -- Acumulador
      IP          : Integer := 0;          -- Instruction Pointer
      Instruction : Integer := 0;
      Operand     : Integer;
      OpCode      : Integer;
      Value       : Integer;
      RunFlag     : Boolean := False;
   begin
      loop
         select
            accept Execute (x : Integer) do
               ProcessorID := x;
               RunFlag := True;
            end Execute;
         or
            accept Stop do
               RunFlag := False;
            end Stop;
         or
            terminate;
         end select;

         while RunFlag loop
            Memory_Instance.Read (IP, Instruction);
            OpCode := Instruction / 100;
            Operand := Instruction mod 100;

            case OpCode is
               when 1 =>
                  -- LOAD
                  Memory_Instance.Read (Operand, Value);
                  Acc := Value;
                  IP := IP + 1;
                  if Debug then
                     Put_Line
                       ("Processor "
                        & ProcessorID'Image
                        & " loaded "
                        & Value'Image
                        & " from memory position "
                        & Operand'Image);
                  end if;

               when 2 =>
                  -- STORE
                  Memory_Instance.Write (Operand, Acc);
                  IP := IP + 1;
                  if Debug then
                     Put_Line
                       ("Processor "
                        & ProcessorID'Image
                        & " stored "
                        & Acc'Image
                        & " in memory position "
                        & Operand'Image);
                  end if;

               when 3 =>
                  -- ADD
                  Acc := Acc + Operand;
                  IP := IP + 1;
                  if Debug then
                     Put_Line
                       ("Processor "
                        & ProcessorID'Image
                        & " added "
                        & Operand'Image
                        & " to accumulator");
                  end if;

               when 4 =>
                  -- SUB
                  Acc := Acc - Operand;
                  IP := IP + 1;
                  if Debug then
                     Put_Line
                       ("Processor "
                        & ProcessorID'Image
                        & " subtracted "
                        & Operand'Image
                        & " from accumulator");
                  end if;

               when 5 =>
                  -- BRCPU
                  if ProcessorID = 2 then
                     IP := 7; -- Saltar instrucciones de CPU 1

                  else
                     IP := IP + 1; -- Saltar instrucciones de CPU 2
                  end if;

               when 6 =>
                  -- SEMINIT
                  Semaphores (Operand).Init (1);
                  IP := IP + 1;

               when 7 =>
                  -- SEMWAIT
                  Semaphores (Operand).Wait;
                  IP := IP + 1;

               when 8 =>
                  -- SEMSIGNAL
                  Semaphores (Operand).Signal;
                  IP := IP + 1;

               when 9 =>
                  -- STATUS
                  Put_Line
                    ("Processor "
                     & ProcessorID'Image
                     & " accumulator: "
                     & Acc'Image);
                  IP := IP + 1;

               when others =>
                  RunFlag := False; -- O manejar según sea necesario
            end case;
         end loop;
      end loop;
   end CPU;

   CPUs : array (0 .. 1) of CPU;

begin
   -- Initial value
   Memory_Instance.Write (64, 8); -- 8
   -- Instructions for CPU 1
   Memory_Instance.Write (0, 601); -- SEMINIT 1
   Memory_Instance.Write (1, 502); -- JUMP
   Memory_Instance.Write (2, 701); -- SEMWAIT 1
   Memory_Instance.Write (3, 164); -- LOAD 8
   Memory_Instance.Write (4, 313); -- ADD 13
   Memory_Instance.Write (5, 265); -- STORE
   Memory_Instance.Write (6, 801); -- SEMSIGNAL 1
   -- Instructions for CPU 2
   Memory_Instance.Write (7, 701); -- SEMWAIT 1
   Memory_Instance.Write (8, 165); -- LOAD SUM
   Memory_Instance.Write (9, 327); -- ADD 27
   Memory_Instance.Write (10, 801); -- SEMSIGNAL 1
   Memory_Instance.Write (11, 900); -- STATUS 

   for i in 0 .. QuantityOfSemaphores loop
      Semaphores (i).Init (1);
   end loop;

   CPUs (0).Execute (1);
   CPUs (1).Execute (2);
   delay 10.0;
   CPUs (0).Stop;
   CPUs (1).Stop;
end Main;
