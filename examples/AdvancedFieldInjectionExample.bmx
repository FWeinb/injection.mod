SuperStrict


Import fab.Injection

Type TBarAbstract Abstract
  Field abstractName:String = "TBarAbstract"
End Type

Type TBarImpl Extends TBarAbstract {Injectable} ' Make Injectable
  Field implName:String = "TBar"
End Type


Type TFoo {Injectable} ' Make Injectable
  Field bar:TBarAbstract {Inject="TBarImpl"} ' Inject TBarImpl to Field bar:TAbstractBar
End Type


' Create a TInjector
Local injector:TInjector = TInjector.Create();
' Request a TFoo instance;
Local foo:TFoo = TFoo(injector.get("TFoo"));

Print foo.bar.abstractName; ' TBarAbstract
Print TBarImpl(foo.bar).implName ' TBarImpl



