ActiveAdmin.register Attachment do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  permit_params :url, :post

  # index ページの表示内容をカスタマイズ
  index do
    selectable_column # 選択カラムを追加
    # data は binary なので非表示
    column :id
    column :url
    column :post
    actions # アクションカラムを追加
  end

  # show ページの表示内容をカスタマイズ
  #   ref. https://activeadmin.info/6-show-pages.html
  show do
    attributes_table do
      row :id
      row :url
      row :post
      row('data_size (bytes)') do |attachment|
        attachment.data.size
      end
    end
  end

  # edit ページの表示内容をカスタマイズ
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :url
      f.input :post
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
