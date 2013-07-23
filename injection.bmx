' Copyright (c) 2013 Fabrice Weinberg
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
'

SuperStrict


Rem
bbdoc: Injection - Dependency Injection Framework based on Reflection
End Rem
Module Fab.Injection

ModuleInfo "Version: 1.03"
ModuleInfo "License: MIT"
ModuleInfo "Author: Fabrice Weinberg"
ModuleInfo "Credit: Inspired by Google Guice for Java"
ModuleInfo "Copyright: (c) 2013 Fabrice Weinberg"

ModuleInfo "History: 0.2 Added the {InjectProviderFor} annotation to methods"
ModuleInfo "History: 0.1 Initial Release"
ModuleInfo "Histroy: Test using BaH.MaxUnit"

Import BRL.LinkedList
Import BRL.Map
Import BRL.StandardIO
Import BRL.System
Import BRL.Reflection

Include "src/TInjection.bmx"
Include "src/TProvider.bmx"
Include "src/TInjector.bmx"