with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
  Debug: constant Boolean := True;
  QuantityOfSemaphores: constant Integer := 15;
  MemorySize: constant Integer := 127;

  procedure LOAD (Parameter : Integer);       
  procedure STORE (Parameter : Integer);      
  procedure ADD (Parameter : Integer);      
  procedure SUB (Parameter : Integer);   
  procedure BRCPU (Processor_ID : Integer);   
  procedure SEMINIT (Semaphore_ID : Integer; Initial_Value : Integer);
  procedure SEMWAIT (Semaphore_ID : Integer);
  procedure SEMSIGNAL (Semaphore_ID : Integer);
  procedure STATUS; 

  task type Semaphore is
    entry Init (x: Integer); -- default 0
    entry Wait;
    entry Signal;
  end Semaphore;

  task body Semaphore is
    Value: Boolean := True;
    begin
      loop
        select
            accept Init (x: Integer) do
            if x = 0 then
              Value := True;
            else
              Value := False;
            end if;
            end Init;
        or
          when Value =>
            accept Wait do
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

  Semaphores: array (0..QuantityOfSemaphores) of Semaphore;

  task type Memory is
    entry Write (x: Integer; y: Integer);
    entry Read (x: Integer; y: out Integer);
  end Memory;

  task body Memory is
    Data: array (0..MemorySize) of Integer;
    Lock: Semaphore;
    begin
      loop
        select
            accept Write (pos: Integer; value: Integer) do
              Lock.Wait;
              Data(pos) := value;
              Lock.Signal;
            end Write;
        or
          accept Read (pos: Integer; value: out Integer) do
            Lock.Wait;
            value := Data(pos);
            Lock.Signal;
          end Read;
        or
          terminate;
        end select;
      end loop;
    end 
  Memory;

  task type CPU is
    entry Execute(x: Integer);
    entry Stop(x: Integer);
  end CPU;

  task body CPU is
    Processor1: Boolean := False;
    Processor2: Boolean := False;
    Acc : Integer := 0;
    IP : Integer := 0;
    Value: Integer;
    memory : Memory;

    begin
      loop
        select
          accept Execute(x : Integer) do
            if(x = 1) then
              processor1 := True;
            else
              processor2 := True;
            end if;
          end Execute;
          or
          accept Stop(x : Integer) do
            if(x = 1) then
              processor1 := False;
            else
              processor2 := False;
            end if;
          end Stop;
        end select;
      end loop;
    end CPU;



begin
  
end Main;