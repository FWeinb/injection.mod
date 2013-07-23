SuperStrict

Import fab.Injection

Type TBar {Injectable}
  Field name:String = "Hello World"
End Type

Type TFoo {Injectable} ' Make Injectable
  Field bar:TBar {Inject} ' Inject TBar to Field
End Type

' Create a TInjector
Local injector:TInjector = TInjector.create();

' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));

'Print "Hello World"
Print foo.bar.name;



