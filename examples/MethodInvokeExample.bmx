SuperStrict

Import fab.Injection


Type TFoo {Injectable} ' Make Injectable
  Method init() {Invoke}
    Print "TFoo Created"
  End Method
End Type

' Create a TInjector
Local injector:TInjector = TInjector.create();

' Request a TFoo instance;
Local bar:TFoo = TFoo(injector.get("TFoo"));

' The bar.init() method is called during creation and therfore is called before "End"

Print "End"

