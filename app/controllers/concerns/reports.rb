module Reports

  def generate_pdf(file)
    file_name = file + '.pdf'
    file += '.html.haml'
    kit = PDFKit.new(render_to_string(layout: false, action: file))
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.scss"
    send_data(kit.to_pdf, filename: file_name, type: 'application/pdf',disposition: 'inline')
  end

end
