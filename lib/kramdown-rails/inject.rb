require 'kramdown'

module KramdownRails
  module TemplateHandler
    class << self

      def erb
        Thread.current[:erb_template] ||= ActionView::Template.registered_template_handler(:erb)
      end

      def call(template, source)
        compiled_template = erb.call(template)
        "Kramdown::Document.new(begin;#{compiled_template};end).to_html.html_safe"
      end

    end
  end
end

class String
  def md_to_html
    Kramdown::Document.new(self).to_html.html_safe
  end
  alias_method :markdown_to_html, :md_to_html
end

ActionView::Template.register_template_handler :md, KramdownRails::TemplateHandler
ActionView::Template.register_template_handler :markdown, KramdownRails::TemplateHandler
