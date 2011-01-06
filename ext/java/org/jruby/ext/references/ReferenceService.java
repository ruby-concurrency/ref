package org.jruby.ext.references;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyModule;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.load.BasicLibraryService;

/**
 * This library adds native Java support for weak and soft references.
 * 
 * @author Brian Durand
 */
public class ReferenceService implements BasicLibraryService {
  public boolean basicLoad(Ruby runtime) throws IOException {
    RubyModule referencesModule = runtime.getModule("References");
    RubyClass referenceClass = referencesModule.getClass("Reference");
    
    RubyClass rubyWeakReferenceClass = runtime.defineClassUnder("WeakReference", referenceClass, RubyWeakReference.ALLOCATOR, referencesModule);
    rubyWeakReferenceClass.defineAnnotatedMethods(RubyWeakReference.class);
    
    RubyClass rubySoftReferenceClass = runtime.defineClassUnder("SoftReference", referenceClass, RubySoftReference.ALLOCATOR, referencesModule);
    rubySoftReferenceClass.defineAnnotatedMethods(RubySoftReference.class);
    
    return true;
  }
}
