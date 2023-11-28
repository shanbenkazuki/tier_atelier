module ApplicationHelper
  def default_meta_tags
    image_path = image_url('top_logo.webp')
    {
      site: 'Tier工房',
      title: 'Tierを作成しよう!',
      reverse: true,
      charset: 'utf-8',
      description: 'Tier工房を使えばあなただけのランキングを作成できます。',
      keywords: 'tier',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_path,
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@',
        image: image_path
      }
    }
  end
end
