json.extract! post, :id, :name, :tags, :category, :full_name, :wip, :body_md, :body_html, :created_at, :updated_at, :message, :revision_number, :created_by, :updated_by, :kind, :comments_count, :tasks_count, :done_tasks_count, :stargazers_count, :watchers_count, :star, :watch, :created_at, :updated_at
json.url post_url(post, format: :json)
