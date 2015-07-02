SuperStrict

Import fab.injection
Import BaH.MaxUnit

Type TProviderInjection Extends TTest


  Field injector:TInjector;

  Method setup() {before}
    injector:TInjector  = TInjector.Create();
  End Method


  Method SimpleProviderInjection() {test}
    Local providerSimple:TProviderSimpleTest = TProviderSimpleTest(injector.get("TProviderSimpleTest"));

    Assert providerSimple, "Injector can't inject TProviderSimpleTest"
    Assert providerSimple.simpleObjProvider, "TProviderSimpleObj wasn't injected"

    Local simpleObj:TProviderSimpleObj = TProviderSimpleObj(providerSimple.simpleObjProvider.get());
    Assert simpleObj, "TProvider can't provide simpleObj"

    AssertEqualsI(50, simpleObj.value, "Value is Wrong");

  End Method


  Method OwnProviderInjection() {test}
    Local obj:TOwnObj = TOwnObj(injector.get("TOwnObj"));
    Local obj1:TOwnObj = TOwnObj(injector.get("TOwnObj"));

    Assert obj, "Injector can't inject TOwnObj"

    AssertEqualsI(50, obj.value, "Value is Wrong");

    AssertEquals(obj, obj1, "Not a Singelton");

  End Method

  Method methodProviderInjection() {test}
    Local obj:TMethodProviderInjection = TMethodProviderInjection(injector.get("TMethodProviderInjection"));
    Assert obj, "Injector can't inject TMethodProviderInjection"
    AssertEquals("Test", obj.test, "Value is wrong");
  End Method

  Method methodProivderInjectionFail() {test}
    Try
      Local obj:TMethodProviderInjectionFail = TMethodProviderInjectionFail(injector.get("TMethodProviderInjectionFail"));
    Catch error:Object
      assertEquals("In Type TMethodProviderInjectionFail, method init argument must be a TProvider (Or extend it)", error.toString(), "Wrong Error Message")
    EndTry
  End Method

End Type

'SimpleProviderInjection
Type TProviderSimpleObj {Injectable}
  Field value:Int = 50;
End Type


Type TProviderSimpleTest {Injectable}
  Field simpleObjProvider:TProvider {InjectProviderFor="TProviderSimpleObj"}
End Type



'OwnProviderInjection
Type TOwnObj
  Field value:Int;
End Type

' Singelton Provider ()
Type TOwnProvider Extends TProvider {ProviderFor="TOwnObj"}
    Field obj:TOwnObj;

    Method init() {Invoke}
      obj = New TOwnObj;
      obj.value = 50;
    End Method

    Method get:Object()
      Return obj;
    End Method

End Type

' Method Provider Injection
Type TMethodProviderInjectionObj {Injectable}
  Field value:String="Test"
End Type

Type TMethodProviderInjection {Injectable}
  Field test:String;
  Method init(objProvider:TProvider) {InjectProviderFor="TMethodProviderInjectionObj"}
    test = TMethodProviderInjectionObj(objProvider.get()).value;
  End Method
End Type

'Fail
Type TMethodProviderInjectionFail {Injectable}
  Field test:String;
  Method init(objProvider:TMethodProviderInjectionObj) {InjectProviderFor="TMethodProviderInjectionObj"}
  End Method
End Type