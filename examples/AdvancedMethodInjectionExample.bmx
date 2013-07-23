SuperStrict


Import fab.Injection

Type TBarAbstract abstract
  Field abstractName:String = "TBarAbstract"
End Type

Type TBarImpl extends TBarAbstract {Injectable} ' Make Injectable
  Field implName:String = "TBar"
End Type


Type TFoo {Injectable} ' Make Injectable
  Method init(bar:TBarAbstract, bar1:TBarAbstract) {Inject="TBarImpl, TBarImpl"}
    Print bar.abstractName; ' TBarAbstract
    Print TBarImpl(bar).implName ' TBarImpl
  End MEthod
End Type


' Create a TInjector
Local injector:TInjector = TInjector.create();
' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));



