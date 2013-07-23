SuperStrict

Import fab.Injection

Type TBar {Injectable}
  Field name:String = "Hello World"
End Type

Type TBarProvider extends TProvider {ProviderFor="TBar"} ' Create a provider for *TBar*


  Method get:Object()
    Local bar:TBar = new TBar
          bar.name =  bar.name + ", this was added by TBarProvider"
    return bar
  End Method

End Type


Type TFoo {Injectable}
  Field bar:TBar {Inject}
End Type

' Create a TInjector
Local injector:TInjector = TInjector.create();

' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));

'Print "Hello World, this was added by TBarProvider"
Print foo.bar.name;



