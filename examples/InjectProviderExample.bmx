SuperStrict

Import fab.Injection

Type TFoo {Injectable}
  Field value:int = 50;
End Type

Type TBar {Injectable}
  Field fooProvider:TProvider {InjectProviderFor="TFoo"} ' Inject a Provider
End Type

' Create a TInjector
Local injector:TInjector = TInjector.create();
Local bar:TBar = TBar(injector.get("TBar"));

Local foo:TFoo = TFoo(bar.fooProvider.get());  ' get a TFoo object from provider
Local foo1:TFoo = TFoo(bar.fooProvider.get()); ' get another TFoo object from provider

print foo.value   ' 50
print foo1.value  ' 50

foo.value = foo.value - 1;

print foo.value   ' 49
print foo1.value  ' 50