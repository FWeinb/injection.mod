SuperStrict

Import fab.injection
Import BaH.MaxUnit


Type TMethodInjectionTest extends TTest
  Field injector:TInjector;

  Method setup() {before}
    injector:TInjector  = TInjector.Create();
  End Method

  Method SimpleMethodInjection() '{test}
    Print "SimpleMethodInjection Test"
    Local testObj:TMethodInjectionTestObj = TMethodInjectionTestObj(injector.get("TMethodInjectionTestObj"));

    Assert testObj, "Injector can't provied TFoo"
    Assert testObj.obj, "TMethodObject wasn't injected in init";

    assertEqualsI(testObj.obj.value, 50, "Value is wrong");

  End Method

  Method AdvancedMethodInjection() {test}
    Print "AdvancedMethodInjection Test"
    Local testObj:TMethodAdvancedObjTest = TMethodAdvancedObjTest(injector.get("TMethodAdvancedObjTest"));

    Assert testObj,     "Injector can't provide TMethodAdvancedObjTest"
    Assert testObj.obj, "TMethodAdvancedObjImpl wasn't injected in init"

    assertEqualsI(testObj.obj.value, 51, "Value is Wrong");

  End Method

  Method MultiMethodInjection() '{test}
    Local testObj:TMultiMethodInjectionTest = TMultiMethodInjectionTest(injector.get("TMultiMethodInjectionTest"));

    Assert testObj, "Injector can't provide TMultiMethodInjectionTest"
    Assert testObj.abstObj, "Injector can't provide TMethodAdvancedObjTest"


    AssertEqualsI testObj.count, 2, "TMulitObj1 + TMulitObj2 should be 2";
    AssertEqualsI testObj.abstObj.value, 51, "Value is Wrong";

  End Method

End Type

' SimpleMethodInjection
Type TMethodObject {Injectable}
  Field value:int = 50;
End Type

Type TMethodInjectionTestObj {Injectable}
  Field obj:TMethodObject;

  Method init(obj:TMethodObject) {Inject}
    Self.obj = obj;
  End Method

End Type

'AdvancedMethodInjection

Type TMethodAdvancedObjAbstract abstract
  Field value:int = 50;
End Type

Type TMethodAdvancedObjImpl extends TMethodAdvancedObjAbstract {Injectable}
  Method init() {Invoke}
    value = value + 1;
  End Method
End Type

Type TMethodAdvancedObjTest {Injectable}
  Field obj:TMethodAdvancedObjAbstract;

  Method init(obj:TMethodAdvancedObjAbstract) {Inject="TMethodAdvancedObjImpl"}
    Self.obj = obj;
  End Method

End Type


'MultiMethodInjection

Type TMulitObj1 {Injectable}
  Field value:int = 1;
End Type

Type TMulitObj2 {Injectable}
  Field value:int = 1;
End Type

Type TMultiMethodInjectionTest {Injectable}
    Field count:int;
    FIeld abstObj:TMethodAdvancedObjAbstract;

    Method init(obj1:TMulitObj1, obj2:TMulitObj2, abstObj:TMethodAdvancedObjAbstract) {Inject="TMulitObj1, TMulitObj2, TMethodAdvancedObjImpl"}
      count = obj1.value + obj2.value;
      Self.abstObj = abstObj;
    End Method

End Type