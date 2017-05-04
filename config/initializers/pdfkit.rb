PDFKit.configure do |config|
  config.wkhtmltopdf = '/home/tejaswini/.rvm/gems/ruby-2.3.3/bin/wkhtmltopdf'
  config.default_options[:quiet] = false
end