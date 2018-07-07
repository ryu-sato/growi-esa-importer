json.extract! attachment, :id, :filename, :data, :url, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)
