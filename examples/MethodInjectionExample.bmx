SuperStrict

Import fab.Injection

Type TBar {Injectable} ' Make Injectable
  Field name:String = "Hello World"
End Type

Type TFoo {Injectable} ' Make Injectable
  Method init(bar:TBar) {Inject}
    'Print "Hello World"
    Print bar.name;
  End Method
End Type

' Create a TInjector
Local injector:TInjector = TInjector.create();

' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));

' The bar.init() method is called during creation and therfore is called before "End"

Print "End"

