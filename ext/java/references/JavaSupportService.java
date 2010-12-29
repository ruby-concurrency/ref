package references;

import references.weak_reference.JavaImpl;

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
public class JavaSupportService implements BasicLibraryService {
  public boolean basicLoad(Ruby runtime) throws IOException {
    RubyModule referencesModule = runtime.getModule("References");
    
    RubyClass weakReferenceClass = referencesModule.getClass("WeakReference");
    RubyClass javaWeakReferenceClass = runtime.defineClassUnder("JavaImpl", runtime.getObject(), JavaImpl.ALLOCATOR, weakReferenceClass);
    javaWeakReferenceClass.defineAnnotatedMethods(JavaImpl.class);
    
    RubyClass referenceClass = referencesModule.getClass("Reference");
    RubyClass rubySoftReferenceClass = runtime.defineClassUnder("SoftReference", referenceClass, RubySoftReference.ALLOCATOR, referencesModule);
    rubySoftReferenceClass.defineAnnotatedMethods(RubySoftReference.class);
    
    return true;
  }
}
