# frozen_string_literal: true

# Render class for will_paginator.
# Renders the paginator to be bootstrap conform.
module WillPaginate
  module ActionView
    class EzOnRails::EzPaginatorRenderer < LinkRenderer
      # Constructor takes additional html_options which are passed to the container of
      # the paginator.
      def initialize(html_options = {})
        super()

        @html_options = html_options
      end

      # Returns the attributes of the paginator container.
      def container_attributes
        @html_options[:class] = "pagination #{@html_options[:class] || ''}"
        @html_options
      end

      # Returns a page number containing a link to the target page.
      def page_number(page)
        tag 'li', link(page, page, class: 'page-link'), class: "page-item #{page == current_page ? 'active' : ''}"
      end

      # Returns the gap tag.
      def gap
        tag('li', tag('span', '...', class: 'page-link text-dark'), class: 'disabled')
      end

      # Returns the previous page link.
      def previous_page
        page = '#'
        page = @collection.current_page - 1 if @collection.current_page > 1
        navigation_link '&laquo;', 'Previous', page
      end

      # Returns the next page link.
      def next_page
        page = '#'
        page = @collection.current_page + 1 if @collection.current_page < @collection.total_pages
        navigation_link '&raquo;', 'Next', page
      end

      # Returns a navigation link, containing the given symbol, text and link.
      # Used for previous and next page links.
      def navigation_link(symbol, text, link)
        tag 'li',
            link(tag('span', symbol, 'aria-hidden': 'true'),
                 link,
                 class: 'page-link',
                 'aria-label': text),
            class: 'page-item'
      end
    end
  end
end
