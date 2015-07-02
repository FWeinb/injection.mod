SuperStrict

Import fab.injection
Import BaH.MaxUnit

Type TNamespaceInjection Extends TTest


  Field injectorA:TInjector;
  Field injectorB:TInjector;

  Method setup() {before}
    injectorA:TInjector  = TInjector.CreateWithNamespace("A");
    injectorB:TInjector  = TInjector.CreateWithNamespace("B");
  End Method


  Method NamespaceInjection() {test}
    Local objA:TNamespaceInjectionObjA = TNamespaceInjectionObjA(injectorA.get("TNamespaceInjectionObjA"));
    AssertEquals("I Am Object A", objA.value, "Should be possible");

    Local objB:TNamespaceInjectionObjB = TNamespaceInjectionObjB(injectorB.get("TNamespaceInjectionObjB"));
    AssertEquals("I Am Object B", objB.value, "Should be possible");

    Local fromA_objAB:TNamespaceInjectionObjAB = TNamespaceInjectionObjAB(injectorA.get("TNamespaceInjectionObjAB"));
    Local fromB_objAB:TNamespaceInjectionObjAB = TNamespaceInjectionObjAB(injectorB.get("TNamespaceInjectionObjAB"));

    AssertEquals(fromA_objAB.value, fromB_objAB.value, "The * Should be a wildcard");
			
			  'Fail
					 Try 
					 			 Local objB:TNamespaceInjectionObjB = TNamespaceInjectionObjB(injectorA.get("TNamespaceInjectionObjB"));
				  Catch err:Object 
					   assertEquals("Can't find *TNamespaceInjectionObjB*", err.toString(), "Wrong Error Message")
					  End Try
					
  End Method

End Type


Type TNamespaceInjectionObjA {Injectable="A"}
  Field value:String="I Am Object A"
End Type
Type TNamespaceInjectionObjAB {Injectable="*"}
  Field value:String="I Am Object AB"
End Type

Type TNamespaceInjectionObjB {Injectable="B"}
  Field value:String="I Am Object B"
End Type
