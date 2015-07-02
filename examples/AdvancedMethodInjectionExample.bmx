SuperStrict

Framework BRL.System
Import fab.Injection

Type TBarAbstract Abstract
  Field abstractName:String = "TBarAbstract"
End Type

Type TBarImpl Extends TBarAbstract {Injectable} ' Make Injectable
  Field implName:String = "TBar"
End Type


Type TFoo {Injectable} ' Make Injectable
  Method init(bar:TBarAbstract, bar1:TInjector) {Inject="TBarImpl, TBarImpl"}
    Print bar.abstractName; ' TBarAbstract
  End Method
End Type


' Create a TInjector
Local injector:TInjector = TInjector.Create();
' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));



