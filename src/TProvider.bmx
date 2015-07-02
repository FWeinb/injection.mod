
Rem
  bbdoc:   Abstract TProvider
  about:   All providers are based on this provider.
EndRem
Type TProvider Abstract
  Method get:Object() Abstract
End Type

Rem
  bbdoc:  Dynamic Provider
  about:  Internally used provider to resolve dependencies more efficient.
EndRem
Type TDynamicProvider Extends TProvider
  Field providedType:TTypeId
  Field injections:TInjection[] ' TInjection

  Function Create:TDynamicProvider(providedType:TTypeId, injections:TInjection[])
    Local dp:TDynamicProvider = New TDynamicProvider
    dp.providedType = providedType;
    dp.injections   = injections;
    Return dp;
  End Function

  Method get:Object()
      Local obj:Object = providedType.newObject();
      For Local injection:TInjection = EachIn injections
          injection.inject(obj);
      Next
      Return obj;
  End Method
End Type

Rem
  bbdoc: Singelton Provider
  about: Internally used provider to provide singeltons
EndRem
Type TSingeltonProvider Extends TProvider
  Field obj:Object

  Function Create:TSingeltonProvider(obj:Object)
    Local sp:TSingeltonProvider = New TSingeltonProvider
          sp.obj = obj;
    Return sp;
  End Function

  Method get:Object()
    Return obj;
  End Method
End Type