Pod::Spec.new do |s|
  s.name         = "FMRichTextView"
  s.version      = "0.0.1"
  s.summary      = "Rich text editor based on UITextView"
  s.author       = { "Future Mind" => "ios@futuremind.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/FutureMind/FMRichTextView.git", :tag => "0.0.1" }
  s.source_files = 'FMRichTextView'
  s.requires_arc = true
end
