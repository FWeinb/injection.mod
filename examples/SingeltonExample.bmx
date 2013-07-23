SuperStrict

Import fab.Injection


Type TFoo {Injectable Singelton}
  Field value:Int = 50;
End Type

' Create a TInjector
Local injector:TInjector = TInjector.Create();

' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));
Local foo1:TFoo = TFoo(injector.get("TFoo"));


Print foo.value;  ' 50
Print foo1.value; ' 50

foo.value = foo.value - 1; ' Substract 1 from foo

Print foo.value  ' 49
Print foo1.value ' 49 if {Singelton} is set on TFoo