Pod::Spec.new do |s|

  s.name         = "TranslateKit"
  s.version      = "0.1.0"
  s.summary      = "A basic SDK for language translation based iOS and OS X applications."

  s.description  = <<-DESC
                   TranslateKit contains many helper classes and routines to develop language translation based applications. It also provides wrapper access to Transifex service.
                   DESC

  s.homepage     = "http://github.com/Legoless/TranslateKit"
  s.license      = 'MIT'
  s.author       = { "Dal Rupnik" => "legoless@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/Legoless/TranslateKit.git", :tag => "0.1.0" }

  s.source_files  = '**/*.{h,m}'
  s.requires_arc = true
end
