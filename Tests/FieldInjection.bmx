SuperStrict

Import fab.injection
Import BaH.MaxUnit


Type TFieldInjectionTest Extends TTest
  Field injector:TInjector;

  Method setup() {before}
   	injector:TInjector  = TInjector.Create();
  End Method

  Method SimpleFieldInjection() {test}
    Local foo:TFoo = TFoo(injector.get("TFoo"));
    If (foo = Null)
      fail("Injector can't provied TFoo");
    End If

    If (foo.bar = Null)
      fail("Injector didn't inject the dependencice of TFoo in foo");
    End If

    assertTrue(foo.bar.test="Test", "Value of foo.bar.test is wrong");

  End Method

  Method AdvancedFieldInjectionTest() {test}
    Local testObj:TToInject = TToInject(injector.get("TToInject"));

    If (testObj = Null)
      fail("Injector can't provide testObj from type TToInject")
      Return
    End If

    If (testObj.obj = Null)
      fail("Injector can't didn't do advanced field Injection")
      Return
    End If

    assertTrue(testObj.obj.abstractObj = "abst", "Value of abstractObj is wrong");

    assertTrue(TImplType(testObj.obj).implObj = "impl", "Value of implObj is wrong");

  End Method

 Method ProviderFieldInjection() {test}
    Print "ProviderFieldInjection Test"
    Local injector:TInjector  = TInjector.Create();
    Local testObj:TProviderInject = TProviderInject(injector.get("TProviderInject"));

    If (testObj = Null)
      fail("Injector can't provied TProvider for TObject");
      Return
    End If

    If (testObj.tObjectProvider = Null)
      fail("Injector can't inject a Provider");
      Return
    End If

    Local newObj:TObject    = TObject(testObj.tObjectProvider.get());
    Local newObj1:TObject   = TObject(testObj.tObjectProvider.get());

    If (newObj.value = Null)
      fail("Provider dosn't build the whole object");
      Return
    End If

    assertEqualsI(newObj.value, 50, "Value mismatch");
    assertEqualsI(newObj1.value, 50, "Value mismatch");

    newObj.value = newObj.value - 1;

    assertEqualsI(newObj.value, 49, "Value mismatch");
    assertEqualsI(newObj1.value, 50, "Value mismatch");
  End Method


End Type


' Simple Field Injection
Type TBar {Injectable}
  Field test:String = "Test"
End Type

Type TFoo {Injectable}

  Field bar:TBar {Inject}

End Type

' Advanced Field Injection
Type TAbstractType Abstract
  Field abstractObj:String = "abst"
End Type


Type TImplType Extends TAbstractType {Injectable}
  Field  implObj:String = "impl"
End Type


Type TToInject {Injectable}
    Field obj:TAbstractType {Inject="TImplType"}
End Type


' Provider Field Injection
Type TObject {Injectable}
  Field value:Int = 50;
End Type


Type TProviderInject {Injectable}
  Field tObjectProvider:TProvider {InjectProviderFor="TObject"}
End Type