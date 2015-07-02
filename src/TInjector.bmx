
' Add tInjectorType to TInjector (after TInjector was created)
TInjector.tInjectorType = TTypeId.ForName("TInjector");

Rem
  bbdoc: Creates Objects and its dependencies
  about: Provides you with the ability to construct arbitary types including its dependencies.
EndRem
Type TInjector {Injectable="*"} ' TInjector is injectable, for all namespaces! Soo meta
  Global tInjectorType:TTypeId;
  Global tProviderType:TTypeId = TTypeId.ForName("TProvider");

  Rem
    bbdoc: Indicates how the object graph is created.
    about: If false the complete object graph is created, otherwise the object graph is build lazy.
  EndRem
  Global lazyLoade:Byte = True;

  ' Cache for faster access to the TTypeId
  Field typeCache:TMap = New TMap     ' String, TTypeId

  ' Dynamicly created Provider
  Field providerCache:TMap = New TMap ' TTypeId, TProvider

  Rem
    bbdoc: Create TInjector
    about: Creates a #TInjector and initialize it.
  EndRem
  Function Create:TInjector()
	Return TInjector.CreateWithNamespace("*");
  End Function

  Function CreateWithNamespace:TInjector(inNamespace:String)
    Local injector:TInjector = New TInjector;

    ' Iterate over all types
    For Local typeTypeId:TTypeId = EachIn TTypeId.EnumTypes();
      Local isProvider:String     = typeTypeId.metaData("ProviderFor");
      Local namespace:String      = typeTypeId.metaData("Injectable");
      Local isInjectable:Byte     = namespace.length <> 0 Or isProvider.length <> 0;


      If (isInjectable) Then
      	Local typeName:String       = typeTypeId.name();

	 	If (inNamespace <> "*" And namespace <> "*" And inNamespace <> namespace)
	      DebugLog "Skip *"+typeName+"* not in namespace " + inNamespace;
	      Continue;
	    End If

        DebugLog "Add *"+typeName+"* to typeCache";
        injector.typeCache.insert typeName, typeTypeId;

        If (isProvider.length <> 0) Then
          Assert isProvider <> "1", "You must specifiy which type should be provided";
          Assert typeTypeId.extendsType(tProviderType) <> 0, "*"+typeName + "* must extend TProvider"

          ' Add provided type typeCache (A type for which there is a provider dosn't need {Injectable})
          injector.typeCache.insert isProvider, TTypeId.ForName(isProvider);

          Local providedType:String = typeTypeId.metaData("ProviderFor");
          DebugLog "Create a TProvider for *"+providedType+"* of type *"+typeName+"*"
          injector.providerCache.insert injector._typeIdForName(providedType), injector._getDynamicProvider(typeTypeId,  Null).get(); '.get() user TProviderImpl from TDynamicProvider
        End If
      End If
    Next

    If ( Not TInjector.lazyLoade ) Then
      DebugLog "Create object graph.."

      For Local typeIdToCreate:TTypeId = EachIn injector.typeCache.values();
		Try
        	injector._getDynamicProvider(typeIdToCreate,  Null);
		Catch e:Object
		End Try
      Next

      DebugLog "..done creating object Graph"
    End If

    Return injector;
  End Function

  Rem
    bbdoc: Request an instance of type typeName
    about: This function will try to provide an instance of type typeName.
    returns: An instance of type typeName with all its dependencies injected.
  EndRem
  Method get:Object(typeName:String)
    Return _getByTypeId(_typeIdForName(typeName));
  End Method

  Rem
    bbdoc: Request a #TProvider that provides instances of type typeName
  EndRem
  Method getProvider:TProvider(typeName:String)
    Return _getDynamicProvider(_typeIdForName(typeName), Null);
  End Method


  Method _getByTypeId:Object(typeTypeId:TTypeId)
      Local instance:Object = _getDynamicProvider(typeTypeId, Null).get();

      Assert instance, "Won't return null for *" + typeTypeId.name() + "*";

      Return instance;
  End Method

  Method _getDynamicProvider:TProvider(typeTypeId:TTypeId, depChain:TList)
    Local provider:TProvider;

    If (Self.providerCache.contains(typeTypeId))
        DebugLog "Get cached Provider for *"+typeTypeId.name()+"*";
        provider = TProvider(Self.providerCache.valueForKey(typeTypeId));
    Else
        DebugLog "Create Provider for *"+typeTypeId.name()+"*"
        If depChain = Null Then depChain = New TList
        provider = _createDynamicProviderFor(typeTypeId, depChain);
    End If

    Assert provider, "No Provider found for *" + typeTypeId.name() + "*"

    Return provider
  End Method

  Method _createDynamicProviderFor:TProvider(typeTypeId:TTypeId, depsChain:TList) ' depsChain<String>
    Local typeTypeIdName:String = typeTypeId.name();
    ' Prevent Circular dependencies
    Assert depsChain.contains(typeTypeIdName) = False, "Circular dependency: "+_showDeps(depsChain);

    ' Add typeTypeId to dependency chain
    depsChain.addLast typeTypeIdName;

    Local injectionList:TList = New TList ' TInjection

    DebugLog "Add field injections.."
    For Local oField:TField = EachIn typeTypeId.enumFields()

        Local fieldTypeId:TTypeId             = oField.typeId();
        Local injectAnnotation:String         = oField.metaData("Inject");
        Local injectProviderAnnotation:String = oField.metaData("InjectProviderFor");

        If (injectAnnotation.length = 0 And injectProviderAnnotation.length = 0) Continue;
        DebugLog "Annotated.."

        Local typeIdToInject:TTypeId = fieldTypeId;

        If (injectAnnotation.length <> 0) Then
          DebugLog "..with {Inject}"
          If (injectAnnotation <> "1") Then
            DebugLog "..value: *" + injectAnnotation + "*"
            typeIdToInject = _typeIdForName(injectAnnotation);
            ' Must be the same or extend argTypeIds
            Assert typeIdToInject.extendsType(fieldTypeId) Or typeIdToInject.Compare(fieldTypeId) = 0 , "Injected Object in Type *"+typeIdToInject.name()+"* in field "+oField.name()+" must be *"+fieldTypeId.name()+"* or a supertype of it"
          End If
        End If

        If (injectProviderAnnotation.length <> 0) Then
          DebugLog "..with {InjectProviderFor}"
          If (injectProviderAnnotation <> "1") Then
            DebugLog "..value: *" + injectProviderAnnotation + "*"
            typeIdToInject = _typeIdForName(injectProviderAnnotation);
          End If
        End If

        ' Get provider to resolve dependency
        Local provider:TProvider = _getDynamicProvider(typeIdToInject, depsChain);


        Local injection:TInjection;
        If (injectAnnotation.length <> 0)
          injection = TFieldInjection.Create(oField, provider)
        Else If (injectProviderAnnotation <> 0)
          injection = TFieldProviderInjection.Create(oField, provider);
        End If

        'addLast to ensure that the execution chain is maintained abstract -> impl -> impl
        injectionList.addLast injection
    Next
    DebugLog "..done field injections~nDebugLog:Add method injections.."

    For Local oMethod:TMethod = EachIn typeTypeId.enumMethods();
        Local injectAnnotation:String         = oMethod.metaData("Inject");
        Local injectProviderFor:String        = oMethod.metaData("InjectProviderFor");
        Local invokeAnnotation:String         = oMethod.metaData("Invoke");

        If (injectAnnotation.length = 0 And invokeAnnotation.length = 0 And injectProviderFor.length = 0) Continue;
        DebugLog "Annotated.."

        Local injection:TInjection;
        Local injectedTypeIds:TTypeId[] =  oMethod.argTypes();
        Local injectedTypeIdsLength:Int = injectedTypeIds.length;
        Local injectedTypeProviders:TProvider[] = New TProvider[injectedTypeIdsLength];

        If (injectAnnotation <> "") Then
          DebugLog "..with {Inject}"

          ' Advanced method injection {Inject="TType1,TType2,TType3"}
          If (injectAnnotation <> "1")
            DebugLog "..value: *" + injectAnnotation + "*"

            Local annotatedTypes:String[] = _getAnnotatedTypes(injectAnnotation);

            Local annotatedTypesLength:Int = annotatedTypes.length - 1;
            For Local i:Int=0 To annotatedTypesLength;
              Local argTypeId:TTypeId = injectedTypeIds[i];
              Local typeString:String = annotatedTypes[i].Trim();
              Local typeId:TTypeId    = _typeIdForName(typeString);

              ' Must be the same or extend argTypeIds
              Assert typeId.extendsType(argTypeId) Or typeId.Compare(argTypeId) = 0, "Injected Object in Type "+typeTypeId.name()+" in method "+oMethod.name()+" must be "+argTypeId.name()+" or a supertype of it"

              'Add copy of depsChain because the deps are not shared between method arguments
              injectedTypeProviders[i] = _getDynamicProvider(typeId, depsChain.copy());
            Next
            ' Add provider for remaining arguments.
            For Local i:Int=annotatedTypesLength+1 To injectedTypeIdsLength - 1
              injectedTypeProviders[i] = _getDynamicProvider(injectedTypeIds[i], depsChain.copy());
            Next
          Else
            ' Simple method injection
            For Local i:Int=0 To injectedTypeIdsLength - 1
              Local argType:TTypeId = injectedTypeIds[i];

              'Add copy of depsChain because the deps are not shared between method arguments
              injectedTypeProviders[i] = _getDynamicProvider(argType, depsChain.copy());
            Next
          End If

          injection = TMethodInjection.Create(oMethod, injectedTypeProviders)
        End If

        If (injectProviderFor <> "") Then
          DebugLog "..with {InjectProviderFor}"

          ' Advanced provider injection {injectProviderFor="TType1,TType2,TType3"}
          If (injectProviderFor <> "1")
            DebugLog "..value: *" + injectProviderFor + "*"

            Local annotatedTypes:String[] = _getAnnotatedTypes(injectProviderFor);

            Assert injectedTypeIds.length = annotatedTypes.length, "In Type "+typeTypeId.name()+", method "+oMethod.name()+" arguments count must match provider count"

            Local annotatedTypesLength:Int = annotatedTypes.length - 1;
            For Local i:Int=0 To annotatedTypesLength;
              Local argTypeId:TTypeId = injectedTypeIds[i];
              Local typeString:String = annotatedTypes[i].Trim();

              ' argTypeId must be a TProvider (or extend it)
              Assert argTypeId.extendsType(tProviderType) Or argTypeId.Compare(tProviderType) = 0, "In Type "+typeTypeId.name()+", method "+oMethod.name()+" argument must be a TProvider (Or extend it)"

              injectedTypeProviders[i] = _getDynamicProvider(_typeIdForName(typeString), depsChain.copy());
            Next

            injection = TMethodProviderInjection.Create(oMethod, injectedTypeProviders)

          Else
            Throw "You must specifiy for which types you want to have proivders injected"
          End If
        End If

        If (invokeAnnotation <> "") Then
          Assert injectedTypeIds.length = 0, "Can't invoke a method with Arguments"
          DebugLog "..with {Invoke}"
          'Dummy injection to only invoke the method
          injection = TMethodInjection.Create(oMethod, Null);
        End If

        'addLast to ensure that the execution chain is maintained abstract -> impl -> impl
        injectionList.addLast injection;
    Next

    ' Create and cache provider
    Local newProvider:TProvider;
    Local dyProvider:TDynamicProvider = TDynamicProvider.Create(typeTypeId, TInjection[](injectionList.ToArray()));

    ' Type is annotated with {Singelton}
    If (typeTypeId.metaData("Singelton"))
      newProvider = TSingeltonProvider.Create(dyProvider.get());
    Else
      newProvider = dyProvider;
    End If
    DebugLog "..done method injections";

    Self.providerCache.insert typeTypeId, newProvider;
    Return newProvider;
  End Method

  Method _typeIdForName:TTypeId(typeName:String)
    Local typeId:TTypeId = TTypeId(Self.typeCache.valueForKey(typeName));
    Assert typeId, "Can't find *"+typeName+"*"
    Return typeId;
  End Method

  Method _showDeps:String(depsChain:TList)'<String>
    Local deps:String = "";
    For Local typeId:String = EachIn depsChain
      deps = deps + " -> " + typeId
    Next
    deps = deps[4..]; ' Remove first ->
    Return deps + " -> *" + String(depsChain.first()) + "*";
  End Method

  Method _getAnnotatedTypes:String[](value:String)
    Local annotatedTypes:String[];
    If (value.contains(","))
      annotatedTypes = value.split(",");
    Else
      annotatedTypes = [value];
    End If
    Return annotatedTypes;
  End Method
End Type
