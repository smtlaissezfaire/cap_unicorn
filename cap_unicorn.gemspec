require 'rake'

Gem::Specification.new do |s|
  s.name                            = "cap_unicorn"
  s.version                         = "0.0.3"
  s.author                          = "Scott Taylor"
  s.email                           = "scott@railsnewbie.com"
  s.homepage                        = "http://github.com/smtlaissezfaire/cap_unicorn"
  s.platform                        = Gem::Platform::RUBY
  s.summary                         = "unicorn capistrano tasks"
  s.description                     = "capistrano tasks to support unicorn"
  s.files                           = FileList["{lib}/**/*"].to_a
  s.require_path                    = "lib"
  s.has_rdoc                        = false
end