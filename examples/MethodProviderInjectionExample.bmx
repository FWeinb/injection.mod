SuperStrict

Import fab.Injection

Type TBar {Injectable} ' Make Injectable
  Field name:String = "Hello World"
End Type

Type TFoo {Injectable} ' Make Injectable
  Method init(barProvider:TProvider) {InjectProviderFor="TBar"}
    Print TBar(barProvider.get()).name
  End Method
End Type

' Create a TInjector
Local injector:TInjector = TInjector.Create();

' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));

' The bar.init() method is called during creation and therfore is called before "End"

Print "End"

