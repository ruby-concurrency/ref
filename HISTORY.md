## 2.0.0

*NOTE: The changes in 2.0 are mostly non-functional changes. The original
author graciously passed maintenance of this gem to the
github.com/ruby-concurrency* team. 2.0 is the first release by the new
maintainers.*

- Added AbstractReferenceKeyMap#to_h method
- Added AbstractReferenceKeyMap#merge method
- Migrated all tests to RSpec
- Removed support for MRI 1.8.x
- Removed IronRuby optimizations
- Added `#put` and `#get` method aliases to `AbstractReferenceKeyMap`
- Added `#size` (alias: `#length`) and `#empty?` methods to `AbstractReferenceKeyMap`
- Added continuous integration with TravisCI
- Moved repo to github.com/ruby-concurrency/ref

## 1.0.5

- Fix breaking test in ruby 2.0

## 1.0.4

- Support for BasicObject in pure ruby weak reference implementation.

## 1.0.3

- Support Ruby 2.0 WeakRef implementation
- Replace autoload with require to make library thread safe

## 1.0.2

- Fix mock object used for testing (Burgestrand)

## 1.0.1

- No code changes. Just including the license file in the release and removing deprecated tasks.

## 1.0.0

- Initial release.
