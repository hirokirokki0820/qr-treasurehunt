module ApplicationHelper
  require "rqrcode"
  require "rqrcode_png"

  def qrcode(url, size)
    qrcode = RQRCode::QRCode.new(url)
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: size,
      standalone: true,
      use_path: true
    ).html_safe
  end

  # bootstrapのアイコンを生成するメソッド
  def icon(icon_name)
    tag.i(class: ["bi", "bi-#{icon_name}"])
  end

  # bootstrapの「アイコン＋文字列」を生成するメソッド
  def icon_with_text(icon_name, text)
    tag.span(icon(icon_name), class: "me-2") + tag.span(text)
  end

end
