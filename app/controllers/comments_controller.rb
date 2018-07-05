class CommentsController < InheritedResources::Base

  private

    def comment_params
      params.require(:comment).permit(:body_md, :body_html, :created_at, :updated_at, :url, :created_by)
    end
end

