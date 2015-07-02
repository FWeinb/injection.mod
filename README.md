injection.mod
=============

Injection - Dependency Injection Framework for BlitzMax based on Reflection

## Getting Started 
Construct a new object using the TInjector:

```bmx
Local injector:TInjector = TInjector.Create()

Local obj:TMyTyp = TMyTyp(injector.get("TMyTyp"))
```

In order to tell the #TInjector that your type TMyTyp is injectable you have to add the annotation {Injectable} to it.  

```bmx
Type TMyTyp {Injectable}
    'Your Implementation
End Type
```

There are a number of annotation to inject dependencies.

# Annotaions:
<h2>{Injectable}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Type</span>
        <p>
            Indicates if this type can be injected by a #TInjector<br />
            You can specify a namespace using <code>{Injectable="Namespace"}</code>

        </p>
        <h3>Sample:</h3>
        <b>Namespace example:</b> <a href="/examples/NamespaceExample.bmx">Open</a>
    </p>
</div>
<h2>{Singelton}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Type</span>
        <p>
        The {Singelton} annotation ensures that this type is only instanciated once during runtime.
        </p>
        <h3>Sample:</h3>
        <b>Singelton example:</b> <a href="/examples/SingeltonExample.bmx">Open</a>
    </p>
</div>
<h2>{ProviderFor}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Type</span>
        <p>
        The {ProviderFor} annotation is used to declare a custome provider for a certain type
        <pre>Type TMyTypeProvder extends TProvider {ProviderFor="TMyType"}</pre>
        </p>
        <p>
        Every provider must extend #TProvider and implement the get:object method.
        Each time you request a instance of *TMyType* it will be created by the type annotated with {ProviderFor="TMyType"}
        </p>
        <h3>Samples:</h3>
        <b>Provider example:</b> <a href="/examples/ProviderExample.bmx">Open</a><br>
    </p>
</div>
<h2>{Invoke}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Method</span>
        <p>
        The {Invoke} annotation invokes a annotaded method with no arguments. It's just a convenience method to {Inject}.
        Methods are called from supertype -> first extend -> second extend.
        </p>
        <h3>Sample:</h3>
        <b>Method invoke example:</b> <a href="/examples/MethodInvokeExample.bmx">Open</a><br>
        <b>Method invoke order example:</b> <a href="/examples/MethodInvokeOrderExample.bmx">Open</a>
    </p>
</div>
<h2>{InjectProviderFor}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Field, Method</span>
        <p>
        The {InjectProviderFor} annotation is used to inject a provider for the specified Type
        <pre> bar:TProvider {InjectProviderFor="TBar"}</pre>
        </p>
        <h6>Sample:</h6>
        <b>Inject provider example:</b> <a href="/examples/InjectProviderExample.bmx">Open</a><br>
        <b>Method provider injection example:</b> <a href="/examples/MethodProviderInjectionExample.bmx">Open</a>
    </p>
</div>
<h2>{Inject}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Field, Method</span>
        <p>
        The {Inject} annotation is used to indicate that the #TInjector should inject instances of the provided Type
        to this field/method. First all fields are injected and after that each method annotated with {Inject} is called.
        methods are called the same way as for {Invoke}
        <pre>bar:TType {Inject}</pre>
        </p>
        <p>
            The {Inject} annotation can also be used to inject a extended type to it's supertype using this syntax:
            <pre>bar:TSuperType {Inject="TExtendSuperType"}</pre>
        </p>
        
        <h3>Samples:</h3>
        
        <b>Field injection example:</b> <a href="/examples/FieldInjectionExample.bmx">Open</a><br>
        <b>Method injection example:</b> <a href="/examples/MethodInjectionExample.bmx">Open</a>
        <br>
        <b>Advanced field injection example:</b> <a href="/examples/AdvancedFieldInjectionExample.bmx">Open</a><br>
        <b>Advanced method injection example:</b> <a href="/examples/AdvancedMethodInjectionExample.bmx">Open</a>
    </p>
</div>
