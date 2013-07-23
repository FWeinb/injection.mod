
Rem
  bbdoc:   Abstract TProvider
  about:   All providers are based on this Provider.
EndRem
Type TProvider abstract
  Method get:Object() abstract
End Type

Rem
  bbdoc:  Dynamic Provider
  about:  Internally used Provider to resolve dependencies more efficient.
EndRem
Type TDynamicProvider extends TProvider
  Field providedType:TTypeId
  Field injections:TList ' TInjection

  Function Create:TDynamicProvider(providedType:TTypeId, injections:TList)
    Local dp:TDynamicProvider = new TDynamicProvider
    dp.providedType = providedType;
    dp.injections   = injections;
    return dp;
  End Function

  Method get:Object()
      Local obj:Object = providedType.newObject();
      For Local injection:TInjection = EachIn injections
          injection.inject(obj);
      Next
      return obj;
  End Method
End Type

Rem
  bbdoc: Singelton Provider
  about:  Internally used Provider to provide Singeltons
EndRem
Type TSingeltonProvider extends TProvider
  Field obj:Object

  Function Create:TSingeltonProvider(obj:Object)
    Local sp:TSingeltonProvider = new TSingeltonProvider
          sp.obj = obj;
    return sp;
  End Function

  Method get:Object()
    return obj;
  End Method
End Type