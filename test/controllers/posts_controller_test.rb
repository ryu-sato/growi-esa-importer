require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post posts_url, params: { post: { body_html: @post.body_html, body_md: @post.body_md, category: @post.category, comments_count: @post.comments_count, created_at: @post.created_at, created_by: @post.created_by, done_tasks_count: @post.done_tasks_count, full_name: @post.full_name, kind: @post.kind, message: @post.message, name: @post.name, revision_number: @post.revision_number, star: @post.star, stargazers_count: @post.stargazers_count, tags: @post.tags, tasks_count: @post.tasks_count, updated_at: @post.updated_at, updated_by: @post.updated_by, watch: @post.watch, watchers_count: @post.watchers_count, wip: @post.wip } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    patch post_url(@post), params: { post: { body_html: @post.body_html, body_md: @post.body_md, category: @post.category, comments_count: @post.comments_count, created_at: @post.created_at, created_by: @post.created_by, done_tasks_count: @post.done_tasks_count, full_name: @post.full_name, kind: @post.kind, message: @post.message, name: @post.name, revision_number: @post.revision_number, star: @post.star, stargazers_count: @post.stargazers_count, tags: @post.tags, tasks_count: @post.tasks_count, updated_at: @post.updated_at, updated_by: @post.updated_by, watch: @post.watch, watchers_count: @post.watchers_count, wip: @post.wip } }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
