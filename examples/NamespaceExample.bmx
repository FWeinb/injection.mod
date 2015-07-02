SuperStrict

Import fab.Injection

Local injectorA:TInjector  = TInjector.CreateWithNamespace("A");
Local injectorB:TInjector  = TInjector.CreateWithNamespace("B");



Type TNamespaceInjectionObjA {Injectable="A"}
  Field value:String="I Am Object A"
End Type

Type TNamespaceInjectionObjAB {Injectable="*"}
  Field value:String="I Am Object AB"
End Type

Type TNamespaceInjectionObjB {Injectable="B"}
  Field value:String="I Am Object B"
End Type