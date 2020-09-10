ActiveAdmin.register Article do
  include ActiveAdmin::AjaxFilter

  menu parent: "Site Content"

  permit_params :title,
    :body,
    :submitter_id,
    :company_id,
    :submission_id,
    :video_url,
    :header_image,
    publishing_attributes: [
      :id,
      :effective_at,
      :featured_on_homepage,
      :pinned_to_track
    ],
    authorships_attributes: [
      :id,
      :_destroy,
      :user_id,
      :is_displayed
    ],
    track_ids: []

  controller do
    def scoped_collection
      resource_class.includes(
        :publishing,
        :authors
      )
    end
  end

  index do
    selectable_column
    column :title
    column :submitter
    column :header_image do |u|
      image_tag u.header_image.url(:thumb) if u.header_image.present?
    end
    column :created_at
    column :updated_at
    column "Published" do |article|
      article.published? ? article&.publishing&.effective_at : "No"
    end
    column "Homepage" do |article|
      article&.publishing&.featured_on_homepage? ? "Yes" : "No"
    end
    column "Pinned to Track" do |article|
      article&.publishing&.pinned_to_track? ? "Yes" : "No"
    end
    column "Authors" do |article|
      article&.authors
    end

    actions
  end

  filter :title

  form do |f|
    f.inputs do
      f.input :title, as: :string
      f.input :body, as: :medium_editor, wrapper_html: {class: "ArticleBody"}, input_html: {
        data: {
          options: {
            "spellcheck": false,
            "toolbar": {
              "buttons": [
                "bold",
                "italic",
                "underline",
                "h2",
                "quote",
                "anchor",
                "orderedlist",
                "unorderedlist",
                "strikethrough",
                "pre"
              ]
            }
          }.to_json
        }
      }
      f.input :submitter_id,
        as: :ajax_select,
        collection: [],
        data: {url: filter_admin_users_path, search_fields: %i[name email]}
      f.input :company_id,
        as: :ajax_select,
        collection: [],
        data: {url: filter_admin_companies_path, search_fields: %i[name]}
      f.input :submission_id,
        as: :ajax_select,
        collection: [],
        data: {url: filter_admin_submissions_path, search_fields: %i[title description year]}
      f.input :track_ids, as: :check_boxes, collection: Track.all, label: "Related Track(s)"
      f.input :header_image,
        as: :file,
        hint: f.object.header_image.present? ? image_tag(f.object.header_image.try(:url, :thumb)) : nil
      f.input :video_url, as: :string
    end

    f.has_many :publishing, allow_destroy: false, add_new: false do |pub|
      pub.input :effective_at
      pub.input :featured_on_homepage
      pub.input :pinned_to_track
    end

    f.has_many :authorships, allow_destroy: true do |authorship|
      authorship.input :user_id,
        as: :ajax_select,
        collection: [],
        data: {url: filter_admin_users_path, search_fields: %i[name email]}
      authorship.input :is_displayed
    end

    f.actions
  end

  action_item :publish, only: %i[show] do
    unless resource.published?
      link_to "Publish", publish_admin_article_path(resource), method: :post
    end
  end

  member_action :publish, method: :post do
    article = Article.find(params[:id])
    article.publish!
    redirect_to admin_article_path(article)
  end

  action_item :unpublish, only: %i[show] do
    if resource.published?
      link_to "Unpublish", unpublish_admin_article_path(resource), method: :post
    end
  end

  member_action :unpublish, method: :post do
    article = Article.find(params[:id])
    article.unpublish!
    redirect_to admin_article_path(article)
  end
end
