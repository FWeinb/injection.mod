SuperStrict

Import fab.injection
Import BaH.MaxUnit

Type TGeneralInjectionTest extends TTest
  Field injector:TInjector;

  Method setup() {before}
    injector:TInjector  = TInjector.Create();
  End Method

  Method CircularDepsTest() {test}
    Try
      Local foo:TCircularFoo = TCircularFoo(injector.get("TCircularFoo"));
    Catch error:Object
      assertEquals("Circular dependency: TCircularFoo -> TCircularBar -> TCircularFee -> *TCircularFoo*", error.toString(), "Circular dependency not found")
    EndTry
  End Method

End Type



'Circular Deps Test
Type TCircularFee {Injectable}
  Field foo:TCircularFoo {Inject}
End Type

Type TCircularBar {Injectable}
  Field fee:TCircularFee {Inject}
End Type

Type TCircularFoo {Injectable}
  Field bar:TCircularBar {Inject}
End Type