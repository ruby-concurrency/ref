package references.weak_reference;

import java.lang.ref.WeakReference;
import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.Visibility;

public class JavaImpl extends RubyObject {
  private WeakReference _ref;

  public JavaImpl(Ruby runtime, RubyClass klass) {
    super(runtime, klass);
  }
  
  public static final ObjectAllocator ALLOCATOR = new ObjectAllocator() {
    public IRubyObject allocate(Ruby runtime, RubyClass klass) {
      return new JavaImpl(runtime, klass);
    }
  };
  
  @JRubyMethod(name = "initialize", frame = true, visibility = Visibility.PRIVATE)
  public IRubyObject initialize(ThreadContext context, IRubyObject obj) {
    _ref = new WeakReference<IRubyObject>(obj);
    return context.getRuntime().getNil();
  }

  @JRubyMethod(name = "object")
  public IRubyObject object() {
    IRubyObject obj = (IRubyObject)_ref.get();
    if (obj != null) {
      return obj;
    } else {
      return getRuntime().getNil();
    }
  }
}
