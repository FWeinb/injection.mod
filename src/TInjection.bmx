

Type TInjection Abstract
  Method inject(obj:Object) Abstract
End Type


Type TFieldInjection Extends TInjection
  Field _field    : TField
  Field _provider : TProvider

  Function Create:TFieldInjection(_field:TField, _provider:TProvider)
    Local sfi:TFieldInjection = New TFieldInjection;
          sfi._field    = _field;
          sfi._provider = _provider;
    Return sfi;
  End Function

  Method inject(obj:Object)
    _field.set obj, _provider.get();
  End Method
End Type


Type TFieldProviderInjection Extends TInjection
  Field _field    : TField
  Field _provider : TProvider

  Function Create:TFieldProviderInjection(_field:TField, _provider:TProvider)
    Local sfi:TFieldProviderInjection = New TFieldProviderInjection;
    sfi._field    = _field;
    sfi._provider = _provider;
    Return sfi;
  End Function

  Method inject(obj:Object)
    _field.set obj, _provider
  End Method

End Type


Type TMethodInjection Extends TInjection
  Field _method      : TMethod
  Field _argCount    : Int
  Field _argProvider : TProvider[]

  Function Create:TMethodInjection(_method:TMethod, _argProvider:TProvider[])
    Local tmi:TMethodInjection = New TMethodInjection
          tmi._method      = _method;
          tmi._argProvider = _argProvider;
          tmi._argCount    = _argProvider.length - 1;
    Return tmi;
  End Function

  Method inject(obj:Object)
    Local objArgs:Object[] = null;
    if (_argProvider <> null)
      objArgs = New Object[_argProvider.length];
      For Local i:Int=0 To _argCount;
        objArgs[i] = _argProvider[i].get();
      Next
    End if
    _method.invoke obj, objArgs;
  End Method

End Type

Type TMethodProviderInjection Extends TInjection
  Field _method      : TMethod
  Field _argCount    : Int
  Field _argProvider : TProvider[]

  Function Create:TMethodProviderInjection(_method:TMethod, _provider:TProvider[])
    Local tmpi:TMethodProviderInjection = New TMethodProviderInjection;
    tmpi._method      = _method;
    tmpi._argProvider = _provider;
    Return tmpi;
  End Function

  Method inject(obj:Object)
    _method.invoke obj, _argProvider;
  End Method

End Type