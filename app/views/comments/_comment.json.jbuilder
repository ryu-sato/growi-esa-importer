json.extract! comment, :id, :body_md, :body_html, :created_at, :updated_at, :url, :created_by, :created_at, :updated_at
json.url comment_url(comment, format: :json)
