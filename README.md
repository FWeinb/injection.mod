injection.mod
=============

Injection - Dependency Injection Framework for BlitzMax based on Reflection

## Getting Started 
To construct a new object using the TInjector:

```blitzmax
Local injector:TInjector = TInjector.Create()
Local obj:TMyTyp = TMyTyp(injector.get("TMyTyp"))
```

In Order to tell the #TInjector that your Type TMyTyp is injectable you have to add the annotation {Injectable} to it</p>

```blitzmax
Type TMyTyp {Injectable}
    'Your Implementation
End Type
```

There are a number of annotation to Inject dependencies.


# Annotaions:
<h2>{Injectable}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Type</span>
        <p>
            Indicates if this Type can be injected by a #TInjector
        </p>
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
        <b>Singelton Example:</b> <a href="../examples/SingeltonExample.bmx">Open</a>
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
        Every Provider must extend #TProvider and implement the get:object Method.
        Each time you request a instance of *TMyType* it will be created by the type annotated with {ProviderFor="TMyType"}
        </p>
        <h3>Samples:</h3>
        <b>Provider Example:</b> <a href="../examples/ProviderExample.bmx">Open</a><br>
    </p>
</div>
<h2>{Invoke}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Method</span>
        <p>
        The {Invoke} annotation invokes a annotaded method with no arguments. It's just a convenience Method to {Inject}.
        Methods are called from Supertype -> first Extend -> second Extend.
        </p>
        <h3>Sample:</h3>
        <b>Method Invoke Example:</b> <a href="../examples/MethodInvokeExample.bmx">Open</a>
        <b>Method Invoke Order Example:</b> <a href="../examples/MethodInvokeOrderExample.bmx">Open</a>
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
        <h3>Sample:</h3>
        <b>Inject Provider Example:</b> <a href="../examples/InjectProviderExample.bmx">Open</a>
        <b>Method Provider Injection Example:</b> <a href="../examples/MethodProviderInjectionExample.bmx">Open</a>
    </p>
</div>
<h2>{Inject}</h2>
<div>
    <p>
        <span><b>Allowed Locations:</b> Field, Method</span>
        <p>
        The {Inject} annotation is used to indicate that the #TInjector should inject instances of the provided Type
        to this Field/Method. First all fields are injected and after that each method annotated with {Inject} is called.
        Methods are called the same way as for {Invoke}
        <pre>bar:TType {Inject}</pre>
        </p>
        <p>
            The {Inject} annotation can also be used to inject a extended Type to it's supertype using this syntax:
            <pre>bar:TSuperType {Inject="TExtendSuperType"}</pre>
        </p>
        
        <h3>Samples:</h3>
        
        <b>Field Injection Example:</b> <a href="../examples/FieldInjectionExample.bmx">Open</a><br>
        <b>Method Injection Example:</b> <a href="../examples/MethodInjectionExample.bmx">Open</a>
        
        <b>Advanced Field Injection Example:</b> <a href="../examples/AdvancedFieldInjectionExample.bmx">Open</a><br>
        <b>Advanced Method Injection Example:</b> <a href="../examples/AdvancedMethodInjectionExample.bmx">Open</a>
    </p>
</div>
