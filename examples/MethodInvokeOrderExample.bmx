SuperStrict

Import fab.Injection

Type TAbstractType abstract

    Method init() {Invoke}
      Print "1"
    End Method
End Type


Type TFirstExtend extends TAbstractType
  Method init1() {Invoke} ' Due to how reflection handels method overrites (it don't handels them) it's not possible to {Invoke} the save method name in the inheritance chain.
    Print "2"
  End Method
End Type

Type TSecondExtend extends TFirstExtend {Injectable}

  Method init2() {Invoke}
    Print "3"
  End Method

End Type

' Create a TInjector
Local injector:TInjector = TInjector.create();

' Request a TFoo instance;
Local secondExtend:TSecondExtend = TSecondExtend(injector.get("TSecondExtend"));

'1
'2
'3
