# Author: Mohammed El-Ansary
# 1.4.2015
# Controller responsible for searching for articles
class SearchController < ApplicationController
  def search
    @query_str = ActionView::Base.full_sanitizer.sanitize(params[:query])
    if @query_str.length > 0
      @query_string = '%' << @query_str << '%'
      @query_string = @query_string.gsub('_', '\\_')
      @query_string = @query_string.gsub('%', '\\%')
      @articles = Article.where('(title LIKE ?) OR (plain_body LIKE ?)',
                                @query_string, @query_string)
    else
      redirect_to(:back)
    end
  end

  private

  # Never trust parameters from the scary internet
  def search_params
    params.permit(:query)
  end
end
